import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon/common/index.dart';

void main() {
  group('ResponsiveUtils', () {
    group('breakpoints', () {
      test('mobileBreakpoint is 480', () {
        expect(ResponsiveUtils.mobileBreakpoint, equals(480));
      });

      test('tabletBreakpoint is 768', () {
        expect(ResponsiveUtils.tabletBreakpoint, equals(768));
      });

      test('desktopBreakpoint is 1024', () {
        expect(ResponsiveUtils.desktopBreakpoint, equals(1024));
      });
    });
  });
}
