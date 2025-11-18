import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:shared_preferences/shared_preferences.dart';

class PrayerSettings extends ChangeNotifier {
  late SharedPreferences _prefs;

  // --- ডিফল্ট মান ---
  Coordinates _coordinates = Coordinates(23.8103, 90.4125); // ডিফল্ট: ঢাকা
  String _locationName = "ঢাকা, বাংলাদেশ";
  CalculationMethod _calculationMethod = CalculationMethod.karachi;
  Madhab _madhab = Madhab.hanafi;
  bool _isLoading = true; // অ্যাপ চালু হলে প্রথমে লোড হবে

  // --- পাবলিক গেটার ---
  Coordinates get coordinates => _coordinates;
  String get locationName => _locationName;
  CalculationMethod get calculationMethod => _calculationMethod;
  Madhab get madhab => _madhab;
  bool get isLoading => _isLoading;

  // ক্যালকুলেশন প্যারামিটার গেটার
  CalculationParameters get calculationParams {
    final params = _calculationMethod.getParameters();
    params.madhab = _madhab;
    return params;
  }

  PrayerSettings() {
    _loadSettings();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // --- পাবলিক মেথড ---

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

  // !! জিপিএস দিয়ে লোকেশন পাওয়ার ফাংশন
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

      // লোকেশনের নাম বের করা
      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        position.latitude, 
        position.longitude,
        // acceptLanguage: "bn_BD" // বাংলায় নাম পাওয়ার চেষ্টা
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