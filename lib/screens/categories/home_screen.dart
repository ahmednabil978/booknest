import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'book_model.dart';
import 'book_repo.dart';
import 'books_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _transactionFilter = 'all';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final BookRepository _bookRepository = BookRepository();
  late Future<List<BookCategory>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _bookRepository.getAllCategories();
  }

  // Show contact information
  Future<void> _showContactInfo(BuildContext context, String userId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      _showSnackBar(context, 'Please sign in to view contact details');
      return;
    }

    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        _showSnackBar(context, 'User details not found');
        return;
      }

      final phoneNumber = userDoc.data()?['phone'] ?? 'Not provided';
      final email = userDoc.data()?['email'] ?? 'Not provided';

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Contact Information', style: TextStyle(color: Color(0xFF5D4141))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Phone: $phoneNumber',
                  style: const TextStyle(fontSize: 16, color: Color(0xFF5D4141))),
              const SizedBox(height: 12),
              Text('Email: $email',
                  style: const TextStyle(fontSize: 16, color: Color(0xFF5D4141))),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Color(0xFF5D4141))),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    } catch (e) {
      _showSnackBar(context, 'Error fetching contact details: $e');
    }
  }

  // Show notifications
  Future<void> _showNotifications(BuildContext context) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF5D4141),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Notifications',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('requests')
                      .where('ownerId', isEqualTo: currentUser.uid)
                      .where('status', isEqualTo: 'pending')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.white)),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: Text('No pending notifications',
                              style: TextStyle(color: Colors.white)),
                        ),
                      );
                    }

                    final requests = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final request = requests[index];
                        return Container(
                          margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            title: Text(
                              'New request for ${request['bookTitle']}',
                              style: const TextStyle(
                                  color: Color(0xFF5D4141),
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  'Status: ${request['status']}',
                                  style: const TextStyle(color: Color(0xFF8D6E63)),
                                ),
                                Text(
                                  _formatDate(request['createdAt']),
                                  style: const TextStyle(color: Color(0xFF8D6E63)),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.visibility,
                                  color: Color(0xFF5D4141)),
                              onPressed: () => _showRequestDetails(context, request),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show request details
  Future<void> _showRequestDetails(BuildContext context, DocumentSnapshot request) async {
    final bookDoc = await _firestore.collection('books').doc(request['bookId']).get();

    if (!bookDoc.exists) {
      _showSnackBar(context, 'Book not found');
      return;
    }

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Request Details',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D4141))),
              const SizedBox(height: 16),
              Text('Book: ${bookDoc['title']}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('Requested by: ${request['requesterName'] ?? 'Unknown'}'),
              const SizedBox(height: 8),
              Text('Status: ${request['status']}'),
              const SizedBox(height: 8),
              Text('Date: ${_formatDate(request['createdAt'])}'),
              const SizedBox(height: 24),
              if (request['status'] == 'pending')
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Expanded(
                //       child: ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: Color(0xFF6D4C41),
                //           padding: const EdgeInsets.symmetric(vertical: 12),
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(12),
                //           ),
                //         ),
                //         onPressed: () => _updateRequestStatus(context, request, 'accepted'),
                //         child:
                //
                //         const Text('Accept',
                //             style: TextStyle(color: Colors.white)),
                //       ),
                //     ),
                //     const SizedBox(width: 12),
                //     Expanded(
                //       child: ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: Colors.white,
                //           padding: const EdgeInsets.symmetric(vertical: 12),
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(12),
                //             side: BorderSide(color: Color(0xFF6D4C41)),
                //           ),
                //         ),
                //         onPressed: () => _updateRequestStatus(context, request, 'rejected'),
                //         child: Text('Reject',
                //             style: TextStyle(color: Color(0xFF6D4C41))),
                //       ),
                //     ),
                //   ],
                // ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close',
                    style: TextStyle(color: Color(0xFF6D4C41))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Update request status
  Future<void> _updateRequestStatus(
      BuildContext context, DocumentSnapshot request, String status) async {
    try {
      await _firestore.collection('requests').doc(request.id).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('users').doc(request['requesterId']).update({
        'unreadNotifications': FieldValue.increment(1),
      });

      Navigator.pop(context);
      _showSnackBar(context, 'Request $status successfully');
    } catch (e) {
      _showSnackBar(context, 'Error updating request: $e');
    }
  }

  // Helper to show snackbar
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Color(0xFF5D4141),
      ),
    );
  }

  // Format timestamp
  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return '';
    return DateFormat('MMM d, y - h:mm a').format(timestamp.toDate());
  }

  Widget _buildCategoriesList() {
    return FutureBuilder<List<BookCategory>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5D4141))),
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

        final categories = snapshot.data!;

        return SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return _buildCategoryItem(categories[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem(BookCategory category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryBooksScreen(category: category.name),
          ),
        );
      },
      child: Container(
        width: 110,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFCD3BA), Color(0xFFF8B195)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                category.icon,
                color: const Color(0xFF5D4141),
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              category.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF5D4141),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionFilter() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildFilterButton('All', 'all'),
          const SizedBox(width: 8),
          _buildFilterButton('Buy', 'buy'),
          const SizedBox(width: 8),
          _buildFilterButton('Exchange', 'exchange'),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, String value) {
    final isSelected = _transactionFilter == value;
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Color(0xFF5D4141) : Colors.white,
          foregroundColor: isSelected ? Colors.white : Color(0xFF5D4141),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        onPressed: () => setState(() => _transactionFilter = value),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _buildBooksList() {
    final currentUser = _auth.currentUser;

    Query query =
    _firestore.collection('books').where('status', isEqualTo: 'available');

    if (currentUser != null) {
      query = query.where('userId', isNotEqualTo: currentUser.uid);
    }

    if (_transactionFilter != 'all') {
      query = query.where('transactionType',
          isEqualTo: _transactionFilter == 'buy' ? 'sell' : 'trade');
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5D4141)),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: Color(0xFF5D4141))));
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text('No books found',
                  style: const TextStyle(color: Color(0xFF5D4141))));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final book = snapshot.data!.docs[index];
            return BookCard(
              book: book,
              onTap: () => _showBookDetails(context, book),
            );
          },
        );
      },
    );
  }

  Future<void> _showBookDetails(BuildContext context, DocumentSnapshot book) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final isOwner = book['userId'] == currentUser.uid;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 16),
            if (book['imageBase64'] != null)
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: MemoryImage(base64Decode(book['imageBase64'])),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(book['title'],
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D4141))),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFCD3BA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                book['transactionType'] == 'sell'
                    ? 'Price: \$${book['price']}'
                    : 'For Exchange',
                style: const TextStyle(
                    color: Color(0xFF5D4141), fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Description:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF5D4141))),
            ),
            const SizedBox(height: 8),
            Text(book['description'] ?? 'No description provided',
                style: const TextStyle(color: Color(0xFF5D4141))),
            const SizedBox(height: 24),
            if (!isOwner)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5D4141),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _sendBookRequest(context, book),
                child: const Text('Request Book',
                    style: TextStyle(color: Colors.white)),
              ),
            if (!isOwner) const SizedBox(height: 12),
            if (!isOwner)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF5D4141)),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _showContactInfo(context, book['userId']),
                child: const Text(
                  'View Contact Info',
                  style: TextStyle(color: Color(0xFF5D4141)),
                ),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _sendBookRequest(BuildContext context, DocumentSnapshot book) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
    final requesterName = userDoc.data()?['name'] ?? 'Unknown';

    try {
      await _firestore.collection('requests').add({
        'bookId': book.id,
        'bookTitle': book['title'],
        'requesterId': currentUser.uid,
        'requesterName': requesterName,
        'ownerId': book['userId'],
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      await _firestore.collection('users').doc(book['userId']).update({
        'unreadNotifications': FieldValue.increment(1),
      });

      Navigator.pop(context);
      _showSnackBar(context, 'Request sent successfully!');
    } catch (e) {
      _showSnackBar(context, 'Failed to send request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Book Exchange Egypt',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF5D4141),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        actions: [
          StreamBuilder<DocumentSnapshot>(
            stream: _firestore
                .collection('users')
                .doc(_auth.currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () => _showNotifications(context),
                );
              }

              return StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('requests')
                    .where('ownerId', isEqualTo: _auth.currentUser?.uid)
                    .where('status', isEqualTo: 'pending')
                    .snapshots(),
                builder: (context, requestSnapshot) {
                  final unreadCount = requestSnapshot.data?.docs.length ?? 0;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications, color: Colors.white),
                        onPressed: () => _showNotifications(context),
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            child: Text(
                              '$unreadCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categories Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Browse Categories',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5D4141),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Find books by category',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF8D6E63),
                    ),
                  ),
                ],
              ),
            ),
            _buildCategoriesList(),
            const SizedBox(height: 24),

            // Available Books Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Books',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5D4141),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Browse books available for exchange or purchase',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF8D6E63),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildTransactionFilter(),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildBooksList(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final DocumentSnapshot book;
  final VoidCallback onTap;

  const BookCard({
    super.key,
    required this.book,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book Cover
                Container(
                  width: 80,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                    image: book['imageBase64'] != null
                        ? DecorationImage(
                      image: MemoryImage(base64Decode(book['imageBase64'])),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: book['imageBase64'] == null
                      ? Center(
                    child: Icon(Icons.book,
                        size: 40,
                        color: const Color(0xFF5D4141)),
                  )
                      : null,
                ),
                const SizedBox(width: 16),

                // Book Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D4141),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Transaction Type
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: book['transactionType'] == 'sell'
                              ? const Color(0xFFE8F5E9)
                              : const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              book['transactionType'] == 'sell'
                                  ? Icons.attach_money
                                  : Icons.swap_horiz,
                              size: 14,
                              color: book['transactionType'] == 'sell'
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFF1565C0),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              book['transactionType'] == 'sell'
                                  ? 'For Sale'
                                  : 'For Exchange',
                              style: TextStyle(
                                fontSize: 12,
                                color: book['transactionType'] == 'sell'
                                    ? const Color(0xFF2E7D32)
                                    : const Color(0xFF1565C0),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Price or Exchange Info
                      Text(
                        book['transactionType'] == 'sell'
                            ? 'Price: \$${book['price']}'
                            : 'Looking for exchange',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5D4141),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Location
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16,
                              color: Color(0xFF8D6E63)),
                          const SizedBox(width: 4),
                          Text(
                            book['location'],
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF8D6E63)),
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
      ),
    );
  }
}