// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shorcut_au/main.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:supercharged/supercharged.dart';

class Koneksi extends StatefulWidget {
  const Koneksi({super.key});

  @override
  State<Koneksi> createState() => _KoneksiState();
}

class _KoneksiState extends State<Koneksi> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: "015060".toColor(),
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 34),
                  child: Text(
                    "Tidak terhubung",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 34),
                  child: Text(
                    "Aktifkan koneksi lokal terlebih dahulu, kemudian coba kembali",
                    style: GoogleFonts.poppins(
                      color: Colors.white60,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 44, bottom: 14),
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 54),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => MyApp()),
                            (Route<dynamic> route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        elevation: 0,
                      ),
                      child: Text(
                        "Coba Kembali",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ),
              ]),
        ),
      ),
    );
  }
}
