import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';
import 'app_exception.dart';

/// Wraps the two-step `POST /uploads/presign` + direct-to-bucket PUT flow
/// (docs/API_SPEC.md, internal/storage's doc comment on the backend side):
/// ask the API for a short-lived presigned PUT URL, then upload the bytes
/// straight to object storage. The direct PUT deliberately goes through a
/// bare [Dio] instance, never [ApiClient]'s — that one attaches this
/// device's bearer token to every request, which must never be sent to a
/// third-party bucket host.
class UploadRepository {
  UploadRepository(this._client);

  final ApiClient _client;

  /// Uploads [bytes] under [purpose] (e.g. "seller-kyc", "review-images")
  /// and returns the object key the backend should be told about — never
  /// the public URL, since purposes like "seller-kyc" are private (see
  /// PresignGet's doc comment on the Go side); callers that do want a
  /// public URL (e.g. review images) can read it off [uploadImageFull]
  /// instead.
  Future<String> uploadImage({
    required Uint8List bytes,
    required String purpose,
    String contentType = 'image/jpeg',
  }) async {
    final result = await uploadImageFull(bytes: bytes, purpose: purpose, contentType: contentType);
    return result.objectKey;
  }

  Future<UploadedImage> uploadImageFull({
    required Uint8List bytes,
    required String purpose,
    String contentType = 'image/jpeg',
  }) async {
    final presign = await _client.post('/uploads/presign', data: {
      'content_type': contentType,
      'purpose': purpose,
    });
    final uploadUrl = presign['upload_url'] as String;
    final objectKey = presign['object_key'] as String;
    final publicUrl = presign['public_url'] as String;

    try {
      final raw = Dio();
      await raw.put<void>(
        uploadUrl,
        data: bytes,
        options: Options(headers: {'Content-Type': contentType}),
      );
    } catch (e) {
      throw UnknownException('upload: $e');
    }
    return UploadedImage(objectKey: objectKey, publicUrl: publicUrl);
  }
}

class UploadedImage {
  const UploadedImage({required this.objectKey, required this.publicUrl});

  final String objectKey;
  final String publicUrl;
}

final uploadRepositoryProvider = Provider<UploadRepository>((ref) {
  return UploadRepository(ref.watch(apiClientProvider));
});
