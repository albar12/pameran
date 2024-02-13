import 'package:flutter/material.dart';
import 'package:jadin_pameran/barcode_page.dart';
import 'package:jadin_pameran/data/data_ws.dart';
import 'package:jadin_pameran/home/home_page.dart';
import 'package:jadin_pameran/model/services_penarikan.dart';
import 'package:jadin_pameran/penarikan/detail_penarikan_page.dart';

class PenarikanPage extends StatefulWidget {
  final String? session;
  final String? sn_mesin;

  const PenarikanPage({
    super.key,
    this.session,
    this.sn_mesin,
  });

  @override
  State<PenarikanPage> createState() => _PenarikanPageState();
}

class _PenarikanPageState extends State<PenarikanPage> {
  TextEditingController tid = TextEditingController();
  TextEditingController search = TextEditingController();

  Future? futurePenarikan;

  List listPenarikan = [];
  List results = [];

  bool visible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.sn_mesin != null) {
      ubah_sn(widget.sn_mesin.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text("Penarikan"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'TID/MID/Merchant',
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                controller: tid,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    onPressed: (() {
                      setState(() {
                        visible = false;
                        tid.clear();
                      });
                    }),
                    child: Text("Cancel"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: (() {
                      if (tid.text.isEmpty) {
                        dialog(
                            "Silahkan Input TID/MID/Merchant Terlebih Dahulu!");
                      } else {
                        setState(() {
                          visible = true;
                        });

                        get_list_penarikan(widget.session.toString(),
                            tid.text.toString(), search.text.toString());
                      }
                    }),
                    child: Text("Cek"),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: futurePenarikan,
                builder: (context, snapshot) {
                  print(snapshot.connectionState);
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Visibility(
                      visible: visible,
                      child: Column(
                        children: [
                          listPenarikan.isNotEmpty
                              ? ListView.builder(
                                  // scrollDirection: Axis.vertical,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: listPenarikan.length,
                                  // itemCount: 10,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      elevation: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Card(
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                      color: Colors
                                                          .deepPurpleAccent, //<-- SEE HERE
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  color: Colors.blue[300],
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                        child: Text(
                                                      "${listPenarikan[index]['MERCHANT']}",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    )),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("MID :"),
                                                      Text(
                                                          "${listPenarikan[index]['MID']}"),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("TID :"),
                                                      Text(
                                                          "${listPenarikan[index]['TID']}"),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (ctx) =>
                                                            DetailPenarikanPage(
                                                              session: widget
                                                                  .session,
                                                              id_jo:
                                                                  listPenarikan[
                                                                          index]
                                                                      ['IDX'],
                                                            )),
                                                    (route) => true);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Container(
                                    child: Text("Data Kosong"),
                                  ),
                                ),
                        ],
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: Container(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void ubah_sn(String snMesin) {
    if (this.mounted) {
      setState(() {
        tid.text = snMesin;
      });
    }
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

  void get_list_penarikan(String session, String tid, String search) {
    futurePenarikan =
        ServicesPenarikan.getListPenarikan(session, tid).then((value) {
      if (value?.data != null) {
        // pemasanganList = value!.data!;
        if (search == '') {
          if (this.mounted) {
            setState(() {
              listPenarikan = value!.data!;
            });
          }
        } else {
          setState(() {
            results.clear();
          });
          for (var i = 0; i < value!.data!.length; i++) {
            if (value.data![i]['sn']
                .toLowerCase()
                .contains(search.toLowerCase())) {
              results.add(value.data![i]);
            }
          }

          if (this.mounted) {
            setState(() {
              listPenarikan = results;
            });
          }
        }
      } else {
        dialog(value?.errormsg);
      }
    });
  }
}
