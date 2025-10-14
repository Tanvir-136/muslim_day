import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class PrayerTimesCard extends StatelessWidget {
  // These are the updated parameters for the progress bar functionality
  final PrayerTimes prayerTimes;
  final Prayer currentPrayer;
  final String currentPrayerName;
  final String timeLeftToEnd;
  final double prayerProgress;
  final DateTime tomorrowFajr;

  const PrayerTimesCard({
    super.key,
    required this.prayerTimes,
    required this.currentPrayer,
    required this.currentPrayerName,
    required this.timeLeftToEnd,
    required this.prayerProgress,
    required this.tomorrowFajr,
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
              _buildProgressIndicator(),
              const SizedBox(width: 16),
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

  // This widget now builds the progress bar
  Widget _buildProgressIndicator() {
    return Expanded(
      flex: 3,
      child: Column(
        children: [
          Text(
            currentPrayerName,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D9375)),
          ),
          const SizedBox(height: 4),
          const Text(
            'শেষ হতে বাকি',
            style: TextStyle(color: Colors.grey, fontSize: 12),
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
                    value: prayerProgress,
                    strokeWidth: 6,
                    color: const Color(0xFF1D9375),
                  ),
                ),
              ),
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

  // This widget now calculates and displays the end times
  Widget _buildPrayerList() {
    DateTime getEndTime(Prayer prayer) {
      if (prayer == Prayer.isha) return tomorrowFajr;
      return prayerTimes.timeForPrayer(prayerTimes.nextPrayer())!;
    }

    return Expanded(
      flex: 4,
      child: Column(
        children: [
          _prayerRow('ফজর: ', prayerTimes.fajr, getEndTime(Prayer.fajr),
              isActive: currentPrayer == Prayer.fajr),
          _prayerRow('যোহর: ', prayerTimes.dhuhr, getEndTime(Prayer.dhuhr),
              isActive: currentPrayer == Prayer.dhuhr),
          _prayerRow('আসর: ', prayerTimes.asr, getEndTime(Prayer.asr),
              isActive: currentPrayer == Prayer.asr),
          _prayerRow('মাগরিব: ', prayerTimes.maghrib, getEndTime(Prayer.maghrib),
              isActive: currentPrayer == Prayer.maghrib),
          _prayerRow('ইশা: ', prayerTimes.isha, getEndTime(Prayer.isha),
              isActive: currentPrayer == Prayer.isha),
        ],
      ),
    );
  }

  // This widget now shows a time range (start - end)
  Widget _prayerRow(String name, DateTime startTime, DateTime endTime,
      {bool isActive = false}) {
    final format = DateFormat.jm();
    final timeRange = '${format.format(startTime)} - ${format.format(endTime)}';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      margin: const EdgeInsets.only(bottom: 4.0),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF1D9375).withOpacity(0.1)
            : Colors.transparent,
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
            timeRange,
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