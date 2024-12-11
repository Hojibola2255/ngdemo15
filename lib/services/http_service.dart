import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../models/cat_list_res.dart';
import '../models/cat_upload_res.dart';
import 'http_helper.dart';

//https://api.thecatapi.com/v1/images/?limit=20&page=0&order=DESC
//https://api.thecatapi.com/v1/images/upload

class Network {
  static bool isTester = true;
  static String SERVER_DEV = "api.thecatapi.com";
  static String SERVER_PROD = "api.thecatapi.com";

  static final client = InterceptedClient.build(
    interceptors: [HttpInterceptor()],
    retryPolicy: HttpRetryPolicy(),
  );

  static String getServer() {
    if (isTester) return SERVER_DEV;
    return SERVER_PROD;
  }

  /* Http Requests */
  static Future<String?> GET(String api, Map<String, String> params) async {
    try {
      var uri = Uri.https(getServer(), api, params);
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        _throwException(response);
      }
    } on SocketException catch (_) {
      // if the network connection fails
      rethrow;
    }
  }

  static Future<String?> POST(String api, Map<String, String> params) async {
    try {
      var uri = Uri.https(getServer(), api, params);
      var response = await client.post(uri, body: jsonEncode(params));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        _throwException(response);
      }
    } on SocketException catch (_) {
      // if the network connection fails
      rethrow;
    }
  }

  static Future<String?> PUT(String api, Map<String, String> params) async {
    try {
      var uri = Uri.https(getServer(), api, params);
      var response = await client.put(uri, body: jsonEncode(params));
      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.body;
      } else {
        _throwException(response);
      }
    } on SocketException catch (_) {
      // if the network connection fails
      rethrow;
    }
  }

  static Future<String?> DEL(String api, Map<String, String> params) async {
    try {
      var uri = Uri.https(getServer(), api, params);
      var response = await client.delete(uri);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        _throwException(response);
      }
    } on SocketException catch (_) {
      // if the network connection fails
      rethrow;
    }
  }

  static _throwException(Response response) {
    String reason = response.reasonPhrase!;
    switch (response.statusCode) {
      case 400:
        throw BadRequestException(reason);
      case 401:
        throw InvalidInputException(reason);
      case 403:
        throw UnauthorisedException(reason);
      case 404:
        throw FetchDataException(reason);
      case 500:
      default:
        throw FetchDataException(reason);
    }
  }

  static Future<String?> MUL(String api, File file, Map<String, String> params) async {

    try {
      var uri = Uri.https(getServer(), api); // http or https
      var request = MultipartRequest('POST', uri);
      request.headers['x-api-key'] = HttpInterceptor.API_KEY;
      request.headers['Content-Type'] = 'multipart/form-data';

      request.files.add(
        http.MultipartFile('file', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split("/").last, contentType: MediaType('image', 'jpeg'),),
      );
      request.fields.addAll(params);

      StreamedResponse streamedResponse = await request.send();
      var response = await Response.fromStream(streamedResponse);
      if (response.statusCode == 201) {
        return response.body;
      } else {
        _throwException(response);
      }
    } on SocketException catch (_) {
      // if the network connection fails
      rethrow;
    }
  }

  /* Http Apis*/
  static String API_CAT_LIST = "/v1/images";
  static String API_CAT_UPLOAD = "/v1/images/upload";

  /* Http Params */
  static Map<String, String> paramsEmpty() {
    Map<String, String> params = Map();
    return params;
  }

  //limit=20&page=0&order=DESC
  static Map<String, String> paramsCatList() {
    Map<String, String> params = new Map();
    params.addAll({'limit': "20", 'page': "0", 'order': "DESC"});
    return params;
  }

/* Http Parsing */

  static List<CatListRes> parseCatList(String response) {
    dynamic json = jsonDecode(response);
    return List<CatListRes>.from(json.map((x) => CatListRes.fromJson(x)));
  }

  static CatUploadRes parseCatUpload(String response) {
    dynamic json = jsonDecode(response);
    return CatUploadRes.fromJson(json);
  }
}