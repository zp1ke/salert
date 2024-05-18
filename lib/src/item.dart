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
    this.taxes = const [],
  })  : assert(
          quantity >= 0,
          'Quantity must be zero or positive.',
        ),
        assert(
          unitPrice >= 0,
          'Unit price must be zero or positive.',
        );

  /// Calculates subtotal amount including discount (excluding taxes).
  double get subtotal {
    var price = unitPrice;
    final theDiscount = discount ?? Discount.empty();
    if (theDiscount.isUnitary) {
      price -= theDiscount.discountOf(price);
    }
    var value = quantity * price;
    if (!theDiscount.isUnitary) {
      value -= discount!.discountOf(value);
    }
    return value;
  }
}
