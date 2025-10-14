import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;

// Define a consistent font size for the large Arabic text
const double _arabicTextSize = 28.0;

// --- CUSTOM ARBIC NUMBER CONVERSION HELPER ---
String _getArabicNumber(int number) {
  const Map<String, String> arabicMap = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩'
  };
  return number
      .toString()
      .split('')
      .map((char) => arabicMap[char] ?? char)
      .join();
}

void main() {
  runApp(
    MaterialApp(
      title: 'The Holy Quran',
      theme: ThemeData(
        // brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        fontFamily: GoogleFonts.lato().fontFamily,
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1E1E1E),
          elevation: 4,
          titleTextStyle: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const SurahListView(),
    ),
  );
}

/// --- Surah List View ---
class SurahListView extends StatelessWidget {
  const SurahListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("The Holy Quran"),
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: Colors.teal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 114,
        itemBuilder: (context, index) {
          final surahNumber = index + 1;
          final englishName = quran.getSurahNameEnglish(surahNumber);
          final arabicName = quran.getSurahName(surahNumber);
          final revelationPlace = quran.getPlaceOfRevelation(surahNumber);

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal,
              child: Text(
                '$surahNumber',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            title: Text(
              arabicName,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 20.0,
                // IMPORTANT: Your app uses a dark theme. Black text will be invisible.
                // Consider changing this to `Colors.white`
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              '$englishName | Verses: ${quran.getVerseCount(surahNumber)} | $revelationPlace',
              style: const TextStyle(
                color: Colors.teal,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SurahDetailsScreen(
                    surahNumber: surahNumber,
                    surahNameEnglish: englishName,
                    surahNameArabic: arabicName,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// --- Surah Details View ---
class SurahDetailsScreen extends StatelessWidget {
  final int surahNumber;
  final String surahNameEnglish;
  final String surahNameArabic;

  const SurahDetailsScreen({
    super.key,
    required this.surahNumber,
    required this.surahNameEnglish,
    required this.surahNameArabic,
  });

  @override
  Widget build(BuildContext context) {
    final verseCount = quran.getVerseCount(surahNumber);

    return Scaffold(
      appBar: AppBar(
        title: Text('$surahNameEnglish ($surahNameArabic)'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: verseCount + 2, // +2 for header and Bismillah
        itemBuilder: (context, index) {
          // --- HEADER INFO ---
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                '${quran.getSurahNameEnglish(surahNumber)} | ${quran.getPlaceOfRevelation(surahNumber)} | Verses: $verseCount',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.teal),
              ),
            );
          }
          // --- Bismillah ---
          if (index == 1) {
            if (surahNumber != 1 && surahNumber != 9) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  quran.basmala,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }

          // --- VERSES ---
          final verseNumber = index - 1; // Adjust index for verses
          final verseText = quran.getVerse(surahNumber, verseNumber);
          // ADDED: Get verse translation
          final verseTranslation =
              quran.getVerseTranslation(surahNumber, verseNumber);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Arabic Verse
                RichText(
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style.copyWith(
                          fontSize: _arabicTextSize,
                          height: 2.0,
                          color: Colors.black,
                        ),
                    children: [
                      TextSpan(text: verseText),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.teal, width: 2.0),
                          ),
                          child: Text(
                            _getArabicNumber(verseNumber),
                            style: const TextStyle(
                              fontSize: _arabicTextSize * 0.75,
                              fontWeight: FontWeight.bold,
                              color: Colors.tealAccent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8), // Spacing

                // ADDED: English Translation Subtitle
                Text(
                  verseTranslation,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.teal,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const Divider(color: Colors.white10, height: 40, thickness: 1),
              ],
            ),
          );
        },
      ),
    );
  }
}
