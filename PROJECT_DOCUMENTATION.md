# Muslim Day - Complete Islamic Companion App

A comprehensive Islamic mobile application built with Flutter, providing essential features for daily Islamic practices.

## 🌟 Features

### ✅ Completed Features

#### 1. **Home Screen - Prayer Times Dashboard**
- Real-time prayer times calculation based on location
- Hijri and Gregorian date display
- Current prayer tracking with progress bar
- Prohibited prayer times indicator (sunrise, zawal, sunset)
- Nafl prayer times (Ishrak, Tahajjud)
- Automatic location detection
- Beautiful gradient UI with card-based design

#### 2. **Mahfil & Islamic Events Page**
- **Upcoming Events Tab:**
  - Weekly Jumma prayer reminders
  - Quran Tafsir classes
  - Daily Fajr congregation
  - Halaqa (discussion sessions)
  - Event details with date, time, and location
  - Add to calendar functionality

- **Important Islamic Dates Tab:**
  - Lailatul Qadr
  - Eid ul-Fitr
  - Eid ul-Adha
  - Ashura
  - Shab-e-Miraj
  - Detailed descriptions and significance
  - Hijri and Gregorian date conversion

- **Books & Articles Tab:**
  - Riyadus Saliheen
  - Tafsir Ibn Kathir
  - Fiqhus Sunnah
  - Hisnul Muslim
  - Resource descriptions and types

#### 3. **Al-Quran Reader**
- All 114 Surahs with Bengali names and meanings
- Arabic text with proper font rendering
- Surah details with verse counts
- Bengali translation support
- Settings for font customization
- Beautiful UI with teal theme
- Surah navigation
- Reading progress tracking

#### 4. **Dua Collection (দোয়া সমূহ)**
- **Categories:**
  - Morning duas (সকাল)
  - Evening duas (সন্ধ্যা)
  - Sleep duas (ঘুম)
  - Food duas (খাবার)
  - Prayer duas (নামাজ)
  - General duas (সাধারণ)
  
- **Features:**
  - Arabic text with Bengali translation
  - Pronunciation guide in Bengali
  - Meaning and benefits
  - Authentic Hadith references
  - Favorite/bookmark system
  - Copy to clipboard functionality
  - Filter by category
  - 25+ essential duas included

#### 5. **Nearby Mosque Finder (নিকটবর্তী মসজিদ)**
- GPS-based location detection
- List of nearby mosques with:
  - Distance from current location
  - Ratings and reviews
  - Contact information
  - Operating hours
- Direction navigation (Google Maps integration)
- Direct call functionality
- Detailed mosque information modal
- Permission handling for location services

#### 6. **Masnoon Amal Guide (মাসনুন আমল)**
- **Daily Amal:**
  - Fajr prayer in congregation
  - Morning and evening Azkar
  - Five daily prayers
  - Quran recitation
  - Istighfar (100 times daily)

- **Weekly Amal:**
  - Jumma prayer guidelines
  - Surah Al-Kahf recitation
  - Monday and Thursday fasting

- **Monthly Amal:**
  - Ayyam-e-Bid fasting (13, 14, 15)
  - New moon sighting and dua

- **Yearly Amal:**
  - Ramadan fasting
  - Hajj pilgrimage
  - Qurbani (sacrifice)
  - Ashura fasting
  - Arafah day fasting

- **Each Amal includes:**
  - Timing and frequency
  - Detailed description
  - Step-by-step instructions
  - Rewards and benefits
  - Authentic references

#### 7. **Amal Journal / Tracker (আমল ট্রাকার)**
- Daily Islamic practices tracking
- Categories: Fardh, Sunnah, Habits
- Point-based reward system
- Streak tracking for consistency
- Daily progress visualization
- Persistent data storage
- Motivational interface

#### 8. **Tasbeeh Counter (তাসবীহ)**
- Digital counter for dhikr
- Customizable target counts (33, 99, 100)
- Vibration feedback
- Total count tracking
- Current session counter
- Reset functionality
- Clean, minimalist UI

#### 9. **Qibla Compass (কিবলা কম্পাস)**
- Accurate Qibla direction finder
- Compass needle animation
- Degree indicator
- Permission handling
- Real-time compass updates

#### 10. **Fiqh Assistant (ফিকহ অ্যাসিস্ট্যান্ট)**
- Islamic Q&A interface
- Chat-based interaction
- Common fiqh questions
- Categorized responses
- User-friendly chat bubbles

#### 11. **Menu & Navigation**
- Bottom navigation bar with 5 tabs:
  - Home (হোম)
  - Mahfil (মাহফিল)
  - Quran (কুরআন)
  - Amal Tracker (আমল ট্রাকার)
  - Menu (মেনু)

- **Menu Sections:**
  - Settings
  - Fiqh Assistant
  - Tools (Qibla, Tasbeeh, Duas, Nearby Mosques)
  - Knowledge Resources
  - Islamic Articles

## 🎨 UI/UX Enhancements

### Color Scheme
- Primary Color: `#1A4D4D` (Deep Teal)
- Accent Color: `#1D9375` (Teal Green)
- Background: `#F5F5F5` (Light Gray)
- Card Background: White with subtle shadows

### Design Elements
- **Material Design 3** principles
- Rounded corners (12px radius)
- Elevation and shadows for depth
- Consistent padding and spacing
- Bengali font support (Google Fonts - Noto Sans Bengali)
- Arabic font support (Amiri Quran)
- Smooth animations and transitions
- Icon-based navigation
- Color-coded categories
- Progress indicators
- Responsive layouts

### Typography
- **Headings:** Bold, 16-18px
- **Body:** Regular, 14px
- **Captions:** 12-13px
- **Arabic Text:** 20px, right-aligned
- Line height: 1.5 for readability

## 📱 Technical Stack

### Dependencies
```yaml
dependencies:
  flutter: SDK
  flutter_localizations: SDK
  
  # State Management
  provider: ^6.1.2
  
  # Storage
  shared_preferences: ^2.2.3
  
  # Islamic Features
  adhan: ^2.0.0-nullsafety.2  # Prayer times calculation
  hijri: ^3.0.0               # Hijri calendar
  quran: ^1.2.4               # Quran data
  
  # Location & Maps
  geolocator: ^12.0.0
  geocoding: ^4.0.0
  flutter_compass: ^0.8.0
  google_maps_flutter: ^2.9.0
  
  # UI Components
  google_fonts: ^6.2.1
  flutter_svg: ^2.0.10+1
  cached_network_image: ^3.4.1
  carousel_slider: ^5.0.0
  flutter_animate: ^4.5.0
  
  # Notifications
  flutter_local_notifications: ^18.0.1
  
  # Audio
  just_audio: ^0.9.40
  
  # Utilities
  intl: ^0.20.2
  http: ^1.2.1
  url_launcher: ^6.3.1
  permission_handler: ^12.0.1
  flutter_markdown: ^0.7.1
```

### Permissions (Android)
```xml
- INTERNET
- ACCESS_FINE_LOCATION
- ACCESS_COARSE_LOCATION
- VIBRATE
- POST_NOTIFICATIONS
- SCHEDULE_EXACT_ALARM
- USE_EXACT_ALARM
- RECEIVE_BOOT_COMPLETED
- WAKE_LOCK
```

## 📂 Project Structure

```
lib/
├── main.dart                          # App entry point
├── data/
│   └── bengali_surah_data.dart       # Surah names in Bengali
├── providers/
│   ├── amal_provider.dart            # Amal tracking state
│   ├── prayer_settings.dart          # Prayer time settings
│   └── quran_settings.dart           # Quran reader settings
├── screens/
│   ├── home_screen.dart              # Main navigation
│   ├── home_content.dart             # Prayer times dashboard
│   ├── mahfil_page.dart              # Islamic events
│   ├── quran_screen.dart             # Quran reader
│   ├── surah_details_screen.dart     # Surah reading view
│   ├── quran_settings.dart           # Quran customization
│   ├── amal_journal_page.dart        # Amal tracker
│   ├── dua_collection_page.dart      # Duas library
│   ├── nearby_mosque_page.dart       # Mosque finder
│   ├── masnoon_amal_page.dart        # Islamic practices guide
│   ├── tasbeeh.dart                  # Tasbeeh counter
│   ├── qibla_compass.dart            # Qibla finder
│   ├── fiqh_assistant_page.dart      # Fiqh Q&A
│   ├── prayer_settings_page.dart     # Prayer configuration
│   └── menu_screens.dart             # Menu screen
└── widgets/
    ├── bottom_nav.dart               # Bottom navigation
    ├── date_time_bar.dart            # Date display widget
    ├── location_bar.dart             # Location widget
    ├── prayer_times_card.dart        # Prayer times card
    └── info_card.dart                # Info display card
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=2.19.6 <3.0.0)
- Android Studio / VS Code
- Android SDK for Android development
- Xcode for iOS development (Mac only)

### Installation

1. **Clone the repository:**
```bash
git clone <repository-url>
cd muslim_day
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Run the app:**
```bash
flutter run
```

### Building for Production

**Android:**
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

## 🔄 Recent Changes & Improvements

### Code Quality
- ✅ Removed unused imports
- ✅ Fixed compilation errors
- ✅ Optimized widget builds
- ✅ Added proper error handling
- ✅ Implemented proper state management

### New Features Added
1. ✅ Complete Mahfil page with events, dates, and resources
2. ✅ Comprehensive Dua collection (25+ duas)
3. ✅ Nearby mosque finder with Maps integration
4. ✅ Masnoon Amal guide with 20+ practices
5. ✅ Enhanced navigation and menu structure

### UI/UX Improvements
- ✅ Consistent color scheme across all screens
- ✅ Bengali and Arabic font support
- ✅ Material Design 3 implementation
- ✅ Smooth animations and transitions
- ✅ Improved card designs with elevation
- ✅ Better spacing and padding
- ✅ Icon-based visual hierarchy

### Bug Fixes
- ✅ Fixed location permission handling
- ✅ Resolved prayer time calculation issues
- ✅ Fixed data persistence in Amal tracker
- ✅ Corrected Bengali number conversions

## 📋 To-Do / Future Enhancements

### High Priority
- [ ] Implement Quran bookmarks functionality
- [ ] Add audio recitation for Quran
- [ ] Add Tafsir (commentary) for Quranic verses
- [ ] Implement push notifications for prayer times
- [ ] Add Adhan (prayer call) audio
- [ ] Create Islamic calendar with Ramadan tracker

### Medium Priority
- [ ] Add Hadith collection with categories
- [ ] Implement theme switching (light/dark mode)
- [ ] Add multi-language support (English, Arabic, Urdu)
- [ ] Create widget for home screen (prayer times)
- [ ] Add Qibla direction on a map
- [ ] Implement social sharing for duas and verses

### Low Priority
- [ ] Add user authentication and cloud sync
- [ ] Create community features
- [ ] Add Islamic quiz/games
- [ ] Implement donation/charity tracking
- [ ] Add Names of Allah with meanings
- [ ] Create prayer tracking statistics

## 🐛 Known Issues

1. ⚠️ Some lint warnings for unused imports (need cleanup)
2. ⚠️ Nearby mosque uses sample data (needs API integration)
3. ⚠️ Some newer package versions available but not compatible

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Guidelines
1. Follow Flutter best practices
2. Use meaningful variable and function names in Bengali or English
3. Add comments for complex logic
4. Test on both Android and iOS
5. Ensure no breaking changes
6. Update documentation

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For issues, questions, or suggestions:
- Create an issue in the repository
- Contact the development team

## 🙏 Acknowledgments

- Quran API and data providers
- Adhan package for prayer time calculations
- Flutter community for excellent packages
- Islamic scholars for authentic references
- All contributors and testers

## 📱 Screenshots

_Screenshots will be added after UI finalization_

---

**Version:** 1.0.0+1  
**Last Updated:** November 28, 2025  
**Status:** Active Development

**Made with ❤️ for the Muslim community**
