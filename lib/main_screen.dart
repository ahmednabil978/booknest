

import 'package:booknest/screens/account_screen.dart';
import 'package:booknest/screens/categories/home_screen.dart';
import 'package:booknest/screens/libraries_screen.dart';
import 'package:booknest/screens/my-ads_screen.dart';
import 'package:booknest/screens/upload_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Tracks the selected tab

  // Pages corresponding to each tab
  final List<Widget> _pages = [
     HomeScreen(),
     LibrariesScreen(),
    const UploadScreen(),
    const MyAdsScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: Colors.brown),
        selectedLabelStyle: TextStyle(color: Colors.brown),
        selectedItemColor: Colors.brown,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed, // For more than 3 items
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: "Libraries"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: "Upload"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "My Ads"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}