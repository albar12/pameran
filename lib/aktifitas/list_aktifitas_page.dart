import 'package:flutter/material.dart';
import 'package:jadin_pameran/aktifitas/aktifitas_page.dart';
import 'package:jadin_pameran/home/home_page.dart';
import 'package:jadin_pameran/model/services_aktifitas.dart';

class ListAktifitasPage extends StatefulWidget {
  final String? session;
  const ListAktifitasPage({
    super.key,
    this.session,
  });

  @override
  State<ListAktifitasPage> createState() => _ListAktifitasPageState();
}

class _ListAktifitasPageState extends State<ListAktifitasPage> {
  TextEditingController search = TextEditingController();

  List listAktifitas = [];
  List results = [];

  Future? futureAktifitas;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListAktifitas(widget.session.toString(), search.text.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (ctx) => HomePage(
                            session: widget.session,
                          )),
                  (route) => true);
            },
          ),
          title: Text("List Aktifitas"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (ctx) => AktifitasPage(
                                session: widget.session,
                              )),
                      (route) => true);
                },
                child: Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                child: new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Card(
                    child: new ListTile(
                      leading: new Icon(Icons.search),
                      title: new TextField(
                        controller: search,
                        decoration: new InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                        ),
                        onChanged: ((value) {
                          results.clear();
                          getListAktifitas(widget.session.toString(),
                              search.text.toString());
                        }),
                      ),
                      trailing: new IconButton(
                        icon: new Icon(Icons.cancel),
                        onPressed: () {
                          search.clear();
                          getListAktifitas(widget.session.toString(),
                              search.text.toString());
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: futureAktifitas,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          getListAktifitas(widget.session.toString(),
                              search.text.toString());
                        },
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: listAktifitas.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("TID :"),
                                            Text(
                                              "${listAktifitas[index]['tid']}",
                                              style: TextStyle(),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("Catatan :"),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.87,
                                              child: Card(
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Colors
                                                        .white, //<-- SEE HERE
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                      child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "${listAktifitas[index]['catatan']}",
                                                      style: TextStyle(),
                                                    ),
                                                  )),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                "${listAktifitas[index]['create_adm']}"),
                                            Text(
                                                "${listAktifitas[index]['datetime']}")
                                          ],
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(SnackBar(
                                      //   content: Text("${listUnpacking[index]}"),
                                      //   duration: const Duration(seconds: 2),
                                      // ));
                                    },
                                  ),
                                ),
                              );
                            }),
                      );
                    } else {
                      return Center(
                        child: Container(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void getListAktifitas(String session, String search) {
    setState(() {
      results.clear();
    });
    futureAktifitas = ServicesAktifitas.getListAktifitas(session).then((value) {
      print(search);
      print(value?.data);

      if (value?.data != null) {
        if (search == '') {
          if (this.mounted) {
            setState(() {
              listAktifitas = value!.data!;
            });
          }
        } else {
          setState(() {
            results.clear();
          });
          for (var i = 0; i < value!.data!.length; i++) {
            if (value.data![i]['tid']
                    .toLowerCase()
                    .contains(search.toLowerCase()) ||
                value.data![i]['datetime']
                    .toLowerCase()
                    .contains(search.toLowerCase()) ||
                value.data![i]['catatan']
                    .toLowerCase()
                    .contains(search.toLowerCase())) {
              results.add(value.data![i]);
            }
          }

          if (this.mounted) {
            setState(() {
              listAktifitas = results;
            });
          }
        }
      } else {
        dialog(value?.errormsg);
      }
    });
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

    AlertDialog alertIndicator = AlertDialog(
      content: Container(
        height: 50,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext) {
        return msg != null ? alertDialog : alertIndicator;
      },
    );
  }
}
