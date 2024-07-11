abstract class Sellable {
  /// Calculates subtotal amount including [discount] (before taxes).
  double get subtotal;

  /// Calculates subtotal amount including [discount] for given [taxCode] (before taxes).
  double subtotalOf(String taxCode);

  /// Calculates tax amount.
  double get tax;

  /// Calculates tax amount including [discount] for given [taxCode].
  double taxOf(String taxCode);

  /// Calculates tax amount including [discount] for given [taxCodes].
  double taxOfCodes(List<String> taxCodes);

  // Calculates discount amount before taxes.
  double get discountAmount;

  /// Calculates total amount.
  double get total;
}
