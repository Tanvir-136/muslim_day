import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:adhan/adhan.dart';
import 'package:hijri/hijri_calendar.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../providers/prayer_settings.dart';

// Import your custom widgets
import '../widgets/location_bar.dart';
import '../widgets/date_time_bar.dart';
import '../widgets/prayer_times_card.dart';
import '../widgets/info_card.dart';

// এই উইজেটটি আপনার প্রধান সালাতের সময় স্ক্রিনের UI এবং লজিক ধারণ করে
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

  // !! নতুন ভেরিয়েবল: নিষিদ্ধ সময় ট্র্যাক করার জন্য
  bool _isProhibitedTime = false;

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // এই লজিকটি নিশ্চিত করে যে প্রোভাইডার লোড হওয়ার পর কোডটি রান করে
    if (!_isInitialized) {
      final prayerSettings =
          Provider.of<PrayerSettings>(context, listen: false);

      // প্রোভাইডার লোড হওয়ার জন্য অপেক্ষা করুন
      if (prayerSettings.isLoading) {
        // যদি এখনও লোড হয়, তবে অপেক্ষা করুন
        // প্রোভাইডার লোড শেষ হলে _onSettingsChanged() কল করবে
      } else {
        // লোড হয়ে গেলে, ডেটা আপডেট করুন
        _updateAllData(prayerSettings);
      }

      prayerSettings.addListener(_onSettingsChanged);
      _startTimer();
      _isInitialized = true;
    }
  }

  void _onSettingsChanged() {
    // listen: false দিয়ে প্রোভাইডার পান
    final prayerSettings = Provider.of<PrayerSettings>(context, listen: false);
    // নতুন সেটিংস দিয়ে সালাতের সময় পুনঃগণনা করুন
    _updateAllData(prayerSettings);
  }

  void _updateAllData(PrayerSettings settings) {
    // যদি সেটিংস লোড না হয়, তবে কিছু করবেন না
    if (settings.isLoading) return;

    try {
      final now = DateTime.now();
      final date = DateComponents.from(now);
      _prayerTimes =
          PrayerTimes(settings.coordinates, date, settings.calculationParams);

      final tomorrowDate =
          DateComponents.from(now.add(const Duration(days: 1)));
      _tomorrowFajr = PrayerTimes(
              settings.coordinates, tomorrowDate, settings.calculationParams)
          .fajr;

      _hijriDate = HijriCalendar.now().toFormat("d MMMM, yyyy");
      _gregorianDate = DateFormat('d MMMM, EEEE', 'bn_BD').format(now);

      _updatePrayerProgressAndCountdown();

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print("Error in _updateAllData: $e");
    }
  }

  // !! নতুন মেথড: নিষিদ্ধ সময় চেক করার জন্য
  bool _checkIfProhibited(DateTime now) {
    if (_prayerTimes == null) return false;
    final sunriseStart = _prayerTimes!.sunrise;
    final sunriseEnd = sunriseStart.add(const Duration(minutes: 15));
    if (now.isAfter(sunriseStart) && now.isBefore(sunriseEnd)) return true;
    final zawalStart =
        _prayerTimes!.dhuhr.subtract(const Duration(minutes: 10));
    final zawalEnd = _prayerTimes!.dhuhr;
    if (now.isAfter(zawalStart) && now.isBefore(zawalEnd)) return true;
    final sunsetStart =
        _prayerTimes!.maghrib.subtract(const Duration(minutes: 10));
    final sunsetEnd = _prayerTimes!.maghrib;
    if (now.isAfter(sunsetStart) && now.isBefore(sunsetEnd)) return true;
    return false;
  }

  // !! adhan প্যাকেজের ত্রুটি সমাধান করে আপডেটেড লজিক
  void _updatePrayerProgressAndCountdown() {
    if (_prayerTimes == null || _tomorrowFajr == null) return;

    final now = DateTime.now();

    // !! আপডেট: প্রথমে নিষিদ্ধ সময় চেক করুন
    _isProhibitedTime = _checkIfProhibited(now);

    // !! প্রথম ত্রুটি সমাধান: () এর ভেতরযোগ করা হয়েছে
    _currentPrayer = _prayerTimes!.currentPrayer();

    DateTime startTime;
    DateTime endTime;

    if (_currentPrayer == Prayer.none) {
      _currentPrayerName = 'পরবর্তী';
      if (now.isAfter(_prayerTimes!.isha)) {
        startTime = _prayerTimes!.isha;
        endTime = _tomorrowFajr!;
      } else {
        final prayerSettings =
            Provider.of<PrayerSettings>(context, listen: false);
        final yesterday = now.subtract(const Duration(days: 1));
        final yesterdayDate = DateComponents.from(yesterday);
        final yesterdayPrayerTimes = PrayerTimes(prayerSettings.coordinates,
            yesterdayDate, prayerSettings.calculationParams);
        startTime = yesterdayPrayerTimes.isha;
        endTime = _prayerTimes!.fajr;
      }
    } else if (_currentPrayer == Prayer.sunrise) {
      _currentPrayerName = 'সূর্যোদয়';
      startTime = _prayerTimes!.sunrise;
      endTime = _prayerTimes!.dhuhr;
    } else {
      _currentPrayerName = _getPrayerNameInBengali(_currentPrayer);
      startTime = _prayerTimes!.timeForPrayer(_currentPrayer)!;

      // !! দ্বিতীয় ত্রুটি সমাধান: () কে (prayer: _currentPrayer) করা হয়েছে
      final nextPrayer = _prayerTimes!.nextPrayer();

      if (nextPrayer == Prayer.none) {
        endTime = _tomorrowFajr!;
      } else {
        endTime = _prayerTimes!.timeForPrayer(nextPrayer)!;
      }
    }

    // !! আপডেট: নিষিদ্ধ সময় হলে প্রগ্রেস বার রিসেট করুন
    if (_isProhibitedTime) {
      _currentPrayerName = 'নিষিদ্ধ সময়';
      _prayerProgress = 0.0;
      _timeLeftToEnd = Duration.zero;
    } else if (now.isAfter(startTime) && now.isBefore(endTime)) {
      final totalDuration = endTime.difference(startTime);
      final elapsedDuration = now.difference(startTime);

      _prayerProgress = elapsedDuration.inSeconds / totalDuration.inSeconds;
      _timeLeftToEnd = endTime.difference(now);
    } else {
      _prayerProgress = 0.0;
      _timeLeftToEnd = Duration.zero;
      if (_currentPrayer != Prayer.none && _currentPrayer != Prayer.sunrise) {
        _currentPrayerName = 'পরবর্তী';
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (_prayerTimes == null) return;

        if (DateTime.now().day != DateComponents.from(_prayerTimes!.fajr).day) {
          _updateAllData(Provider.of<PrayerSettings>(context, listen: false));
        } else {
          setState(() {
            _updatePrayerProgressAndCountdown();
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    Provider.of<PrayerSettings>(context, listen: false)
        .removeListener(_onSettingsChanged);
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  String _formatTime(DateTime time) {
    return DateFormat.jm('bn_BD').format(time);
  }

  // !! জিপিএস বাটন প্রেস হ্যান্ডেল করার জন্য
  void _handleLocationPress() {
    // প্রোভাইডারকে লোকেশন ডিটেক্ট করতে বলুন
    Provider.of<PrayerSettings>(context, listen: false).detectCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    // Consumer ব্যবহার করে PrayerSettings থেকে ডেটা নিন
    return Consumer<PrayerSettings>(
      builder: (context, settings, child) {
        // জিপিএস লোডিং চেক
        if (settings.isLoading ||
            _prayerTimes == null ||
            _tomorrowFajr == null) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.teal));
        }

        // --- সময় গণনা (নফল ও নিষিদ্ধ সময়ের জন্য) ---

        final ishrakStartTime =
            _prayerTimes!.sunrise.add(const Duration(minutes: 15));
        final maghribTime = _prayerTimes!.maghrib;
        final fajrTimeTomorrow = _tomorrowFajr!;
        final nightDuration = fajrTimeTomorrow.difference(maghribTime);
        final lastThirdOfNightStart = fajrTimeTomorrow
            .subtract(Duration(seconds: (nightDuration.inSeconds / 3).round()));
        final zawalStart =
            _prayerTimes!.dhuhr.subtract(const Duration(minutes: 10));
        final sunriseStart = _prayerTimes!.sunrise;
        final sunriseEnd = sunriseStart.add(const Duration(minutes: 15));
        final sunsetStart =
            _prayerTimes!.maghrib.subtract(const Duration(minutes: 10));
        final sunsetEnd = _prayerTimes!.maghrib;

        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // LocationBar জিপিএস বাটন সহ
                LocationBar(
                  country: ' ',
                  location: settings.locationName,
                  isLoading: settings.isLoading,
                  onLocationPressed:
                      _handleLocationPress,
                ),
                DateTimeBar(
                  gregorianDate: _gregorianDate,
                  hijriDate: _hijriDate,
                  sunriseTime: _formatTime(_prayerTimes!.sunrise),
                  sunsetTime: _formatTime(_prayerTimes!.maghrib
                      .subtract(const Duration(minutes: 2))),
                ),
                PrayerTimesCard(
                  prayerTimes: _prayerTimes!,
                  currentPrayer: _currentPrayer,
                  currentPrayerName: _currentPrayerName,
                  timeLeftToEnd: _formatDuration(_timeLeftToEnd),
                  prayerProgress: _prayerProgress,
                  tomorrowFajr: _tomorrowFajr!,
                  isProhibitedTime: _isProhibitedTime,
                ),
                _buildInfoCardsGrid(
                  ishrakTime: _formatTime(ishrakStartTime),
                  tahajjudTime: _formatTime(lastThirdOfNightStart),
                  sunriseRange:
                      '${_formatTime(sunriseStart)} - ${_formatTime(sunriseEnd)}',
                  zawalRange:
                      '${_formatTime(zawalStart)} - ${_formatTime(_prayerTimes!.dhuhr)}',
                  sunsetRange:
                      '${_formatTime(sunsetStart)} - ${_formatTime(sunsetEnd)}',
                ),
                _buildSehriIftarRow(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCardsGrid({
    required String ishrakTime,
    required String tahajjudTime,
    required String sunriseRange,
    required String zawalRange,
    required String sunsetRange,
  }) {
    final prohibitedTimesContent =
        'সূর্যোদয়: $sunriseRange\nযাওয়াল: $zawalRange\nসূর্যাস্ত: $sunsetRange';
    final naflTimesContent = 'ইশরাক: $ishrakTime\nতাহাজ্জুদ: $tahajjudTime';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double spacing = 12.0;
          final double itemWidth = (constraints.maxWidth - spacing) / 2;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              SizedBox(
                width: itemWidth,
                child: InfoCard(
                  title: 'সালাতের নিষিদ্ধ সময়',
                  content: prohibitedTimesContent,
                  hasInfoIcon: true,
                  isSimple: false,
                ),
              ),
              SizedBox(
                width: itemWidth,
                child: InfoCard(
                    title: 'নফল সালাতের ওয়াক্ত',
                    content: naflTimesContent,
                    isSimple: false),
              ),
              SizedBox(
                width: itemWidth,
                child: const InfoCard(
                    title: 'বিশেষ দ্রষ্টব্য (FAQ)', isSimple: true),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSehriIftarRow() {
    String iftarTime = _formatTime(_prayerTimes!.maghrib);
    String sehriTime =
        _formatTime(_prayerTimes!.fajr.subtract(const Duration(minutes: 10)));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(
              child: InfoCard.sehriIftar(
                  title: 'সাহরির শেষ সময়:', time: sehriTime)),
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