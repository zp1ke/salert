import 'discount.dart';
import 'item.dart';
import 'sellable.dart';

class Sale implements Sellable {
  final List<Item> items;
  final Discount? discount;
  final double tip;

  Sale({
    required this.items,
    this.discount,
    this.tip = 0,
  });

  /// Calculates subtotal amount including [discount] (before taxes).
  @override
  double get subtotal {
    return items.map((item) => item.subtotal).reduce((s1, s2) => s1 + s2);
  }

  /// Calculates subtotal amount including [discount] for given [taxCode] (before taxes).
  @override
  double subtotalOf(String taxCode) {
    return items
        .map((item) => item.subtotalOf(taxCode))
        .reduce((s1, s2) => s1 + s2);
  }

  /// Calculates tax amount including [discount].
  @override
  double get tax {
    return items.map((item) => item.tax).reduce((s1, s2) => s1 + s2);
  }

  /// Calculates tax amount including [discount] for given [taxCode].
  @override
  double taxOf(String taxCode) {
    return items.map((item) => item.taxOf(taxCode)).reduce((s1, s2) => s1 + s2);
  }

  // Calculates discount amount before taxes.
  @override
  double get discountAmount {
    // TODO
    return 0;
  }

  @override
  double get total {
    return subtotal + tax;
  }
}
