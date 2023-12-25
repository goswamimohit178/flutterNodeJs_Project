import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../model/pets.dart';

class PetsProvider extends ChangeNotifier {
  static const apiEndpoint =
      'https://mocki.io/v1/19f59d44-d31d-4f2d-ae32-f1bdc6a0d0fe';

  bool isLoading = true;
  String error = '';
  Pets pets = Pets(data: []);
  Pets serachedPets = Pets(data: []);
  String searchText = '';

  //
  getDataFromAPI() async {
    try {
      Response response = await http.get(Uri.parse(apiEndpoint));
      if (response.statusCode == 200) {
        pets = petsFromJson(response.body);
      } else {
        error = response.statusCode.toString();
      }
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    updateData();
  }

  updateData() {
    serachedPets.data.clear();
    if (searchText.isEmpty) {
      serachedPets.data.addAll(pets.data);
    } else {
      serachedPets.data.addAll(pets.data
          .where((element) =>
              element.userName.toLowerCase().startsWith(searchText))
          .toList());
    }
    notifyListeners();
  }

  search(String username) {
    searchText = username;
    updateData();
  }
  //
}
