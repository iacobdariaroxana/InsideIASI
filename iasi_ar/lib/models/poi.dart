class PointOfInterest {
  final String? name;
  final String? info0;
  final String? info1;
  final String? info2;
  final String? info3;
  final String? openingHours;
  final String? link;

  const PointOfInterest(
      {required this.name,
      required this.info0,
      required this.info1,
      required this.info2,
      required this.info3,
      required this.openingHours,
      required this.link});

  factory PointOfInterest.fromJson(Map<String, dynamic> json) {
    return PointOfInterest(
        name: json['name'],
        info0: json['info0'],
        info1: json['info1'],
        info2: json['info2'],
        info3: json['info3'],
        openingHours: json['opening_hours'],
        link: json['link']);
  }
}
