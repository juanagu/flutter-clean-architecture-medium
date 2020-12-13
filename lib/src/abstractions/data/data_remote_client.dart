abstract class DataRemoteClient {
  Future<bool> isAuthenticated();

  Future<dynamic> post(String path, {dynamic data});

  Future<dynamic> get(String path);

  Stream<dynamic> listen(String path);
}
