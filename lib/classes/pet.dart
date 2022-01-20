// To parse this JSON data, do
//
//     final pet = petFromJson(jsonString);

import 'dart:convert';

List<Pet> petFromJson(String str) => List<Pet>.from(json.decode(str).map((x) => Pet.fromJson(x)));

String petToJson(List<Pet> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pet {
  Pet({this.createdAt, this.name, this.avatar, this.bornAt, this.id, this.month});

  DateTime? createdAt;
  String? name;
  String? avatar;
  DateTime? bornAt;
  int? id;
  int? month;

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      name: json["name"],
      avatar: json["avatar"],
      bornAt: json["bornAt"] == null ? null : DateTime.parse(json["bornAt"]),
      month: json["month"]);

  Map<String, dynamic> toJson() => {"id": id, "createdAt": createdAt, "name": name, "avatar": avatar, "bornAt": bornAt, "month": month};
}
