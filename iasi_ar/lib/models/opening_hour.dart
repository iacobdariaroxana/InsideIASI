class OpeningHour {
  final String? day;
  final String? openingTime;
  final String? closingTime;

  const OpeningHour(
      {required this.day,
      required this.openingTime,
      required this.closingTime});

  factory OpeningHour.fromJson(Map<String, dynamic> json) {
    return OpeningHour(
        openingTime: json['openingTime'],
        closingTime: json['closingTime'],
        day: json['day']);
  }
}
