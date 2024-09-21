import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:raccoltalatte/collections/collection.dart';
import 'package:raccoltalatte/config.dart';
import 'package:raccoltalatte/date_time_picker.dart';
import 'package:raccoltalatte/origins_dropdown.dart';
import 'package:raccoltalatte/recognizer.dart';
import 'package:raccoltalatte/requests.dart';
import 'package:raccoltalatte/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:image_picker/image_picker.dart';
import 'package:universal_platform/universal_platform.dart';

class AddButton extends StatefulWidget {
  const AddButton({super.key, required this.username, required this.admin});
  final String username;
  final bool admin;

  @override
  State<StatefulWidget> createState() => AddButtonState();
}

class AddButtonState extends State<AddButton> {
  String origin = '';
  DateTime date = DateTime.now();
  late ImagePicker _picker;

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
  }

  final _formKey = GlobalKey<FormState>();
  final MLKitTextRecognizer recognizer = MLKitTextRecognizer();

  Future<String?> obtainImage() async {
    final String? file;
    if (!kIsWeb && (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)) {
      file = (await _picker.pickImage(source: ImageSource.camera))?.path;
    } else {
      file = null;
    }
    return file;
  }

  Future<String?> getExtStorageOrDownloadsDirPath() async {
    if (!kIsWeb) {
      final documentsDir = await getApplicationDocumentsDirectory();
      if (Platform.isAndroid) {
        //final extStorageDir = await getExternalStorageDirectory();
        //return extStorageDir?.path ?? documentsDir.path;
        return '/storage/emulated/0/Download';
      } else {
        final downloadsDir = await getDownloadsDirectory();
        return downloadsDir?.path ?? documentsDir.path;
      }
    }
    return null;
  }

  Future<void> inputPopup(BuildContext context, String? _) async {
    date = DateTime.now();
    String? filePath = await obtainImage();
    final String recognized;
    if (filePath != null) {
      recognized = await recognizer.processImage(filePath);
    } else {
      recognized = '';
    }

    String? s;
    if (context.mounted) {
      s = await showDialog(
          context: context,
          builder: (_) {
            var quantityController = TextEditingController(text: recognized);
            var quantity2Controller = TextEditingController(text: '0');
            return AddDialog(
                formKey: _formKey,
                addAction: () {
                  Navigator.pop(context,
                      '${quantityController.text};${quantity2Controller.text}');
                },
                context: context,
                children: [
                  TextField(
                      text: 'Quantità',
                      error: 'Inserisci la quantità',
                      controller: quantityController),
                  TextField(
                      text: 'Seconda',
                      error: 'Inserisci il latte di seconda',
                      controller: quantity2Controller),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OriginsDropdown((value, redraw) {
                        origin = value;
                      })),
                  DateTimePicker(
                    date: date,
                    onChanged: (value) {
                      date = value;
                    },
                    admin: widget.admin,
                  ),
                ]);
          });
    }

    if (s == null) {
      return;
    }
    var tmp = s.split(';');
    final quantity = int.parse(
        tmp[0].substring((tmp[0].length - 5 >= 0) ? tmp[0].length - 5 : 0));
    final quantity2 = int.parse(
        tmp[1].substring((tmp[1].length - 5 >= 0) ? tmp[1].length - 5 : 0));

    if (recognized != '') {
      int recognizedInt = int.parse(recognized);
      FirebaseAnalytics.instance.logEvent(name: 'ocr', parameters: {
        'equals': (recognizedInt == quantity),
        'recognized': recognizedInt,
        'real': quantity
      });
    }

    // save file
    if (!kIsWeb && filePath != null) {
      Gal.putImage(filePath);
      if (saveFile) {
        uploadFile(File(filePath), date);
      }
    }

    final Collection c =
        Collection(widget.username, origin, quantity, quantity2, date, '');
    await addCollection(c, filePath).catchError((error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Button<Collection>(inputPopup: inputPopup);
  }
}
