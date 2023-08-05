class Language {
  final String languageCode;
  final String flagIcon;

  Language({
    required this.languageCode,
    required this.flagIcon,
  });

  static final List<Language> _languages = [
    Language(languageCode: 'en', flagIcon: '🇬🇧'),
    Language(languageCode: 'ro', flagIcon: '🇷🇴'),
    Language(languageCode: 'es', flagIcon: '🇪🇸'),
    Language(languageCode: 'fr', flagIcon: '🇫🇷'),
    Language(languageCode: 'it', flagIcon: '🇮🇹'),
    Language(languageCode: 'de', flagIcon: '🇩🇪'),
    Language(languageCode: 'ru', flagIcon: '🇷🇺')
  ];
  static List<Language> get languages => _languages;
}
