import 'package:flutter/cupertino.dart';
import 'package:mycampus/Api/CampusService.dart';
import 'package:mycampus/Models/Campus.dart';

class CampusProvider extends ChangeNotifier {
  List<Campus> _list = [];
  List<Campus> get list => _list;
  campusList() {
    CampusService().getCampus().then((value) {
      _list = value;
      print(value);
      notifyListeners();
    });
  }
}
