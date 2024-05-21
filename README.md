# Salert

[![Test](https://github.com/h4j4x/salert/actions/workflows/test.yml/badge.svg)](https://github.com/h4j4x/salert/actions/workflows/test.yml)

A library for efficient sales amounts calculations, including discounts, subtotal before taxes, taxes and total amounts.

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
