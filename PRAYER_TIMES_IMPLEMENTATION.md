# Muslim Day App - Prayer Times Implementation Guide

## Overview
This document outlines the comprehensive implementation for fixing prayer times calculation and UI in the Muslim Day app.

## Key Changes Implemented

### 1. Prayer Time Calculation Using Adhan Package ✅
- All prayer times now calculated using the `adhan` package
- Includes: Fajr, Dhuhr, Asr, Maghrib, Isha
- Additional times: Sunrise, Ishraq, Tahajjud, Duha
- Prohibited times calculated accurately

### 2. Calculation Methods (Excluding Shia) ✅
Available methods in settings:
- Muslim World League
- Egyptian General Authority
- University of Islamic Sciences, Karachi  
- Umm al-Qura University, Makkah
- Dubai (UAE)
- Qatar
- Kuwait
- Singapore
- ISNA (North America)
- Moonsighting Committee

**Removed:** Tehran (Shia method)

### 3. Manual Location Selection ✅
- Created `LocationSelectionScreen` with all 64 Bangladesh districts
- Users can search and select their district
- Coordinates pre-configured for each district
- GPS option still available as alternative

### 4. Files Created/Updated

#### New Files:
1. `/lib/models/district.dart` - District model with coordinates
2. `/lib/models/prayer_times.dart` - Prayer times data model  
3. `/lib/providers/prayer_provider.dart` - Prayer calculation provider
4. `/lib/screens/location_selection_screen.dart` - Location selection UI

#### Modified Files:
1. `/lib/providers/prayer_settings.dart` - Added `updateManualLocation()` method
2. `/lib/screens/prayer_settings_page.dart` - Needs recreation with new UI

### 5. Progress Bar Implementation
The home screen should show:
- Current prayer time
- Circular progress indicator
- Time remaining until next prayer
- Proper calculation of progress percentage

### 6. UI Components Needed

#### Home Screen Updates:
```dart
- Top card: Islamic & Gregorian dates, sunrise/sunset times
- Prayer times card with:
  * Circular progress bar (showing time remaining)
  * List of 5 daily prayers with times
  * Current prayer highlighted
- Prohibited times card
- Nafil prayer times (Ishraq, Tahajjud, etc.)
- Sahri/Iftar timing card
```

#### Calendar Page:
- Monthly view of prayer times
- No overflow errors
- Proper date navigation
- Bengali numerals

#### Settings Page:
- Location selection button
- Calculation method selector (no Shia)
- Madhab selection (Hanafi/Shafi)
- Notification settings
- Time adjustments

## Next Steps

### To Complete Implementation:

1. **Recreate Prayer Settings Page**
```bash
cd "/home/tanvir/Desktop/Flutter Projects/muslim_day"
# Create new prayer_settings_page.dart with proper UI
```

2. **Update Home Content**
- Integrate new prayer provider
- Add functional progress bar
- Display all prayer times correctly

3. **Fix Calendar Page**
- Remove overflow errors
- Implement proper Bengali UI
- Add date picker functionality

4. **Test All Features**
- Prayer time calculations
- Location selection
- Calculation method changes
- Progress bar accuracy
- UI responsiveness

## Code Snippets

### Using Prayer Times in Widgets:
```dart
final prayerSettings = Provider.of<PrayerSettings>(context);
final prayerTimes = prayerSettings.getExtendedPrayerTimes(DateTime.now());
final fivePrayers = prayerSettings.getFivePrayers(DateTime.now());
```

### Circular Progress Bar:
```dart
CircularProgressIndicator(
  value: progress, // 0.0 to 1.0
  strokeWidth: 8,
  backgroundColor: Colors.grey[300],
  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
)
```

### Bengali Number Conversion:
```dart
String _toBengaliNumber(String number) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const bengali = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
  for (int i = 0; i < english.length; i++) {
    number = number.replaceAll(english[i], bengali[i]);
  }
  return number;
}
```

## Testing Checklist

- [ ] Prayer times calculate correctly for selected location
- [ ] Calculation method changes update times
- [ ] Progress bar shows accurate remaining time
- [ ] All special times (Ishraq, Tahajjud) display correctly
- [ ] Prohibited times marked properly
- [ ] Location selection works (both GPS and manual)
- [ ] Settings save and persist
- [ ] UI matches provided screenshots
- [ ] No overflow errors
- [ ] Bengali text displays properly
- [ ] Times update at midnight automatically

## Important Notes

1. **Adhan Package**: All calculations use `PrayerTimes.today()` from adhan package
2. **Coordinates**: Dhaka default is (23.8103, 90.4125)
3. **Method Storage**: Saved in SharedPreferences
4. **Auto-Update**: Timer refreshes UI every second
5. **Bengali Locale**: Using 'bn_BD' for date formatting

## Support

For issues or questions, refer to:
- Adhan package docs: https://pub.dev/packages/adhan
- Flutter Provider: https://pub.dev/packages/provider
