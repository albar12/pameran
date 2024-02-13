import 'package:flutter/material.dart';
import 'package:jadin_pameran/data/data_ws.dart';
import 'package:jadin_pameran/login/login_page.dart';
import 'package:jadin_pameran/model/services_logout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutPage extends StatefulWidget {
  final String? session;
  const LogoutPage({
    super.key,
    this.session,
  });

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text("Apa Anda Yakin Akan Logout?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            print(widget.session.toString());
            DataWs? result =
                await ServicesLogout.logout(widget.session.toString());

            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) {
            //   return LoginPage();
            // }));
            print(result?.statuscode);
            if (result?.statuscode == '200' || result?.errormsg == null) {
              clearPrefs();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (ctx) => LoginPage()),
                  (route) => false);
            } else {
              dialog(result?.errormsg);
            }
          },
          child: Text("Oke"),
        )
      ],
    );
  }

  void dialog(String? msg) {
    TextButton okButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text("OK"),
    );

    AlertDialog alertDialog = AlertDialog(
      content: Text('${msg}'),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext) {
        return alertDialog;
      },
    );
  }

  clearPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
