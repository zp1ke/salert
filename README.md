<!--
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
-->

# Salert

Library for sales data calculations.

## Features

- Sales items calculations (discount, subtotal, taxes, total).
- Sales calculations (discount, subtotal, taxes, total).

## Usage

Example for SRI invoice (Ecuador):
```dart
// VAT tax with 13%.
final vat = Tax(code: 'IVA13', unitValue: 13);
// Invoice item (product or service).
final item = Item(code: 'productX', quantity: 1, unitPrice: 10, taxes: [vat]);
// The sale (aka Invoice)
final sale = Sale(items: [item], tip: 1);
// Calculate sale values.
print('SUBTOTAL  ${sale.subtotal}');
print('TAX  ${sale.tax}');
print('TOTAL  ${sale.total}');
```
