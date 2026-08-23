// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SendOtpResult _$SendOtpResultFromJson(Map<String, dynamic> json) =>
    _SendOtpResult(
      retryAfterSeconds: (json['retry_after_seconds'] as num).toInt(),
    );

Map<String, dynamic> _$SendOtpResultToJson(_SendOtpResult instance) =>
    <String, dynamic>{'retry_after_seconds': instance.retryAfterSeconds};

_AuthTokens _$AuthTokensFromJson(Map<String, dynamic> json) => _AuthTokens(
  accessToken: json['access_token'] as String,
  refreshToken: json['refresh_token'] as String,
  user: json['user'] == null
      ? null
      : AppUser.fromJson(json['user'] as Map<String, dynamic>),
  isNewUser: json['is_new_user'] as bool? ?? false,
);

Map<String, dynamic> _$AuthTokensToJson(_AuthTokens instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'user': ?instance.user?.toJson(),
      'is_new_user': instance.isNewUser,
    };
