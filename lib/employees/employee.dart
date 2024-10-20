class Employee {
  final String name;
  final String id;

  Employee({required this.name, required this.id});

  @override
  String toString() {
    return 'Employee{name: $name}';
  }

  Map<String, dynamic> toJson() => {'name': name};

  factory Employee.fromJson(Map<String, dynamic> json, String id) {
    return Employee(id: id, name: json['name']);
  }
}
