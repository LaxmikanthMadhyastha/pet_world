import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pet_world/classes/pet.dart';
import 'package:pet_world/constants.dart';

class PetWorldService {
  Future<List<Pet>> getAllAnimals({int? page, int? limit, String searchParam = '', String sort = 'desc'}) async {
    List<Pet> petList = [];
    late Uri url;
    if (searchParam.length > 3) {
      url = Uri.parse(API.baseUrl + '?page=$page&limit=$limit&name=$searchParam&sortBy=bornAt&order=$sort');
    } else {
      url = Uri.parse(API.baseUrl + '?page=$page&limit=$limit&sortBy=bornAt&order=$sort');
    }
    var response = await http.get(url);
    if (response.statusCode == 200) {
      try {
        var jsonData = json.decode(response.body);
        jsonData.forEach((ele) {
          Pet pet = Pet.fromJson(ele);
          pet.month = (DateTime.now().difference(pet.bornAt!).inDays) ~/ 30;
          petList.add(pet);
        });
      } catch (e) {}
    }
    return petList;
  }
}
