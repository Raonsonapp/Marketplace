/// Generic wrapper for cursor-paginated list endpoints, matching
/// docs/API_SPEC.md's convention: `{ "data": [...], "next_cursor": "..." }`.
///
/// Not a freezed/json_serializable model because the item type `T` is
/// supplied per-call with a custom decoder (generic json_serializable
/// codegen for arbitrary `T` adds complexity with no real benefit here).
class PaginatedResponse<T> {
  const PaginatedResponse({required this.data, required this.nextCursor});

  final List<T> data;
  final String? nextCursor;

  bool get hasMore => nextCursor != null;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson,
  ) {
    final rawList = (json['data'] as List<dynamic>?) ?? const [];
    return PaginatedResponse<T>(
      data: rawList.map((e) => itemFromJson(e as Map<String, dynamic>)).toList(),
      nextCursor: json['next_cursor'] as String?,
    );
  }

  static const empty = PaginatedResponse(data: [], nextCursor: null);
}
