import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Dio dioService() {
  var dio = Dio(
    BaseOptions(
        baseUrl: 'https://spotiphis.graphis.dev.br/api/',
        responseType: ResponseType.plain,
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
        }),
  );

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      requestInterceptor(options);
      return handler.next(options);
    },
  ));

  return dio;
}

dynamic requestInterceptor(RequestOptions options) async {
  if (options.headers.containsKey('auth')) {
    print("true");
    // var token = await AuthProvider().getToken();

    String? token = await getTokenFromStorage();

    print(token);
    options.headers.addAll({'Authorization': 'Bearer $token'});
    print(options.headers.toString());
  }
}

Future<String?> getTokenFromStorage() async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'auth-token');
  return token;
}
