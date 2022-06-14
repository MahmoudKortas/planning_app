import 'dart:convert';

import 'parent_model.dart';

// ignore: non_constant_identifier_names
List<LocationsModel> LocationsModelFromJson(String str) {
  return List<LocationsModel>.from(
      json.decode(str).map((x) => LocationsModel.fromJson(x)));
}

// ignore: non_constant_identifier_names
String LocationsModelToJson(List<LocationsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationsModel {
  String? id;
  String? name;
  String? disassembledName;
  List<double>? coord;
  String? type;
  int? matchQuality;
  bool? isBest;
  Parent? parent;

  LocationsModel(
      {this.id,
      this.name,
      this.disassembledName,
      this.coord,
      this.type,
      this.matchQuality,
      this.isBest,
      this.parent});

  LocationsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    disassembledName = json['disassembledName'];
    coord = json['coord'].cast<double>();
    type = json['type'];
    matchQuality = json['matchQuality'];
    isBest = json['isBest'];
    parent =
        json['parent'] != null ? Parent.fromJson(json['parent']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['disassembledName'] = disassembledName;
    data['coord'] = coord;
    data['type'] = type;
    data['matchQuality'] = matchQuality;
    data['isBest'] = isBest;
    if (parent != null) {
      data['parent'] = parent!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'LocationsModel(id: $id, name: $name, disassembledName: $disassembledName, coord: $coord, type: $type, matchQuality: $matchQuality, isBest: $isBest, parent: $parent)';
  }
}
