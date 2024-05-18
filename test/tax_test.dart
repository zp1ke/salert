import 'package:salert/salert.dart';
import 'package:test/test.dart';

void main() {
  group('Tax data', () {
    test('Value if percentage is converted to lower than one(1)', () {
      final tax = Tax(code: 'test', unitValue: 15);
      expect(tax.isPercentage, isTrue);
      expect(tax.unitValue, equals(0.15));
    });

    test('Value if not percentage is kept', () {
      final tax = Tax(code: 'test', unitValue: 15, isPercentage: false);
      expect(tax.isPercentage, isFalse);
      expect(tax.unitValue, equals(15));
    });
  });
}
