// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  phone: json['phone'] as String,
  fullName: json['full_name'] as String?,
  email: json['email'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  language: json['language'] as String? ?? 'tg',
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'phone': instance.phone,
  'full_name': ?instance.fullName,
  'email': ?instance.email,
  'avatar_url': ?instance.avatarUrl,
  'language': instance.language,
};
