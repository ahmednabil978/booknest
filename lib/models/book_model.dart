// lib/models/book_model.dart
class Book {
  final String id;
  final String title;
  final String category;
  final String description;
  final String transactionType; // 'sell' or 'trade'
  final double? price; // only for sell type
  final String location;
  final String userId; // owner ID
  final String status; // 'available' or 'unavailable'
  final DateTime createdAt;

  Book({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.transactionType,
    this.price,
    required this.location,
    required this.userId,
    this.status = 'available',
    required this.createdAt,
  });

  factory Book.fromMap(Map<String, dynamic> data, String id) {
    return Book(
      id: id,
      title: data['title'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      transactionType: data['transactionType'] ?? 'sell',
      price: data['price']?.toDouble(),
      location: data['location'] ?? '',
      userId: data['userId'] ?? '',
      status: data['status'] ?? 'available',
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'description': description,
      'transactionType': transactionType,
      'price': price,
      'location': location,
      'userId': userId,
      'status': status,
      'createdAt': createdAt,
    };
  }
}

// lib/models/user_model.dart
class AppUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String location;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String id) {
    return AppUser(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      location: data['location'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
    };
  }
}