import 'discount.dart';
import 'item.dart';

class Sale {
  final List<Item> items;
  final Discount? discount;

  Sale({
    required this.items,
    this.discount,
  });
}
