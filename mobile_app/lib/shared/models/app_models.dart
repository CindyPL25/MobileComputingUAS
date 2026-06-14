class UserModel {
  final String nim;
  final String name;
  final String email;
  final String major;
  final String status;

  UserModel({
    required this.nim,
    required this.name,
    required this.email,
    required this.major,
    required this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nim: json['nim'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      major: json['major'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nim': nim,
      'name': name,
      'email': email,
      'major': major,
      'status': status,
    };
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
  final String sourceUrl;
  final bool popular;

  BookModel({
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
    required this.sourceUrl,
    required this.popular,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      category: json['category'] ?? '',
      publisher: json['publisher'] ?? '',
      year: json['year'] ?? '',
      isbn: json['isbn'] ?? '',
      status: json['status'] ?? '',
      cover: json['cover'] ?? '',
      description: json['description'] ?? '',
      sourceUrl: json['source_url'] ?? '',
      popular: json['popular'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'category': category,
      'publisher': publisher,
      'year': year,
      'isbn': isbn,
      'status': status,
      'cover': cover,
      'description': description,
      'source_url': sourceUrl,
      'popular': popular,
    };
  }
}

class HistoryModel {
  final String title;
  final String borrowedAt;
  final String returnedAt;
  final String status;

  HistoryModel({
    required this.title,
    required this.borrowedAt,
    required this.returnedAt,
    required this.status,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      title: json['title'] ?? '',
      borrowedAt: json['borrowed_at'] ?? '',
      returnedAt: json['returned_at'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'borrowed_at': borrowedAt,
      'returned_at': returnedAt,
      'status': status,
    };
  }
}

class QrScanModel {
  final String book;
  final String student;
  final String time;
  final String location;
  final String result;

  QrScanModel({
    required this.book,
    required this.student,
    required this.time,
    required this.location,
    required this.result,
  });

  factory QrScanModel.fromJson(Map<String, dynamic> json) {
    return QrScanModel(
      book: json['book'] ?? '',
      student: json['student'] ?? '',
      time: json['time'] ?? '',
      location: json['location'] ?? '',
      result: json['result'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'book': book,
      'student': student,
      'time': time,
      'location': location,
      'result': result,
    };
  }
}

class AdminUserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String createdAt;

  AdminUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'created_at': createdAt,
    };
  }
}