import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_settings.dart';
import '../data/bangladesh_districts.dart'; // <-- জেলার তালিকা ইম্পোর্ট করুন

class LocationSettingsPage extends StatefulWidget {
  const LocationSettingsPage({super.key});

  @override
  State<LocationSettingsPage> createState() => _LocationSettingsPageState();
}

class _LocationSettingsPageState extends State<LocationSettingsPage> {
  String? _selectedDistrict;

  @override
  void initState() {
    super.initState();
    // বর্তমান সেভ করা জেলাটি ডিফল্ট হিসাবে দেখান
    _selectedDistrict =
        Provider.of<PrayerSettings>(context, listen: false).locationName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "লোকেশন সেটিংস",
          style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Text(
                  "সালাত ও সাহরি-ইফতারের সময় সঠিক ভাবে হিসাব করার জন্য আপনার লোকেশন সেট করুন।",
                  style: GoogleFonts.notoSansBengali(
                      fontSize: 15, color: Colors.grey[700]),
                ),
                const SizedBox(height: 20),
                // --- দেশ নির্বাচন ---
                _buildSectionHeader(context, "দেশ নির্বাচন করুন"),
                _buildDropdown(
                  value: "Bangladesh",
                  items: [
                    DropdownMenuItem(
                      value: "Bangladesh",
                      child: Text("Bangladesh",
                          style: GoogleFonts.notoSansBengali(fontSize: 16)),
                    )
                  ],
                  onChanged: (val) {}, // শুধু বাংলাদেশ ডিফল্ট
                ),
                const SizedBox(height: 20),
                // --- জেলা নির্বাচন ড্রপডাউন ---
                _buildSectionHeader(context, "জেলা নির্বাচন করুন"),
                _buildDropdown<String?>(
                  value: _selectedDistrict,
                  items: bangladeshDistricts.map((DistrictLocation district) {
                    return DropdownMenuItem<String>(
                      value: district.name,
                      child: Text(
                        district.name,
                        style: GoogleFonts.notoSansBengali(fontSize: 16),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedDistrict = newValue;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          // --- সেভ বাটন ---
          _buildSaveButton(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
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

  Widget _buildSaveButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () {
          if (_selectedDistrict != null) {
            Provider.of<PrayerSettings>(context, listen: false)
                .updateLocation(_selectedDistrict!);
            Navigator.pop(context);
          }
        },
        child: Text(
          "সেভ করুন",
          style: GoogleFonts.notoSansBengali(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
