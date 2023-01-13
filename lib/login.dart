// ignore_for_file: prefer_const_constructors, unnecessary_this, must_call_super, annotate_overrides, avoid_print, iterable_contains_unrelated_type, deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shorcut_au/services/services.dart';
import 'package:supercharged/supercharged.dart';

import 'main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late bool isLoading = false, statusObsecure = true, emailValid, passwordValid;
  late double height, width, defaultMargin = 14.0;
  Color blueCustom = "015060".toColor();
  Color whiteCustom = Colors.white70;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ImageProvider bgFull = AssetImage("assets/images/bg.png");

  LoginService service = LoginService();

  void initState() {
    isLoading = false;

    super.initState();
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Keluar Aplikasi',
              textAlign: TextAlign.center,
            ),
            content: Text(
              'Apakah anda ingin keluar dari aplikasi ?',
              textAlign: TextAlign.center,
            ),
            actions: [
              Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(
                            width: 1.5,
                            color: blueCustom,
                          ),
                          primary: Colors.white,
                          onPrimary: blueCustom),
                      child: Text('Tidak'),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();

                        await preferences.clear();
                        exit(0);
                      },
                      style: ElevatedButton.styleFrom(primary: blueCustom),
                      child: Text('Iya'),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              )
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(bgFull, context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: blueCustom),
            ),
            SafeArea(
                child: Center(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: width / 2,
                        height: height / 5,
                        margin: EdgeInsets.only(bottom: 45, top: 10),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/logo_seskoau.png"))),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(
                            defaultMargin, 6, defaultMargin, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Log in.",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Selamat datang, silahkan masukkan data anda.",
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 60,
                        margin: EdgeInsets.fromLTRB(
                            defaultMargin, defaultMargin, defaultMargin, 6),
                        child: TextFormField(
                          cursorColor: whiteCustom,
                          controller: emailController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(color: whiteCustom),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: whiteCustom),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: whiteCustom),
                            ),
                            prefixIcon: Icon(
                              Icons.account_circle,
                              color: whiteCustom,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 60,
                        margin: EdgeInsets.fromLTRB(
                            defaultMargin, defaultMargin, defaultMargin, 6),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: statusObsecure,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: whiteCustom),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: whiteCustom),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: whiteCustom),
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: whiteCustom,
                            ),
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                statusObsecure ? Icons.lock_open : Icons.lock,
                                color: whiteCustom,
                              ),
                              onPressed: () {
                                setState(() {
                                  statusObsecure
                                      ? statusObsecure = false
                                      : statusObsecure = true;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 34, bottom: 6),
                        height: 60,
                        padding:
                            EdgeInsets.symmetric(horizontal: defaultMargin),
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                              });

                              if (emailController.text == "" ||
                                  passwordController.text == "") {
                                setState(() {
                                  isLoading = false;
                                });

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.red[600],
                                  content: Text(
                                      'Harap masukkan Username dan Password.'),
                                ));
                              } else {
                                service
                                    .login(emailController.text,
                                        passwordController.text)
                                    .then((val) async {
                                  if (val) {
                                    setState(() {
                                      isLoading = false;
                                    });

                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => MyHomePage(
                                                  title: "SESKOAU",
                                                )),
                                        (Route<dynamic> route) => false);
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });

                                    return ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.red[600],
                                      content: Text(
                                          'Cek kembali apakah username dan password sudah benar.'),
                                    ));
                                  }
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              elevation: 0,
                            ),
                            child: isLoading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        blueCustom),
                                  )
                                : Text(
                                    "Masuk",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: blueCustom,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )),
                      ),
                    ],
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
