import 'package:flutter/material.dart';
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

  // This list holds all the pages for your bottom navigation bar.
  static const List<Widget> _pages = <Widget>[
    HomeContent(),                       // Index 0: home screen UI
    Center(child: Text('Mahfil Page')), // Index 1: Mahfil
    SurahListView(),                    // Index 2: Quran
    Center(child: Text('Dua Page')),    // Index 3: Dua
    MenuScreen(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body now shows the selected page from our list.
      // IndexedStack keeps the state of pages when you switch tabs.
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