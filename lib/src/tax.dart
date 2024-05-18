class Tax {
  final String code;
  final double unitValue;
  final bool isPercentage;
  final bool affectTax;
  final int priority;

  Tax({
    required this.code,
    required double unitValue,
    this.isPercentage = true,
    this.affectTax = false,
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
}
