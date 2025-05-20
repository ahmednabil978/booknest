import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/books.dart';
import 'upload_screen.dart';

class MyAdsScreen extends StatelessWidget {
  const MyAdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF6D4C41); // Brown 600
    final Color secondaryColor = const Color(0xFFFFD54F); // Amber 300
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
            child: Text('Please log in to view your ads',
                style: TextStyle(color: primaryColor, fontSize: 18))),
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          secondary: secondaryColor,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Uploaded Books'),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UploadScreen()),
              ),
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('books')
              .where('userId', isEqualTo: user.uid)
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }

            final books = snapshot.data!.docs.map((doc) {
              return Book.fromFirestore(doc);
            }).toList();

            if (books.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.book, size: 50, color: primaryColor),
                    const SizedBox(height: 16),
                    Text(
                      'No books uploaded yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UploadScreen()),
                      ),
                      child: const Text('Upload Your First Book',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: books.length,
              itemBuilder: (ctx, index) => BookItem(
                book: books[index],
                primaryColor: primaryColor,
                secondaryColor: secondaryColor,
              ),
            );
          },
        ),
      ),
    );
  }
}

class BookItem extends StatelessWidget {
  final Book book;
  final Color primaryColor;
  final Color secondaryColor;

  const BookItem({
    super.key,
    required this.book,
    required this.primaryColor,
    required this.secondaryColor,
  });

  Future<void> _deleteBook(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Book'),
        content: const Text('Are you sure you want to delete this book?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: primaryColor)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await FirebaseFirestore.instance
            .collection('books')
            .doc(book.id)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Book deleted successfully'),
            backgroundColor: primaryColor,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Future<void> _showContactInfo(BuildContext context) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) return;
  //
  //   final userDoc = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user.uid)
  //       .get();
  //
  //   final phoneNumber = userDoc.data()?['phone'] ?? 'Not provided';
  //   final email = userDoc.data()?['email'] ?? 'Not provided';
  //
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Contact Information'),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text('Phone: $phoneNumber',
  //               style: TextStyle(fontSize: 16, color: primaryColor)),
  //           const SizedBox(height: 8),
  //           Text('Email: $email',
  //               style: TextStyle(fontSize: 16, color: primaryColor)),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text('Close', style: TextStyle(color: primaryColor)),
  //         ),
  //         if (phoneNumber != 'Not provided')
  //           TextButton(
  //             onPressed: () {
  //               // Implement call functionality
  //               Navigator.pop(context);
  //             },
  //             child: const Text('Call', style: TextStyle(color: Colors.green)),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        // onTap: () => _showContactInfo(context),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Image
              Container(
                width: 80,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: secondaryColor.withOpacity(0.2),
                ),
                child: book.imageBase64 != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    base64Decode(book.imageBase64!),
                    width: 80,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                )
                    : Icon(Icons.book, size: 40, color: primaryColor),
              ),
              const SizedBox(width: 16),
              // Book Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    if (book.author != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'by ${book.author!}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: secondaryColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            book.category ?? 'General',
                            style: TextStyle(
                              fontSize: 12,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: book.transactionType == 'sell'
                                ? Colors.green.withOpacity(0.2)
                                : Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            book.transactionType == 'sell'
                                ? 'For Sale'
                                : 'For Trade',
                            style: TextStyle(
                              fontSize: 12,
                              color: book.transactionType == 'sell'
                                  ? Colors.green[800]
                                  : Colors.blue[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (book.price != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '\$${book.price!.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Row(
                    //   children: [
                    //     Icon(Icons.phone, size: 16, color: primaryColor),
                    //     const SizedBox(width: 4),
                    //     Text(
                    //       'Tap to view contact info',
                    //       style: TextStyle(
                    //         fontSize: 12,
                    //         color: primaryColor,
                    //         fontStyle: FontStyle.italic,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              // Delete Button
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red[300]),
                onPressed: () => _deleteBook(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}