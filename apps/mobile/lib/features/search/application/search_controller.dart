import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/paginated_state.dart';
import '../../../core/models/product.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/storage/preferences_storage.dart';
import '../data/search_models.dart';
import '../data/search_repository.dart';

part 'search_controller.freezed.dart';

@freezed
class SearchScreenState with _$SearchScreenState {
  const factory SearchScreenState({
    @Default('') String query,
    @Default(false) bool isSearching,
    @Default(false) bool isLoadingSuggestions,
    PaginatedState<Product>? results,
    @Default(SearchSuggestions()) SearchSuggestions suggestions,
    @Default(<String>[]) List<String> recentSearches,
    AppException? error,
  }) = _SearchScreenState;
}

/// Drives the search screen: recent searches (local), suggestions
/// (`GET /search/suggestions`), and paginated results (`GET /search`) — see
/// docs/API_SPEC.md.
class SearchController extends Notifier<SearchScreenState> {
  @override
  SearchScreenState build() {
    final recents = ref.watch(preferencesStorageProvider).readRecentSearches();
    return SearchScreenState(recentSearches: recents);
  }

  void updateQuery(String query) {
    state = state.copyWith(query: query, results: null, error: null);
    if (query.trim().isEmpty) {
      state = state.copyWith(suggestions: const SearchSuggestions());
      return;
    }
    _loadSuggestions(query);
  }

  Future<void> _loadSuggestions(String query) async {
    state = state.copyWith(isLoadingSuggestions: true);
    try {
      final suggestions = await ref.read(searchRepositoryProvider).getSuggestions(query);
      if (state.query == query) {
        state = state.copyWith(suggestions: suggestions, isLoadingSuggestions: false);
      }
    } catch (_) {
      state = state.copyWith(isLoadingSuggestions: false);
    }
  }

  Future<void> submitSearch([String? explicitQuery]) async {
    final query = (explicitQuery ?? state.query).trim();
    if (query.isEmpty) return;

    state = state.copyWith(query: query, isSearching: true, error: null, results: null);
    await ref.read(preferencesStorageProvider).addRecentSearch(query);
    state = state.copyWith(recentSearches: ref.read(preferencesStorageProvider).readRecentSearches());

    try {
      final page = await ref.read(searchRepositoryProvider).search(query: query);
      state = state.copyWith(
        isSearching: false,
        results: PaginatedState(items: page.data, nextCursor: page.nextCursor),
      );
    } catch (e) {
      state = state.copyWith(isSearching: false, error: ErrorMapper.map(e));
    }
  }

  Future<void> loadMore() async {
    final current = state.results;
    if (current == null || !current.hasMore || current.isLoadingMore) return;
    state = state.copyWith(results: current.copyWith(isLoadingMore: true));
    try {
      final page = await ref.read(searchRepositoryProvider).search(
            query: state.query,
            cursor: current.nextCursor,
          );
      state = state.copyWith(
        results: current.copyWith(
          items: [...current.items, ...page.data],
          nextCursor: page.nextCursor,
          clearCursor: page.nextCursor == null,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      state = state.copyWith(results: current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> clearRecentSearches() async {
    await ref.read(preferencesStorageProvider).clearRecentSearches();
    state = state.copyWith(recentSearches: const []);
  }
}

final searchControllerProvider =
    NotifierProvider<SearchController, SearchScreenState>(SearchController.new);
