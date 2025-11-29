import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:shared_preferences/shared_preferences.dart';

// Prayer time types including nafil and prohibited times
enum PrayerTimeType {
  fajr,
  sunrise,
  dhuhr,
  asr,
  maghrib,
  isha,
  tahajjud,
  ishrak,
  duha,
  prohibitedAfterFajr,
  prohibitedBeforeDhuhr,
  prohibitedAfterAsr,
}

class ExtendedPrayerTime {
  final String name;
  final String nameBn;
  final DateTime time;
  final PrayerTimeType type;
  final bool isProhibited;
  final bool isNafil;

  ExtendedPrayerTime({
    required this.name,
    required this.nameBn,
    required this.time,
    required this.type,
    this.isProhibited = false,
    this.isNafil = false,
  });
}

class PrayerSettings extends ChangeNotifier {
  late SharedPreferences _prefs;

  Coordinates _coordinates = Coordinates(23.8103, 90.4125); 
  String _locationName = "ঢাকা, বাংলাদেশ";
  CalculationMethod _calculationMethod = CalculationMethod.karachi;
  Madhab _madhab = Madhab.hanafi;
  bool _isLoading = true; 

  Coordinates get coordinates => _coordinates;
  String get locationName => _locationName;
  CalculationMethod get calculationMethod => _calculationMethod;
  Madhab get madhab => _madhab;
  bool get isLoading => _isLoading;

  CalculationParameters get calculationParams {
    final params = _calculationMethod.getParameters();
    params.madhab = _madhab;
    return params;
  }

  String getCalculationMethodName(CalculationMethod method) {
    switch (method) {
      case CalculationMethod.muslim_world_league:
        return "Muslim World League";
      case CalculationMethod.egyptian:
        return "Egyptian General Authority";
      case CalculationMethod.karachi:
        return "University of Islamic Sciences, Karachi";
      case CalculationMethod.umm_al_qura:
        return "Umm al-Qura University, Makkah";
      case CalculationMethod.dubai:
        return "Dubai (UAE)";
      case CalculationMethod.qatar:
        return "Qatar";
      case CalculationMethod.kuwait:
        return "Kuwait";
      case CalculationMethod.singapore:
        return "Singapore";
      case CalculationMethod.north_america:
        return "ISNA (North America)";
      case CalculationMethod.moon_sighting_committee:
        return "Moonsighting Committee";
      case CalculationMethod.tehran:
        return "Tehran";
      default:
        return method.name;
    }
  }

  // Get all extended prayer times including nafil and prohibited times
  List<ExtendedPrayerTime> getExtendedPrayerTimes(DateTime date) {
    final prayerTimes = PrayerTimes.today(_coordinates, calculationParams);
    final List<ExtendedPrayerTime> times = [];
    // Order the timeline from Fajr -> ... -> Isha, then add Tahajjud after Isha.
    // Fajr
    times.add(ExtendedPrayerTime(
      name: 'Fajr',
      nameBn: 'ফজর',
      time: prayerTimes.fajr,
      type: PrayerTimeType.fajr,
    ));

    // Prohibited time after Fajr (from sunrise until Ishrak)
    times.add(ExtendedPrayerTime(
      name: 'Prohibited (After Fajr)',
      nameBn: 'নিষিদ্ধ সময় (ফজরের পর)',
      time: prayerTimes.sunrise,
      type: PrayerTimeType.prohibitedAfterFajr,
      isProhibited: true,
    ));

    // Sunrise
    times.add(ExtendedPrayerTime(
      name: 'Sunrise',
      nameBn: 'সূর্যোদয়',
      time: prayerTimes.sunrise,
      type: PrayerTimeType.sunrise,
    ));

    // Ishrak (15-20 mins after sunrise)
    final ishrakTime = prayerTimes.sunrise.add(const Duration(minutes: 20));
    times.add(ExtendedPrayerTime(
      name: 'Ishrak',
      nameBn: 'ইশরাক',
      time: ishrakTime,
      type: PrayerTimeType.ishrak,
      isNafil: true,
    ));

    // Duha (Mid-morning)
    final duhaTime = prayerTimes.sunrise.add(
      Duration(
        minutes: (prayerTimes.dhuhr.difference(prayerTimes.sunrise).inMinutes * 0.4).round(),
      ),
    );
    times.add(ExtendedPrayerTime(
      name: 'Duha',
      nameBn: 'চাশত',
      time: duhaTime,
      type: PrayerTimeType.duha,
      isNafil: true,
    ));

    // Prohibited before Dhuhr (10-15 mins before)
    times.add(ExtendedPrayerTime(
      name: 'Prohibited (Before Dhuhr)',
      nameBn: 'নিষিদ্ধ সময় (জোহরের আগে)',
      time: prayerTimes.dhuhr.subtract(const Duration(minutes: 10)),
      type: PrayerTimeType.prohibitedBeforeDhuhr,
      isProhibited: true,
    ));

    // Dhuhr
    times.add(ExtendedPrayerTime(
      name: 'Dhuhr',
      nameBn: 'যোহর',
      time: prayerTimes.dhuhr,
      type: PrayerTimeType.dhuhr,
    ));

    // Asr
    times.add(ExtendedPrayerTime(
      name: 'Asr',
      nameBn: 'আসর',
      time: prayerTimes.asr,
      type: PrayerTimeType.asr,
    ));

    // Prohibited after Asr (until Maghrib)
    times.add(ExtendedPrayerTime(
      name: 'Prohibited (After Asr)',
      nameBn: 'নিষিদ্ধ সময় (আসরের পর)',
      time: prayerTimes.asr,
      type: PrayerTimeType.prohibitedAfterAsr,
      isProhibited: true,
    ));

    // Maghrib
    times.add(ExtendedPrayerTime(
      name: 'Maghrib',
      nameBn: 'মাগরিব',
      time: prayerTimes.maghrib,
      type: PrayerTimeType.maghrib,
    ));

    // Isha
    times.add(ExtendedPrayerTime(
      name: 'Isha',
      nameBn: 'ইশা',
      time: prayerTimes.isha,
      type: PrayerTimeType.isha,
    ));

    // Tahajjud (Last third of night begins after Isha)
    // Compute start of last third of night as: Isha + 2/3 of the night length (Isha->Fajr)
    final nightDurationMinutes = prayerTimes.fajr.difference(prayerTimes.isha).inMinutes;
    final tahajjudStart = prayerTimes.isha.add(
      Duration(minutes: ((nightDurationMinutes * 2) / 3).round()),
    );
    times.add(ExtendedPrayerTime(
      name: 'Tahajjud',
      nameBn: 'তাহাজ্জুদ',
      time: tahajjudStart,
      type: PrayerTimeType.tahajjud,
      isNafil: true,
    ));

    return times;
  }

  // Get only the 5 fard prayers
  List<ExtendedPrayerTime> getFivePrayers(DateTime date) {
    final allTimes = getExtendedPrayerTimes(date);
    return allTimes.where((time) => 
      !time.isNafil && !time.isProhibited && time.type != PrayerTimeType.sunrise
    ).toList();
  }

  PrayerSettings() {
    _loadSettings();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }


  Future<void> updateCalculationMethod(CalculationMethod method) async {
    _calculationMethod = method;
    await _prefs.setString('calculationMethod', method.name);
    notifyListeners();
  }

  Future<void> updateMadhab(Madhab madhab) async {
    _madhab = madhab;
    await _prefs.setString('madhab', madhab.name);
    notifyListeners();
  }

  Future<void> updateManualLocation(double latitude, double longitude, String locationName) async {
    _coordinates = Coordinates(latitude, longitude);
    _locationName = locationName;

    await _prefs.setDouble('latitude', latitude);
    await _prefs.setDouble('longitude', longitude);
    await _prefs.setString('locationName', locationName);
    
    notifyListeners();
  }

  Future<void> detectCurrentLocation() async {
    _setLoading(true);
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('লোকেশন সার্ভিস বন্ধ।');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('লোকেশন পারমিশন দেওয়া হয়নি।');
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw Exception('লোকেশন পারমিশন স্থায়ীভাবে বন্ধ করা আছে।');
      } 

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium
      );

      _coordinates = Coordinates(position.latitude, position.longitude);

      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        position.latitude, 
        position.longitude,
        // acceptLanguage: "bn_BD" 
      );
      
      if (placemarks.isNotEmpty) {
        geo.Placemark place = placemarks[0];
        _locationName = "${place.locality ?? place.subAdministrativeArea}, ${place.country ?? ''}";
      } else {
        _locationName = "বর্তমান লোকেশন";
      }

      // নতুন লোকেশন সেভ করুন
      await _prefs.setDouble('latitude', _coordinates.latitude);
      await _prefs.setDouble('longitude', _coordinates.longitude);
      await _prefs.setString('locationName', _locationName);

    } catch (e) {
      debugPrint("Error detecting location: $e");
      // এখানে একটি এরর মেসেজ দেখানো যেতে পারে
    }
    _setLoading(false);
  }

  // --- সেভ ও লোড ---

  Future<void> _loadSettings() async {
    _setLoading(true); // লোডিং শুরু
    _prefs = await SharedPreferences.getInstance();
    
    // স্থানাঙ্ক লোড করুন
    double latitude = _prefs.getDouble('latitude') ?? _coordinates.latitude;
    double longitude = _prefs.getDouble('longitude') ?? _coordinates.longitude;
    _coordinates = Coordinates(latitude, longitude);
    _locationName = _prefs.getString('locationName') ?? _locationName;

    // ক্যালকুলেশন মেথড লোড
    String methodName = _prefs.getString('calculationMethod') ?? _calculationMethod.name;
    _calculationMethod = CalculationMethod.values.firstWhere(
      (m) => m.name == methodName,
      orElse: () => CalculationMethod.karachi
    );

    // মাযহাব লোড
    String madhabName = _prefs.getString('madhab') ?? _madhab.name;
    _madhab = Madhab.values.firstWhere(
      (m) => m.name == madhabName,
      orElse: () => Madhab.hanafi
    );
    _setLoading(false); // লোডিং শেষ
  }
}