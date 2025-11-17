import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'qibla_compass.dart';
import 'prayer_settings_page.dart';
import 'tasbeeh.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F4),
      appBar: AppBar(
        // অ্যাপবার আপডেট করা হয়েছে
        title: Text(
          'মেনু',
          style: GoogleFonts.notoSansBengali(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
      ),
      body: ListView(
        children: [
          // General Section
          _buildMenuItem(
            icon: Icons.settings_outlined,
            title: 'সেটিংস',
            onTap: () {
              // <-- ৩. নেভিগেশন যোগ করা হয়েছে
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrayerSettingsPage(),
                ),
              );
            },
          ),
          _buildMenuItem(
              icon: Icons.quiz_outlined,
              title: 'বহুল জিজ্ঞাসিত প্রশ্ন (FAQ)',
              onTap: () {}),

          // Tools Section
          _buildSectionHeader('টুলস'),
          _buildMenuItem(
              icon: Icons.explore_outlined,
              title: 'কিবলা কম্পাস',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QiblaCompassScreen(),
                  ),
                );
              }),
          _buildMenuItem(
            icon: Icons.format_list_numbered,
            title: 'তাসবীহ',
            onTap: () {
              // Navigate to TasbeehCounterPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TasbeehCounterScreen(),
                ),
              );
            },
          ),
          _buildMenuItem(
              icon: Icons.mosque_outlined,
              title: 'নিকটবর্তী মসজিদ',
              onTap: () {}),

          // Knowledge Section
          _buildSectionHeader('প্রয়োজনীয় ইলম'),
          _buildMenuItem(
              icon: Icons.book_outlined,
              title: 'কুরআন-হাদীস (নির্বাচিত অংশ)',
              onTap: () {}),
          _buildMenuItem(
              icon: Icons.web_stories_outlined,
              title: 'মুসলিমস ডে ওয়েবসাইট',
              onTap: () {}),
          _buildMenuItem(
              icon: Icons.assignment_outlined,
              title: 'মাসনুন আমল',
              onTap: () {}),
          _buildMenuItem(
              icon: Icons.article_outlined, title: 'আর্টিকেল', onTap: () {}),
          _buildMenuItem(
              icon: Icons.help_outline, title: 'মাসআলা', onTap: () {}),
        ],
      ),
    );
  }

  // Helper widget for section headers like "টুলস"
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Text(
        title,
        style: GoogleFonts.notoSansBengali(
          // <-- ফন্ট আপডেট করা হয়েছে
          color: Color(0xFF1D9375),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  // Helper widget for each clickable menu item
  Widget _buildMenuItem(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.grey.shade600),
        title: Text(
          title,
          style: GoogleFonts.notoSansBengali(
            // <-- ফন্ট আপডেট করা হয়েছে
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        onTap: onTap,
      ),
    );
  }
}
