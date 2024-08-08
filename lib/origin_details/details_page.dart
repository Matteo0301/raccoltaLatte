import 'package:raccoltalatte/collections/collection.dart';
import 'package:raccoltalatte/model.dart';
import 'package:raccoltalatte/origin_details/details_table.dart';
import 'package:raccoltalatte/requests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OriginDetails extends StatefulWidget {
  const OriginDetails(
      {super.key,
      required this.title,
      required this.username,
      required this.admin,
      required this.origin});
  final String title;
  final String username;
  final bool admin;
  final String origin;

  @override
  State<StatefulWidget> createState() => OriginDetailsState();
}

class OriginDetailsState extends State<OriginDetails> {
  DateTime date = DateTime.now()
      .copyWith(month: DateTime.now().month + 1, day: 0, hour: 12);

  int total = 0;

  Future<List<Collection>> getCollectionList() async {
    DateTime end = date.copyWith(month: date.month + 1, day: 0, hour: 12);
    DateTime start = end.copyWith(day: 0, hour: 12);
    String endDate = end.toIso8601String();
    String startDate = start.toIso8601String();
    final res = (await getCollections(
            widget.username, widget.admin, startDate, endDate))
        .where((element) => element.origin == widget.origin)
        .toList();
    return res;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = DetailsTable(date: date, request: getCollectionList);
    return ChangeNotifierProvider(
      create: (context) => Model<Collection>(),
      child: Scaffold(
        appBar: AppBar(
            title: Text(
                'Mese: ${date.month.toString().padLeft(2, "0")}/${date.year}'),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      date = date.copyWith(
                          month: date.month + 2, day: 0, hour: 12);
                      if (date.isAfter(DateTime.now())) {
                        date = DateTime.now().copyWith(
                            month: DateTime.now().month + 1, day: 0, hour: 12);
                      }
                    });
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      date = date.copyWith(day: 0, hour: 12);
                      if (date.isBefore(DateTime(2021, 1, 1))) {
                        date = DateTime(2021, 1, 1);
                      }
                    });
                  },
                  icon: const Icon(Icons.arrow_forward_ios)),
            ],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: content,
      ),
    );
  }
}
