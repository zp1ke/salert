import 'package:salert/salert.dart';
import 'package:test/test.dart';

void main() {
  group('Sale calculation', () {
    test('Subtotal calculation', () {
      // No taxes
      var item = Item(code: 'item1', quantity: 2, unitPrice: 10);
      var sale = Sale(items: [item]);
      expect(sale.subtotal, 20);
      expect(sale.subtotalOf('tax1'), 0);

      // With one(1) item having one(1) tax.
      var tax = Tax(code: 'tax1', unitValue: 10);
      item = Item(code: 'item1', quantity: 2, unitPrice: 10, taxes: [tax]);
      sale = Sale(items: [item]);
      expect(sale.subtotal, 20);
      expect(sale.subtotalOf('tax1'), 20);

      // With one(1) item having two(2) taxes.
      var tax2 = Tax(code: 'tax2', unitValue: 5, affectNextTaxSubtotal: true);
      item = Item(
        code: 'item1',
        quantity: 2,
        unitPrice: 10,
        taxes: [tax, tax2],
      );
      sale = Sale(items: [item]);
      expect(sale.subtotal, 20);
      expect(sale.subtotalOf('tax1'), 21);
      expect(sale.subtotalOf('tax2'), 20);

      // With two(2) items having two(2) taxes.
      var item2 = Item(
        code: 'item2',
        quantity: 1,
        unitPrice: 10,
        taxes: [tax, tax2],
      );
      sale = Sale(items: [item, item2]);
      expect(sale.subtotal, 30);
      expect(sale.subtotalOf('tax1'), 31.5);
      expect(sale.subtotalOf('tax2'), 30);
    });

    test('Tax calculation', () {
      // No taxes
      var item = Item(code: 'item1', quantity: 2, unitPrice: 10);
      var sale = Sale(items: [item]);
      expect(sale.tax, 0);
      expect(sale.taxOf('tax1'), 0);

      // With one(1) item having one(1) tax.
      var tax = Tax(code: 'tax1', unitValue: 10);
      item = Item(code: 'item1', quantity: 2, unitPrice: 10, taxes: [tax]);
      sale = Sale(items: [item]);
      expect(sale.tax, 2);
      expect(sale.taxOf('tax1'), 2);

      // With one(1) item having two(2) taxes.
      var tax2 = Tax(code: 'tax2', unitValue: 5, affectNextTaxSubtotal: true);
      item = Item(
        code: 'item1',
        quantity: 2,
        unitPrice: 10,
        taxes: [tax, tax2],
      );
      sale = Sale(items: [item]);
      expect(sale.tax, 3.1);
      expect(sale.taxOf('tax1'), 2.1);
      expect(sale.taxOf('tax2'), 1);

      // With two(2) items having two(2) taxes each.
      var item2 = Item(
        code: 'item2',
        quantity: 1,
        unitPrice: 10,
        taxes: [tax, tax2],
      );
      sale = Sale(items: [item, item2]);
      expect(sale.tax, 4.65);
      expect(sale.taxOf('tax1'), closeTo(3.15, 0.01));
      expect(sale.taxOf('tax2'), 1.5);
    });

    test('Discount calculation', () {
      // No discount
      var item = Item(code: 'item1', quantity: 2, unitPrice: 10);
      var sale = Sale(items: [item]);
      expect(sale.discountAmount, 0);

      // With one(1) item having one(1) tax each affecting total value.
      final tax = Tax(code: 'tax1', unitValue: 10);
      item = Item(code: 'item1', quantity: 2, unitPrice: 10, taxes: [tax]);
      var discount = Discount(amount: 1, affectSubtotalBeforeTaxes: false);
      sale = Sale(items: [item], discount: discount);
      expect(sale.discountAmount, closeTo(0.909, 0.01));

      // With one(1) item having two(2) taxes affecting total value.
      var tax2 = Tax(code: 'tax2', unitValue: 5, affectNextTaxSubtotal: true);
      item = Item(
        code: 'item1',
        quantity: 2,
        unitPrice: 10,
        taxes: [tax, tax2],
      );
      sale = Sale(items: [item], discount: discount);
      expect(sale.discountAmount, closeTo(0.8658, 0.01));

      // With two(2) items having two(2) taxes each affecting total value.
      var item2 = Item(
        code: 'item2',
        quantity: 1,
        unitPrice: 10,
        taxes: [tax, tax2],
      );
      sale = Sale(items: [item, item2], discount: discount);
      expect(sale.discountAmount, closeTo(0.8658, 0.01));

      // With one(1) item having one(1) tax and discount; affecting total value.
      final item3 = Item(
        code: 'item3',
        quantity: 1,
        unitPrice: 10,
        taxes: [tax],
        discount: Discount(amount: 1),
      );
      sale = Sale(items: [item3], discount: discount);
      expect(sale.discountAmount, closeTo(1.909, 0.01));
    });

    test('Overall calculations', () {
      // With two(2) items having one(1) tax each.
      var itemA = Item(
        code: 'itemA',
        quantity: 1,
        unitPrice: 11,
        taxes: [
          Tax(
            code: 'tax15',
            unitValue: 15,
            affectNextTaxSubtotal: false,
          ),
        ],
        discount: Discount(amount: 2),
      );
      var itemB = Item(
        code: 'itemB',
        quantity: 1,
        unitPrice: 12,
        taxes: [
          Tax(
            code: 'tax15',
            unitValue: 15,
            affectNextTaxSubtotal: false,
          ),
        ],
        discount: Discount(amount: 1),
      );
      // No discount
      var sale = Sale(items: [itemA, itemB]);
      expect(sale.discountAmount, 3);
      expect(sale.subtotal, 20);
      expect(sale.tax, 3);
      expect(sale.total, 23);
      // Still no discount
      sale = Sale(
        items: [itemA, itemB],
        discount: Discount(amount: 0),
      );
      expect(sale.discountAmount, 3);
      expect(sale.subtotal, 20);
      expect(sale.tax, 3);
      expect(sale.total, 23);
      // Again no discount
      sale = Sale(
        items: [itemA, itemB],
        discount: Discount(amount: 0, affectSubtotalBeforeTaxes: false),
      );
      expect(sale.discountAmount, 3);
      expect(sale.subtotal, 20);
      expect(sale.tax, 3);
      expect(sale.total, 23);
      // With subtotal discount
      sale = Sale(
        items: [itemA, itemB],
        discount: Discount(amount: 1, affectSubtotalBeforeTaxes: true),
      );
      expect(sale.discountAmount, 4);
      expect(sale.subtotal, 19);
      expect(sale.tax, closeTo(2.85, 0.01));
      expect(sale.total, closeTo(21.85, 0.01));
      // With total discount
      sale = Sale(
        items: [itemA, itemB],
        discount: Discount(amount: 1, affectSubtotalBeforeTaxes: false),
      );
      expect(sale.discountAmount, closeTo(3.87, 0.01));
      expect(sale.subtotal, closeTo(19.13, 0.01));
      expect(sale.tax, closeTo(2.87, 0.01));
      expect(sale.total, closeTo(22, 0.01));
      // With zero total discount
      final itemC = Item(
        code: 'itemC',
        quantity: 1,
        unitPrice: 6.956522,
        taxes: [
          Tax(
            code: 'tax15',
            unitValue: 15,
            affectNextTaxSubtotal: false,
          ),
        ],
        discount: Discount(amount: 0),
      );
      sale = Sale(
        items: [itemC],
        discount: Discount(amount: 0, affectSubtotalBeforeTaxes: false),
      );
      expect(sale.discountAmount, 0);
      expect(sale.subtotal, closeTo(6.96, 0.01));
      expect(sale.tax, closeTo(1.04, 0.01));
      expect(sale.total, closeTo(8, 0.01));
    });

    test('Sale discount calculation', () {
      // With one(1) item having one(1) tax and discount; affecting total value.
      final tax = Tax(code: 'tax1', unitValue: 15);
      final item = Item(
        code: 'item',
        quantity: 1,
        unitPrice: 11,
        taxes: [tax],
        discount: Discount(amount: 1),
      );
      var discount = Discount(amount: 1.5, affectSubtotalBeforeTaxes: false);
      var sale = Sale(items: [item], discount: discount);
      expect(sale.discountAmountOfSaleAffectingSubtotal, closeTo(1.3, 0.01));
      expect(sale.total, closeTo(10.0, 0.01));

      // With one(1) item having one(1) tax and discount; affecting total value.
      discount = Discount(amount: 1.3);
      sale = Sale(items: [item], discount: discount);
      expect(sale.discountAmountOfSaleAffectingSubtotal, closeTo(1.3, 0.01));
      expect(sale.total, closeTo(10.0, 0.01));
    });

    test('Empty sale calculation', () {
      var sale = Sale(items: []);
      expect(sale.subtotal, .0);
      expect(sale.tax, .0);
      expect(sale.discountAmount, .0);
      expect(sale.total, .0);
    });
  });
}
