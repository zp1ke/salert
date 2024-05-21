import 'dart:math';

/// Represents a discount.
class Discount {
  /// Amount for calculations.
  final double amount;

  /// Unitary applies calculation for every item.
  final bool isUnitary;

  /// If amount represents a percentage.
  final bool isPercentage;

  /// True if applies before taxes.
  final bool affectTax;

  Discount({
    required double amount,
    this.isUnitary = true,
    this.isPercentage = false,
    this.affectTax = true,
  })  : assert(amount >= 0, 'Amount must be zero or positive.'),
        amount = !isPercentage || amount <= 1 ? amount : amount / 100;

  static Discount empty() => Discount(amount: .0);

  /// Calculates discount amount for given [value].
  double discountOf(double value) {
    if (isPercentage) {
      return value * amount;
    }
    return min(amount, value);
  }
}
