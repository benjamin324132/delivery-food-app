import 'package:delivery_app/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Services {
  String baseurl = BASE_URL;
  FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<dynamic> logIn(
      String email, String password, String deviceToken) async {
    const String url = "$BASE_URL/api/v1/users/login";

    Map<String, String> headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "email": email.trim(),
      "password": password.trim(),
      "deviceToken": deviceToken
    });

    final response =
        await http.post(Uri.parse(url), body: body, headers: headers);

    if (response.statusCode == 201 || response.statusCode == 200) {
      var user = json.decode(response.body);
      return user;
    } else {
      //var error = json.decode(response.body);
      throw Exception("Error");
    }
  }

  Future<dynamic> signup(String name, String email, String phone,
      String password, String deviceToken) async {
    const String url = "$BASE_URL/api/v1/users";

    Map<String, String> headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "name": name,
      "phone": phone.trim(),
      "email": email.trim(),
      "password": password.trim(),
      "deviceToken": deviceToken
    });

    final response =
        await http.post(Uri.parse(url), body: body, headers: headers);

    if (response.statusCode == 201 || response.statusCode == 200) {
      var user = json.decode(response.body);
      return user;
    } else {
      //var error = json.decode(response.body);
      //throw Exception(error['message']);
      throw Exception("Error");
    }
  }

  Future<dynamic> getDishes(
      {String keyword = "", String pageNumber = ""}) async {
    String url =
        "$BASE_URL/api/v1/dishes?keyword=$keyword&pageNumber=$pageNumber";

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      var error = json.decode(response.body);
      throw Exception(error['message']);
    }
  }

  Future<dynamic> getDishesByLocation(
      {required double lat,
      required double long,
      String keyword = "",
      String pageNumber = ""}) async {
    String url =
        "$BASE_URL/api/v1/dishes/location/$lat/$long?keyword=$keyword&pageNumber=$pageNumber";

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      //var error = json.decode(response.body);
      //throw Exception(error['message']);
      //throw Exception("Error");
    }
  }

  Future<dynamic> getDish(id) async {
    String url = "$BASE_URL/api/v1/dishes/$id";

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      var error = json.decode(response.body);
      throw Exception(error['message']);
    }
  }

  Future<dynamic> crateOrder(dishes, deliveryAdress, lat, long) async {
    String? token = await storage.read(key: "jwt");
    String url = "$BASE_URL/api/v1/orders";

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };
    final body = jsonEncode({
      "dishes": dishes,
      "deliveryAdress": deliveryAdress,
      "lat": lat,
      "long": long,
    });

    var response =
        await http.post(Uri.parse(url), body: body, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      //var error = json.decode(response.body);
      //throw Exception(error['message']);
      throw Exception("Error");
    }
  }

  Future<dynamic> getMyOrders(
      {String keyword = "", String pageNumber = ""}) async {
    String? token = await storage.read(key: "jwt");
    String url =
        "$BASE_URL/api/v1/orders/myorders?keyword=$keyword&pageNumber=$pageNumber";

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };

    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      //var error = json.decode(response.body);
      //throw Exception(error['message']);
      throw Exception("Error");
    }
  }

  Future<dynamic> getOrderById(String id) async {
    String? token = await storage.read(key: "jwt");
    String url = "$BASE_URL/api/v1/orders/$id";

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };

    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      //var error = json.decode(response.body);
      //throw Exception(error['message']);
      throw Exception("Error");
    }
  }
}
