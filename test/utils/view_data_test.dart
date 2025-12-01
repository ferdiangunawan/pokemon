import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon/common/index.dart';

void main() {
  group('ViewData', () {
    test('initial state should have correct values', () {
      final viewData = ViewData<String>.initial();

      expect(viewData.isInitial, isTrue);
      expect(viewData.isLoading, isFalse);
      expect(viewData.isHasData, isFalse);
      expect(viewData.isError, isFalse);
      expect(viewData.data, isNull);
      expect(viewData.message, isEmpty);
    });

    test('loading state should have correct values', () {
      final viewData = ViewData<String>.loading();

      expect(viewData.isInitial, isFalse);
      expect(viewData.isLoading, isTrue);
      expect(viewData.isHasData, isFalse);
      expect(viewData.isError, isFalse);
    });

    test('loaded state should have correct values', () {
      final viewData = ViewData<String>.loaded(data: 'test data');

      expect(viewData.isInitial, isFalse);
      expect(viewData.isLoading, isFalse);
      expect(viewData.isHasData, isTrue);
      expect(viewData.isError, isFalse);
      expect(viewData.data, equals('test data'));
    });

    test('error state should have correct values', () {
      final viewData = ViewData<String>.error(message: 'error message');

      expect(viewData.isInitial, isFalse);
      expect(viewData.isLoading, isFalse);
      expect(viewData.isHasData, isFalse);
      expect(viewData.isError, isTrue);
      expect(viewData.message, equals('error message'));
    });

    test('copyWith should create new instance with updated status', () {
      final original = ViewData<String>.loaded(data: 'initial data');
      final updated = original.copyWith(status: ViewState.loading);

      expect(updated.isLoading, isTrue);
      expect(updated.data, equals('initial data'));
      expect(original.isHasData, isTrue);
    });

    test('copyWith should preserve data when only status changes', () {
      final original = ViewData<String>.loaded(data: 'test data');
      final updated = original.copyWith(
        status: ViewState.error,
        message: 'error',
      );

      expect(updated.isError, isTrue);
      expect(updated.data, equals('test data'));
      expect(updated.message, equals('error'));
    });
  });
}
