import 'package:flutter_test/flutter_test.dart';
import 'package:meno/core/core.dart';
import 'package:meno/shared/domain/value_objects/id.dart';

void main() {
  group('Id ValueObject', () {
    const validUuid = '123e4567-e89b-12d3-a456-426614174000';
    const invalidUuid = 'this-is-not-a-uuid';

    group('Factory: Id.unique()', () {
      test('should create a valid ID with a Right value', () {
        // Act
        final id = Id.unique();

        // Assert
        expect(id.isValid, isTrue);
        expect(id.value.isRight(), isTrue);
      });

      test('should generate different IDs on subsequent calls', () {
        // Act
        final id1 = Id.unique();
        final id2 = Id.unique();

        // Assert
        expect(id1, isNot(equals(id2)));
      });
    });

    group('Factory: Id.fromString()', () {
      test('should return Right when input is a valid UUID', () {
        // Act
        final id = Id.fromString(validUuid);

        // Assert
        expect(id.isValid, isTrue);
        expect(id.getOrCrash(), validUuid);
      });

      test('should return Right and trim whitespace from valid UUID', () {
        // Act
        final id = Id.fromString('  $validUuid  ');

        // Assert
        expect(id.isValid, isTrue);
        expect(id.getOrCrash(), validUuid); // Should match the trimmed version
      });

      test(
        'should return Left(RequiredValueException) when input is empty',
        () {
          // Act
          final id = Id.fromString('');

          // Assert
          expect(id.isValid, isFalse);
          id.value.fold(
            (failure) => expect(failure, isA<RequiredValueException>()),
            (_) => fail('Should be Left'),
          );
        },
      );

      test(
        'should return Left(InvalidValueException) when input is garbage',
        () {
          // Act
          final id = Id.fromString(invalidUuid);

          // Assert
          expect(id.isValid, isFalse);
          id.value.fold(
            (failure) => expect(failure, isA<InvalidValueException>()),
            (_) => fail('Should be Left'),
          );
        },
      );
    });

    group('Static: Id.empty', () {
      test('should represent a failure state (Left)', () {
        // Act
        const id = Id.empty;

        // Assert
        expect(id.isValid, isFalse);
        expect(id.value.isLeft(), isTrue);
      });
    });

    group('Equality (Equatable)', () {
      test('should consider two Ids with same value as equal', () {
        // Act
        final id1 = Id.fromString(validUuid);
        final id2 = Id.fromString(validUuid);

        // Assert
        expect(id1, equals(id2));
      });

      test('should consider two Ids with different values as not equal', () {
        // Act
        final id1 = Id.fromString(validUuid);
        final id2 = Id.unique();

        // Assert
        expect(id1, isNot(equals(id2)));
      });
    });
  });
}
