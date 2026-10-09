import 'package:app/src/abstractions/ioc/injector.dart';
import 'package:get_it/get_it.dart' hide FactoryFunc;

class GetItInjector implements Injector {
  GetItInjector() : _getIt = GetIt.asNewInstance();

  final GetIt _getIt;

  @override
  void registerFactory<T extends Object>(FactoryFunc<T> factoryFunc) {
    _getIt.registerFactory<T>(factoryFunc);
  }

  @override
  void registerLazySingleton<T extends Object>(FactoryFunc<T> factoryFunc) {
    _getIt.registerLazySingleton<T>(factoryFunc);
  }

  @override
  void registerSingleton<T extends Object>(T instance) {
    _getIt.registerSingleton<T>(instance);
  }

  @override
  Future<void> clear() => _getIt.reset();

  @override
  T resolve<T extends Object>() => _getIt.get<T>();
}
