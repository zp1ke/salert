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
}
