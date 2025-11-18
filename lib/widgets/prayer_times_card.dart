import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class PrayerTimesCard extends StatelessWidget {
  final PrayerTimes prayerTimes;
  final Prayer currentPrayer;
  final String currentPrayerName;
  final String timeLeftToEnd;
  final double prayerProgress;
  final DateTime tomorrowFajr;
  
  // !! নতুন প্যারামিটার: নিষিদ্ধ সময় কিনা তা জানার জন্য
  final bool isProhibitedTime;

  const PrayerTimesCard({
    super.key,
    required this.prayerTimes,
    required this.currentPrayer,
    required this.currentPrayerName,
    required this.timeLeftToEnd,
    required this.prayerProgress,
    required this.tomorrowFajr,
    // !! isProhibitedTime যোগ করা হয়েছে
    required this.isProhibitedTime,
    // !! ত্রুটি সমাধান: অপ্রয়োজনীয় 'ishrakTime' প্যারামিটারটি সরিয়ে ফেলা হয়েছে
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // প্রগ্রেস বারটি এখন 'isProhibitedTime' প্যারামিটার গ্রহণ করবে
              _buildProgressIndicator(),
              const SizedBox(width: 16),
              // সালাতের তালিকায় শুধু ৫ ওয়াক্ত সালাত থাকবে
              _buildPrayerList(),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today, color: Color(0xFF1D9375), size: 18),
              SizedBox(width: 8),
              Text(
                'ক্যালেন্ডার পেজ দেখুন',
                style: TextStyle(
                  color: Color(0xFF1D9375),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // !! এই উইজেটটি আপডেট করা হয়েছে
  Widget _buildProgressIndicator() {
    // নিষিদ্ধ সময় হলে রঙ এবং লেখা পরিবর্তন করুন
    final Color progressColor = isProhibitedTime ? Colors.red.shade700 : const Color(0xFF1D9375);
    final String title = isProhibitedTime ? 'নিষিদ্ধ সময়' : currentPrayerName;
    final String subtitle = isProhibitedTime ? 'সালাত থেকে বিরত থাকুন' : 'শেষ হতে বাকি';

    return Expanded(
      flex: 3,
      child: Column(
        children: [
          Text(
            title, // ডাইনামিক টাইটেল
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: progressColor), // ডাইনামিক রঙ
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle, // ডাইনামিক সাবটাইটেল
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 6,
                  color: Colors.grey.shade200,
                ),
              ),
              SizedBox(
                height: 80,
                width: 80,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: CircularProgressIndicator(
                    value: (prayerProgress.isFinite
                        ? prayerProgress.clamp(0.0, 1.0)
                        : 0.0),
                    strokeWidth: 6,
                    color: progressColor, // ডাইনামিক রঙ
                  ),
                ),
              ),
              // নিষিদ্ধ সময়ে কাউন্টডাউন দেখানোর দরকার নেই
              if (!isProhibitedTime)
                Text(
                  timeLeftToEnd,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // !! এই উইজেটটি আপডেট করা হয়েছে
  Widget _buildPrayerList() {
    DateTime getEndTime(Prayer prayer) {
      switch (prayer) {
        case Prayer.fajr:
          // ফজর শেষ হয় সূর্যোদয়ে
          return prayerTimes.sunrise; 
        case Prayer.dhuhr:
          return prayerTimes.timeForPrayer(Prayer.asr) ?? DateTime.now();
        case Prayer.asr:
          return prayerTimes.timeForPrayer(Prayer.maghrib) ?? DateTime.now();
        case Prayer.maghrib:
          return prayerTimes.timeForPrayer(Prayer.isha) ?? DateTime.now();
        case Prayer.isha:
          return tomorrowFajr;
        case Prayer.sunrise:
        case Prayer.none:
        default:
          return DateTime.now();
      }
    }
    
    // শুধু ৫ ওয়াক্তের সময়
    final fajrStart = prayerTimes.timeForPrayer(Prayer.fajr);
    final dhuhrStart = prayerTimes.timeForPrayer(Prayer.dhuhr);
    final asrStart = prayerTimes.timeForPrayer(Prayer.asr);
    final maghribStart = prayerTimes.timeForPrayer(Prayer.maghrib);
    final ishaStart = prayerTimes.timeForPrayer(Prayer.isha);

    return Expanded(
      flex: 5,
      child: Column(
        children: [
          // !! ত্রুটি সমাধান: `!` (bang operator) সরিয়ে ফেলা হয়েছে
          _prayerRow('ফজর:', fajrStart, getEndTime(Prayer.fajr),
              isActive: currentPrayer == Prayer.fajr),
          _prayerRow('যোহর:', dhuhrStart, getEndTime(Prayer.dhuhr),
              isActive: currentPrayer == Prayer.dhuhr),
          _prayerRow('আছর:', asrStart, getEndTime(Prayer.asr),
              isActive: currentPrayer == Prayer.asr),
          _prayerRow('মাগরিব:', maghribStart, getEndTime(Prayer.maghrib),
              isActive: currentPrayer == Prayer.maghrib),
          _prayerRow('ইশা:', ishaStart, getEndTime(Prayer.isha),
              isActive: currentPrayer == Prayer.isha),
        ],
      ),
    );
  }

  // !! এই উইজেটটি আপডেট করা হয়েছে
  Widget _prayerRow(String name, DateTime? startTime, DateTime? endTime,
      {bool isActive = false}) {
    
    // বাংলা লোকাল ব্যবহার করা হয়েছে
    final format = DateFormat.jm('bn_BD');
    
    // !! ত্রুটি সমাধান: startTime এবং endTime null হতে পারে, তাই চেক করা হয়েছে
    final String startStr =
        startTime != null ? format.format(startTime) : '--:--';
    final String endStr = endTime != null ? format.format(endTime) : '--:--';

    // !! ত্রুটি সমাধান: _formatTime হেল্পার ফাংশনটি এখানে নেই, তাই সরাসরি format() ব্যবহার করা হয়েছে
    String timeRange;
    if (name == 'ফজর:' && endTime != null) {
      timeRange = '$startStr - ${format.format(endTime)}'; // সূর্যোদয়
    } else if (name == 'ইশা:' && endTime != null) {
      timeRange = '$startStr - ${format.format(endTime)}'; // পরবর্তী ফজর
    } else {
      timeRange = '$startStr - $endStr';
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      margin: const EdgeInsets.only(bottom: 4.0),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0x1A1D9375) // 10% alpha
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? const Color(0xFF1D9375) : Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              timeRange,
              textAlign: TextAlign.right,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? const Color(0xFF1D9375) : Colors.black54,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}