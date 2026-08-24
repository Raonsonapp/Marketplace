/// Mirrors `services/api/internal/httpapi/dto/seller_application.go`'s
/// SellerApplicationResponse/CreateSellerApplicationRequest. Plain classes
/// (no freezed/json_serializable) — this is a small, one-off shape used
/// only by the become-a-seller wizard, not worth the generated-file
/// overhead the rest of the app's shared models carry.
class SellerApplication {
  const SellerApplication({
    required this.id,
    required this.status,
    required this.birthDate,
    this.storeLat,
    this.storeLng,
    this.storeWebsite,
    this.storeInstagram,
    this.storeTelegram,
    this.storeWhatsapp,
    required this.livenessPassed,
    this.faceMatchScore,
    this.rejectionReason,
    required this.createdAt,
  });

  factory SellerApplication.fromJson(Map<String, dynamic> json) {
    return SellerApplication(
      id: json['id'] as String,
      status: json['status'] as String,
      birthDate: json['birth_date'] as String,
      storeLat: (json['store_lat'] as num?)?.toDouble(),
      storeLng: (json['store_lng'] as num?)?.toDouble(),
      storeWebsite: json['store_website'] as String?,
      storeInstagram: json['store_instagram'] as String?,
      storeTelegram: json['store_telegram'] as String?,
      storeWhatsapp: json['store_whatsapp'] as String?,
      livenessPassed: json['liveness_passed'] as bool? ?? false,
      faceMatchScore: (json['face_match_score'] as num?)?.toDouble(),
      rejectionReason: json['rejection_reason'] as String?,
      createdAt: json['created_at'] as String,
    );
  }

  final String id;
  final String status; // 'pending' | 'approved' | 'rejected'
  final String birthDate;
  final double? storeLat;
  final double? storeLng;
  final String? storeWebsite;
  final String? storeInstagram;
  final String? storeTelegram;
  final String? storeWhatsapp;
  final bool livenessPassed;
  final double? faceMatchScore;
  final String? rejectionReason;
  final String createdAt;

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
}

/// Request body for `POST /seller-applications`.
class CreateSellerApplicationRequest {
  const CreateSellerApplicationRequest({
    required this.birthDate,
    this.storeLat,
    this.storeLng,
    this.storeWebsite,
    this.storeInstagram,
    this.storeTelegram,
    this.storeWhatsapp,
    required this.passportFrontKey,
    required this.passportBackKey,
    required this.selfieWithPassportKey,
    required this.liveSelfieKey,
    required this.livenessPassed,
    this.faceMatchScore,
  });

  final String birthDate; // "YYYY-MM-DD"
  final double? storeLat;
  final double? storeLng;
  final String? storeWebsite;
  final String? storeInstagram;
  final String? storeTelegram;
  final String? storeWhatsapp;
  final String passportFrontKey;
  final String passportBackKey;
  final String selfieWithPassportKey;
  final String liveSelfieKey;
  final bool livenessPassed;
  final double? faceMatchScore;

  Map<String, dynamic> toJson() => {
        'birth_date': birthDate,
        'store_lat': storeLat,
        'store_lng': storeLng,
        'store_website': storeWebsite,
        'store_instagram': storeInstagram,
        'store_telegram': storeTelegram,
        'store_whatsapp': storeWhatsapp,
        'passport_front_key': passportFrontKey,
        'passport_back_key': passportBackKey,
        'selfie_with_passport_key': selfieWithPassportKey,
        'live_selfie_key': liveSelfieKey,
        'liveness_passed': livenessPassed,
        'face_match_score': faceMatchScore,
      };
}
