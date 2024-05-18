import 'package:salert/salert.dart';
import 'package:test/test.dart';

void main() {
  group('Discount data', () {
    test('Value if percentage is converted to lower than one(1)', () {
      final amount = Discount(amount: 15, isPercentage: true);
      expect(amount.isPercentage, isTrue);
      expect(amount.amount, equals(0.15));
    });

    test('Value if not percentage is kept', () {
      final amount = Discount(amount: 15);
      expect(amount.isPercentage, isFalse);
      expect(amount.amount, equals(15));
    });
  });
}
