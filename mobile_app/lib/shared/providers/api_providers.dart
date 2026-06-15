import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_environment.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/network_client.dart';
import '../models/app_models.dart';

final appEnvironmentProvider = Provider<AppEnvironment>((ref) {
  return AppEnvironment.fromDartDefine();
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

final networkClientProvider = Provider<NetworkClient>((ref) {
  final environment = ref.watch(appEnvironmentProvider);
  return NetworkClient(baseUrl: environment.apiBaseUrl);
});

final apiRepositoryProvider = Provider<ApiRepository>((ref) {
  return ApiRepository(
    dio: ref.watch(networkClientProvider).dio,
    prefs: ref.watch(sharedPreferencesProvider),
  );
});

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<UserModel?>>((ref) {
  return AuthController(ref.watch(apiRepositoryProvider));
});

final dashboardProvider = FutureProvider<DashboardModel>((ref) {
  return ref.watch(apiRepositoryProvider).fetchDashboard();
});

final profileProvider = FutureProvider<UserModel>((ref) {
  return ref.watch(apiRepositoryProvider).fetchProfile();
});

final booksProvider = FutureProvider<List<BookModel>>((ref) {
  return ref.watch(apiRepositoryProvider).fetchBooks();
});

final bookDetailProvider = FutureProvider.family<BookModel, int>((ref, id) {
  return ref.watch(apiRepositoryProvider).fetchBookDetail(id);
});

final adminUsersProvider = FutureProvider<List<UserModel>>((ref) {
  return ref.watch(apiRepositoryProvider).fetchAdminUsers();
});

final borrowingsProvider = FutureProvider<List<HistoryModel>>((ref) {
  return ref.watch(apiRepositoryProvider).fetchBorrowings();
});

final notificationsProvider = FutureProvider<List<NotificationModel>>((ref) {
  return ref.watch(apiRepositoryProvider).fetchNotifications();
});

class AuthController extends StateNotifier<AsyncValue<UserModel?>> {
  AuthController(this._repository) : super(const AsyncValue.loading()) {
    _loadCurrentUser();
  }

  final ApiRepository _repository;

  Future<void> _loadCurrentUser() async {
    final token = await _repository.readToken();
    if (token == null || token.isEmpty) {
      state = const AsyncValue.data(null);
      return;
    }

    try {
      final user = await _repository.fetchProfile();
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      await _repository.clearToken();
      state = AsyncValue.error(error, stackTrace);
      state = const AsyncValue.data(null);
    }
  }

  Future<UserModel> login(String identity, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.login(identity: identity, password: password);
      state = AsyncValue.data(user);
      return user;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
    } finally {
      state = const AsyncValue.data(null);
    }
  }
}

class ApiRepository {
  ApiRepository({required Dio dio, required SharedPreferences prefs})
      : _dio = dio,
        _prefs = prefs;

  final Dio _dio;
  final SharedPreferences _prefs;

  Future<String?> readToken() async => _prefs.getString(AppConstants.secureTokenKey);

  Future<void> clearToken() async => _prefs.remove(AppConstants.secureTokenKey);

  Future<UserModel> login({required String identity, required String password}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      'login.php',
      data: {'identity': identity, 'password': password},
    );
    final data = _unwrapMap(response);
    final token = data['token']?.toString();
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan pada response login.');
    }
    await _prefs.setString(AppConstants.secureTokenKey, token);
    return UserModel.fromJson(data);
  }

  Future<void> logout() async {
    try {
      await _dio.post<Map<String, dynamic>>('logout.php', options: await _authOptions());
    } finally {
      await clearToken();
    }
  }

  Future<UserModel> fetchProfile() async {
    final response = await _dio.get<Map<String, dynamic>>('profile.php', options: await _authOptions());
    return UserModel.fromJson(_unwrapMap(response));
  }

  Future<DashboardModel> fetchDashboard() async {
    final response = await _dio.get<Map<String, dynamic>>('dashboard.php', options: await _authOptions());
    return DashboardModel.fromJson(_unwrapMap(response));
  }

  Future<List<BookModel>> fetchBooks() async {
    final response = await _dio.get<Map<String, dynamic>>('books.php');
    return _unwrapList(response).map(BookModel.fromJson).toList();
  }

  Future<BookModel> fetchBookDetail(int id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      'book-detail.php',
      queryParameters: {'id': id},
    );
    return BookModel.fromJson(_unwrapMap(response));
  }

  Future<List<HistoryModel>> fetchBorrowings() async {
    final response = await _dio.get<Map<String, dynamic>>('borrowings.php', options: await _authOptions());
    return _unwrapList(response).map(HistoryModel.fromJson).toList();
  }

  Future<List<NotificationModel>> fetchNotifications() async {
    final response = await _dio.get<Map<String, dynamic>>('notifications.php', options: await _authOptions());
    return _unwrapList(response).map(NotificationModel.fromJson).toList();
  }

  // --- Admin Books CRUD ---
  Future<void> addBook(Map<String, dynamic> data) async {
    await _dio.post<Map<String, dynamic>>('admin-books.php', data: data, options: await _authOptions());
  }

  Future<void> updateBook(Map<String, dynamic> data) async {
    await _dio.put<Map<String, dynamic>>('admin-books.php', data: data, options: await _authOptions());
  }

  Future<void> deleteBook(int id) async {
    await _dio.delete<Map<String, dynamic>>('admin-books.php', data: {'id': id}, options: await _authOptions());
  }

  // --- Admin Users CRUD ---
  Future<List<UserModel>> fetchAdminUsers() async {
    final response = await _dio.get<Map<String, dynamic>>('admin-users.php', options: await _authOptions());
    return _unwrapList(response).map(UserModel.fromJson).toList();
  }

  Future<void> updateUser(Map<String, dynamic> data) async {
    await _dio.put<Map<String, dynamic>>('admin-users.php', data: data, options: await _authOptions());
  }

  Future<QrActionResult> validateBookCode(String bookCode) async {
    final books = await fetchBooks();
    final matches = books.where((book) => book.bookCode == bookCode);
    if (matches.isEmpty) {
      return QrActionResult(success: false, message: 'Kode QR tidak ditemukan di database.');
    }
    final book = matches.first;
    return QrActionResult(success: true, message: 'Kode QR valid untuk "${book.title}".', book: book);
  }

  Future<QrActionResult> borrowByQr(String bookCode) async {
    final response = await _dio.post<Map<String, dynamic>>(
      'borrowings.php',
      data: {'book_code': bookCode, 'location': 'Flutter QR'},
      options: await _authOptions(),
    );
    final body = _unwrapBody(response);
    final data = body['data'];
    final borrowing = data is Map<String, dynamic> ? HistoryModel.fromJson(data) : null;
    return QrActionResult(success: true, message: body['message']?.toString() ?? 'Peminjaman QR berhasil.', borrowing: borrowing);
  }

  Future<QrActionResult> returnByQr(String bookCode) async {
    final response = await _dio.post<Map<String, dynamic>>(
      'borrowings.php',
      data: {'book_code': bookCode, 'action': 'return', 'location': 'Flutter QR'},
      options: await _authOptions(),
    );
    final body = _unwrapBody(response);
    final data = body['data'];
    final borrowing = data is Map<String, dynamic> ? HistoryModel.fromJson(data) : null;
    return QrActionResult(success: true, message: body['message']?.toString() ?? 'Pengembalian QR berhasil.', borrowing: borrowing);
  }

  Future<Options> _authOptions() async {
    final token = await readToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token login tidak ditemukan. Silakan login ulang.');
    }
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  Map<String, dynamic> _unwrapBody(Response<Map<String, dynamic>> response) {
    final body = response.data;
    if (body == null) {
      throw Exception('Response backend kosong.');
    }
    final success = body['success'] == true;
    if (!success) {
      throw Exception(body['message']?.toString() ?? 'Request gagal.');
    }
    return body;
  }

  Map<String, dynamic> _unwrapMap(Response<Map<String, dynamic>> response) {
    final body = _unwrapBody(response);
    final data = body['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    throw Exception('Format data backend tidak sesuai.');
  }

  List<Map<String, dynamic>> _unwrapList(Response<Map<String, dynamic>> response) {
    final body = _unwrapBody(response);
    final data = body['data'];
    if (data is List) {
      return data.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return <Map<String, dynamic>>[];
  }
}
