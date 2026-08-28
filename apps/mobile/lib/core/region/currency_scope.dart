import 'package:flutter/widgets.dart';

/// Carries the active market's currency label ("сомонӣ", "₽", …) down the
/// widget tree.
///
/// Prices come from the API as bare decimal strings with no currency tag —
/// which currency they are in follows from the market the shopper is in — so
/// every price widget needs that label. Threading it through constructors
/// would touch every widget between the app root and each price; an
/// inherited scope, installed once in `main.dart` from
/// `activeCountryProvider`, lets plain `StatelessWidget` price rows read it
/// from their `BuildContext` without becoming `ConsumerWidget`s.
class CurrencyScope extends InheritedWidget {
  const CurrencyScope({super.key, required this.label, required super.child});

  /// Null while `GET /countries` is still in flight (or if it failed), in
  /// which case `CurrencyFormatter` falls back to the Tajik somoni names.
  final String? label;

  /// The active currency label, or null when no scope is installed (widget
  /// tests that mount a single widget) — callers pass it straight through to
  /// `CurrencyFormatter`, whose fallback handles null.
  static String? labelOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CurrencyScope>()?.label;
  }

  @override
  bool updateShouldNotify(CurrencyScope oldWidget) => oldWidget.label != label;
}
