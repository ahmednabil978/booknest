import 'package:flutter/material.dart';

import 'book_details_screen.dart';
import 'book_model.dart';
import 'book_repo.dart';

class CategoryBooksScreen extends StatelessWidget {
  final String category;

  const CategoryBooksScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BookRepository _bookRepository = BookRepository();

    return Scaffold(
      backgroundColor: const Color(0xFFFFD6AC), // Light cream background
      appBar: AppBar(
        title: Text(
          category,
          style: const TextStyle(
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
      body: FutureBuilder<List<Book>>(
        future: _bookRepository.getBooksByCategory(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFF5D4141)), // Dark brown loader
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Color(0xFF5D4141)),
              ),
            );
          }

          final books = snapshot.data!;

          if (books.isEmpty) {
            return Center(
              child: Text(
                'No books available in $category category',
                style: const TextStyle(color: Color(0xFF5D4141)),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              return _buildBookItem(context, books[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildBookItem(BuildContext context, Book book) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white, // White card background
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailScreen(book: book),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Cover Image
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    book.imageUrl,
                    width: 80,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 120,
                        color: const Color(0xFF5D4141).withOpacity(0.1),
                        child: Icon(
                          Icons.book,
                          color: const Color(0xFF5D4141).withOpacity(0.3),
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Book Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF5D4141), // Dark brown text
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Author
                    Text(
                      book.author,
                      style: TextStyle(
                        color: const Color(0xFF5D4141).withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      book.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFF5D4141).withOpacity(0.7),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Price and Condition
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5D4141).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${book.price} ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5D4141),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5D4141).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            book.condition,
                            style: TextStyle(
                              color: const Color(0xFF5D4141).withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}