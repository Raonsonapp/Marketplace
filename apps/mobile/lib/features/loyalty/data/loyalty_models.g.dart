// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoyaltyAccount _$LoyaltyAccountFromJson(Map<String, dynamic> json) =>
    _LoyaltyAccount(
      balance: json['balance'] as String,
      tier: json['tier'] as String,
      lifetimeEarned: json['lifetime_earned'] as String,
    );

Map<String, dynamic> _$LoyaltyAccountToJson(_LoyaltyAccount instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'tier': instance.tier,
      'lifetime_earned': instance.lifetimeEarned,
    };

_LoyaltyTransaction _$LoyaltyTransactionFromJson(Map<String, dynamic> json) =>
    _LoyaltyTransaction(
      id: json['id'] as String,
      type: json['type'] as String,
      amount: json['amount'] as String,
      balanceAfter: json['balance_after'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$LoyaltyTransactionToJson(_LoyaltyTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'amount': instance.amount,
      'balance_after': instance.balanceAfter,
      'description': ?instance.description,
      'created_at': instance.createdAt.toIso8601String(),
      'expires_at': ?instance.expiresAt?.toIso8601String(),
    };
