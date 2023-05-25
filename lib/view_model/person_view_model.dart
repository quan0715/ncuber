import 'package:flutter/material.dart';
import 'package:ncuber/model/person_model.dart';

class PersonViewModel extends ChangeNotifier {
  late PersonModel _personModel;

  setPerson(PersonModel personModel) {
    _personModel = personModel;
    notifyListeners();
  }

  getPersonByUid(int uid) {

  }

  PersonModel get personModel => _personModel;
}
