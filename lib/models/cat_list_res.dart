// To parse this JSON data, do
//
//     final catListRes = catListResFromJson(jsonString);

import 'dart:convert';

List<CatListRes> catListResFromJson(String str) => List<CatListRes>.from(json.decode(str).map((x) => CatListRes.fromJson(x)));

String catListResToJson(List<CatListRes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CatListRes {
  List<dynamic> breeds;
  String id;
  String url;
  int width;
  int height;
  String? subId;
  DateTime createdAt;
  String originalFilename;
  dynamic breedIds;

  CatListRes({
    required this.breeds,
    required this.id,
    required this.url,
    required this.width,
    required this.height,
    required this.subId,
    required this.createdAt,
    required this.originalFilename,
    required this.breedIds,
  });

  factory CatListRes.fromJson(Map<String, dynamic> json) => CatListRes(
    breeds: List<dynamic>.from(json["breeds"].map((x) => x)),
    id: json["id"],
    url: json["url"],
    width: json["width"],
    height: json["height"],
    subId: json["sub_id"],
    createdAt: DateTime.parse(json["created_at"]),
    originalFilename: json["original_filename"],
    breedIds: json["breed_ids"],
  );

  Map<String, dynamic> toJson() => {
    "breeds": List<dynamic>.from(breeds.map((x) => x)),
    "id": id,
    "url": url,
    "width": width,
    "height": height,
    "sub_id": subId,
    "created_at": createdAt.toIso8601String(),
    "original_filename": originalFilename,
    "breed_ids": breedIds,
  };
}