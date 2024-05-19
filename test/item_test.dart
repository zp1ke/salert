import 'package:salert/salert.dart';
import 'package:test/test.dart';

void main() {
  group('Item calculations', () {
    test('Subtotal calculation', () {
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

      // unit discount not affecting tax with one(1) tax
      discount = Discount(amount: 1, affectTax: false);
      var tax = Tax(code: 'tax1', unitValue: 10);
      item = Item(
        code: 'test',
        quantity: 1,
        unitPrice: 10,
        discount: discount,
        taxes: [tax],
      );
      // 10 x (1 + 0.1) = 11 (total without discount)
      // 11 - 1 = 10 (total with discount)
      // 10 / (1 + 0.1) = 9.09... (subtotal satisfying discounted total)
      expect(item.subtotal, closeTo(9.09, 0.01));

      // unit discount not affecting tax with two(2) taxes
      discount = Discount(amount: 1, affectTax: false);
      var tax2 = Tax(code: 'tax2', unitValue: 5, affectTax: true);
      item = Item(
        code: 'test',
        quantity: 1,
        unitPrice: 10,
        discount: discount,
        taxes: [tax, tax2],
      );
      // 10 x (1 + 0.05) = 10.5 (total with first tax)
      // 10.5 x (1 + 0.1) = 11.55 (total without discount)
      // 11.55 - 1 = 10.55 (total with discount)
      // 10.55 / (1 + 0.1) = 9.59... (subtotal without second tax)
      // 9.59 / (1 + 0.05) = 9.134... (subtotal satisfying discounted total)
      expect(item.subtotal, closeTo(9.134, 0.01));
    });

    test('Tax calculation', () {
      // no tax
      var item = Item(
        code: 'test',
        quantity: 1,
        unitPrice: 10,
      );
      expect(item.tax, equals(0));

      // unit discount not affecting tax with one(1) tax
      var discount = Discount(amount: 1, affectTax: false);
      var tax = Tax(code: 'tax1', unitValue: 10);
      item = Item(
        code: 'test',
        quantity: 1,
        unitPrice: 10,
        discount: discount,
        taxes: [tax],
      );
      // 10 x (1 + 0.1) = 11 (total without discount)
      // 11 - 1 = 10 (total with discount)
      // 10 / (1 + 0.1) = 9.09... (subtotal satisfying discounted total)
      // 9.09 * 0.1 = 0.909...
      expect(item.tax, closeTo(0.909, 0.01));

      // unit discount not affecting tax with two(2) taxes
      discount = Discount(amount: 1, affectTax: false);
      var tax2 = Tax(code: 'tax2', unitValue: 5, affectTax: true);
      item = Item(
        code: 'test',
        quantity: 1,
        unitPrice: 10,
        discount: discount,
        taxes: [tax, tax2],
      );
      // 10 x (1 + 0.05) = 10.5 (total with first tax)
      // 10.5 x (1 + 0.1) = 11.55 (total without discount)
      // 11.55 - 1 = 10.55 (total with discount)
      // 10.55 / (1 + 0.1) = 9.59... (subtotal without second tax)
      // 9.59 / (1 + 0.05) = 9.134... (subtotal satisfying discounted total)
      // 9.134 * (1 + 0.05) = 9.59 (first tax subtotal)
      // 9.134 * 0.05 = 0.4567 (first tax)
      // 9.59 * 0.1 = 0.959 (second tax)
      // 0.4567 + 0.959 = 1.41577...
      expect(item.tax, closeTo(1.41577, 0.01));
    });

    test('Discount calculation', () {
      // no tax
      var item = Item(
        code: 'test',
        quantity: 1,
        unitPrice: 10,
      );
      expect(item.discountAmount, equals(0));

      // unit discount not affecting tax with one(1) tax
      var discount = Discount(amount: 1, affectTax: false);
      var tax = Tax(code: 'tax1', unitValue: 10);
      item = Item(
        code: 'test',
        quantity: 1,
        unitPrice: 10,
        discount: discount,
        taxes: [tax],
      );
      // 10 x (1 + 0.1) = 11 (total without discount)
      // 11 - 1 = 10 (total with discount)
      // 10 / (1 + 0.1) = 9.09... (subtotal satisfying discounted total)
      // 10 - 9.09 = 0.909...
      expect(item.discountAmount, closeTo(0.909, 0.01));

      // unit discount not affecting tax with two(2) taxes
      discount = Discount(amount: 1, affectTax: false);
      var tax2 = Tax(code: 'tax2', unitValue: 5, affectTax: true);
      item = Item(
        code: 'test',
        quantity: 1,
        unitPrice: 10,
        discount: discount,
        taxes: [tax, tax2],
      );
      // 10 x (1 + 0.05) = 10.5 (total with first tax)
      // 10.5 x (1 + 0.1) = 11.55 (total without discount)
      // 11.55 - 1 = 10.55 (total with discount)
      // 10.55 / (1 + 0.1) = 9.59... (subtotal without second tax)
      // 9.59 / (1 + 0.05) = 9.134... (subtotal satisfying discounted total)
      // 10 - 9.134 = 0.866...
      expect(item.tax, closeTo(1.41577, 0.01));
    });
  });
}
