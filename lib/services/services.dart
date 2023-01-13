import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';

part 'login_service.dart';

// String baseUrl = "http://196.160.22.76:83/api";
// String baseWeb = "http://196.160.22.76:83/";

String baseUrl = "http://192.168.3.17/identity-management-system/public/api";
String baseWeb = "http://192.168.3.17/identity-management-system/public/";

String? userActiveNama;
String? userActiveId;
String? userActiveGroupId;
String? userActiveEmail;

class ErrorData {
  final int kode;

  ErrorData(this.kode);

  Map<String, dynamic> toJson() => {'code': kode};
}
