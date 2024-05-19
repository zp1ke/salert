abstract class Sellable {
  /// Calculates subtotal amount including [discount] (before taxes).
  double get subtotal;

  /// Calculates subtotal amount including [discount] for given [taxCode] (before taxes).
  double subtotalOf(String taxCode);

  double get tax;

  /// Calculates tax amount including [discount] for given [taxCode].
  double taxOf(String taxCode);

  // Calculates discount amount before taxes.
  double get discountAmount;

  double get total;
}
