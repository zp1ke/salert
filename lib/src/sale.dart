import 'discount.dart';
import 'item.dart';

class Sale {
  final List<Item> items;
  final Discount? discount;
  final double tip;

  Sale({
    required this.items,
    this.discount,
    this.tip = 0,
  });

  /// Calculates subtotal amount including [discount] (excluding taxes).
  double get subtotal {
    return items.map((item) => item.subtotal).reduce((s1, s2) => s1 + s2);
  }

  /// Calculates subtotal amount including [discount] for given [taxCode] (excluding taxes).
  double subtotalOf(String taxCode) {
    return items
        .map((item) => item.subtotalOf(taxCode))
        .reduce((s1, s2) => s1 + s2);
  }

  /// Calculates tax amount including [discount].
  double get tax {
    return items.map((item) => item.tax).reduce((s1, s2) => s1 + s2);
  }

  /// Calculates tax amount including [discount] for given [taxCode].
  double taxOf(String taxCode) {
    return items.map((item) => item.taxOf(taxCode)).reduce((s1, s2) => s1 + s2);
  }

  double get total {
    return subtotal + tax;
  }
}
