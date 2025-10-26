import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quran/quran.dart' as quran;
import '../providers/quran_settings.dart';
import 'quran_settings.dart'; 

/// ইংরেজি সংখ্যাকে বাংলা সংখ্যায় রূপান্তর করে
String _getBengaliNumber(int number) {
  const Map<String, String> bengaliMap = {
    '0': '০', '1': '১', '2': '২', '3': '৩', '4': '৪',
    '5': '৫', '6': '৬', '7': '৭', '8': '৮', '9': '৯'
  };
  return number
      .toString()
      .split('')
      .map((char) => bengaliMap[char] ?? char)
      .join();
}

/// সূরার বিস্তারিত দেখানোর স্ক্রিন
class SurahDetailsScreen extends StatelessWidget {
  final int surahNumber;
  final String surahNameEnglish;
  final String surahNameArabic;
  final String surahNameBengali;
  final String surahNameMeaning;

  const SurahDetailsScreen({
    super.key,
    required this.surahNumber,
    required this.surahNameEnglish,
    required this.surahNameArabic,
    required this.surahNameBengali,
    required this.surahNameMeaning,
  });

  @override
  Widget build(BuildContext context) {
    final verseCount = quran.getVerseCount(surahNumber);
    final settings = Provider.of<QuranSettings>(context);
    
    // ইংরেজি স্থানকে বাংলায় রূপান্তর
    final placeOfRevelation = quran.getPlaceOfRevelation(surahNumber);
    final revelationPlaceBengali =
        placeOfRevelation == "Makkah" ? "মাক্কী" : "মাদানী";

    // !! নতুন লজিক: বিসমিল্লাহ কার্ড দেখানো হবে কিনা?
    final bool showBismillahCard = (surahNumber != 1 && surahNumber != 9);
    
    // !! নতুন লজিক: মোট আইটেম সংখ্যা গণনা
    // ১ (হেডার) + আয়াত সংখ্যা + (বিসমিল্লাহ কার্ড থাকলে ১, না থাকলে ০)
    final int totalItemCount = 1 + verseCount + (showBismillahCard ? 1 : 0);

    return Scaffold(
      backgroundColor: Colors.grey[50], // হালকা ব্যাকগ্রাউন্ড
      // --- অ্যাপবার ---
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          surahNameBengali, // বাংলা শিরোনাম
          style: GoogleFonts.notoSansBengali(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.grey[800]),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_outlined), // ফিল্টার আইকন
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border), // বুকমার্ক আইকন
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward), // ফরওয়ার্ড আইকন
            onPressed: () {},
          ),
        ],
      ),
      // --- প্লে বাটন ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.teal,
        child: const Icon(Icons.play_arrow, color: Colors.white),
      ),
      // --- বডি ---
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // !! itemCount পরিবর্তন করা হয়েছে
        itemCount: totalItemCount, 
        itemBuilder: (context, index) {
          
          // --- ১. সাব-হেডার (সর্বদা index 0) ---
          if (index == 0) {
            return _buildSubHeader(
                revelationPlaceBengali, verseCount, surahNameMeaning);
          }

          // --- ২. বিসমিল্লাহ কার্ড (যদি প্রযোজ্য হয় এবং index 1 হয়) ---
          if (showBismillahCard && index == 1) {
            return _buildBismillahCard(settings);
          }

          // --- ৩. আয়াতসমূহ ---
          
          // !! নতুন লজিক: আয়াতের নম্বর গণনা
          int verseNumber;
          if (showBismillahCard) {
            // যদি বিসমিল্লাহ কার্ড থাকে (index 1), তবে আয়াত শুরু হয় index 2 থেকে
            // তাই, verseNumber = index - 1 (e.g., index 2 -> verse 1)
            verseNumber = index - 1;
          } else {
            // যদি বিসমিল্লাহ কার্ড না থাকে (সূরা ১ বা ৯), তবে আয়াত শুরু হয় index 1 থেকে
            // তাই, verseNumber = index (e.g., index 1 -> verse 1)
            verseNumber = index;
          }

          final verseText = quran.getVerse(surahNumber, verseNumber);
          
          // !! গুরুত্বপূর্ণ: এখানে আমরা ইংরেজি অনুবাদ পাচ্ছি
          final verseTranslation =
              quran.getVerseTranslation(surahNumber, verseNumber);

          return _VerseCard(
            verseNumber: verseNumber,
            verseText: verseText,
            verseTranslation: verseTranslation, // placeholder
            settings: settings,
          );
        },
      ),
    );
  }

  /// সাব-হেডার উইজেট
  Widget _buildSubHeader(
      String place, int verseCount, String meaning) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Center(
        child: Text(
          "$place | $meaning | আয়াত সংখ্যা: ${_getBengaliNumber(verseCount)}",
          style: GoogleFonts.notoSansBengali(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }

  /// বিসমিল্লাহ দেখানোর জন্য কার্ড
  Widget _buildBismillahCard(QuranSettings settings) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Center(
          child: Text(
            quran.basmala,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: settings.arabicFontSize * 1.1, 
              fontFamily: GoogleFonts.amiri().fontFamily, 
              color: Colors.teal,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// প্রতিটি আয়াতের জন্য আলাদা কার্ড উইজেট
class _VerseCard extends StatelessWidget {
  const _VerseCard({
    required this.verseNumber,
    required this.verseText,
    required this.verseTranslation,
    required this.settings,
  });

  final int verseNumber;
  final String verseText;
  final String verseTranslation;
  final QuranSettings settings;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- কার্ডের উপরের অংশ (নম্বর ও মেনু) ---
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _getBengaliNumber(verseNumber),
                    style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.more_horiz, color: Colors.grey[400]),
                  onPressed: () {
                    // এখানে কপি, শেয়ার, বুকমার্ক অপশন যোগ করা যাবে
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // --- আরবি আয়াত ---
            Text(
              verseText,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: settings.arabicFontSize,
                fontFamily: GoogleFonts.amiri().fontFamily,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                height: 1.8, // লাইন স্পেসিং
              ),
            ),
            const SizedBox(height: 16),

            // --- বাংলা অনুবাদ ---
            if (settings.showTranslation)
              Text(
                verseTranslation, // !! এটি ইংরেজি অনুবাদ (Placeholder)
                textAlign: TextAlign.left,
                style: GoogleFonts.notoSansBengali(
                  fontSize: settings.translationFontSize,
                  color: Colors.grey[700],
                  height: 1.6,
                ),
              ),
          ],
        ),
      ),
    );
  }
}