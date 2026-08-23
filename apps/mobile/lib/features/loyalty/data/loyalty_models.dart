import 'package:freezed_annotation/freezed_annotation.dart';

part 'loyalty_models.freezed.dart';
part 'loyalty_models.g.dart';

/// TajBonus account summary (`GET /loyalty` — docs/API_SPEC.md, Section 15
/// "TajBonus"). Money fields are decimal strings, matching every other
/// monetary field in the app.
@freezed
abstract class LoyaltyAccount with _$LoyaltyAccount {
  const factory LoyaltyAccount({
    required String balance,
    required String tier,
    required String lifetimeEarned,
  }) = _LoyaltyAccount;

  factory LoyaltyAccount.fromJson(Map<String, dynamic> json) => _$LoyaltyAccountFromJson(json);
}

/// One `loyalty_transactions` ledger row (`GET /loyalty/transactions` —
/// docs/API_SPEC.md), matching docs/DATABASE_SCHEMA.md's `type` CHECK
/// constraint exactly (`earn|spend|expire|adjust|campaign`).
enum LoyaltyTransactionType {
  earn,
  spend,
  expire,
  adjust,
  campaign;

  static LoyaltyTransactionType fromApi(String value) {
    return switch (value) {
      'earn' => LoyaltyTransactionType.earn,
      'spend' => LoyaltyTransactionType.spend,
      'expire' => LoyaltyTransactionType.expire,
      'adjust' => LoyaltyTransactionType.adjust,
      'campaign' => LoyaltyTransactionType.campaign,
      _ => LoyaltyTransactionType.adjust,
    };
  }
}

@freezed
abstract class LoyaltyTransaction with _$LoyaltyTransaction {
  const factory LoyaltyTransaction({
    required String id,
    required String type,
    required String amount,
    required String balanceAfter,
    String? description,
    required DateTime createdAt,
    DateTime? expiresAt,
  }) = _LoyaltyTransaction;

  factory LoyaltyTransaction.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyTransactionFromJson(json);
}
