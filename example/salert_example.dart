import 'package:salert/salert.dart';

void main() {
  ecuadorSriExample();
}

void ecuadorSriExample() {
  // ICE tax with 15% (ICE taxes always affect VAT taxes).
  final ice = Tax(code: 'iceX', unitValue: 15, affectTax: true);
  // VAT tax with 13%.
  final vat = Tax(code: 'IVA13', unitValue: 13);
  // Some item (product / service).
  final item = Item(
    code: 'productX',
    quantity: 2,
    unitPrice: 10,
    taxes: [ice, vat],
  );
  // The sale (aka Invoice)
  final sale = Sale(items: [item], tip: 1);
  // Calculate some values.
  print('Sale values:');
  print('   Subtotal iceX  ${sale.subtotalOf(ice.code).toMoneyString}');
  print('  Subtotal IVA13  ${sale.subtotalOf(vat.code).toMoneyString}');
  print('        SUBTOTAL  ${sale.subtotal.toMoneyString}');
  print('        Tax iceX  ${sale.taxOf(ice.code).toMoneyString}');
  print('       Tax IVA13  ${sale.taxOf(vat.code).toMoneyString}');
  print('             TAX  ${sale.tax.toMoneyString}');
  print('           TOTAL  ${sale.total.toMoneyString}');
}

extension NumberExtension on double {
  String get toMoneyString => toStringAsFixed(2).padLeft(5, '0');
}
