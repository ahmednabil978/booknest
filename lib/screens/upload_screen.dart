import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  // Color Scheme
  static const Color primaryColor = Color(0xFF6D4C41); // Brown 600
  static const Color secondaryColor = Color(0xFFFFD54F); // Amber 300
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color errorColor = Color(0xFFD32F2F);

  // Form State
  File? _image;
  final picker = ImagePicker();
  bool _isLoading = false;
  bool _showForm = false;
  String? _transactionType;
  String? _base64Image;

  // Form Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? _selectedCategory;

  // Categories
  final List<String> _categories = [
    'Fiction',
    'Non-Fiction',
    'Romance',
    'Mystery',
    'Fantasy',
    'Science Fiction',
    'Historical',
    'Business',
    'Biography',
    'Self-Help',
    'Children',
    'Cookbooks'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await File(pickedFile.path).readAsBytes();
        setState(() {
          _image = File(pickedFile.path);
          _base64Image = base64Encode(bytes);
        });
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e', isError: true);
    }
  }

  Future<void> _submitBook() async {
    if (_titleController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _selectedCategory == null ||
        _base64Image == null) {
      _showSnackBar('Please fill all required fields', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      await FirebaseFirestore.instance.collection('books').add({
        'title': _titleController.text,
        'price': double.parse(_priceController.text),
        'category': _selectedCategory,
        'description': _descriptionController.text,
        'location': _locationController.text,
        'imageBase64': _base64Image,
        'transactionType': _transactionType,
        'userId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'available',
      });

      if (!mounted) return;
      _showSnackBar('Book submitted successfully!');
      _resetForm();
    } catch (e) {
      _showSnackBar('Error submitting book: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? errorColor : primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _showForm = false;
      _transactionType = null;
      _image = null;
      _base64Image = null;
      _titleController.clear();
      _priceController.clear();
      _descriptionController.clear();
      // _locationController.clear();
      _selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Book'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: !_showForm ? _buildTypeSelector() : _buildUploadForm(),
            ),
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          'List Your Book',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose how you want to list your book',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 40),
        _buildTypeCard(
          icon: Icons.swap_horiz,
          title: 'Exchange',
          subtitle: 'Trade with another book',
          onTap: () => setState(() {
            _transactionType = 'trade';
            _showForm = true;
          }),
        ),
        const SizedBox(height: 20),
        _buildTypeCard(
          icon: Icons.attach_money,
          title: 'Sell',
          subtitle: 'Sell for a fixed price',
          onTap: () => setState(() {
            _transactionType = 'sell';
            _showForm = true;
          }),
        ),
      ],
    );
  }

  Widget _buildTypeCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back button
        TextButton.icon(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          label: Text(
            'Back',
            style: TextStyle(color: primaryColor),
          ),
          onPressed: _resetForm,
        ),
        const SizedBox(height: 16),

        // Form Title
        Text(
          _transactionType == 'trade' ? 'Exchange Book' : 'Sell Book',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Fill in the book details',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 24),

        // Image Upload
        Center(
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 180,
              height: 240,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: primaryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: _image == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          size: 40,
                          color: primaryColor.withOpacity(0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Add Book Cover',
                          style: TextStyle(
                            color: primaryColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Title Field
        Text(
          'Book Title *',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _titleController,
          decoration: _inputDecoration('Enter book title'),
        ),
        const SizedBox(height: 16),

        // Price/Value Field
        Text(
          _transactionType == 'trade' ? 'Estimated Value *' : 'Price *',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _priceController,
          decoration: _inputDecoration(
            _transactionType == 'trade'
                ? 'Enter estimated value'
                : 'Enter price',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),

        // Location Field
        // Text(
        //   'Location *',
        //   style: TextStyle(
        //     color: primaryColor,
        //     fontWeight: FontWeight.w500,
        //   ),
        // ),
        // const SizedBox(height: 8),
        // TextField(
        //   controller: _locationController,
        //   decoration: _inputDecoration('Enter your location'),
        // ),
        // const SizedBox(height: 16),

        // Category Dropdown
        Text(
          'Category *',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: _inputDecoration('Select category'),
          items: _categories
              .map((category) => DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  ))
              .toList(),
          onChanged: (value) => setState(() => _selectedCategory = value),
          validator: (value) =>
              value == null ? 'Please select a category' : null,
        ),
        const SizedBox(height: 16),

        // Description Field
        Text(
          'Description',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          decoration: _inputDecoration('Enter book description (optional)'),
          maxLines: 3,
        ),
        const SizedBox(height: 32),

        // Submit Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _submitBook,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Submit Book',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: primaryColor,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    );
  }
}
