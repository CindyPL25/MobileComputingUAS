class UserModel {
  final int id;
  final String nim;
  final String name;
  final String email;
  final String role;
  final String major;
  final String status;
  final String phone;
  final String address;

  const UserModel({
    required this.id,
    required this.nim,
    required this.name,
    required this.email,
    required this.role,
    required this.major,
    required this.status,
    required this.phone,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _asInt(json['id']),
      nim: _asString(json['nim']),
      name: _asString(json['name']),
      email: _asString(json['email']),
      role: _asString(json['role']),
      major: _asString(json['major']),
      status: _asString(json['status']),
      phone: _asString(json['phone']),
      address: _asString(json['address']),
    );
  }

  String get initials {
    final words = name.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    if (words.isEmpty) return '?';
    return words.take(2).map((part) => part[0]).join().toUpperCase();
  }
}

class DashboardModel {
  final int totalBooks;
  final int totalCategories;
  final int totalUsers;
  final int totalActiveBorrowings;

  const DashboardModel({
    required this.totalBooks,
    required this.totalCategories,
    required this.totalUsers,
    required this.totalActiveBorrowings,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalBooks: _asInt(json['total_books']),
      totalCategories: _asInt(json['total_categories']),
      totalUsers: _asInt(json['total_users']),
      totalActiveBorrowings: _asInt(json['total_active_borrowings']),
    );
  }
}

class BookModel {
  final int id;
  final String title;
  final String author;
  final String category;
  final String publisher;
  final String year;
  final String isbn;
  final String status;
  final String cover;
  final String description;
  final String bookCode;
  final int stock;
  final int availableStock;
  final bool popular;

  const BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.publisher,
    required this.year,
    required this.isbn,
    required this.status,
    required this.cover,
    required this.description,
    required this.bookCode,
    required this.stock,
    required this.availableStock,
    required this.popular,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final availableStock = _asInt(json['available_stock']);
    return BookModel(
      id: _asInt(json['id'] ?? json['book_id']),
      title: _asString(json['title']),
      author: _asString(json['author']),
      category: _asString(json['category_name'] ?? json['category']),
      publisher: _asString(json['publisher']),
      year: _asString(json['publication_year'] ?? json['year']),
      isbn: _asString(json['isbn']),
      status: availableStock > 0 ? 'Tersedia' : 'Dipinjam',
      cover: _asString(json['cover_image'] ?? json['cover']),
      description: _asString(json['description']),
      bookCode: _asString(json['book_code']),
      stock: _asInt(json['stock']),
      availableStock: availableStock,
      popular: _asBool(json['is_popular'] ?? json['popular']),
    );
  }
}

class HistoryModel {
  final int id;
  final String title;
  final String borrowedAt;
  final String dueDate;
  final String returnedAt;
  final String status;
  final List<BookModel> books;

  const HistoryModel({
    required this.id,
    required this.title,
    required this.borrowedAt,
    required this.dueDate,
    required this.returnedAt,
    required this.status,
    required this.books,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    final rawBooks = json['books'];
    final books = rawBooks is List
        ? rawBooks
            .whereType<Map>()
            .map((book) => BookModel.fromJson(Map<String, dynamic>.from(book)))
            .toList()
        : <BookModel>[];
    final title = books.isEmpty ? _asString(json['book_titles'] ?? json['title']) : books.map((book) => book.title).join(', ');
    return HistoryModel(
      id: _asInt(json['id'] ?? json['borrowing_id']),
      title: title,
      borrowedAt: _asString(json['borrow_date'] ?? json['borrowed_at']),
      dueDate: _asString(json['due_date']),
      returnedAt: _asString(json['return_date'] ?? json['returned_at']),
      status: _statusLabel(_asString(json['status'])),
      books: books,
    );
  }
}

class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: _asInt(json['id']),
      title: _asString(json['title']),
      message: _asString(json['message']),
      type: _asString(json['notification_type']),
      isRead: _asBool(json['is_read']),
      createdAt: _asString(json['created_at']),
    );
  }
}

class QrActionResult {
  final bool success;
  final String message;
  final HistoryModel? borrowing;
  final BookModel? book;

  const QrActionResult({
    required this.success,
    required this.message,
    this.borrowing,
    this.book,
  });
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _asString(dynamic value) => value?.toString() ?? '';

bool _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  final raw = value?.toString().toLowerCase();
  return raw == '1' || raw == 'true' || raw == 'yes';
}

String _statusLabel(String status) {
  switch (status.toLowerCase()) {
    case 'returned':
      return 'Dikembalikan';
    case 'overdue':
      return 'Terlambat';
    case 'active':
      return 'Dipinjam';
    case 'pending':
      return 'Pending';
    default:
      return status.isEmpty ? '-' : status;
  }
}
