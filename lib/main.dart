import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/quran_settings.dart';
import 'providers/prayer_settings.dart'; 
import 'screens/home_screen.dart'; 

// !! 1. Import the date formatting library
import 'package:intl/date_symbol_data_local.dart';

void main() async { 
  // !! 3. Ensure Flutter is initialized before running async code
  WidgetsFlutterBinding.ensureInitialized();

  // !! 4. THIS IS THE FIX: Load Bengali (bn_BD) locale datadata
  await initializeDateFormatting('bn_BD', null);

  // Wrap your app in MultiProvider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => QuranSettings()),
        ChangeNotifierProvider(create: (context) => PrayerSettings()),
      ],
      child: const MuslimDayApp(), // Your app
    ),
  );
}

class MuslimDayApp extends StatelessWidget {
  const MuslimDayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuranSettings>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'Muslim Day',
          theme: ThemeData(
            primarySwatch: Colors.teal,
            // Set the default app font to Bengali
            fontFamily: GoogleFonts.notoSansBengali().fontFamily, 
            appBarTheme: AppBarTheme(
              backgroundColor: const Color(0xFF1A4D4D),
              elevation: 4,
              titleTextStyle: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          ),
          home: const HomeScreen(), 
        );
      },
    );
  }
}