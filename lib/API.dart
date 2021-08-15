import 'dart:async';
import 'package:http/http.dart' as http;

const baseUrl = "http://www.mocky.io/v2/5d565297300000680030a986";

class API {
  static Future getUsers() {
    var url = baseUrl;
    return http.get(url);
  }
}