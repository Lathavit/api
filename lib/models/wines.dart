// POJO (Plain Old Java Object)
class Wine {
  final String? winery;
  final String? wine;
  final String? location;
  final String? image;
  final String? average;

  Wine({
    required this.winery,
    required this.wine,
    required this.location,
    required this.image,
    required this.average,
  });

  factory Wine.fromJson(Map<String, dynamic> json) {
    return Wine(
      winery: json['winery'],
      wine: json['wine'],
      location: json['location'],
      image: json['image'],
      average: json['rating']['average'],
    );
  }
}