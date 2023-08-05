class AppLanguage {
  final String languageCode;
  final String countryCode;
  final String flagIcon;
  final double speechRate;

  AppLanguage(
      {required this.languageCode,
      required this.flagIcon,
      required this.countryCode,
      required this.speechRate});

  static final List<AppLanguage> _languages = [
    AppLanguage(
        languageCode: 'en',
        flagIcon: '🇬🇧',
        countryCode: 'US',
        speechRate: 0.5),
    AppLanguage(
        languageCode: 'ro',
        flagIcon: '🇷🇴',
        countryCode: 'RO',
        speechRate: 0.8)
  ];
  static List<AppLanguage> get languages => _languages;
}
