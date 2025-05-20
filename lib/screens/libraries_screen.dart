import 'package:flutter/material.dart';

class LibrariesScreen extends StatelessWidget {
  const LibrariesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF6D4C41); // Brown 600
    final Color secondaryColor = const Color(0xFFFFD54F); // Amber 300
    final Color backgroundColor = const Color(0xFFF5F5F5);

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          secondary: secondaryColor,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Local Libraries by Area'),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
        ),
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              ..._buildAreaTiles(context, primaryColor, secondaryColor),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAreaTiles(
      BuildContext context, Color primaryColor, Color secondaryColor) {
    final librariesByArea = {
      'Downtown Cairo': [
        Library(
          name: 'Egyptian National Library',
          description:
          'The largest and oldest government library in Egypt with rare manuscripts and historical documents. Established in 1870, it houses over 2.5 million volumes including priceless Islamic manuscripts.',
          location: 'Corniche El Nil, Downtown',
          hours: '9:00 AM - 3:00 PM (Closed Fridays)',
          contact: '+20 2 2578 0741',
          imageUrl: 'assets/images/library1.jpg',
        ),
        Library(
          name: 'American University in Cairo Library',
          description:
          'Premier academic library with extensive English and Arabic collections. Features over 400,000 volumes, digital resources, and special collections on Egyptology and Middle Eastern studies.',
          location: 'AUC Tahrir Square, Downtown',
          hours: '8:00 AM - 8:00 PM (Weekdays), 10:00 AM - 4:00 PM (Weekends)',
          contact: '+20 2 2615 3676',
          imageUrl: 'assets/images/library2.jpg',
        ),
        Library(
          name: 'Dar El Kotob (House of Books)',
          description:
          'National repository of Egyptian publications with millions of volumes. Established in 1870, it serves as Egypt\'s legal deposit library and includes rare books dating back to the 19th century.',
          location: 'Corniche El Nil, Ramlet Boulak',
          hours: '8:00 AM - 4:00 PM',
          contact: '+20 2 2579 5720',
          imageUrl: 'assets/images/library3.jpg',
        ),
      ],
      'Zamalek': [
        Library(
          name: 'British Council Library',
          description:
          'Modern library with British literature, language learning resources, and cultural events. Offers IELTS preparation materials and regular author talks and workshops.',
          location: '192 El Nil Street, Zamalek',
          hours: '10:00 AM - 6:00 PM (Closed Fridays)',
          contact: '+20 2 2461 1919',
          imageUrl: 'assets/images/library4.jpg',
        ),
        Library(
          name: 'Goethe-Institut Library',
          description:
          'German cultural center library with books, media, and language learning materials. Features over 10,000 German titles and hosts regular film screenings and cultural events.',
          location: '5 El Saleh Ayoub Street, Zamalek',
          hours: '10:00 AM - 5:00 PM (Closed Sundays)',
          contact: '+20 2 2735 9870',
          imageUrl: 'assets/images/library5.jpg',
        ),
      ],
      'Heliopolis': [
        Library(
          name: 'Heliopolis Public Library',
          description:
          'Community library serving Heliopolis with books for all ages. Features children\'s reading programs and regular book clubs for adults.',
          location: 'Al-Ahram Street, Heliopolis',
          hours: '9:00 AM - 5:00 PM',
          contact: '+20 2 2415 1088',
          imageUrl: 'assets/images/library6.jpg',
        ),
        Library(
          name: 'Institut Français Library',
          description:
          'French cultural center with extensive French literature and multimedia. Offers DELF/DALF exam preparation and hosts French film festivals.',
          location: '5 Shagaret El Dorr Street, Heliopolis',
          hours: '10:00 AM - 8:00 PM (Closed Mondays)',
          contact: '+20 2 2419 8383',
          imageUrl: 'assets/images/library7.jpg',
        ),
      ],
      'Maadi': [
        Library(
          name: 'Maadi Public Library',
          description:
          'The main public library serving Maadi residents with a wide collection of Arabic and English books. Features quiet study areas and computer workstations.',
          location: 'Road 9, Maadi',
          hours: '9:00 AM - 5:00 PM (Closed Fridays)',
          contact: '+20 2 2524 3050',
          imageUrl: 'assets/images/library8.jpg',
        ),
        Library(
          name: 'Maadi Community Library',
          description:
          'Community-run library with international books and children\'s section. Operated by volunteers and supported by local donations and memberships.',
          location: 'Degla, Maadi',
          hours: '10:00 AM - 8:00 PM (Weekdays), 12:00 PM - 6:00 PM (Weekends)',
          contact: '+20 2 2528 0671',
          imageUrl: 'assets/images/library9.jpg',
        ),
      ],
      'Madinet Nasr': [
        Library(
          name: 'Nasr City Public Library',
          description:
          'Large public library with extensive Arabic literature collection. Features regular poetry readings and author signings.',
          location: 'Abbas El-Akkad, Nasr City',
          hours: '8:00 AM - 4:00 PM',
          contact: '+20 2 2260 2145',
          imageUrl: 'assets/images/library10.jpg',
        ),
        Library(
          name: 'Al-Ahram Newspaper Library',
          description:
          'Specialized library for periodicals and newspaper archives. Houses complete collections of Egyptian newspapers dating back to the 19th century.',
          location: 'El-Galaa Street, Nasr City',
          hours: '10:00 AM - 6:00 PM (Closed Saturdays)',
          contact: '+20 2 2670 1000',
          imageUrl: 'assets/images/library11.jpg',
        ),
      ],
      '6th of October City': [
        Library(
          name: 'October Public Library',
          description:
          'Modern library serving 6th of October City with diverse collections. Features state-of-the-art facilities and digital resources.',
          location: 'Central District, 6th of October',
          hours: '9:00 AM - 5:00 PM',
          contact: '+20 2 3824 5560',
          imageUrl: 'assets/images/library12.jpg',
        ),
        Library(
          name: 'German University in Cairo Library',
          description:
          'Academic library with extensive technical and scientific resources. Open to the public with registration, featuring over 100,000 volumes in multiple languages.',
          location: 'GUC Campus, 6th of October',
          hours: '8:00 AM - 8:00 PM (Weekdays)',
          contact: '+20 2 3854 0320',
          imageUrl: 'assets/images/library13.jpg',
        ),
      ],
      'Giza': [
        Library(
          name: 'Giza Public Library',
          description:
          'Main public library serving Giza with diverse collections. Features local history archives and children\'s storytelling sessions.',
          location: 'El Omraniya, Giza Governorate',
          hours: '8:00 AM - 4:00 PM',
          contact: '+20 2 3582 2110',
          imageUrl: 'assets/images/library14.jpg',
        ),
        Library(
          name: 'Cairo University Main Library',
          description:
          'One of Egypt\'s largest academic libraries with millions of volumes. Open to university students and faculty, with limited public access.',
          location: 'Cairo University, Giza',
          hours: '8:00 AM - 4:00 PM (Closed Fridays)',
          contact: '+20 2 3567 8000',
          imageUrl: 'assets/images/library15.jpg',
        ),
        Library(
          name: 'Cairo University Engineering Library',
          description:
          'Specialized technical library serving engineering students. Contains rare technical manuals and engineering standards collections.',
          location: 'Cairo University, Giza',
          hours: '8:00 AM - 4:00 PM (Closed Fridays)',
          contact: '+20 2 3567 8222',
          imageUrl: 'assets/images/library16.jpg',
        ),
      ],
      'Dokki': [
        Library(
          name: 'Agricultural Research Center Library',
          description:
          'Specialized library for agricultural sciences and research. Houses unique collections on Egyptian agriculture and desert reclamation.',
          location: 'Giza Street, Dokki',
          hours: '8:00 AM - 3:00 PM',
          contact: '+20 2 3335 8211',
          imageUrl: 'assets/images/library17.jpg',
        ),
        Library(
          name: 'National Research Center Library',
          description:
          'Scientific research library with extensive technical resources. Provides access to scientific journals and research papers.',
          location: 'El-Tahrir Street, Dokki',
          hours: '9:00 AM - 4:00 PM',
          contact: '+20 2 3333 6225',
          imageUrl: 'assets/images/library18.jpg',
        ),
      ],
      'Agouza': [
        Library(
          name: 'Agouza Public Library',
          description:
          'Community library serving Agouza and surrounding areas. Features local author collections and reading programs for youth.',
          location: 'Nile Street, Agouza',
          hours: '9:00 AM - 4:00 PM',
          contact: '+20 2 3303 4580',
          imageUrl: 'assets/images/library19.jpg',
        ),
      ],
      'Mohandessin': [
        Library(
          name: 'Mohandessin Public Library',
          description:
          'Modern library with books for all ages in the heart of Mohandessin. Features comfortable reading lounges and free WiFi.',
          location: 'Gameat El Dewal Street, Mohandessin',
          hours: '10:00 AM - 6:00 PM',
          contact: '+20 2 3305 6721',
          imageUrl: 'assets/images/library20.jpg',
        ),
      ],
    };

    return librariesByArea.entries.map((entry) {
      return _buildAreaTile(
        context,
        primaryColor,
        secondaryColor,
        entry.key,
        entry.value,
      );
    }).toList();
  }

  Widget _buildAreaTile(
      BuildContext context,
      Color primaryColor,
      Color secondaryColor,
      String areaName,
      List<Library> libraries,
      ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          collapsedBackgroundColor: Colors.white,
          backgroundColor: secondaryColor.withOpacity(0.1),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.location_on, color: primaryColor),
          ),
          title: Text(
            areaName,
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          children: libraries
              .map((library) => _buildLibraryItem(context, primaryColor, library))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildLibraryItem(BuildContext context, Color primaryColor, Library library) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showLibraryDetails(context, library),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: primaryColor.withOpacity(0.1)),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.library_books, color: primaryColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      library.name,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      library.location,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: primaryColor),
            ],
          ),
        ),
      ),
    );
  }

  void _showLibraryDetails(BuildContext context, Library library) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final primaryColor = const Color(0xFF6D4C41);
        final secondaryColor = const Color(0xFFFFD54F);

        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 16,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              // Draggable handle
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 8),
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Library name and icon
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: secondaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.library_books,
                              size: 32,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  library.name,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  library.location,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Library image placeholder
                      Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage(library.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Details section
                      _buildDetailSection(
                        icon: Icons.access_time,
                        title: 'Opening Hours',
                        content: library.hours,
                        primaryColor: primaryColor,
                      ),
                      _buildDetailSection(
                        icon: Icons.phone,
                        title: 'Contact',
                        content: library.contact,
                        primaryColor: primaryColor,
                      ),
                      _buildDetailSection(
                        icon: Icons.info,
                        title: 'About',
                        content: library.description,
                        primaryColor: primaryColor,
                        isDescription: true,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              // Close button
              Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, bottom: 24, top: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Close',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailSection({
    required IconData icon,
    required String title,
    required String content,
    required Color primaryColor,
    bool isDescription = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: primaryColor, size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            content,
            style: TextStyle(
              fontSize: isDescription ? 15 : 16,
              color: Colors.grey[800],
              height: isDescription ? 1.5 : 1.3,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class Library {
  final String name;
  final String description;
  final String location;
  final String hours;
  final String contact;
  final String imageUrl;

  Library({
    required this.name,
    required this.description,
    required this.location,
    required this.hours,
    required this.contact,
    this.imageUrl = 'assets/default_library.jpg',
  });
}