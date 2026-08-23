import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tajikshop/core/localization/fallback_localizations_delegate.dart';
import 'package:tajikshop/core/widgets/empty_state_view.dart';
import 'package:tajikshop/features/reviews/data/review_models.dart';
import 'package:tajikshop/features/reviews/presentation/widgets/product_reviews_list.dart';
import 'package:tajikshop/features/reviews/presentation/widgets/review_tile.dart';
import 'package:tajikshop/l10n/app_localizations.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    locale: const Locale('tg'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      ...AppLocalizations.localizationsDelegates,
      FallbackMaterialLocalizationsDelegate(),
      FallbackCupertinoLocalizationsDelegate(),
      FallbackWidgetsLocalizationsDelegate(),
    ],
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('shows the empty state when there are no reviews', (tester) async {
    await tester.pumpWidget(_wrap(const ProductReviewsList(reviews: [])));

    expect(find.byType(EmptyStateView), findsOneWidget);
    expect(find.byType(ReviewTile), findsNothing);
  });

  testWidgets('renders one ReviewTile per review when populated', (tester) async {
    final reviews = [
      Review(
        id: 'r1',
        productId: 'p1',
        rating: 5,
        text: 'Хеле хуб аст',
        createdAt: DateTime(2026, 1, 10),
        reviewerName: 'Али',
      ),
      Review(
        id: 'r2',
        productId: 'p1',
        rating: 3,
        createdAt: DateTime(2026, 1, 12),
      ),
    ];

    await tester.pumpWidget(_wrap(ProductReviewsList(reviews: reviews)));

    expect(find.byType(EmptyStateView), findsNothing);
    expect(find.byType(ReviewTile), findsNWidgets(2));
    expect(find.text('Али'), findsOneWidget);
    expect(find.text('Хеле хуб аст'), findsOneWidget);
  });
}
