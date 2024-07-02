import 'discount.dart';
import 'item.dart';
import 'pair.dart';
import 'sellable.dart';
import 'tax.dart';

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

  /// Calculates tax amount.
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

  /// Calculates total amount.
  @override
  double get total {
    return subtotal + tax + tip;
  }

  List<Item> get itemsWithSaleDiscount {
    return _items;
  }

  List<Item> get _items {
    if (discount == null) {
      return items;
    }
    final list = <Item>[];
    var theDiscount = _discount;
    for (final item in items) {
      if (theDiscount == null || theDiscount.amount == 0) {
        list.add(item);
        continue;
      }
      final discountPair = _discountAdding(item, theDiscount);
      final discountedItem = item.copyWith(discount: discountPair.first);
      list.add(discountedItem);

      theDiscount = discountPair.second;
    }
    return list;
  }

  Discount? get _discount {
    if (discount != null && !discount!.affectSubtotalBeforeTaxes) {
      final baseSubtotal =
          items.map((item) => item.subtotal).reduce((s1, s2) => s1 + s2);
      final baseTax = items.map((item) => item.tax).reduce((s1, s2) => s1 + s2);
      final baseTotal = baseSubtotal + baseTax + tip;
      var discountValue = discount!.discountOf(baseTotal);
      final discountedSubtotal = _inverseSubtotalOf(baseTotal - discountValue);
      discountValue = baseSubtotal - discountedSubtotal;
      return Discount(amount: discountValue);
    }
    return discount;
  }

  /// Calculates associated subtotal of given [total] using [items].
  double _inverseSubtotalOf(double total) {
    var subtotal = total;
    final taxes = _taxes;
    taxes.sort(Tax.comparator);
    for (final tax in taxes.reversed) {
      subtotal = tax.inverseSubtotalOf(subtotal);
    }
    return subtotal;
  }

  List<Tax> get _taxes {
    final taxes = <Tax>{};
    for (var item in items) {
      taxes.addAll(item.taxes);
    }
    final list = taxes.toList();
    list.sort(Tax.comparator);
    return list;
  }

  /// Adds given [addDiscount] to [discount].
  /// [addDiscount] is expected to be by value (not percentage) and affecting total.
  ///
  /// @return pair with:
  /// first parameter is result discount with the sum of [addDiscount] and [discount].
  /// second parameter is value of [addDiscount] that didn't fit for this item.
  Pair<Discount, Discount?> _discountAdding(Item item, Discount addDiscount) {
    final itemSubtotal = item.subtotal;
    final itemAddDiscount = addDiscount.discountOf(itemSubtotal);
    final itemDiscountAmount = item.discountAmount;
    final itemDiscount = Discount(
      amount: (itemAddDiscount / item.quantity) +
          (itemDiscountAmount / item.quantity),
    );
    Discount? restDiscount;
    if (addDiscount.amount > itemAddDiscount) {
      restDiscount = Discount(amount: addDiscount.amount - itemAddDiscount);
    }
    return Pair(first: itemDiscount, second: restDiscount);
  }
}
