import 'dart:math';

class Discount {
  final double amount;
  final bool isUnitary;
  final bool isPercentage;
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
