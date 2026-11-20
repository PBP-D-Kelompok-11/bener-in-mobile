import 'dart:async';
import 'dart:convert';
import 'dart:io';

typedef ApiJson = Map<String, Object?>;

class ApiAccount {
  const ApiAccount({required this.name, required this.role});

  final String name;
  final String role;
}

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class BenerinApi {
  BenerinApi({Uri? baseUri})
    : _baseUri =
          baseUri ??
          Uri.tryParse(
            const String.fromEnvironment(
              'API_BASE_URL',
              defaultValue: 'https://hisyam-prasetyo-benerin.pws.cs.ui.ac.id',
            ),
          ) ??
          Uri();

  static const _timeout = Duration(seconds: 12);

  final Uri _baseUri;
  late final _client = HttpClient()..connectionTimeout = _timeout;
  final _cookies = <String, Cookie>{};
  String? _csrfToken;
  bool _changingSession = false;

  Future<ApiAccount> login(String username, String password) async {
    _beginSessionChange();
    try {
      final csrf = await _request('auth/csrf/');
      final response = await _request(
        'auth/login/',
        body: {'username': username, 'password': password},
        csrfToken: _string(csrf, 'csrf_token'),
      );
      final user = _object(response['user']);
      _csrfToken = _string(response, 'csrf_token');

      return ApiAccount(
        name: _string(user, 'nama_lengkap'),
        role: _string(user, 'role'),
      );
    } on ApiException catch (error) {
      if (error.statusCode == 400) {
        throw const ApiException('Username atau kata sandi salah.');
      }
      rethrow;
    } finally {
      _changingSession = false;
    }
  }

  Future<void> logout() async {
    _beginSessionChange();
    try {
      try {
        await _request('auth/logout/', body: const {}, csrfToken: _csrfToken);
      } on ApiException catch (error) {
        if (error.statusCode != 403) rethrow;
      }
      _cookies.clear();
      _csrfToken = null;
    } finally {
      _changingSession = false;
    }
  }

  Future<List<ApiJson>> repairs() async {
    return _results(await _request('repairs/'));
  }

  Future<ApiJson> partner(int id) => _request('mitra/$id/');

  Future<List<ApiJson>> nearby() async {
    return _results(
      await _request(
        'locations/mitra/',
        query: {'lat': '-6.36', 'lng': '106.83'},
      ),
    );
  }

  Future<ApiJson> impact() => _request('impact/');

  void close() => _client.close(force: true);

  void _beginSessionChange() {
    if (_changingSession) {
      throw const ApiException('Tunggu proses akun yang sedang berjalan.');
    }
    _changingSession = true;
  }

  Future<ApiJson> _request(
    String path, {
    ApiJson? body,
    Map<String, String>? query,
    String? csrfToken,
  }) async {
    if ((!_baseUri.isScheme('https') && !_baseUri.isScheme('http')) ||
        _baseUri.host.isEmpty) {
      throw const ApiException('Alamat backend bener.in tidak valid.');
    }
    final uri = _baseUri
        .resolve('/api/v1/$path')
        .replace(queryParameters: query);

    try {
      final request = await _client.openUrl(body == null ? 'GET' : 'POST', uri);
      request.followRedirects = false;
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.cookies.addAll(_cookies.values);

      if (body != null) {
        final payload = utf8.encode(jsonEncode(body));
        request.headers.contentType = ContentType.json;
        request.contentLength = payload.length;
        if (csrfToken != null) {
          request.headers.set('X-CSRFToken', csrfToken);
        }
        request.add(payload);
      }

      final response = await request.close().timeout(_timeout);
      final text = await utf8.decoder.bind(response).join().timeout(_timeout);
      for (final cookie in response.cookies) {
        if (cookie.name == 'sessionid' || cookie.name == 'csrftoken') {
          if (cookie.maxAge == 0 || cookie.value.isEmpty) {
            _cookies.remove(cookie.name);
          } else {
            _cookies[cookie.name] = cookie;
          }
        }
      }

      if (response.statusCode == 204) return const {};
      if (response.statusCode != 200) {
        throw ApiException(
          'API mengembalikan HTTP ${response.statusCode}.',
          statusCode: response.statusCode,
        );
      }
      return _object(jsonDecode(text));
    } on TimeoutException {
      throw const ApiException('API tidak merespons tepat waktu.');
    } on IOException {
      throw const ApiException('Gagal terhubung ke backend bener.in.');
    } on FormatException {
      throw const ApiException('Respons backend bukan JSON yang valid.');
    }
  }

  static ApiJson _object(Object? value) {
    if (value is ApiJson) return value;
    throw const ApiException('Format data backend tidak sesuai.');
  }

  static String _string(ApiJson data, String key) {
    final value = data[key];
    if (value is String) return value;
    throw const ApiException('Format data akun dari backend tidak sesuai.');
  }

  static List<ApiJson> _results(ApiJson data) {
    final results = data['results'];
    if (results is List<Object?>) return results.map(_object).toList();
    throw const ApiException('Format daftar dari backend tidak sesuai.');
  }
}
