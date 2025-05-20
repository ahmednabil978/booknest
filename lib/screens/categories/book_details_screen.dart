import 'package:flutter/material.dart';

import 'book_model.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD6AC), // Light cream background
      appBar: AppBar(
        title: const Text(
          'Book Details',
          style: TextStyle(
            color: Color(0xFFFFD6AC), // Cream text
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF5D4141), // Dark brown app bar
        iconTheme: const IconThemeData(
          color: Color(0xFFFFD6AC), // Cream back button
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover Image - Updated to show full image
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    book.imageUrl,
                    fit: BoxFit.contain, // Changed to contain to show full image
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF5D4141).withOpacity(0.1),
                        child: Center(
                          child: Icon(
                            Icons.book,
                            size: 60,
                            color: const Color(0xFF5D4141).withOpacity(0.3),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Book Title
            Text(
              book.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4141), // Dark brown text
              ),
            ),
            const SizedBox(height: 8),

            // Author
            Text(
              'by ${book.author}',
              style: TextStyle(
                fontSize: 18,
                color: const Color(0xFF5D4141).withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 20),

            // Category and Condition Chips
            Row(
              children: [
                Chip(
                  label: Text(
                    book.category,
                    style: const TextStyle(
                      color: Color(0xFF5D4141), // Dark brown text
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: const Color(0xFF5D4141).withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(
                    book.condition,
                    style: const TextStyle(
                      color: Color(0xFF5D4141), // Dark brown text
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: const Color(0xFF5D4141).withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Description
            Text(
              'Description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF5D4141), // Dark brown text
              ),
            ),
            const SizedBox(height: 8),
            Text(
              book.description,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: const Color(0xFF5D4141).withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),

            // Price
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF5D4141).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Price: ',
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color(0xFF5D4141).withOpacity(0.8),
                    ),
                  ),
                  Text(
                    '${book.price} ',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D4141), // Dark brown text
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Request Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showOwnerInfo(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF5D4141), // Dark brown button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Request This Book',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFFFD6AC), // Cream text
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOwnerInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFFD6AC), // Light cream background
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5D4141).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Owner Information',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4141), // Dark brown text
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.person,
                        color: const Color(0xFF5D4141), // Dark brown icon
                      ),
                      title: Text(
                        'Owner Name',
                        style: TextStyle(
                          color: const Color(0xFF5D4141).withOpacity(0.7),
                        ),
                      ),
                      subtitle: Text(
                        book.ownerName,
                        style: const TextStyle(
                          color: Color(0xFF5D4141), // Dark brown text
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey[300],
                      indent: 16,
                      endIndent: 16,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.phone,
                        color: const Color(0xFF5D4141), // Dark brown icon
                      ),
                      title: Text(
                        'Contact Number',
                        style: TextStyle(
                          color: const Color(0xFF5D4141).withOpacity(0.7),
                        ),
                      ),
                      subtitle: Text(
                        book.ownerContact,
                        style: const TextStyle(
                          color: Color(0xFF5D4141), // Dark brown text
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Request sent successfully!',
                          style: TextStyle(color: Colors.white),
                        ),
                        duration: const Duration(seconds: 2),
                        backgroundColor: const Color(0xFF5D4141), // Dark brown
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF5D4141), // Dark brown
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Confirm Request',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFFFD6AC), // Cream text
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}