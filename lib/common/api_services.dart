import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mains/common/utils.dart';
import 'package:mains/my_mains_view/logIn_flow/logIn_page_screen/User_Login_option.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'exception.dart';

Future<dynamic> callWebApi(
  TickerProvider? tickerProvider,
  String url,
  Map data, {
  required Function onResponse,
  Function? onError,
  String token = "",
  bool showLoader = true,
  bool hideLoader = true,
  String authPrefix = "Bearer",
}) async {
  if (showLoader && tickerProvider != null)
    Utils.showLoaderDialogNew(tickerProvider);
  try {
    Utils.print('request url: ' + url);
    Utils.print('request data: ' + json.encode(data).toString());

    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
    };
    headers.addIf(token.isNotEmpty, "Authorization", "$authPrefix $token");
    Utils.print('headers: ' + json.encode(headers));

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(data),
    );

    return _returnResponse(response, onResponse, onError, hideLoader);
  } on SocketException catch (e) {
    Utils.print(e.toString());
    if (onError != null) {
      onError();
    }
    Utils.showToast('No Internet Connection');
    if (hideLoader) Utils.hideLoader();
    return;
  } catch (e) {
    if (onError != null) {
      onError();
    }
    Utils.print(e.toString());
    Utils.showToast('Something went wrong');
    if (hideLoader) Utils.hideLoader();
  }
}

Future<dynamic> callWebApiGet(
  TickerProvider? tickerProvider,
  String url, {
  required Function onResponse,
  Function? onError,
  String token = "",
  bool showLoader = true,
  bool hideLoader = true,
  String authPrefix = "Bearer",
}) async {
  if (showLoader && tickerProvider != null)
    Utils.showLoaderDialogNew(tickerProvider);
  try {
    Utils.print('request url: ' + url);

    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
    };
    headers.addIf(token.isNotEmpty, "Authorization", "$authPrefix $token");
    print('Request headers: ' + headers.toString());
    Utils.print('headers: ' + json.encode(headers));

    final http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    return _returnResponse(response, onResponse, onError, hideLoader);
  } on SocketException catch (e) {
    Utils.print(e.toString());
    if (onError != null) {
      onError();
    }
    Utils.showToast('No Internet Connection');
    if (hideLoader) Utils.hideLoader();
    return;
  } catch (e) {
    if (onError != null) {
      onError();
    }
    Utils.print(e.toString());
    Utils.showToast('Something went wrong');
    if (hideLoader) Utils.hideLoader();
  }
}

_returnResponse(
  http.Response response,
  Function onResponse,
  Function? onError,
  bool hideLoader,
) async {
  if (hideLoader) Utils.hideLoader();

  Utils.print('response code:' + response.statusCode.toString());
  Utils.print('response :' + response.body.toString());

  Map? responseJson = {};
  try {
    responseJson = jsonDecode(response.body);
  } catch (exception) {
    responseJson = {};
    Utils.print("Error parsing response: " + exception.toString());
  }

  switch (response.statusCode) {
    case 200:
      onResponse(response);
      return 'responseJson';
    case 400:
      Utils.showToast(
        responseJson?['message'] ??
            "You've reached the maximum number of OTP requests. Please try again later.",
      );
      if (onError != null) {
        onError();
      }
      throw BadRequestException(response.body.toString());
    case 404:
      if (onError != null) {
        onError();
      }
      throw InvalidInputException(response.body.toString());
    case 401:
    case 403:
      if (onError != null) {
        onError();
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Get.offAll(() => User_Login_option());
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      Utils.showToast(responseJson?['message'] ?? "Internal server error");
      if (onError != null) {
        onError();
      }
      throw FetchDataException(
        'Error occurred while Communication with Server with StatusCode : ${response.statusCode}',
      );
  }
}

Future<dynamic> callMultipartWebApi(
  TickerProvider? tickerProvider,
  String url,
  Map<String, String> data,
  List<http.MultipartFile> files, {
  required Function onResponse,
  Function? onError,
  required String token,
  bool showLoader = true,
  bool hideLoader = true,
  String authPrefix = "Bearer",
}) async {
  if (showLoader && tickerProvider != null)
    Utils.showLoaderDialogNew(tickerProvider);

  var request = http.MultipartRequest("POST", Uri.parse(url));

  Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json',
    'Authorization': '$authPrefix $token',
  };

  Utils.print('request url: ' + url);
  Utils.print('request data: ' + data.toString());
  Utils.print('headers: ' + json.encode(headers));

  request.headers.addAll(headers);

  try {
    request.fields.addAll(data);
    for (http.MultipartFile file in files) {
      request.files.add(file);
      Utils.print('request file: ' + file.filename!);
    }
  } catch (e) {
    Utils.print("Error adding request : " + e.toString());
    if (hideLoader) Utils.hideLoader(); // Hide loader on error
  }

  try {
    var response = await request.send();
    return returnMutipartResponse(response, onResponse, onError, hideLoader);
  } on SocketException catch (e) {
    Utils.print(e.toString());
    if (onError != null) {
      onError();
    }
    Utils.showToast('No Internet Connection');
    if (hideLoader) Utils.hideLoader(); // Hide loader on error
    return;
  } catch (e) {
    if (onError != null) {
      onError();
    }
    Utils.print(e.toString());
    Utils.showToast('Something went wrong');
    if (hideLoader) Utils.hideLoader(); // Hide loader on error
  }
}

returnMutipartResponse(
  http.StreamedResponse response,
  Function onResponse,
  Function? onError,
  bool hideLoader,
) async {
  Utils.print('response code:' + response.statusCode.toString());
  Map? responseJson = {};
  try {
    responseJson = json.decode(await response.stream.bytesToString());
    Utils.print('response :' + responseJson.toString());
  } catch (exception) {
    responseJson!['message'] = "Something went wrong";
    Utils.print(exception.toString());
  }
  switch (response.statusCode) {
    case 200:
      if (hideLoader) Utils.hideLoader();
      onResponse(responseJson);
      return 'responseJson';
    case 400:
      Utils.showToast(responseJson!['message']);
      if (onError != null) {
        onError();
      }
      if (hideLoader) Utils.hideLoader(); // Hide loader on error
      throw BadRequestException(responseJson.toString());
    case 404:
      if (onError != null) {
        onError();
      }
      Utils.hideLoader();
      Utils.showToast(responseJson!['message']);
      throw InvalidInputException(responseJson.toString());
    case 401:
    case 403:
      if (onError != null) {
        onError();
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Get.offAll(() => User_Login_option());
      throw UnauthorisedException(responseJson.toString());
    case 500:
    default:
      Utils.showToast(responseJson!['message']);
      if (onError != null) {
        onError();
      }
      if (hideLoader) Utils.hideLoader(); // Hide loader on error
      throw FetchDataException(responseJson.toString());
  }
}
