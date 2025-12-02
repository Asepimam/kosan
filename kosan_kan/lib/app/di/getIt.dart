import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kosan_kan/data/local/auth_local.dart';
import 'package:kosan_kan/data/provider/api_client.dart';
import 'package:kosan_kan/data/repositories/auth_repository_impl.dart';
import 'package:kosan_kan/data/repositories/user_repository_impl.dart';
import 'package:kosan_kan/domain/repositories/auth_repository.dart';
import 'package:kosan_kan/domain/repositories/user_repository.dart';
import 'package:kosan_kan/domain/usecases/auth_usecase.dart';
import 'package:kosan_kan/domain/usecases/refresh_token_usecase.dart';
import 'package:kosan_kan/domain/usecases/user_usecase.dart';
import 'package:kosan_kan/presentation/auth/bloc/auth_bloc.dart';
import 'package:kosan_kan/presentation/profile/bloc/profile_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // register hive
  await Hive.initFlutter();
  final appPrefBox = await Hive.openBox('app_preferences');
  final authBox = await Hive.openBox('auth_local');

  sl.registerLazySingleton<Box>(() => appPrefBox, instanceName: 'appPrefBox');
  sl.registerLazySingleton<Box>(() => authBox, instanceName: 'authBox');

  sl.registerLazySingleton<AuthLocal>(() => AuthLocal());

  //registere dio
  sl.registerLazySingleton<Dio>(
    () => Dio(BaseOptions(baseUrl: 'http://192.168.1.43:8000/')),
  );

  // api client
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl(), sl()));

  // bloc
  sl.registerLazySingleton<AuthBloc>(() => AuthBloc(sl(), sl(), sl()));

  // repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));

  // usecases
  sl.registerLazySingleton(() => AuthUsecase(sl()));
  sl.registerLazySingleton(() => UserUsecase(sl()));
  sl.registerLazySingleton(() => RefreshTokenUsecase(sl()));
  // profile bloc (depends on UserUsecase)
  sl.registerLazySingleton<ProfileBloc>(() => ProfileBloc(sl()));
}
