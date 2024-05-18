import 'discount.dart';
import 'tax.dart';

/// Represents a sale item (product or service).
class Item {
  final String code;
  final double quantity;
  final double unitPrice;
  final Discount? discount;
  final List<Tax> taxes;

  Item({
    required this.code,
    required this.quantity,
    required this.unitPrice,
    this.discount,
    List<Tax>? taxes,
  })  : assert(
          quantity >= 0,
          'Quantity must be zero or positive.',
        ),
        assert(
          unitPrice >= 0,
          'Unit price must be zero or positive.',
        ),
        taxes = <Tax>[] {
    if (taxes != null) {
      taxes.sort((tax1, tax2) => tax1.priority.compareTo(tax2.priority));
      this.taxes.addAll(taxes);
    }
  }

  /// Calculates subtotal amount including [discount] (excluding taxes).
  double get subtotal {
    if (discount == null || discount!.affectTax) {
      return _subtotalOf(unitPrice, discount);
    }
    final base = _subtotalOf(unitPrice);
    final baseTax = _taxAmountOf(base);
    var baseTotal = base + baseTax;
    baseTotal -= discount!.discountOf(baseTotal);
    final inverse = _inverseSubtotalOf(baseTotal);
    return _subtotalOf(inverse / quantity);
  }

  /// Calculates subtotal amount of given [price] including [discount] (excluding taxes).
  double _subtotalOf(double price, [Discount? discount]) {
    final theDiscount = discount ?? Discount.empty();
    if (theDiscount.isUnitary) {
      price -= theDiscount.discountOf(price);
    }
    var value = quantity * price;
    if (!theDiscount.isUnitary) {
      value -= theDiscount.discountOf(value);
    }
    return value;
  }

  /// Calculates tax amount of given [subtotal].
  double _taxAmountOf(double subtotal) {
    var value = .0;
    for (final tax in taxes) {
      final taxAmount = tax.taxOf(subtotal);
      value += taxAmount;
      if (tax.affectTax) {
        subtotal += taxAmount;
      }
    }
    return value;
  }

  /// Calculates associated subtotal of given [total] using [taxes].
  double _inverseSubtotalOf(double total) {
    var subtotal = total;
    for (final tax in taxes.reversed) {
      subtotal = tax.inverseSubtotalOf(subtotal);
    }
    return subtotal;
  }
}
