import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

class PrayerTimesCard extends StatelessWidget {
  final PrayerTimes prayerTimes;
  final Prayer currentPrayer;
  final String nextPrayerName;
  final String timeLeft;

  const PrayerTimesCard({
    super.key,
    required this.prayerTimes,
    required this.currentPrayer,
    required this.nextPrayerName,
    required this.timeLeft,
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
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCountdownTimer(),
              const SizedBox(width: 16),
              _buildPrayerList(),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          // --- THIS IS THE MISSING WIDGET THAT WAS ADDED BACK ---
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
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

  Widget _buildCountdownTimer() {
    // ... (This function remains the same)
    return Expanded(
      flex: 3,
      child: Column(
        children: [
          Text(
            nextPrayerName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'শুরু হতে বাকি',
            style: TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            timeLeft,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D9375),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerList() {
    // ... (This function remains the same)
     return Expanded(
      flex: 4,
      child: Column(
        children: [
          _prayerRow('ফজর', prayerTimes.fajr, isActive: currentPrayer == Prayer.fajr),
          _prayerRow('যোহর', prayerTimes.dhuhr, isActive: currentPrayer == Prayer.dhuhr),
          _prayerRow('আসর', prayerTimes.asr, isActive: currentPrayer == Prayer.asr),
          _prayerRow('মাগরিব', prayerTimes.maghrib, isActive: currentPrayer == Prayer.maghrib),
          _prayerRow('ইশা', prayerTimes.isha, isActive: currentPrayer == Prayer.isha),
        ],
      ),
    );
  }

  Widget _prayerRow(String name, DateTime time, {bool isActive = false}) {
    // ... (This function remains the same)
    final formattedTime = DateFormat.jm().format(time);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      margin: const EdgeInsets.only(bottom: 4.0),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1D9375).withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? const Color(0xFF1D9375) : Colors.black87,
            ),
          ),
          Text(
            formattedTime,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? const Color(0xFF1D9375) : Colors.black54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}