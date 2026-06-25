import 'package:flutter_test/flutter_test.dart';
import 'package:safe_opensig/shared/models/simulation/state_verifier/evm_state_verifier.dart';

void main() {
  group('normalizeStorageKey', () {
    test('normalizes minimal and padded slot zero to the same key', () {
      const paddedSlotZero =
          '0x0000000000000000000000000000000000000000000000000000000000000000';

      expect(normalizeStorageKey('0x0'), paddedSlotZero);
      expect(normalizeStorageKey(paddedSlotZero), paddedSlotZero);
    });

    test('normalizes odd-length minimal keys', () {
      expect(
        normalizeStorageKey('0xabc'),
        '0x0000000000000000000000000000000000000000000000000000000000000abc',
      );
    });

    test('accepts uppercase hex prefix', () {
      expect(
        normalizeStorageKey('0XABC'),
        '0x0000000000000000000000000000000000000000000000000000000000000abc',
      );
    });

    test('rejects non-hex storage keys', () {
      expect(() => normalizeStorageKey('0xzz'), throwsFormatException);
      expect(() => normalizeStorageKey('slot-0'), throwsFormatException);
    });
  });
}
