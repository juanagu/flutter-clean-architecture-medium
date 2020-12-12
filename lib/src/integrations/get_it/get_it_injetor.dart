import 'package:get_it/get_it.dart';
import 'package:app/src/abstractions/ioc/injector.dart';

class GetItInjector implements Injector {
  static final GetItInjector _singleton = GetItInjector._internal();
  final GetIt _getIt = GetIt.asNewInstance();

  factory GetItInjector() {
    return _singleton;
  }

  GetItInjector._internal();

  @override
  void registerFactory<T>(factoryFunc) {
    if (_getIt.isRegistered<T>()) {
      _getIt.unregister<T>();
    }

    _getIt.registerFactory<T>(factoryFunc);
  }

  @override
  void registerLazySingleton<T>(factoryFunc) {
    if (_getIt.isRegistered<T>()) {
      _getIt.unregister<T>();
    }
    _getIt.registerLazySingleton(factoryFunc);
  }

  @override
  void clear() {
    _getIt.reset();
  }

  @override
  T resolve<T>() {
    return _getIt.get<T>();
  }

  @override
  T resolveByName<T>(String name) {
    return _getIt.get<T>(
      instanceName: name,
    );
  }

  @override
  void registerFactoryByName<T>(factoryFunc, String name) {
    if (_getIt.isRegistered(instanceName: name)) {
      _getIt.unregister(instanceName: name);
    }
    _getIt.registerFactory<T>(
      factoryFunc,
      instanceName: name,
    );
  }

  @override
  void registerLazySingletonByName<T>(factoryFunc, String name) {
    _getIt.registerLazySingleton<T>(
      factoryFunc,
      instanceName: name,
    );
  }

  @override
  void registerSingleton<T>(T instance) {
    _getIt.registerSingleton<T>(instance);
  }
}
