// book_model.dart

import 'package:flutter/material.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String category;
  final String description;
  final String ownerId;
  final String ownerName;
  final String ownerContact;
  final String imageUrl;
  final String price;
  final String condition;
  final DateTime publishedDate;
  final bool isAvailable;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.description,
    required this.ownerId,
    required this.ownerName,
    required this.ownerContact,
    required this.imageUrl,
    required this.price,
    required this.condition,
    required this.publishedDate,
    required this.isAvailable,
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      ownerId: map['ownerId'] ?? '',
      ownerName: map['ownerName'] ?? '',
      ownerContact: map['ownerContact'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      condition: map['condition'] ?? '',
      publishedDate: DateTime.parse(map['publishedDate']),
      isAvailable: map['isAvailable'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'category': category,
      'description': description,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerContact': ownerContact,
      'imageUrl': imageUrl,
      'price': price,
      'condition': condition,
      'publishedDate': publishedDate.toIso8601String(),
      'isAvailable': isAvailable,
    };
  }
}

// category_model.dart
class BookCategory {
  final String name;
  final IconData icon;

  BookCategory({required this.name, required this.icon});
}