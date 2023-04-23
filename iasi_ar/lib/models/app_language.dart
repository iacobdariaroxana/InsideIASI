class AppLanguage {
  final String languageCode;
  final String flagIcon;
  AppLanguage({required this.languageCode, required this.flagIcon});
  static final List<AppLanguage> _languages = [
    AppLanguage(languageCode: 'en', flagIcon: '🇬🇧'),
    AppLanguage(languageCode: 'ro', flagIcon: '🇷🇴')
  ];
  static List<AppLanguage> get languages => _languages;
}
