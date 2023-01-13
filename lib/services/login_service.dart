// ignore_for_file: avoid_print

part of 'services.dart';

class LoginService {
  Client client = Client();

  Future login(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = {'email': email, 'password': password};
    var link = "$baseUrl/login";

    final Uri url = Uri.parse(link);
    final response = await client.post(url,
        headers: {"content-type": "application/json"}, body: json.encode(data));
    if (response.statusCode == 200) {
      var dtUser = json.decode(response.body);

      prefs.setString('id', dtUser["result"]["id_user"].toString());
      prefs.setString('nama', dtUser["result"]["nama"].toString());
      prefs.setString('id_group', dtUser["result"]["id_group"].toString());
      prefs.setString('email', dtUser["result"]["username"].toString());

      //Set State Variable
      userActiveNama = prefs.getString("nama");
      userActiveId = prefs.getString("id");
      userActiveGroupId = prefs.getString("id_group");
      userActiveEmail = prefs.getString("email");

      return true;
    } else {
      return false;
    }
  }

  Future getAplikasi() async {
    var link = "$baseUrl/$userActiveId/get-aplikasi";

    final Uri url = Uri.parse(link);
    final response =
        await client.get(url, headers: {"content-type": "application/json"});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      var data = ErrorData(400).toJson();
      return data;
    }
  }
}
