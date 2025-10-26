import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quran_settings.dart'; 
import '../widgets/bottom_nav.dart';
import 'home_content.dart';
import 'quran_screen.dart'; 
import 'menu_screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // 3. This list is no longer 'const' because the provider is created at runtime.
  static final List<Widget> _pages = <Widget>[
    const HomeContent(), // Index 0: home screen UI
    const Center(child: Text('Mahfil Page')), // Index 1: Mahfil

    // 4. THIS IS THE FIX:
    ChangeNotifierProvider(
      create: (context) => QuranSettings(),
      child: const QuranScreen(), // Index 2: Quran
    ),
    
    const Center(child: Text('Dua Page')), // Index 3: Dua
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
      // IndexedStack keeps the state of pages (like scroll position) when you switch tabs.
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}