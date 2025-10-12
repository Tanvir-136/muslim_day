import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:adhan/adhan.dart';
import 'package:hijri/hijri_calendar.dart';
import 'dart:async';

// Custom widgets
import '../widgets/location_bar.dart';
import '../widgets/date_time_bar.dart';
import '../widgets/prayer_times_card.dart';
import '../widgets/info_card.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  PrayerTimes? _prayerTimes;
  String _hijriDate = '';
  String _gregorianDate = '';
  Timer? _timer;
  Duration _timeLeftToEnd = Duration.zero;
  String _currentPrayerName = '';
  Prayer _currentPrayer = Prayer.none;
  double _prayerProgress = 0.0;
  DateTime? _tomorrowFajr;

  @override
  void initState() {
    super.initState();
    _updateAllData();
  }

  void _updateAllData() {
    final myCoordinates = Coordinates(22.62, 90.25); // Garuria Union
    final params = CalculationMethod.karachi.getParameters();
    params.madhab = Madhab.hanafi;
    params.highLatitudeRule = HighLatitudeRule.twilight_angle;

    final date = DateComponents.from(DateTime.now());
    _prayerTimes = PrayerTimes(myCoordinates, date, params);

    final tomorrowDate = DateComponents.from(DateTime.now().add(const Duration(days: 1)));
    _tomorrowFajr = PrayerTimes(myCoordinates, tomorrowDate, params).fajr;

    _hijriDate = HijriCalendar.now().toFormat("d MMMM, yyyy");
    _gregorianDate = DateFormat('d MMMM, EEEE', 'bn_BD').format(DateTime.now());

    _updatePrayerProgressAndCountdown();
    _startTimer();

    if (mounted) setState(() {});
  }

  void _updatePrayerProgressAndCountdown() {
    if (_prayerTimes == null) return;
    final now = DateTime.now();
    _currentPrayer = _prayerTimes!.currentPrayer();
    final nextPrayer = _prayerTimes!.nextPrayer();

    _currentPrayerName = _getPrayerNameInBengali(_currentPrayer);
    DateTime? startTime = _prayerTimes!.timeForPrayer(_currentPrayer);
    DateTime? endTime;

    switch (_currentPrayer) {
      case Prayer.fajr:
        endTime = _prayerTimes!.sunrise;
        break;
      case Prayer.sunrise:
        endTime = _prayerTimes!.dhuhr;
        break;
      case Prayer.dhuhr:
        endTime = _prayerTimes!.asr;
        break;
      case Prayer.asr:
        endTime = _prayerTimes!.maghrib;
        break;
      case Prayer.maghrib:
        endTime = _prayerTimes!.isha;
        break;
      case Prayer.isha:
        endTime = _tomorrowFajr;
        break;
      default:
        endTime = _prayerTimes!.fajr;
    }

    if (startTime != null && endTime != null && now.isAfter(startTime) && now.isBefore(endTime)) {
      final totalDuration = endTime.difference(startTime);
      final elapsed = now.difference(startTime);
      _prayerProgress = elapsed.inSeconds / totalDuration.inSeconds;
      _timeLeftToEnd = endTime.difference(now);
    } else {
      _prayerProgress = 0.0;
      _timeLeftToEnd = Duration.zero;
      if (nextPrayer != null) {
        _currentPrayer = nextPrayer;
        _currentPrayerName = 'পরবর্তী ${_getPrayerNameInBengali(nextPrayer)}';
      } else {
        _currentPrayerName = 'পরবর্তী ফজর';
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(_updatePrayerProgressAndCountdown);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    if (_prayerTimes == null || _tomorrowFajr == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final scale = (screenWidth / 400).clamp(0.8, 1.5);
        final isTablet = screenWidth > 600;

        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 16 * scale,
              vertical: 12 * scale,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const LocationBar(
                  country: 'বাংলাদেশ',
                  location: 'Garuria Union, Barisal',
                ),
                SizedBox(height: 12 * scale),
                Transform.scale(
                  scale: scale,
                  child: DateTimeBar(
                    gregorianDate: _gregorianDate,
                    hijriDate: _hijriDate,
                    sunriseTime: DateFormat.jm().format(_prayerTimes!.sunrise),
                    sunsetTime: DateFormat.jm()
                        .format(_prayerTimes!.maghrib.subtract(const Duration(minutes: 2))),
                  ),
                ),
                SizedBox(height: 16 * scale),
                Transform.scale(
                  scale: scale,
                  child: PrayerTimesCard(
                    prayerTimes: _prayerTimes!,
                    currentPrayer: _currentPrayer,
                    currentPrayerName: _currentPrayerName,
                    timeLeftToEnd: _formatDuration(_timeLeftToEnd),
                    prayerProgress: _prayerProgress,
                    tomorrowFajr: _tomorrowFajr!,
                  ),
                ),
                SizedBox(height: 20 * scale),
                _buildInfoCardsGrid(isTablet, screenWidth, scale),
                _buildSehriIftarRow(screenWidth, scale),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCardsGrid(bool isTablet, double screenWidth, double scale) {
    final crossAxisCount = isTablet ? 3 : 2;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8 * scale),
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12 * scale,
        mainAxisSpacing: 12 * scale,
        childAspectRatio: isTablet ? 2.2 : 1.7,
        children: const [
          InfoCard(
            title: 'সালাতের নিষিদ্ধ সময়',
            content: 'সূর্যোদয়, দ্বিপ্রহর এবং সূর্যাস্তের সময়',
            hasInfoIcon: true,
            isSimple: false,
          ),
          InfoCard(title: 'নফল সালাতের ওয়াক্ত', isSimple: true),
          InfoCard(title: 'বিশেষ দ্রষ্টব্য (FAQ)', isSimple: true),
        ],
      ),
    );
  }

  Widget _buildSehriIftarRow(double screenWidth, double scale) {
    String iftarTime = DateFormat.jm().format(_prayerTimes!.maghrib);
    String sehriTime =
        DateFormat.jm().format(_prayerTimes!.fajr.subtract(const Duration(minutes: 10)));

    return Padding(
      padding: EdgeInsets.only(bottom: 16 * scale),
      child: Row(
        children: [
          Expanded(child: InfoCard.sehriIftar(title: 'সাহরির শেষ', time: sehriTime)),
          SizedBox(width: 12 * scale),
          Expanded(child: InfoCard.sehriIftar(title: 'আজকের ইফতার', time: iftarTime)),
        ],
      ),
    );
  }

  String _getPrayerNameInBengali(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return 'ফজর';
      case Prayer.sunrise:
        return 'সূর্যোদয়';
      case Prayer.dhuhr:
        return 'যোহর';
      case Prayer.asr:
        return 'আসর';
      case Prayer.maghrib:
        return 'মাগরিব';
      case Prayer.isha:
        return 'ইশা';
      default:
        return '';
    }
  }
}
