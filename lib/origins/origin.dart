import 'dart:math';
import 'package:html/parser.dart';

class Origin {
  final String name;
  final double lat;
  final double lng;
  final String id;
  final String address;

  Origin(this.name, this.lat, this.lng, this.address, this.id);

  @override
  String toString() {
    return 'Origin{name: $name}';
  }

  /* String toJson() {
    return '{"name": "$name", "lat": $lat, "lng": $lng}';
  } */

  Map<String, dynamic> toJson() =>
      {'name': name, 'lat': lat, 'lng': lng, 'address': address};

  factory Origin.fromJson(Map<String, dynamic> json, String id) {
    return Origin(parseFragment(json['name']).text!, json['lat'], json['lng'],
        json['address'] ?? '', id);
  }

  distance(location) {
    return sqrt(
        pow(location.latitude - lat, 2) + pow(location.longitude - lng, 2));
  }
}
