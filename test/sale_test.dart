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
      var tax2 = Tax(code: 'tax2', unitValue: 5, affectTax: true);
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
      var tax2 = Tax(code: 'tax2', unitValue: 5, affectTax: true);
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

      // With two(2) items having two(2) taxes.
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
  });
}
