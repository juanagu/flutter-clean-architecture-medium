typedef FactoryFunc<T> = T Function();

abstract class Injector {
  static Injector instance;
  void registerFactory<T>(FactoryFunc<T> factoryFunc);

  void registerFactoryByName<T>(FactoryFunc<T> factoryFunc, String name);

  void registerSingleton<T>(T instance);

  void registerLazySingleton<T>(FactoryFunc<T> factoryFunc);

  void registerLazySingletonByName<T>(FactoryFunc<T> factoryFunc, String name);

  void clear();

  T resolve<T>();

  T resolveByName<T>(String name);

  static Injector register(Injector implementation) {
    instance = implementation;
    return instance;
  }
}
