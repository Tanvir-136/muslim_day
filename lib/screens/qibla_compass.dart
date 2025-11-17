import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:adhan/adhan.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/prayer_settings.dart'; 
import 'dart:math' as math; 

class QiblaCompassScreen extends StatelessWidget {
  const QiblaCompassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // প্রোভাইডার থেকে ব্যবহারকারীর সেভ করা স্থানাঙ্ক (coordinates) নিন
    final settings = Provider.of<PrayerSettings>(context, listen: false);
    
    // adhan প্যাকেজ ব্যবহার করে কিবলার দিক গণনা করুন
    final qiblaDirection = Qibla(settings.coordinates).direction;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "কিবলা কম্পাস",
          style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "কম্পাস সেন্সর পড়তে ত্রুটি হয়েছে: ${snapshot.error}",
                style: const TextStyle(color: Colors.red, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 10),
                  Text("কম্পাস ক্যালিব্রেট করা হচ্ছে..."),
                ],
              ),
            );
          }

          double? deviceHeading = snapshot.data!.heading;

          if (deviceHeading == null) {
            return Center(
              child: Text(
                "আপনার ডিভাইসে কম্পাস সেন্সর পাওয়া যায়নি।",
                style: GoogleFonts.notoSansBengali(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          }
          
          // কিবলা আইকনটি ঘোরানোর জন্য কোণ গণনা
          double relativeAngle = (qiblaDirection - deviceHeading);
          double relativeAngleRadians = relativeAngle * (math.pi / 180.0);

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "কিবলা",
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${qiblaDirection.toStringAsFixed(2)}° N", // উত্তর থেকে কিবলার কোণ
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),

                // কম্পাস UI
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // কম্পাসের ব্যাকগ্রাউন্ড
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300, width: 4),
                        ),
                      ),
                      
                      // উত্তর দিক (N)
                      const Positioned(
                        top: 10,
                        child: Text("N", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                      ),
                      const Positioned(
                        bottom: 10,
                        child: Text("S", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey)),
                      ),
                      const Positioned(
                        right: 10,
                        child: Text("E", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey)),
                      ),
                      const Positioned(
                        left: 10,
                        child: Text("W", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey)),
                      ),

                      // কিবলার কাঁটা (এটি ঘুরবে)
                      Transform.rotate(
                        angle: relativeAngleRadians, // ডিভাইস ঘোরার সাথে সাথে এটিও ঘুরবে
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.mosque, // কাবার জন্য মসজিদ আইকন
                              size: 60,
                              color: Colors.teal,
                            ),
                            Container( // কাঁটার দণ্ড
                              width: 4,
                              height: 80,
                              color: Colors.teal,
                            ),
                          ],
                        ),
                      ),

                      // ডিভাইসের হেডিং (উত্তর দিকের কাঁটা)
                      Transform.rotate(
                        angle: (deviceHeading * -1) * (math.pi / 180.0), // এটি উত্তর দিক নির্দেশ করবে
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Icon(Icons.navigation, color: Colors.red, size: 40),
                             SizedBox(height: 110), // বিপরীত দিকে
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    "লাল তীরটি উত্তর দিকে নির্দেশ করে। সবুজ আইকনটি কিবলার দিক নির্দেশ করে।",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSansBengali(fontSize: 16, color: Colors.grey),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}