class Location {
  final String type; // Always "Point"
  final List<double> coordinates; // [longitude, latitude]

  Location(this.type, this.coordinates);
}
