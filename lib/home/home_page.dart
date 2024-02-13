import 'package:flutter/material.dart';
import 'package:jadin_pameran/aktifitas/aktifitas_page.dart';
import 'package:jadin_pameran/aktifitas/list_aktifitas_page.dart';
import 'package:jadin_pameran/laporan_pemasangan/laporan_pemasangan.dart';
import 'package:jadin_pameran/laporan_penarikan/laporan_penarikan.dart';
import 'package:jadin_pameran/logout/logout_page.dart';
import 'package:jadin_pameran/model/shared_preferances.dart';
import 'package:jadin_pameran/pemasangan/pemasangan_form_page.dart';
import 'package:jadin_pameran/pemasangan/pemasangan_page.dart';
import 'package:jadin_pameran/penarikan/penarikan_page.dart';
import 'package:jadin_pameran/qc/qc_page.dart';

class HomePage extends StatefulWidget {
  final String? session;
  const HomePage({
    super.key,
    this.session,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? session;
  String? name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _drawerHeader(),
            ListTile(
                title: Row(
                  children: [
                    Icon(Icons.logout),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0),
                      child: Text(
                        "Logout",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                onTap: (() {
                  return showLogoutDialog(session.toString());
                }))
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 155,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.blue,
                                  child: Icon(
                                    Icons.schedule,
                                    size: 50.0,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Aktifitas",
                                  style: TextStyle(
                                    fontFamily: 'NotoSerif',
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          )),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (ctx) => ListAktifitasPage(
                                    session: session,
                                  )),
                          (route) => true);
                    },
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 155,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.blue,
                                  child: Icon(
                                    Icons.install_mobile,
                                    size: 50.0,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "QC",
                                  style: TextStyle(
                                    fontFamily: 'NotoSerif',
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          )),
                        ),
                      ),
                    ),
                    onTap: () {
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //   content: Text("${session}"),
                      //   duration: const Duration(seconds: 1),
                      // ));

                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (ctx) => QcPage(
                                    session: session,
                                  )),
                          (route) => true);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 155,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.blue,
                                  child: Icon(
                                    Icons.install_mobile,
                                    size: 50.0,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Pemasangan",
                                  style: TextStyle(
                                    fontFamily: 'NotoSerif',
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          )),
                        ),
                      ),
                    ),
                    onTap: () {
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //   content: Text("${session}"),
                      //   duration: const Duration(seconds: 1),
                      // ));

                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (ctx) => PemasanganPage(
                                    session: session,
                                  )),
                          (route) => true);
                    },
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 155,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.blue,
                                  child: Icon(
                                    Icons.undo_outlined,
                                    size: 50.0,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Penarikan",
                                  style: TextStyle(
                                    fontFamily: 'NotoSerif',
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          )),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (ctx) => PenarikanPage(
                                    session: session,
                                  )),
                          (route) => true);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 155,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.blue,
                                  child: Icon(
                                    Icons.list_alt_outlined,
                                    size: 50.0,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Laporan Pemasangan",
                                  style: TextStyle(
                                    fontFamily: 'NotoSerif',
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          )),
                        ),
                      ),
                    ),
                    onTap: () {
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //   content: Text("${session}"),
                      //   duration: const Duration(seconds: 1),
                      // ));

                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (ctx) => LaporanPemasanganPage(
                                    session: session,
                                  )),
                          (route) => true);
                    },
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 155,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.blue,
                                  child: Icon(
                                    Icons.list_alt,
                                    size: 50.0,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Laporan Penarikan",
                                  style: TextStyle(
                                    fontFamily: 'NotoSerif',
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          )),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (ctx) => LaporanPenarikanPage(
                                    session: session,
                                  )),
                          (route) => true);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  load() async {
    session = await SharedPref.getString("session");
    name = await SharedPref.getString("name");
    print(session);
    if (this.mounted) {
      // check whether the state object is in tree
      setState(() {
        // make changes here
      });
    }
  }

  _drawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text(
        '${name}',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      accountEmail: Text(""),
    );
  }

  void showLogoutDialog(String session) {
    showDialog(
      context: context,
      builder: (BuildContext) {
        return LogoutPage(
          session: session,
        );
      },
    );
  }
}
