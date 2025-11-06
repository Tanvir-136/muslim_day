import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/bangladesh_districts.dart';
import '../providers/prayer_settings.dart';

class LocationListPage extends StatelessWidget {
  const LocationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    // Get the provider reference
    final settingsProvider = Provider.of<PrayerSettings>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Your District"),
      ),
      body: ListView.builder(
        itemCount: bangladeshDistricts.length,
        itemBuilder: (context, index) {
          final district = bangladeshDistricts[index];
          
          return ListTile(
            title: Text(district.name),
            onTap: () {
              // 1. Call the new method on your provider
                context.read<PrayerSettings>().updateLocation(district as String);
              
              // 2. Go back to the previous screen
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}