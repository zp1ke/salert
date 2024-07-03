import 'dart:math';

class Tax {
  final String code;
  final double unitValue;
  final bool isPercentage;
  final bool affectNextTaxSubtotal;
  final int priority;

  Tax({
    required this.code,
    required double unitValue,
    this.isPercentage = true,
    this.affectNextTaxSubtotal = false,
    this.priority = 1,
  })  : assert(
          unitValue >= 0,
          'Unit value must be zero or positive.',
        ),
        unitValue =
            !isPercentage || unitValue <= 1 ? unitValue : unitValue / 100;

  /// Calculates tax amount for given [value].
  double taxOf(double value) {
    if (isPercentage) {
      return value * unitValue;
    }
    return unitValue;
  }

  /// Calculates subtotal for given [total].
  double inverseSubtotalOf(double total) {
    if (isPercentage) {
      return total / (1 + unitValue);
    }
    return max(total - unitValue, 0);
  }

  @override
  bool operator ==(Object other) =>
      other is Tax && other.runtimeType == runtimeType && other.code == code;

  @override
  int get hashCode => code.hashCode;

  static Comparator<Tax> get comparator => (Tax tax1, Tax tax2) {
        final byPriority = tax1.priority.compareTo(tax2.priority);
        if (byPriority != 0) {
          return byPriority;
        }
        if (tax1.affectNextTaxSubtotal == tax2.affectNextTaxSubtotal) {
          return 0;
        }
        return tax1.affectNextTaxSubtotal ? -1 : 1;
      };
}
