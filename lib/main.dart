import 'package:muslim_day/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/quran_settings.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => QuranSettings(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prayer Times',
      debugShowCheckedModeBanner: false,
      // Add localization delegates for Bangla date formatting
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('bn', ''), // Bengali
      ],
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFFF3F5F7),
        primaryColor: const Color(0xFF006A56),
        fontFamily: 'HindSiliguri',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF3F5F7),
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}