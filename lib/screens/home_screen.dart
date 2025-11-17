import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../providers/quran_settings.dart'; 
import '../widgets/bottom_nav.dart';
import 'home_content.dart';
import 'quran_screen.dart'; 
import 'menu_screens.dart';
import '../providers/amal_provider.dart';
import 'amal_journal_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // This list is no longer 'const'
  static final List<Widget> _pages = <Widget>[
    const HomeContent(), // Index 0: Home
    const Center(child: Text('মাহফিল পেজ')), // Index 1: Mahfil
    
    // Index 2: Quran (as before)
    ChangeNotifierProvider(
      create: (context) => QuranSettings(),
      child: const QuranScreen(), 
    ),
    
    // !! 3. Replaced "Dua Page" with "Amal Journal"
    ChangeNotifierProvider(
      create: (context) => AmalProvider(),
      child: const AmalJournalPage(), // Index 3: Amal Journal
    ), 
    
    const MenuScreen(), // Index 4: Menu
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      // !! 4. Enabled your BottomNav
      bottomNavigationBar: BottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}