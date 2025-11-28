import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/prayer_settings.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final prayerSettings = Provider.of<PrayerSettings>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'সেটিংস',
          style: GoogleFonts.notoSansBengali(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          // Theme Section
          _buildSectionHeader('থিম'),
          _buildThemeSelector(themeProvider),
          
          const Divider(height: 32),
          
          // Prayer Settings Section
          _buildSectionHeader('নামাজের সেটিংস'),
          _buildCalculationMethodTile(context, prayerSettings),
          _buildLocationTile(context, prayerSettings),
          
          const Divider(height: 32),
          
          // Notification Section
          _buildSectionHeader('নোটিফিকেশন'),
          _buildSwitchTile(
            'নামাজের সময় নোটিফিকেশন',
            'নামাজের সময় হলে আপনাকে জানানো হবে',
            Icons.notifications_active,
            true,
            (value) {
              // TODO: Implement notification toggle
            },
          ),
          _buildSwitchTile(
            'আজান সাউন্ড',
            'নোটিফিকেশনের সাথে আজান শোনান',
            Icons.volume_up,
            false,
            (value) {
              // TODO: Implement adhan sound toggle
            },
          ),
          
          const Divider(height: 32),
          
          // Display Section
          _buildSectionHeader('প্রদর্শন'),
          _buildSwitchTile(
            'বাংলা সংখ্যা ব্যবহার করুন',
            'ইংরেজির পরিবর্তে বাংলা সংখ্যা দেখান',
            Icons.numbers,
            true,
            (value) {
              // TODO: Implement Bengali number toggle
            },
          ),
          
          const Divider(height: 32),
          
          // App Info Section
          _buildSectionHeader('অ্যাপ সম্পর্কে'),
          _buildInfoTile(
            'সংস্করণ',
            '১.০.০',
            Icons.info_outline,
          ),
          _buildTapTile(
            'গোপনীয়তা নীতি',
            'আমাদের গোপনীয়তা নীতি দেখুন',
            Icons.privacy_tip_outlined,
            () {
              _showPrivacyPolicy(context);
            },
          ),
          _buildTapTile(
            'শর্তাবলী',
            'ব্যবহারের শর্তাবলী',
            Icons.description_outlined,
            () {
              _showTermsOfService(context);
            },
          ),
          _buildTapTile(
            'অ্যাপ শেয়ার করুন',
            'বন্ধুদের সাথে শেয়ার করুন',
            Icons.share,
            () {
              // TODO: Implement share functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'শেয়ার ফিচার শীঘ্রই যোগ করা হবে',
                    style: GoogleFonts.notoSansBengali(),
                  ),
                ),
              );
            },
          ),
          _buildTapTile(
            'রেটিং দিন',
            'Google Play Store এ রেটিং দিন',
            Icons.star_border,
            () {
              // TODO: Implement rating functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'রেটিং ফিচার শীঘ্রই যোগ করা হবে',
                    style: GoogleFonts.notoSansBengali(),
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 32),
          
          // Credits
          Center(
            child: Column(
              children: [
                Text(
                  'Made with ❤️ for the Muslim Ummah',
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '© 2025 Muslim Day App',
                  style: GoogleFonts.notoSansBengali(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: GoogleFonts.notoSansBengali(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1D9375),
        ),
      ),
    );
  }

  Widget _buildThemeSelector(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Column(
          children: [
            RadioListTile<ThemeMode>(
              title: Text(
                'লাইট মোড',
                style: GoogleFonts.notoSansBengali(),
              ),
              subtitle: Text(
                'হালকা রঙের থিম',
                style: GoogleFonts.notoSansBengali(fontSize: 12),
              ),
              secondary: const Icon(Icons.light_mode),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                }
              },
            ),
            const Divider(height: 1),
            RadioListTile<ThemeMode>(
              title: Text(
                'ডার্ক মোড',
                style: GoogleFonts.notoSansBengali(),
              ),
              subtitle: Text(
                'গাঢ় রঙের থিম (চোখের জন্য ভালো)',
                style: GoogleFonts.notoSansBengali(fontSize: 12),
              ),
              secondary: const Icon(Icons.dark_mode),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                }
              },
            ),
            const Divider(height: 1),
            RadioListTile<ThemeMode>(
              title: Text(
                'সিস্টেম ডিফল্ট',
                style: GoogleFonts.notoSansBengali(),
              ),
              subtitle: Text(
                'ফোনের সেটিংস অনুযায়ী',
                style: GoogleFonts.notoSansBengali(fontSize: 12),
              ),
              secondary: const Icon(Icons.settings_system_daydream),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculationMethodTile(
    BuildContext context,
    PrayerSettings prayerSettings,
  ) {
    final methods = {
      'MWL': 'মুসলিম ওয়ার্ল্ড লীগ',
      'ISNA': 'ইসলামিক সোসাইটি অফ নর্থ আমেরিকা',
      'Egypt': 'মিশরীয় জেনারেল অথরিটি',
      'Karachi': 'ইউনিভার্সিটি অফ ইসলামিক সায়েন্সেস, করাচি',
      'Jafari': 'জাফরি (শিয়া)',
    };

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.calculate),
        title: Text(
          'হিসাব পদ্ধতি',
          style: GoogleFonts.notoSansBengali(),
        ),
        subtitle: Text(
          methods['MWL'] ?? 'মুসলিম ওয়ার্ল্ড লীগ',
          style: GoogleFonts.notoSansBengali(fontSize: 12),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          _showCalculationMethodDialog(context, methods);
        },
      ),
    );
  }

  Widget _buildLocationTile(
    BuildContext context,
    PrayerSettings prayerSettings,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.location_on),
        title: Text(
          'লোকেশন',
          style: GoogleFonts.notoSansBengali(),
        ),
        subtitle: Text(
          prayerSettings.locationName.isNotEmpty
              ? prayerSettings.locationName
              : 'লোকেশন নির্ধারণ করুন',
          style: GoogleFonts.notoSansBengali(fontSize: 12),
        ),
        trailing: prayerSettings.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.gps_fixed, size: 20),
        onTap: () {
          prayerSettings.detectCurrentLocation();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'লোকেশন খোঁজা হচ্ছে...',
                style: GoogleFonts.notoSansBengali(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: SwitchListTile(
        secondary: Icon(icon),
        title: Text(
          title,
          style: GoogleFonts.notoSansBengali(),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.notoSansBengali(fontSize: 12),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: GoogleFonts.notoSansBengali(),
        ),
        trailing: Text(
          value,
          style: GoogleFonts.notoSansBengali(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1D9375),
          ),
        ),
      ),
    );
  }

  Widget _buildTapTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: GoogleFonts.notoSansBengali(),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.notoSansBengali(fontSize: 12),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showCalculationMethodDialog(
    BuildContext context,
    Map<String, String> methods,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'হিসাব পদ্ধতি নির্বাচন করুন',
          style: GoogleFonts.notoSansBengali(),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: methods.entries.map((entry) {
            return ListTile(
              title: Text(
                entry.value,
                style: GoogleFonts.notoSansBengali(),
              ),
              onTap: () {
                // TODO: Update calculation method
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${entry.value} নির্বাচন করা হয়েছে',
                      style: GoogleFonts.notoSansBengali(),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'বাতিল',
              style: GoogleFonts.notoSansBengali(),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'গোপনীয়তা নীতি',
          style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Text(
            '''আমরা আপনার গোপনীয়তাকে সম্মান করি।

এই অ্যাপ সংগ্রহ করে:
• আপনার লোকেশন (নামাজের সময় নির্ধারণের জন্য)
• আপনার পছন্দের সেটিংস (স্থানীয়ভাবে সংরক্ষিত)

আমরা সংগ্রহ করি না:
• কোনো ব্যক্তিগত তথ্য
• কোনো তৃতীয় পক্ষের সাথে ডেটা শেয়ার করি না
• কোনো বিজ্ঞাপন ট্র্যাকিং নেই

সব ডেটা শুধুমাত্র আপনার ডিভাইসে থাকে এবং কখনও কোনো সার্ভারে পাঠানো হয় না।''',
            style: GoogleFonts.notoSansBengali(height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'বুঝেছি',
              style: GoogleFonts.notoSansBengali(),
            ),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'শর্তাবলী',
          style: GoogleFonts.notoSansBengali(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Text(
            '''এই অ্যাপ ব্যবহার করে, আপনি নিম্নলিখিত শর্তাবলীতে সম্মত হচ্ছেন:

১. এই অ্যাপটি ইসলামিক শিক্ষার জন্য তৈরি করা হয়েছে।
২. সমস্ত তথ্য সঠিক রাখার চেষ্টা করা হয়েছে।
৩. কিন্তু গুরুত্বপূর্ণ ধর্মীয় বিষয়ে স্থানীয় আলেমদের সাথে পরামর্শ করুন।
৪. নামাজের সময় স্থানীয় মসজিদের সময়ের সাথে মিলিয়ে নিন।
৫. এই অ্যাপটি সম্পূর্ণ বিনামূল্যে এবং ওপেন সোর্স।

যেকোনো সমস্যার জন্য যোগাযোগ করুন।''',
            style: GoogleFonts.notoSansBengali(height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'বুঝেছি',
              style: GoogleFonts.notoSansBengali(),
            ),
          ),
        ],
      ),
    );
  }
}
