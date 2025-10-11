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
import '../widgets/bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  PrayerTimes? _prayerTimes;
  String _hijriDate = '';
  String _gregorianDate = '';
  Timer? _timer;
  Duration _timeLeft = Duration.zero;
  String _nextPrayerName = '';
  Prayer _currentPrayer = Prayer.none;

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

    final bengaliLocale = 'bn_BD';
    var gregorianFormatter = DateFormat('EEEE, d MMMM', bengaliLocale);
    _gregorianDate = gregorianFormatter.format(DateTime.now());
    _hijriDate = HijriCalendar.now().toFormat("d MMMM, yyyy");

    _currentPrayer = _prayerTimes!.currentPrayer();
    Prayer nextPrayer = _prayerTimes!.nextPrayer();
    _nextPrayerName = _getPrayerNameInBengali(nextPrayer);
    DateTime? nextPrayerTime = _prayerTimes!.timeForPrayer(nextPrayer);

    if (nextPrayerTime != null) {
      _timeLeft = nextPrayerTime.difference(DateTime.now());
      _startTimer();
    }

    if (mounted) setState(() {});
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft.inSeconds > 0) {
            _timeLeft = _timeLeft - const Duration(seconds: 1);
          } else {
            timer.cancel();
            _updateAllData();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
    if (_prayerTimes == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const LocationBar(
                country:'',
                location: 'Garuria Union, Barisal',
              ),
              DateTimeBar(
                gregorianDate: _gregorianDate,
                hijriDate: _hijriDate,
                sunriseTime: DateFormat.jm().format(_prayerTimes!.sunrise),
                sunsetTime: DateFormat.jm().format(_prayerTimes!.maghrib.subtract(const Duration(minutes: 2))),
              ),
              PrayerTimesCard(
                prayerTimes: _prayerTimes!,
                currentPrayer: _currentPrayer,
                nextPrayerName: _nextPrayerName,
                timeLeft: _formatDuration(_timeLeft),
              ),
              _buildInfoCardsGrid(),
              _buildSehriIftarRow(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildInfoCardsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
        children: const [
          InfoCard(
            title: 'সালাতের নিষিদ্ধ সময়',
            content: 'সূর্যোদয়, দ্বিপ্রহর এবং সূর্যাস্তের সময়',
            hasInfoIcon: true,
            isSimple: false, // Set to false to show content
          ),
          InfoCard(
            title: 'নফল সালাতের ওয়াক্ত',
            isSimple: true,
          ),
          InfoCard(
            title: 'বিশেষ দ্রষ্টব্য (FAQ)',
            isSimple: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSehriIftarRow() {
    String iftarTime = DateFormat.jm().format(_prayerTimes!.maghrib);
    String sehriTime = DateFormat.jm().format(_prayerTimes!.fajr.subtract(const Duration(minutes: 10)));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: InfoCard.sehriIftar(
              title: 'সাহরির শেষ',
              time: sehriTime,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InfoCard.sehriIftar(
              title: 'আজকের ইফতার',
              time: iftarTime,
            ),
          ),
        ],
      ),
    );
  }

  String _getPrayerNameInBengali(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr: return 'ফজর';
      case Prayer.sunrise: return 'সূর্যোদয়';
      case Prayer.dhuhr: return 'যোহর';
      case Prayer.asr: return 'আসর';
      case Prayer.maghrib: return 'মাগরিব';
      case Prayer.isha: return 'ইশা';
      default: return 'পরবর্তী';
    }
  }
}