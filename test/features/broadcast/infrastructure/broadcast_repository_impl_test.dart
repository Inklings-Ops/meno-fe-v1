import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/exceptions/meno_exception.dart';
import 'package:meno/features/broadcast/infrastructure/infrastructure.dart';
import 'package:meno/shared/domain/domain.dart';
import 'package:mockito/mockito.dart';

// Manual mocks since mockito/mocktail are not in pubspec or we want to avoid extra steps
class MockBroadcastRemoteDataSource extends Mock
    implements BroadcastRemoteDataSource {
  @override
  Future<dynamic> getBroadcasts(
    Map<String, dynamic>? queryParameters, {
    dynamic cancelToken,
  }) async => super.noSuchMethod(
    Invocation.method(
      #getBroadcasts,
      [queryParameters],
      {#cancelToken: cancelToken},
    ),
    returnValue: Future.value({}),
  );
}

class MockBroadcastLocalDataSource extends Mock
    implements BroadcastLocalDataSource {}

void main() {
  late BroadcastRepositoryImpl repository;
  late MockBroadcastRemoteDataSource mockRemote;
  late MockBroadcastLocalDataSource mockLocal;

  setUp(() {
    mockRemote = MockBroadcastRemoteDataSource();
    mockLocal = MockBroadcastLocalDataSource();
    repository = BroadcastRepositoryImpl(remote: mockRemote, local: mockLocal);
  });

  group('getBroadcasts', () {
    const tBroadcastId = '123e4567-e89b-12d3-a456-426614174000';
    final tBroadcastDtoMap = {
      'id': tBroadcastId,
      'title': 'Test Broadcast',
      'description': 'Test Description',
      'status': 'inactive',
    };

    final tResponse = {
      'broadcasts': [tBroadcastDtoMap],
      'currentPage': 1,
      'totalItems': 1,
      'totalPages': 1,
    };

    const tQuery = BroadcastQuery();

    test(
      'should return Right(PagedList) when remote call is successful',
      () async {
        // Arrange
        when(
          mockRemote.getBroadcasts(any, cancelToken: anyNamed('cancelToken')),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await repository.getBroadcasts(tQuery);

        // Assert
        expect(result.isRight(), true);
        result.fold((l) => fail('Should be Right'), (r) {
          expect(r.items.length, 1);
          expect(r.items.first?.id.getOrCrash(), tBroadcastId);
          expect(r.currentPage, 1);
        });
        verify(
          mockRemote.getBroadcasts(
            argThat(containsPair('page', 1)),
            cancelToken: anyNamed('cancelToken'),
          ),
        ).called(1);
      },
    );

    test(
      'should return Left(MenoException) when remote throws MenoException',
      () async {
        // Arrange
        const tException = MenoException('Server Error', 500);
        when(
          mockRemote.getBroadcasts(any, cancelToken: anyNamed('cancelToken')),
        ).thenThrow(tException);

        // Act
        final result = await repository.getBroadcasts(tQuery);

        // Assert
        expect(result, const Left(tException));
      },
    );

    test(
      'should return Left(MenoException) when an unexpected error occurs',
      () async {
        // Arrange
        final tError = Exception('Unexpected');
        when(
          mockRemote.getBroadcasts(any, cancelToken: anyNamed('cancelToken')),
        ).thenThrow(tError);

        // Act
        final result = await repository.getBroadcasts(tQuery);

        // Assert
        result.fold(
          (l) => expect(l.message, contains('Unexpected')),
          (r) => fail('Should be Left'),
        );
      },
    );

    test('should build correct query parameters for complex query', () async {
      // Arrange
      const complexQuery = BroadcastQuery(
        pagination: PaginationParams(page: 2, size: 15),
        status: BroadcastStatus.active,
        keywords: 'flutter',
        includeTotalListeners: true,
      );
      when(
        mockRemote.getBroadcasts(any, cancelToken: anyNamed('cancelToken')),
      ).thenAnswer((_) async => tResponse);

      // Act
      await repository.getBroadcasts(complexQuery);

      // Assert
      verify(
        mockRemote.getBroadcasts(
          argThat(
            allOf([
              containsPair('page', 2),
              containsPair('size', 15),
              containsPair('status', 'active'),
              containsPair('keywords', 'flutter'),
              containsPair('include', 'totalListeners'),
            ]),
          ),
          cancelToken: anyNamed('cancelToken'),
        ),
      ).called(1);
    });
  });
}
