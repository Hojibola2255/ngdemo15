// To parse this JSON data, do
//
//     final catUploadRes = catUploadResFromJson(jsonString);

import 'dart:convert';

CatUploadRes catUploadResFromJson(String str) => CatUploadRes.fromJson(json.decode(str));

String catUploadResToJson(CatUploadRes data) => json.encode(data.toJson());

class CatUploadRes {
  String id;
  String url;
  int width;
  int height;
  String originalFilename;
  int pending;
  int approved;

  CatUploadRes({
    required this.id,
    required this.url,
    required this.width,
    required this.height,
    required this.originalFilename,
    required this.pending,
    required this.approved,
  });

  factory CatUploadRes.fromJson(Map<String, dynamic> json) => CatUploadRes(
    id: json["id"],
    url: json["url"],
    width: json["width"],
    height: json["height"],
    originalFilename: json["original_filename"],
    pending: json["pending"],
    approved: json["approved"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
    "width": width,
    "height": height,
    "original_filename": originalFilename,
    "pending": pending,
    "approved": approved,
  };
}