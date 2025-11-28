import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:adhan/adhan.dart';
import '../providers/prayer_settings.dart';

class PrayerSettingsPage extends StatelessWidget {
  const PrayerSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Consumer to read and update settings
    return Consumer<PrayerSettings>(
      builder: (context, settings, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Prayer Settings",
              style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: Colors.black, // Back arrow and title color
            elevation: 1,
          ),
          backgroundColor: Colors.grey[50],
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // --- Calculation Method ---
              _buildSectionHeader(context, "Calculation Method"),
              _buildDropdown<CalculationMethod>(
                value: settings.calculationMethod,
                items: CalculationMethod.values.map((method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Text(
                      _getCalculationMethodName(method),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    settings.updateCalculationMethod(newValue);
                  }
                },
              ),

              // --- Madhab ---
              _buildSectionHeader(context, "Asr Juristic Method"),
              _buildDropdown<Madhab>(
                value: settings.madhab,
                items: [
                  const DropdownMenuItem(
                    value: Madhab.hanafi,
                    child: Text("Hanafi (Later Asr)"),
                  ),
                  const DropdownMenuItem(
                    value: Madhab.shafi,
                    child: Text("Standard (Shafi, Maliki, Hanbali)"),
                  ),
                ],
                onChanged: (newValue) {
                  if (newValue != null) {
                    settings.updateMadhab(newValue);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper to build section headers
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.notoSansBengali(
          color: Colors.teal,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  // Generic Dropdown builder
  Widget _buildDropdown<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          style: GoogleFonts.notoSansBengali(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  // Helper to get readable names for calculation methods
  String _getCalculationMethodName(CalculationMethod method) {
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
      case CalculationMethod.other:
        return "Other";
      default:
        return method.name;
    }
  }
}