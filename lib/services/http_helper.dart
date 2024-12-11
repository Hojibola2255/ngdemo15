
import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';
import 'package:http_interceptor/models/retry_policy.dart';
import 'log_service.dart';


class HttpInterceptor implements InterceptorContract {
  static String API_KEY = "live_25MQkrVdHQyw0AcUzRc7yxgCV3hG5Wvt0XcYPPFlJHEj7a8zS6YfEed4jkO6p6cB";

  // We need to intercept request
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      // Fetching access token from your local
      var accessToken = "";
      // Clear previous header and update it with updated token
      data.headers.clear();
      data.headers['x-api-key'] = API_KEY;
      data.headers['Content-type'] = 'application/json';
      LogService.i(data.toString());
    } catch (e) {
      LogService.e(e.toString());
    }
    return data;
  }

  // Currently we do not have any need to intercept response
  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode == 200 || data.statusCode == 201) {
      LogService.i(data.toString());
    } else {
      LogService.e(data.toString());
    }
    return data;
  }
}

class HttpRetryPolicy extends RetryPolicy {
  //Number of retry
  @override
  int maxRetryAttempts = 2;

  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    if (response.statusCode == 401) {
      // Load access and refresh token from local
      var accessToken = "";
      var refreshToken = "";

      // Call refresh token Api and get response
      // Map<String, String> headers = {'Content-type': 'application/json'};
      // headers.putIfAbsent("Authorization", () => 'Bearer $accessToken');
      // headers.putIfAbsent("RefreshToken", () => 'Bearer $refreshToken');
      // var response = await HttpService.GET(HttpService.API_REFRESH_TOKEN, HttpService.paramsEmpty());
      // Store access and refresh token to local

      return true;
    }
    return false;
  }
}

class HttpException implements Exception {
  final _message;
  final _prefix;

  HttpException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends HttpException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends HttpException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends HttpException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends HttpException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

//https://codewithandrea.com/articles/flutter-exception-handling-try-catch-result-type/