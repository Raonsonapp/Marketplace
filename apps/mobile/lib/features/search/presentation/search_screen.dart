import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/error_state_view.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../l10n/app_localizations.dart';
import '../../favorites/application/favorite_ids_controller.dart';
import '../application/search_controller.dart';

/// Search bar + results (`GET /search`, `GET /search/suggestions` —
/// docs/API_SPEC.md), with locally-stored recent searches.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        ref.read(searchControllerProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(searchControllerProvider);
    final favoriteIds = ref.watch(favoriteIdsControllerProvider).valueOrNull ?? const <String>{};

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _textController,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: l10n.searchHint,
            border: InputBorder.none,
          ),
          onChanged: (value) => ref.read(searchControllerProvider.notifier).updateQuery(value),
          onSubmitted: (value) => ref.read(searchControllerProvider.notifier).submitSearch(value),
        ),
      ),
      body: _buildBody(context, l10n, state, favoriteIds),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    SearchScreenState state,
    Set<String> favoriteIds,
  ) {
    if (state.results != null) {
      final results = state.results!;
      if (state.isSearching) {
        return const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: ProductGridSkeleton(),
        );
      }
      if (state.error != null) {
        return ErrorStateView(
          error: state.error!,
          onRetry: () => ref.read(searchControllerProvider.notifier).submitSearch(),
        );
      }
      if (results.items.isEmpty) {
        return EmptyStateView(icon: Icons.search_off, title: l10n.searchNoResults);
      }
      return GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: results.items.length + (results.hasMore ? 1 : 0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.sm,
          crossAxisSpacing: AppSpacing.sm,
          childAspectRatio: 0.62,
        ),
        itemBuilder: (context, index) {
          if (index >= results.items.length) return const ProductCardSkeleton();
          final product = results.items[index].copyWith(
            isFavorite: favoriteIds.contains(results.items[index].id),
          );
          return ProductCard(
            product: product,
            onTap: () => context.push(RoutePaths.productDetailPath(product.id)),
            onFavoriteToggle: () =>
                ref.read(favoriteIdsControllerProvider.notifier).toggle(product.id),
          );
        },
      );
    }

    if (state.isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        if (state.suggestions.suggestions.isNotEmpty) ...[
          Text(l10n.searchSuggestions, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: state.suggestions.suggestions
                .map((s) => ActionChip(label: Text(s), onPressed: () => _search(s)))
                .toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        if (state.recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.searchRecent, style: Theme.of(context).textTheme.titleMedium),
              TextButton(
                onPressed: () => ref.read(searchControllerProvider.notifier).clearRecentSearches(),
                child: Text(l10n.searchClearRecent),
              ),
            ],
          ),
          ...state.recentSearches.map(
            (query) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.history),
              title: Text(query),
              onTap: () => _search(query),
            ),
          ),
        ],
        if (state.suggestions.popular.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.searchSuggestions, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: state.suggestions.popular
                .map((s) => ActionChip(label: Text(s), onPressed: () => _search(s)))
                .toList(),
          ),
        ],
      ],
    );
  }

  void _search(String query) {
    _textController.text = query;
    ref.read(searchControllerProvider.notifier).submitSearch(query);
  }
}
