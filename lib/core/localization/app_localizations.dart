import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ?? AppLocalizations(const Locale('en'));
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'Smart Fodder',
      'app_subtitle': 'Smart Feeding for Better Farming',
      'system_online': 'System Online',
      'system_offline': 'System Offline',
      'gate': 'Fodder Gate',
      'gate_open': 'Gate Open',
      'gate_closed': 'Gate Closed',
      'opening_gate': 'Opening gate...',
      'closing_gate': 'Closing gate...',
      'open_gate': 'OPEN GATE',
      'close_gate': 'CLOSE GATE',
      'feed_level': 'Feed Level',
      'feed_good': 'GOOD',
      'feed_high': 'HIGH',
      'feed_low': 'LOW',
      'feed_empty': 'EMPTY',
      'next_feeding': 'Next Feeding',
      'today_feedings': 'Today\'s Feedings',
      'home': 'Home',
      'schedule': 'Schedule',
      'history': 'History',
      'settings': 'Settings',
      'alerts': 'Alerts',
      'login': 'Login',
      'register': 'Register',
      'logout': 'Logout',
      'farm_name': 'Farm Name',
      'cattle_count': 'Number of Cattle',
      'dev_mode': 'Development Mode',
      'mock_active': 'Simulated Hardware Mode Active',
    },
    'ta': { // Tamil
      'app_title': 'ஸ்மார்ட் ஃபாடர்',
      'app_subtitle': 'சிறந்த விவசாயத்திற்கான ஸ்மார்ட் தீவனம்',
      'system_online': 'அமைப்பு ஆன்லைனில் உள்ளது',
      'system_offline': 'அமைப்பு ஆஃப்லைனில் உள்ளது',
      'gate': 'தீவன கதவு',
      'gate_open': 'கதவு திறக்கப்பட்டது',
      'gate_closed': 'கதவு மூடப்பட்டது',
      'opening_gate': 'கதவு திறக்கப்படுகிறது...',
      'closing_gate': 'கதவு மூடப்படுகிறது...',
      'open_gate': 'கதவை திற',
      'close_gate': 'கதவை மூடு',
      'feed_level': 'தீவன நிலை',
      'feed_good': 'நல்ல நிலை',
      'feed_high': 'அதிகம்',
      'feed_low': 'குறைவு',
      'feed_empty': 'காலியாக உள்ளது',
      'next_feeding': 'அடுத்த தீவனம்',
      'today_feedings': 'இன்றைய தீவனங்கள்',
      'home': 'முகப்பு',
      'schedule': 'அட்டவணை',
      'history': 'வரலாறு',
      'settings': 'அமைப்புகள்',
      'alerts': 'எச்சரிக்கைகள்',
      'login': 'உள்நுழை',
      'register': 'பதிவு செய்',
      'logout': 'வெளியேறு',
      'farm_name': 'பண்ணை பெயர்',
      'cattle_count': 'மாடுகளின் எண்ணிக்கை',
      'dev_mode': 'டெவலப்மென்ட் பயன்முறை',
      'mock_active': 'போலி வன்பொருள் பயன்முறை செயல்படுகிறது',
    },
    'kn': { // Kannada
      'app_title': 'ಸ್ಮಾರ್ಟ್ ಫೋಡರ್',
      'app_subtitle': 'ಉತ್ತಮ ಕೃಷಿಗಾಗಿ ಸ್ಮಾರ್ಟ್ ಮೇವು ವ್ಯವಸ್ಥೆ',
      'system_online': 'ವ್ಯವಸ್ಥೆ ಆನ್‌ಲೈನ್‌ನಲ್ಲಿದೆ',
      'system_offline': 'ವ್ಯವಸ್ಥೆ ಆಫ್‌ಲೈನ್‌ನಲ್ಲಿದೆ',
      'gate': 'ಮೇವಿನ ಬಾಗಿಲು',
      'gate_open': 'ಬಾಗಿಲು ತೆರೆದಿದೆ',
      'gate_closed': 'ಬಾಗಿಲು ಮುಚ್ಚಿದೆ',
      'opening_gate': 'ಬಾಗಿಲು ತೆರೆಯಲಾಗುತ್ತಿದೆ...',
      'closing_gate': 'ಬಾಗಿಲು ಮುಚ್ಚಲಾಗುತ್ತಿದೆ...',
      'open_gate': 'ಬಾಗಿಲು ತೆರೆಯಿರಿ',
      'close_gate': 'ಬಾಗಿಲು ಮುಚ್ಚಿ',
      'feed_level': 'ಮೇವಿನ ಮಟ್ಟ',
      'feed_good': 'ಉತ್ತಮವಾಗಿದೆ',
      'feed_high': 'ಹೆಚ್ಚಾಗಿದೆ',
      'feed_low': 'ಕಡಿಮೆಯಾಗಿದೆ',
      'feed_empty': 'ಖಾಲಿಯಾಗಿದೆ',
      'next_feeding': 'ಮುಂದಿನ ಮೇವು',
      'today_feedings': 'ಇಂದಿನ ಮೇವುಗಳು',
      'home': 'ಮುಖಪುಟ',
      'schedule': 'ಸಮಯಪಟ್ಟಿ',
      'history': 'ಇತಿಹಾಸ',
      'settings': 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು',
      'alerts': 'ಎಚ್ಚರಿಕೆಗಳು',
      'login': 'ಲಾಗಿನ್',
      'register': 'ನೋಂದಾಯಿಸಿ',
      'logout': 'ಲಾಗ್‌ಔಟ್',
      'farm_name': 'ಫಾರ್ಮ್ ಹೆಸರು',
      'cattle_count': 'ಹಸುಗಳ ಸಂಖ್ಯೆ',
      'dev_mode': 'ಡೆವಲಪ್‌ಮೆಂಟ್ ಮೋಡ್',
      'mock_active': 'ಅನುಕರಿಸಿದ ಯಂತ್ರಾಂಶ ಮೋಡ್ ಸಕ್ರಿಯವಾಗಿದೆ',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ta', 'kn'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
