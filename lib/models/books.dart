import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String? author;
  final String? description;
  final String? imageUrl;
  final String? imageBase64;
  final String? location;
  final double? price;
  final String? status;
  final String? transactionType;
  final String? category;
  final String userId;
  final DateTime createdAt;

  Book({
    required this.id,
    required this.title,
    this.author,
    this.description,
    this.imageUrl,
    this.imageBase64,
    this.location,
    this.price,
    this.status,
    this.transactionType,
    this.category,
    required this.userId,
    required this.createdAt,
  });

  factory Book.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Book(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      imageBase64: data['imageBase64'],
      location: data['location'],
      price: data['price']?.toDouble(),
      status: data['status'],
      transactionType: data['transactionType'],
      category: data['category'],
      userId: data['userId'],
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'imageUrl': imageUrl,
      'imageBase64': imageBase64,
      'location': location,
      'price': price,
      'status': status ?? 'available',
      'transactionType': transactionType,
      'category': category,
      'userId': userId,
      'createdAt': createdAt,
    };
  }
}