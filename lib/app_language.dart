enum AppLanguage {
  arabic,
  french,
  english,
}

extension AppLanguageExtension on AppLanguage {
  String get code {
    switch (this) {
      case AppLanguage.arabic:
        return 'ar';
      case AppLanguage.french:
        return 'fr';
      case AppLanguage.english:
        return 'en';
    }
  }

  String get displayName {
    switch (this) {
      case AppLanguage.arabic:
        return 'العربية';
      case AppLanguage.french:
        return 'Français';
      case AppLanguage.english:
        return 'English';
    }
  }
}