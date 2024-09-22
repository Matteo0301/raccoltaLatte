import 'package:raccoltalatte/origins/origin.dart';
import 'package:raccoltalatte/requests.dart';
import 'package:raccoltalatte/theme.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class OriginsDropdown extends StatelessWidget {
  const OriginsDropdown(this.onChanged, {super.key});
  final void Function(String) onChanged;
  static List<Origin>? origins;

  Future<Position> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Impossibile recuperare la posizione');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Fornire i permessi per la geolocalizzazione');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Fornire i permessi per la geolocalizzazione');
    }

    return await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.best));
  }

  getSortedOrigins() async {
    final List<Origin> newOrigins;
    final Position location = await getLocation();
    if (origins == null || origins == []) {
      newOrigins = await getOrigins();
    } else {
      newOrigins = origins!;
    }

    newOrigins
        .sort((a, b) => a.distance(location).compareTo(b.distance(location)));
    origins = newOrigins;
    return newOrigins;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.all(MyTheme.padding),
        child: Text('Conferente: '),
      ),
      FutureBuilder(
        future: getSortedOrigins(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Nessun conferente trovato'));
          } else if (snapshot.hasData) {
            List<Origin> list = snapshot.data as List<Origin>;
            return OriginsDropdownHelper(list, onChanged);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )
    ]);
  }
}

class OriginsDropdownHelper extends StatefulWidget {
  const OriginsDropdownHelper(this.origins, this.onChanged, {super.key});
  final List<Origin> origins;
  final void Function(String) onChanged;

  @override
  State<StatefulWidget> createState() => DropdownState();
}

class DropdownState extends State<OriginsDropdownHelper> {
  String selected = '';

  @override
  Widget build(BuildContext context) {
    if (widget.origins.isEmpty) return const Text('Nessun conferente trovato');
    if (selected == '') {
      selected = widget.origins[0].name;
      widget.onChanged(selected);
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
        items: widget.origins.map<DropdownMenuItem<String>>((Origin value) {
          return DropdownMenuItem<String>(
            value: value.name,
            child: Text(value.name),
          );
        }).toList(),
      ),
    );
  }
}
