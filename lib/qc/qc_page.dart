import 'package:flutter/material.dart';
import 'package:jadin_pameran/home/home_page.dart';
import 'package:jadin_pameran/model/services_pemasangan.dart';
import 'package:jadin_pameran/qc/qc_form_page.dart';

class QcPage extends StatefulWidget {
  final String? session;
  final String? sn_mesin;

  const QcPage({
    super.key,
    this.session,
    this.sn_mesin,
  });

  @override
  State<QcPage> createState() => _QcPageState();
}

class _QcPageState extends State<QcPage> {
  TextEditingController sn = TextEditingController();
  TextEditingController search = TextEditingController();

  bool visible = false;

  List qcList = [];
  List results = [];

  Future? qcFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.sn_mesin != null) {
      ubah_sn(widget.sn_mesin.toString());
    }

    get_list_pemasangan(
        widget.session.toString(), sn.text.toString(), search.text.toString());
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
        title: Text("QC"),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
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
                controller: sn,
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
                        // visible = false;
                        sn.clear();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (ctx) => QcPage(
                                      session: widget.session,
                                    )),
                            (route) => true);
                      });
                    }),
                    child: Text("Cancel"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: (() {
                      if (sn.text.isEmpty) {
                        dialog(
                            "Silahkan Input TID/MID/Merchant Terlebih Dahulu");
                      } else {
                        setState(() {
                          visible = true;
                        });

                        get_list_pemasangan(widget.session.toString(),
                            sn.text.toString(), search.text.toString());
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
                future: qcFuture,
                builder: (context, snapshot) {
                  print(snapshot.connectionState);
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Visibility(
                      // visible: visible,
                      visible: true,
                      child: Column(
                        children: [
                          qcList.isNotEmpty
                              ? ListView.builder(
                                  // scrollDirection: Axis.vertical,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: qcList.length,
                                  // itemCount: 10,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      elevation: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          "No : ${qcList[index]['IDX']}"),
                                                      // Text(
                                                      //     "${qcList[index]['IDX']}"),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(""),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
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
                                                      "${qcList[index]['MERCHANT']}",
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
                                                          "${qcList[index]['MID']}"),
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
                                                          "${qcList[index]['TID']}"),
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
                                                            QcFormPage(
                                                              session: widget
                                                                  .session,
                                                              id: qcList[index]
                                                                  ['IDX'],
                                                              tid: qcList[index]
                                                                  ['TID'],
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

  void get_list_pemasangan(String session, String mid, String search) {
    if (mid != null && mid != '') {
      qcFuture =
          ServicesPemasangan.getListPemasangan(session, mid).then((value) {
        if (value?.data != null) {
          // pemasanganList = value!.data!;
          if (search == '') {
            if (this.mounted) {
              setState(() {
                qcList = value!.data!;
              });
            }
          } else {
            setState(() {
              results.clear();
            });
            for (var i = 0; i < value!.data!.length; i++) {
              if (value.data![i]['tid']
                  .toLowerCase()
                  .contains(search.toLowerCase())) {
                results.add(value.data![i]);
              }
            }

            if (this.mounted) {
              setState(() {
                qcList = results;
              });
            }
          }
        } else {
          dialog(value?.errormsg);
        }

        print(qcList.isNotEmpty);
      });
    } else {
      qcFuture = ServicesPemasangan.getListQC(session).then((value) {
        if (value?.data != null) {
          // pemasanganList = value!.data!;
          if (search == '') {
            if (this.mounted) {
              setState(() {
                qcList = value!.data!;
              });
            }
          } else {
            setState(() {
              results.clear();
            });
            for (var i = 0; i < value!.data!.length; i++) {
              if (value.data![i]['tid']
                  .toLowerCase()
                  .contains(search.toLowerCase())) {
                results.add(value.data![i]);
              }
            }

            if (this.mounted) {
              setState(() {
                qcList = results;
              });
            }
          }
        } else {
          dialog(value?.errormsg);
        }

        print(qcList.isNotEmpty);
      });
    }
  }

  void ubah_sn(String snMesin) {
    if (this.mounted) {
      setState(() {
        sn.text = snMesin;
      });
    }
  }
}
