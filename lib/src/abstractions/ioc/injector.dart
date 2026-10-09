typedef FactoryFunc<T> = T Function();

/// Service locator port. The app registers one implementation at startup and
/// feature composition roots resolve app-wide services through it.
abstract class Injector {
  static Injector? _instance;

  static Injector get instance {
    final instance = _instance;
    if (instance == null) {
      throw StateError('Injector.register must run before resolving services');
    }
    return instance;
  }

  static Injector register(Injector implementation) {
    _instance = implementation;
    return implementation;
  }

  void registerFactory<T extends Object>(FactoryFunc<T> factoryFunc);

  void registerLazySingleton<T extends Object>(FactoryFunc<T> factoryFunc);

  void registerSingleton<T extends Object>(T instance);

  Future<void> clear();

  T resolve<T extends Object>();
}
