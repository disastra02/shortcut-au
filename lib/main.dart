// ignore_for_file: unnecessary_const, import_of_legacy_library_into_null_safe, library_private_types_in_public_api, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shorcut_au/integrated_campus.dart';
import 'package:shorcut_au/koneksi.dart';
import 'package:shorcut_au/login.dart';
import 'package:shorcut_au/services/services.dart';
import 'package:shorcut_au/smart_campus.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:supercharged/supercharged.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
  configLoading();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SESKOAU',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Splash(),
      builder: EasyLoading.init(),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late String userId;
  late bool userValidasi = false, koneksiLokal = false;

  @override
  void initState() {
    getUser();
    cekKoneksi();
    super.initState();
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getString("id") ?? "";
      userValidasi = userId != "" ? true : false;
      if (userValidasi) {
        userActiveNama = prefs.getString("nama");
        userActiveId = prefs.getString("id");
        userActiveGroupId = prefs.getString("id_group");
        userActiveEmail = prefs.getString("email");
      }
    });
  }

  cekKoneksi() async {
    try {
      // Uri urlLink = Uri.parse("http://196.160.22.57");
      Uri urlLink = Uri.parse("http://192.168.3.17");
      http.Response response = await http.get(urlLink);

      if (response.statusCode == 200) {
        koneksiLokal = true;
      } else {
        koneksiLokal = false;
      }
      setState(() {});
    } catch (e) {
      koneksiLokal = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 4,
        navigateAfterSeconds: koneksiLokal
            ? userValidasi
                ? const MyHomePage(title: "SESKO")
                : const Login()
            : const Koneksi(),
        image: Image.asset("assets/logo_seskoau.png"),
        backgroundColor: "015060".toColor(),
        photoSize: 60.0,
        loaderColor: Colors.white);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: const [
                Tab(
                  text: "Smart",
                ),
                Tab(
                  text: "Integrated",
                ),
              ],
            ),
          ),
          body: Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                    image: AssetImage('assets/images/bg.png'),
                    fit: BoxFit.cover)),
            child: const TabBarView(
              children: [SmartCampus(), IntegratedCampus()],
            ),
          ) // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }
}
