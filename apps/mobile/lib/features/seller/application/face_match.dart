import 'dart:math' as math;

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

/// On-device, free approximation of "is this the same person": normalizes a
/// handful of ML Kit face landmarks against interocular distance (so it
/// doesn't matter how close/far the camera was) and compares the two
/// resulting shape vectors. This is a coarse geometric heuristic, not a
/// trained face-embedding model — see
/// SellerApplicationService's doc comment on the Go side for the honest
/// trade-off this represents (free and on-device, not laboratory-grade).
///
/// Returns null when either face is missing the landmarks needed to compare
/// (both eyes, at minimum) — the caller treats that as "couldn't verify"
/// rather than guessing a score.
double? computeFaceSimilarity(Face a, Face b) {
  final vectorA = _shapeVector(a);
  final vectorB = _shapeVector(b);
  if (vectorA == null || vectorB == null) return null;

  var sumSquares = 0.0;
  for (var i = 0; i < vectorA.length; i++) {
    final d = vectorA[i] - vectorB[i];
    sumSquares += d * d;
  }
  final distance = math.sqrt(sumSquares);

  // Empirically, two photos of the same person under this normalization
  // land well under 1.0; different people tend to exceed it. Not a
  // calibrated threshold — see faceMatchApprovalThreshold on the backend,
  // which is the actual gate.
  const maxExpectedDistance = 2.0;
  final similarity = 1 - (distance / maxExpectedDistance);
  return similarity.clamp(0.0, 1.0);
}

/// Builds a normalized (dx, dy) offset for each available landmark,
/// relative to the eye midpoint and scaled by interocular distance. Returns
/// null if either eye landmark is missing.
List<double>? _shapeVector(Face face) {
  final leftEye = face.landmarks[FaceLandmarkType.leftEye]?.position;
  final rightEye = face.landmarks[FaceLandmarkType.rightEye]?.position;
  if (leftEye == null || rightEye == null) return null;

  final interocular = _distance(leftEye.x.toDouble(), leftEye.y.toDouble(), rightEye.x.toDouble(), rightEye.y.toDouble());
  if (interocular < 1) return null;

  final centerX = (leftEye.x + rightEye.x) / 2;
  final centerY = (leftEye.y + rightEye.y) / 2;

  const landmarkOrder = [
    FaceLandmarkType.leftEye,
    FaceLandmarkType.rightEye,
    FaceLandmarkType.noseBase,
    FaceLandmarkType.leftMouth,
    FaceLandmarkType.rightMouth,
    FaceLandmarkType.bottomMouth,
  ];

  final vector = <double>[];
  for (final type in landmarkOrder) {
    final point = face.landmarks[type]?.position;
    if (point == null) {
      // Missing landmark: contribute a neutral (0,0) offset rather than
      // dropping the whole comparison — keeps the vectors the same length
      // across faces where ML Kit didn't find every point.
      vector.addAll([0.0, 0.0]);
      continue;
    }
    vector.add((point.x - centerX) / interocular);
    vector.add((point.y - centerY) / interocular);
  }
  return vector;
}

double _distance(double x1, double y1, double x2, double y2) {
  return math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2));
}

/// True liveness is hard to prove for free; this is a liveness-lite signal:
/// eyes clearly open in [openFrame] and clearly more closed in
/// [blinkFrame] — evidence of a live blink between two captures, rather
/// than a static printed photo held up to the camera.
bool detectedBlink(Face openFrame, Face blinkFrame) {
  final openProb = _avgEyeOpen(openFrame);
  final blinkProb = _avgEyeOpen(blinkFrame);
  if (openProb == null || blinkProb == null) return false;
  return openProb > 0.6 && blinkProb < openProb - 0.25;
}

double? _avgEyeOpen(Face face) {
  final left = face.leftEyeOpenProbability;
  final right = face.rightEyeOpenProbability;
  if (left == null || right == null) return null;
  return (left + right) / 2;
}
