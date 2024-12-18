import 'package:flutter/material.dart';
import 'package:raccoltalatte/config.dart';
import 'package:raccoltalatte/employees/employee.dart';
import 'package:raccoltalatte/requests.dart';
import 'package:raccoltalatte/theme.dart';

class EmployeesDropdown extends StatelessWidget {
  const EmployeesDropdown(this.onChanged, {super.key});
  final void Function(String) onChanged;
  static List<Employee>? origins;

  @override
  Widget build(BuildContext context) {
    if (!askEmployee) {
      return const SizedBox.shrink();
    }
    return Row(children: [
      const Padding(
        padding: EdgeInsets.all(MyTheme.padding),
        child: Text('Operaio: '),
      ),
      FutureBuilder(
        future: getEmployees(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Nessun operaio trovato'));
          } else if (snapshot.hasData) {
            List<Employee> list = snapshot.data as List<Employee>;
            return DropdownHelper(list, onChanged);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )
    ]);
  }
}

class DropdownHelper extends StatefulWidget {
  const DropdownHelper(this.origins, this.onChanged, {super.key});
  final List<Employee> origins;
  final void Function(String) onChanged;

  @override
  State<StatefulWidget> createState() => DropdownState();
}

class DropdownState extends State<DropdownHelper> {
  String selected = '';

  @override
  Widget build(BuildContext context) {
    if (widget.origins.isEmpty) return const Text('Nessun operaio trovato');
    if (widget.origins[0].name != '') {
      widget.origins.insert(0, Employee(name: '', id: ''));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: selected,
        iconSize: 24,
        elevation: 16,
        underline: Container(
          height: 2,
        ),
        onChanged: (value) {
          setState(() {
            if (value == null) {
              selected = '';
            } else {
              selected = value;
              widget.onChanged(selected);
            }
          });
        },
        items: widget.origins.map<DropdownMenuItem<String>>((Employee value) {
          return DropdownMenuItem<String>(
            value: value.name,
            child: Text(value.name),
          );
        }).toList(),
      ),
    );
  }
}
