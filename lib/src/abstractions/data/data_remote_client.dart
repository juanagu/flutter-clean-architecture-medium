import 'package:meta/meta.dart';

abstract class DataRemoteClient {
  Future<bool> isAuthenticated();

  Future<dynamic> post(String path, {@required dynamic data});

  Future<dynamic> put(String path, String id, {@required dynamic data});

  Future<dynamic> patch(String path, String id, {@required dynamic data});

  Future<dynamic> get(String path);
}
