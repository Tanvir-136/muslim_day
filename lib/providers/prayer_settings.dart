import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/bangladesh_districts.dart'; // <-- ১. নতুন ডেটা ফাইল ইম্পোর্ট করুন

class PrayerSettings extends ChangeNotifier {
  late SharedPreferences _prefs;

  // --- ডিফল্ট মান ---
  Coordinates _coordinates = bangladeshDistricts[0].coordinates; // Dhaka's Coords
  String _locationName = bangladeshDistricts[0].name; // "ঢাকা"
  CalculationMethod _calculationMethod = CalculationMethod.karachi;
  Madhab _madhab = Madhab.hanafi;

  // --- পাবলিক গেটার ---
  Coordinates get coordinates => _coordinates;
  String get locationName => _locationName;
  CalculationMethod get calculationMethod => _calculationMethod;
  Madhab get madhab => _madhab;

  // ক্যালকুলেশন প্যারামিটার গেটার (অপরিবর্তিত)
  CalculationParameters get calculationParams {
    final params = _calculationMethod.getParameters();
    params.madhab = _madhab;
    return params;
  }

  PrayerSettings() {
    _loadSettings();
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

  // !! নতুন মেথড: জেলা অনুযায়ী লোকেশন আপডেট করার জন্য
  Future<void> updateLocation(String newLocationName) async {
    try {
      final newLocationData = bangladeshDistricts.firstWhere(
        (d) => d.name == newLocationName,
        orElse: () => bangladeshDistricts[0] // না পেলে ডিফল্ট (Dhaka)
      );

      _locationName = newLocationData.name;
      _coordinates = newLocationData.coordinates;

      await _prefs.setString('locationName', _locationName);
      
      notifyListeners(); // home_content.dart কে আপডেট করার জন্য
    } catch (e) {
      print("Error updating location: $e");
    }
  }

  // !! জিপিএস ফাংশন (detectCurrentLocation) সম্পূর্ণ সরিয়ে ফেলা হয়েছে

  // --- সেভ ও লোড ---
  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    
    _locationName = _prefs.getString('locationName') ?? bangladeshDistricts[0].name;
    _coordinates = bangladeshDistricts.firstWhere(
      (d) => d.name == _locationName,
      orElse: () => bangladeshDistricts[0]
    ).coordinates;

    String methodName = _prefs.getString('calculationMethod') ?? _calculationMethod.name;
    _calculationMethod = CalculationMethod.values.firstWhere(
      (m) => m.name == methodName,
      orElse: () => CalculationMethod.karachi
    );

    String madhabName = _prefs.getString('madhab') ?? _madhab.name;
    _madhab = Madhab.values.firstWhere(
      (m) => m.name == madhabName,
      orElse: () => Madhab.hanafi
    );

    notifyListeners();
  }
}