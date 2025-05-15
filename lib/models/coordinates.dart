class Coordinates {
  final double lat;
  final double lan;

  Coordinates({required this.lat, required this.lan});

  factory Coordinates.empty() {
    return Coordinates(lat: 0.0, lan: 0.0);
  }
}
