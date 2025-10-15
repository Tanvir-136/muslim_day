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
            // replaced withAlpha to avoid deprecation of withOpacity
            color: Colors.grey.withAlpha(26),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            // Aligning to the top makes the layout look cleaner
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // The Expanded widgets are now here to control the main layout
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
    // CORRECTED: The flex ratio is adjusted to give this section less space
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
            textAlign: TextAlign.center,
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
                    // Safely clamp the progress to [0,1] and handle non-finite values
                    value: (prayerProgress.isFinite
                        ? prayerProgress.clamp(0.0, 1.0)
                        : 0.0),
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
      // Map each prayer to its next prayer; isha ends at tomorrow's fajr (provided)
      switch (prayer) {
        case Prayer.fajr:
          final DateTime? next = prayerTimes.timeForPrayer(Prayer.dhuhr);
          return next ?? DateTime.now();
        case Prayer.dhuhr:
          final DateTime? next = prayerTimes.timeForPrayer(Prayer.asr);
          return next ?? DateTime.now();
        case Prayer.asr:
          final DateTime? next = prayerTimes.timeForPrayer(Prayer.maghrib);
          return next ?? DateTime.now();
        case Prayer.maghrib:
          final DateTime? next = prayerTimes.timeForPrayer(Prayer.isha);
          return next ?? DateTime.now();
        case Prayer.isha:
          // Isha ends at tomorrow's fajr
          return tomorrowFajr;
        // handle other possible enum values
        case Prayer.sunrise:
        case Prayer.none:
        default:
          return DateTime.now();
      }
    }
    // collect start times
    final fajrStart = prayerTimes.timeForPrayer(Prayer.fajr);
    final dhuhrStart = prayerTimes.timeForPrayer(Prayer.dhuhr);
    final asrStart = prayerTimes.timeForPrayer(Prayer.asr);
    final maghribStart = prayerTimes.timeForPrayer(Prayer.maghrib);
    final ishaStart = prayerTimes.timeForPrayer(Prayer.isha);

    // CORRECTED: The flex ratio is adjusted to give this section MORE space
    return Expanded(
      flex: 5,
      child: Column(
        children: [
          _prayerRow('ফজর:', fajrStart, getEndTime(Prayer.fajr),
              isActive: currentPrayer == Prayer.fajr),
          _prayerRow('জোহর:', dhuhrStart, getEndTime(Prayer.dhuhr),
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

  // This widget now shows a time range (start - end)
  Widget _prayerRow(String name, DateTime? startTime, DateTime? endTime,
      {bool isActive = false}) {
    final format = DateFormat.jm();
    final String startStr =
        startTime != null ? format.format(startTime) : '--:--';
    final String endStr = endTime != null ? format.format(endTime) : '--:--';
    final timeRange = '$startStr - $endStr';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      margin: const EdgeInsets.only(bottom: 4.0),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0x1A1D9375) // 10% alpha of 0xFF1D9375
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