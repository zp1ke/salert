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
    return _items.map((item) => item.subtotal).reduce((s1, s2) => s1 + s2);
  }

  /// Calculates subtotal amount including [discount] for given [taxCode] (before taxes).
  @override
  double subtotalOf(String taxCode) {
    return _items
        .map((item) => item.subtotalOf(taxCode))
        .reduce((s1, s2) => s1 + s2);
  }

  /// Calculates tax amount including [discount].
  @override
  double get tax {
    return _items.map((item) => item.tax).reduce((s1, s2) => s1 + s2);
  }

  /// Calculates tax amount including [discount] for given [taxCode].
  @override
  double taxOf(String taxCode) {
    return _items
        .map((item) => item.taxOf(taxCode))
        .reduce((s1, s2) => s1 + s2);
  }

  // Calculates discount amount before taxes.
  @override
  double get discountAmount {
    return _items
        .map((item) => item.discountAmount)
        .reduce((s1, s2) => s1 + s2);
  }

  @override
  double get total {
    return subtotal + tax;
  }

  List<Item> get _items {
    if (discount == null) {
      return items;
    }
    final list = <Item>[];
    var theDiscount = discount;
    for (final item in items) {
      if (theDiscount == null) {
        list.add(item);
        continue;
      }
      final discountPair = item.discountAdding(theDiscount);
      final discountedItem = item.copyWith(discount: discountPair.first);
      list.add(discountedItem);

      theDiscount = discountPair.second;
    }
    return list;
  }
}
