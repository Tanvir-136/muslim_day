import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:adhan/adhan.dart';
import 'package:hijri/hijri_calendar.dart';
import 'dart:async';

// Import your custom widgets
import '../widgets/location_bar.dart';
import '../widgets/date_time_bar.dart';
import '../widgets/prayer_times_card.dart';
import '../widgets/info_card.dart';

// This widget contains the entire UI and logic for your main prayer times screen
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
    final date = DateComponents.from(DateTime.now());

    _prayerTimes = PrayerTimes(myCoordinates, date, params);

    final tomorrowDate =
        DateComponents.from(DateTime.now().add(const Duration(days: 1)));
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
    _currentPrayerName = _getPrayerNameInBengali(_currentPrayer);

    DateTime? startTime = _prayerTimes!.timeForPrayer(_currentPrayer);
    // FIXED: Passed the current prayer to correctly find the next one
    DateTime? endTime = _prayerTimes!.timeForPrayer(_prayerTimes!.nextPrayer());

    if (_currentPrayer == Prayer.isha) {
      endTime = _tomorrowFajr;
    }

    if (startTime != null &&
        endTime != null &&
        now.isAfter(startTime) &&
        now.isBefore(endTime)) {
      final totalDuration = endTime.difference(startTime);
      final elapsedDuration = now.difference(startTime);

      _prayerProgress = elapsedDuration.inSeconds / totalDuration.inSeconds;
      _timeLeftToEnd = endTime.difference(now);
    } else {
      _prayerProgress = 0.0;
      _timeLeftToEnd = Duration.zero;
      _currentPrayerName = 'পরবর্তী';
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _updatePrayerProgressAndCountdown();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    if (_prayerTimes == null || _tomorrowFajr == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const LocationBar(
              country: ' ',
              location: 'Garuria Union, Barisal',
            ),
            DateTimeBar(
              gregorianDate: _gregorianDate,
              hijriDate: _hijriDate,
              sunriseTime: DateFormat.jm().format(_prayerTimes!.sunrise),
              sunsetTime: DateFormat.jm().format(
                  _prayerTimes!.maghrib.subtract(const Duration(minutes: 2))),
            ),
            PrayerTimesCard(
              prayerTimes: _prayerTimes!,
              currentPrayer: _currentPrayer,
              currentPrayerName: _currentPrayerName,
              timeLeftToEnd: _formatDuration(_timeLeftToEnd),
              prayerProgress: _prayerProgress,
              tomorrowFajr: _tomorrowFajr!,
            ),
            _buildInfoCardsGrid(),
            _buildSehriIftarRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCardsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate each item's width to fit two columns with spacing
          const double spacing = 12.0;
          final double itemWidth = (constraints.maxWidth - spacing) / 2;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              SizedBox(
                width: itemWidth,
                child: const InfoCard(
                  title: 'সালাতের নিষিদ্ধ সময়',
                  content: 'সূর্যোদয়, দ্বিপ্রহর এবং সূর্যাস্তের সময়',
                  hasInfoIcon: true,
                  isSimple: false,
                ),
              ),
              SizedBox(
                width: itemWidth,
                child: const InfoCard(
                    title: 'নফল সালাতের ওয়াক্ত', isSimple: true),
              ),
              SizedBox(
                width: itemWidth,
                child: const InfoCard(title: 'বিশেষ দ্রষ্টব্য (FAQ)', isSimple: true),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSehriIftarRow() {
    String iftarTime = DateFormat.jm().format(_prayerTimes!.maghrib);
    String sehriTime = DateFormat.jm()
        .format(_prayerTimes!.fajr.subtract(const Duration(minutes: 10)));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(
              child: InfoCard.sehriIftar(title: 'সাহরির শেষ সময়:', time: sehriTime)),
          const SizedBox(width: 12),
          Expanded(
              child:
                  InfoCard.sehriIftar(title: 'আজকের ইফতার:', time: iftarTime)),
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
        return 'পরবর্তী';
    }
  }
}