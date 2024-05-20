import 'package:salert/salert.dart';

void main() {
  ecuadorSriExample();
}

void ecuadorSriExample() {
  // ICE tax with 15% (ICE taxes always affect VAT taxes).
  final ice = Tax(code: 'iceX', unitValue: 15, affectTax: true);
  // VAT tax with 13%.
  final vat = Tax(code: 'IVA13', unitValue: 13);
  // Some item (product or service).
  final item = Item(
    code: 'productX',
    quantity: 2,
    unitPrice: 10,
    discount: Discount(amount: 1),
    taxes: [ice, vat],
  );
  // Calculate item values.
  printSellable(item, 'Item values:', [ice.code, vat.code]);
  // The sale (aka Invoice)
  final sale = Sale(items: [item], tip: 1);
  // Calculate sale values.
  printSellable(sale, 'Sale values:', [ice.code, vat.code]);
}

void printSellable(Sellable sellable, String title, List<String> taxCodes) {
  print(title);
  final pad = 30;
  for (final taxCode in taxCodes) {
    print(
      'Subtotal $taxCode  ${sellable.subtotalOf(taxCode).toMoneyString}'
          .padLeft(pad),
    );
  }
  print('SUBTOTAL  ${sellable.subtotal.toMoneyString}'.padLeft(pad));
  for (final taxCode in taxCodes) {
    print(
      'Tax $taxCode  ${sellable.taxOf(taxCode).toMoneyString}'.padLeft(pad),
    );
  }
  print('DISCOUNT  ${sellable.discountAmount.toMoneyString}'.padLeft(pad));
  print('TAX  ${sellable.tax.toMoneyString}'.padLeft(pad));
  print('TOTAL  ${sellable.total.toMoneyString}'.padLeft(pad));
  print('-------------------');
}

extension NumberExtension on double {
  String get toMoneyString => toStringAsFixed(2).padLeft(5, '0');
}
