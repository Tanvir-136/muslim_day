import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/bangladesh_districts.dart';

class PrayerSettings extends ChangeNotifier {
  late SharedPreferences _prefs;

  // --- ডিফল্ট মান ---
  Coordinates _coordinates = bangladeshDistricts[0].coordinates; // Dhaka's Coords
  String _locationName = bangladeshDistricts[0].name; // "ঢাকা"
  CalculationMethod _calculationMethod = CalculationMethod.karachi;
  Madhab _madhab = Madhab.hanafi;

  // --- !! নতুন লোডিং স্টেট !! ---
  bool _isLoading = true; // Start as true
  bool get isLoading => _isLoading;
  // --- !! শেষ !! ---

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
    _isLoading = true;
    notifyListeners(); // Show loader
    
    _calculationMethod = method;
    await _prefs.setString('calculationMethod', method.name);
    
    _isLoading = false;
    notifyListeners(); // Hide loader and update UI
  }

  Future<void> updateMadhab(Madhab madhab) async {
    _isLoading = true;
    notifyListeners(); // Show loader

    _madhab = madhab;
    await _prefs.setString('madhab', madhab.name);

    _isLoading = false;
    notifyListeners(); // Hide loader and update UI
  }

  // !! নতুন মেথড: জেলা অনুযায়ী লোকেশন আপডেট করার জন্য
  Future<void> updateLocation(String newLocationName) async {
    _isLoading = true;
    notifyListeners(); // Show loader

    try {
      // Find the location data from the static list.
      final newLocationData = bangladeshDistricts.firstWhere(
        (district) => district.name == newLocationName,
        // If not found, default to the first item in the list (Dhaka).
        orElse: () => bangladeshDistricts[0],
      );

      // Update the state with the new location's data.
      _locationName = newLocationData.name;
      _coordinates = newLocationData.coordinates;

      // Persist the new location name for the next app launch.
      await _prefs.setString('locationName', _locationName);
    } catch (e) {
      // Log any potential errors during the process.
      debugPrint("Error updating location: $e");
    } finally {
      // Ensure loader is hidden even if there's an error
      _isLoading = false;
      notifyListeners(); // Hide loader and update UI
    }
  }

  // --- সেভ ও লোড ---
  Future<void> _loadSettings() async {
    // We are already in a loading state (_isLoading = true by default)
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

    // --- !! লোডিং শেষ !! ---
    _isLoading = false;
    notifyListeners(); // Notify UI that loading is complete
  }
}