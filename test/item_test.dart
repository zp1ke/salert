import 'package:salert/salert.dart';
import 'package:test/test.dart';

void main() {
  group('Item calculations', () {
    test('Subtotal calculation includes discount', () {
      // no discount
      var item = Item(
        code: 'test',
        quantity: 1,
        unitPrice: 10,
      );
      expect(item.subtotal, equals(10));

      // unit discount
      var discount = Discount(amount: 1);
      item = Item(
        code: 'test',
        quantity: 1,
        unitPrice: 10,
        discount: discount,
      );
      expect(item.subtotal, equals(9));

      // unit percentage discount
      discount = Discount(amount: 10, isPercentage: true);
      item = Item(
        code: 'test',
        quantity: 1,
        unitPrice: 10,
        discount: discount,
      );
      expect(item.subtotal, equals(9));

      // total discount
      discount = Discount(amount: 1, isUnitary: false);
      item = Item(
        code: 'test',
        quantity: 2,
        unitPrice: 10,
        discount: discount,
      );
      expect(item.subtotal, equals(19));

      // total percentage discount
      discount = Discount(amount: 10, isPercentage: true, isUnitary: false);
      item = Item(
        code: 'test',
        quantity: 2,
        unitPrice: 10,
        discount: discount,
      );
      expect(item.subtotal, equals(18));

      // unit discount not affecting tax
      discount = Discount(amount: 1, affectTax: false);
      var tax = Tax(code: 'test', unitValue: 10); // ten(10) percent tax
      item = Item(
        code: 'test',
        quantity: 1,
        unitPrice: 10,
        discount: discount,
        taxes: [tax],
      );
      expect(item.subtotal, closeTo(9.09, 0.01));
    });
  });
}
