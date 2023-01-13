// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages, deprecated_member_use, prefer_const_constructors, use_build_context_synchronously, unnecessary_brace_in_string_interps, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shorcut_au/login.dart';
import 'package:supercharged/supercharged.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'services/services.dart';

class IntegratedCampus extends StatefulWidget {
  const IntegratedCampus({Key? key}) : super(key: key);

  @override
  _IntegratedCampusState createState() => _IntegratedCampusState();
}

class _IntegratedCampusState extends State<IntegratedCampus> {
  Color blueCustom = "015060".toColor();
  Map<String, dynamic>? dtAll;
  List? aplKedua = [];
  LoginService service = LoginService();
  bool valData = false, koneksiLokal = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  cekKoneksi() async {
    koneksiLokal = false;
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

  getData() async {
    // aplKedua = [];
    await cekKoneksi();

    if (koneksiLokal) {
      dtAll = await service.getAplikasi();

      if (dtAll!['code'] == 200) {
        aplKedua = dtAll!['result']['aplikasi2'];
        valData = aplKedua!.isEmpty ? true : false;
      } else {
        valData = true;
      }

      setState(() {});
    } else {
      EasyLoading.showError('Gunakan koneksi lokal');
      EasyLoading.dismiss();
    }
  }

  void _loadFromUrl(int index) async {
    EasyLoading.show(status: 'Memuat...');
    await cekKoneksi();

    if (koneksiLokal) {
      bool sso = aplKedua![index]['sso'] == "0" ? true : false;
      String url = sso
          ? '${aplKedua![index]['url']}/otomatis/$userActiveEmail'
          : aplKedua![index]['url'];

      Uri urlLink = Uri.parse(url);
      http.Response response = await http.get(urlLink);

      if (response.statusCode == 200) {
        launchUrl(urlLink, mode: LaunchMode.externalApplication);
        EasyLoading.dismiss();
      } else {
        EasyLoading.showError('Coba Lagi');
        EasyLoading.dismiss();
      }
    } else {
      EasyLoading.showError('Gunakan koneksi lokal');
      EasyLoading.dismiss();
    }
  }

  Future refreshData() async {
    // aplKedua!.clear();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 24,
        ),
        Text(
          "Integrated Campus",
          style: GoogleFonts.poppins().copyWith(
              fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
        ),
        const SizedBox(
          height: 24,
        ),
        Expanded(
            child: RefreshIndicator(
          onRefresh: refreshData,
          child: aplKedua!.isEmpty
              ? Text(
                  valData
                      ? "Tidak ada aplikasi"
                      : "Memuat data, harap tunggu ...",
                  style: GoogleFonts.poppins().copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white))
              : AlignedGridView.count(
                  padding:
                      const EdgeInsets.only(left: 24, right: 24, bottom: 0),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  itemCount: aplKedua!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _loadFromUrl(index);
                      },
                      child: Image(
                        image: NetworkImage(
                            '${baseWeb}/images/uploads/${aplKedua![index]['icon']}'),
                        fit: BoxFit.contain,
                      ),
                    );
                  }),
        )),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 14, bottom: 14),
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(
                      'Keluar Aplikasi',
                      textAlign: TextAlign.center,
                    ),
                    content: const Text(
                      'Apakah anda ingin keluar dari aplikasi ?',
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  side: BorderSide(
                                    width: 1.5,
                                    color: blueCustom,
                                  ),
                                  primary: Colors.white,
                                  onPrimary: blueCustom),
                              child: const Text('Tidak'),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () async {
                                userActiveNama = "";
                                userActiveId = "";
                                userActiveGroupId = "";
                                userActiveEmail = "";

                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();

                                await preferences.clear();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              },
                              style:
                                  ElevatedButton.styleFrom(primary: blueCustom),
                              child: Text('Ya'),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                elevation: 0,
              ),
              child: Text(
                "Keluar",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: blueCustom,
                  fontWeight: FontWeight.w500,
                ),
              )),
        ),
      ],
    );
  }
}
