import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/paginated_response.dart';
import '../../../core/network/api_client.dart';
import 'order_models.dart';

/// Filter values accepted by `GET /orders?status=` (docs/API_SPEC.md).
enum OrdersFilter { active, completed, cancelled }

extension on OrdersFilter {
  String get apiValue => switch (this) {
        OrdersFilter.active => 'active',
        OrdersFilter.completed => 'completed',
        OrdersFilter.cancelled => 'cancelled',
      };
}

/// Calls `/orders*` (docs/API_SPEC.md). Order creation itself lives in
/// `CheckoutRepository` (`POST /orders` needs the `Idempotency-Key` header).
class OrdersRepository {
  OrdersRepository(this._client);

  final ApiClient _client;

  Future<PaginatedResponse<OrderSummary>> getOrders({
    required OrdersFilter filter,
    String? cursor,
  }) async {
    final json = await _client.get('/orders', queryParameters: {
      'status': filter.apiValue,
      if (cursor != null) 'cursor': cursor,
    });
    return PaginatedResponse.fromJson(json, OrderSummary.fromJson);
  }

  Future<OrderDetail> getOrder(String orderId) async {
    final json = await _client.get('/orders/$orderId');
    return OrderDetail.fromJson(json);
  }

  Future<void> cancelOrder({required String orderId, required String reason}) {
    return _client.post('/orders/$orderId/cancel', data: {'reason': reason}).then((_) {});
  }

  Future<void> reorder(String orderId) => _client.post('/orders/$orderId/reorder');

  Future<Map<String, dynamic>> getReceipt(String orderId) {
    return _client.get('/orders/$orderId/receipt');
  }
}

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepository(ref.watch(apiClientProvider));
});
