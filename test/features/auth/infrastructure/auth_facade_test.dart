// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:meno_fe_v1/features/auth/domain/exceptions/auth_exception.dart';
// import 'package:meno_fe_v1/features/auth/domain/inputs/inputs.dart';
// import 'package:meno_fe_v1/features/auth/infrastructure/auth_facade.dart';
// import 'package:meno_fe_v1/features/auth/infrastructure/datasources/auth_local_datasource.dart';
// import 'package:meno_fe_v1/features/auth/infrastructure/datasources/auth_remote_datasource.dart';
// import 'package:meno_fe_v1/features/auth/infrastructure/mapper/auth_mapper.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';

// import 'auth_facade_test.mocks.dart';

// @GenerateNiceMocks([
//   MockSpec<AuthRemoteDatasource>(),
//   MockSpec<AuthLocalDatasource>(),
//   MockSpec<AuthMapper>()
// ])
// void main() {
//   late AuthFacade authFacade;
//   late MockAuthRemoteDatasource mockAuthRemoteDatasource;
//   late MockAuthLocalDatasource mockAuthLocalDatasource;
//   late MockAuthMapper mockAuthMapper;

//   setUp(() {
//     mockAuthRemoteDatasource = MockAuthRemoteDatasource();
//     mockAuthLocalDatasource = MockAuthLocalDatasource();
//     mockAuthMapper = MockAuthMapper();

//     authFacade = AuthFacade(
//       authMapper: mockAuthMapper,
//       localDatasource: mockAuthLocalDatasource,
//       remoteDatasource: mockAuthRemoteDatasource,
//     );
//   });

//   final tEmail = IEmail("email@example.com");
//   final tPassword = IPassword("some_password", isSignIn: true);

//   test(
//     'login() should return a left value if the remote datasource fails',
//     () async {
//       // Arrange
//       when(mockAuthRemoteDatasource.login(
//               email: "email@example.com", password: "some_password"))
//           .thenThrow(DioException(requestOptions: RequestOptions()));

//       // Act
//       final result = await authFacade.login(email: tEmail, password: tPassword);

//       final foldedResult = result.fold((l) => l, (r) => r);

//       // Assert
//       expect(result, isA<Left>());
//       expect(foldedResult, const AuthException.serverError());
//     },
//   );
// }
