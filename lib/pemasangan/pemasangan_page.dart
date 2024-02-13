import 'package:flutter/material.dart';
import 'package:jadin_pameran/barcode_page.dart';
import 'package:jadin_pameran/home/home_page.dart';
import 'package:jadin_pameran/model/services_pemasangan.dart';
import 'package:jadin_pameran/pemasangan/pemasangan_form_page.dart';

class PemasanganPage extends StatefulWidget {
  final String? session;
  final String? sn_mesin;

  const PemasanganPage({
    super.key,
    this.session,
    this.sn_mesin,
  });

  @override
  State<PemasanganPage> createState() => _PemasanganPageState();
}

class _PemasanganPageState extends State<PemasanganPage> {
  TextEditingController sn = TextEditingController();
  TextEditingController search = TextEditingController();

  bool visible = false;

  List pemasanganList = [];
  List results = [];

  Future? pemasanganFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.sn_mesin != null) {
      ubah_sn(widget.sn_mesin.toString());
    }
    // get_list_pemasangan(
    //     widget.session.toString(), sn.text.toString(), search.text.toString());
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
        title: Text("Pemasangan"),
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
                        visible = false;
                        sn.clear();
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
                future: pemasanganFuture,
                builder: (context, snapshot) {
                  print(snapshot.connectionState);
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Visibility(
                      visible: visible,
                      child: Column(
                        children: [
                          pemasanganList.isNotEmpty
                              ? ListView.builder(
                                  // scrollDirection: Axis.vertical,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: pemasanganList.length,
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
                                                          "No : ${pemasanganList[index]['IDJO']}"),
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
                                                      "${pemasanganList[index]['MERCHANT']}",
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
                                                          "${pemasanganList[index]['MID']}"),
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
                                                          "${pemasanganList[index]['TID']}"),
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
                                                            PemasanganFormPage(
                                                              session: widget
                                                                  .session,
                                                              id: pemasanganList[
                                                                  index]['IDX'],
                                                              tid:
                                                                  pemasanganList[
                                                                          index]
                                                                      ['TID'],
                                                              fotoMesinNetwork:
                                                                  pemasanganList[
                                                                          index]
                                                                      [
                                                                      'FOTO_MESIN'],
                                                              fotoStrukNetwork:
                                                                  pemasanganList[
                                                                          index]
                                                                      [
                                                                      'FOTO_STRUK'],
                                                              idjo:
                                                                  pemasanganList[
                                                                          index]
                                                                      ['IDJO'],
                                                              tids: pemasanganList[
                                                                      index][
                                                                  'TID_Merchant'],
                                                              area:
                                                                  pemasanganList[
                                                                          index]
                                                                      ['AREA'],
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
    if (mid != '' && mid != null) {
      pemasanganFuture =
          ServicesPemasangan.getListPemasanganTeknisi(session, mid)
              .then((value) {
        if (value?.data != null) {
          // pemasanganList = value!.data!;
          if (search == '') {
            if (this.mounted) {
              setState(() {
                pemasanganList = value!.data!;
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
                pemasanganList = results;
              });
            }
          }
        } else {
          dialog(value?.errormsg);
        }

        print(pemasanganList.isNotEmpty);
      });
    } else {
      pemasanganFuture =
          ServicesPemasangan.getListPemasanganTeknisi2(session).then((value) {
        if (value?.data != null) {
          // pemasanganList = value!.data!;
          if (search == '') {
            if (this.mounted) {
              setState(() {
                pemasanganList = value!.data!;
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
                pemasanganList = results;
              });
            }
          }
        } else {
          dialog(value?.errormsg);
        }

        print(pemasanganList.isNotEmpty);
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
