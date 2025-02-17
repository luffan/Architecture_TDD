// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../core/network/interfaces/network_info.dart' as _i491;
import '../core/network/network_info_impl.dart' as _i927;
import '../core/util/input_converter.dart' as _i664;
import '../features/number_trivia/data/data_sources/interfaces/number_trivia_local_data_source.dart'
    as _i633;
import '../features/number_trivia/data/data_sources/interfaces/number_trivia_remote_data_source.dart'
    as _i365;
import '../features/number_trivia/data/data_sources/number_trivia_local_data_source_impl.dart'
    as _i176;
import '../features/number_trivia/data/data_sources/number_trivia_remote_data_source_impl.dart'
    as _i57;
import '../features/number_trivia/data/repositories/number_trivia_repository_impl.dart'
    as _i41;
import '../features/number_trivia/domain/repositories/number_trivia_repository.dart'
    as _i43;
import '../features/number_trivia/domain/usecases/get_concrete_number_trivia.dart'
    as _i71;
import '../features/number_trivia/domain/usecases/get_random_number_trivia.dart'
    as _i145;
import '../features/number_trivia/presentation/bloc/number_trivia_bloc.dart'
    as _i783;
import 'provider/connectivity_source_provider.dart' as _i807;
import 'provider/local_source_provider.dart' as _i454;
import 'provider/remote_source_provider.dart' as _i823;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final remoteSourceProvider = _$RemoteSourceProvider();
    final localSourceModule = _$LocalSourceModule();
    final connectivitySourceModule = _$ConnectivitySourceModule();
    gh.singleton<_i664.InputConverter>(() => _i664.InputConverter());
    gh.singleton<_i361.Dio>(() => remoteSourceProvider.dio());
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => localSourceModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i973.InternetConnectionChecker>(
        () => connectivitySourceModule.connectionChecker);
    gh.singleton<_i365.NumberTriviaRemoteDataSource>(
        () => _i57.NumberTriviaRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.singleton<_i491.NetworkInfo>(
        () => _i927.NetworkInfoImpl(gh<_i973.InternetConnectionChecker>()));
    gh.singleton<_i633.NumberTriviaLocalDataSource>(() =>
        _i176.NumberTriviaLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.singleton<_i43.NumberTriviaRepository>(
        () => _i41.NumberTriviaRepositoryImpl(
              remoteDataSource: gh<_i365.NumberTriviaRemoteDataSource>(),
              localDataSource: gh<_i633.NumberTriviaLocalDataSource>(),
              networkInfo: gh<_i491.NetworkInfo>(),
            ));
    gh.singleton<_i145.GetRandomNumberTrivia>(
        () => _i145.GetRandomNumberTrivia(gh<_i43.NumberTriviaRepository>()));
    gh.singleton<_i71.GetConcreteNumberTrivia>(
        () => _i71.GetConcreteNumberTrivia(gh<_i43.NumberTriviaRepository>()));
    gh.factory<_i783.NumberTriviaBloc>(() => _i783.NumberTriviaBloc(
          concrete: gh<_i71.GetConcreteNumberTrivia>(),
          random: gh<_i145.GetRandomNumberTrivia>(),
          inputConverter: gh<_i664.InputConverter>(),
        ));
    return this;
  }
}

class _$RemoteSourceProvider extends _i823.RemoteSourceProvider {}

class _$LocalSourceModule extends _i454.LocalSourceModule {}

class _$ConnectivitySourceModule extends _i807.ConnectivitySourceModule {}
