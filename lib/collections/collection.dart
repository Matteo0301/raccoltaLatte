import 'package:html/parser.dart';

class Collection {
  final String user;
  final String origin;
  final int quantity;
  final DateTime date;
  final int quantity2;
  final String id;

  Collection(this.user, this.origin, this.quantity, this.quantity2, this.date,
      this.id);

  @override
  String toString() {
    return 'Collection{user: $user,  quantity: $quantity, quantity2: $quantity2}';
  }

  factory Collection.fromJson(Map<String, dynamic> json, String id) {
    return Collection(
        parseFragment(json['user']).text!,
        parseFragment(json['origin']).text!,
        json['quantity'],
        json['quantity2'],
        DateTime.parse(json['date']),
        id);
  }

  Map<String, dynamic> toJson() => {
        'user': user,
        'origin': origin,
        'quantity': quantity,
        'quantity2': quantity2,
        'date': date.toIso8601String()
      };
}
