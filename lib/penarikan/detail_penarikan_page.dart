import 'dart:io' as Io;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jadin_pameran/barcode_page.dart';
import 'package:jadin_pameran/data/data_ws.dart';
import 'package:jadin_pameran/model/services_penarikan.dart';
import 'package:jadin_pameran/penarikan/penarikan_page.dart';

class DetailPenarikanPage extends StatefulWidget {
  final String? session;
  final String? id_jo;
  final String? sn_mesin;
  final String? pic_penyerahan;
  final List? tids_update2;
  final List? tids_update2_value;
  final Io.File? foto_merchant2;

  const DetailPenarikanPage({
    super.key,
    this.session,
    this.id_jo,
    this.sn_mesin,
    this.pic_penyerahan,
    this.tids_update2,
    this.tids_update2_value,
    this.foto_merchant2,
  });

  @override
  State<DetailPenarikanPage> createState() => _DetailPenarikanPageState();
}

class _DetailPenarikanPageState extends State<DetailPenarikanPage> {
  TextEditingController sn = TextEditingController();
  TextEditingController pic_penyerahan = TextEditingController();
  TextEditingController catatan_penyerahan = TextEditingController();

  Future? futurePenarikan;

  bool visible = false;

  List listPenarikan = [];
  List results = [];
  List tids_update = [];
  List tids_value = [];

  XFile? merchant;

  Io.File? file_merchant;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.sn_mesin != null) {
      ubah_sn(widget.sn_mesin.toString());
    }

    if (widget.tids_update2 != null && widget.tids_update2_value != null) {
      ubah_tids(widget.tids_update2!, widget.tids_update2_value!);
    }

    if (widget.pic_penyerahan != null) {
      ubah_pic(widget.pic_penyerahan.toString());
    }

    if (widget.foto_merchant2 != null) {
      if (this.mounted) {
        setState(() {
          file_merchant = widget.foto_merchant2;
        });
      }
    }

    get_list_penarikan(widget.session.toString(), widget.id_jo.toString());
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
                    builder: (ctx) => PenarikanPage(
                          session: widget.session,
                        )),
                (route) => true);
          },
        ),
        title: Text("Form Penarikan"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: futurePenarikan,
            builder: (context, snapshot) {
              print(snapshot.connectionState);
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: [
                    ListView.builder(
                      // scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listPenarikan.length,
                      // itemCount: 10,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'TID',
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              controller: TextEditingController(
                                text: "${listPenarikan[index]['TID']}",
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'MID',
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              controller: TextEditingController(
                                text: "${listPenarikan[index]['MID']}",
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Merchant',
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              controller: TextEditingController(
                                text: "${listPenarikan[index]['MERCHANT']}",
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Tipe EDC',
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              controller: TextEditingController(
                                text: "${listPenarikan[index]['TIPE_EDC']}",
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'PIC Merchant',
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              controller: TextEditingController(
                                text: "${listPenarikan[index]['PIC_MERCHANT']}",
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'No Telpon PIC',
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              controller: TextEditingController(
                                text: "${listPenarikan[index]['NO_TLPN_PIC']}",
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              readOnly: true,
                              maxLines: 3,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Catatan',
                              ),
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              controller: TextEditingController(
                                text: "${listPenarikan[index]['CATATAN']}",
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (tids_value.length > 0)
                              for (var i = 0; i < tids_value.length; i++)
                                CheckboxListTile(
                                  title: Text(
                                      '${tids_value[i]['tid']} (${tids_value[i]['sn']})'),
                                  value:
                                      tids_update.contains(tids_value[i]['tid'])
                                          ? true
                                          : false,
                                  onChanged: (bool? value) {
                                    if (value == true) {
                                      tids_update.add(tids_value[i]['tid']);
                                    } else {
                                      tids_update.remove(tids_value[i]['tid']);
                                    }
                                    setState(() {});
                                    print(tids_update);
                                  },
                                ),
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  side: new BorderSide(
                                      color: Colors.black, width: 2.0),
                                  borderRadius: BorderRadius.circular(4.0)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Foto Penarikan",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        // if (sn.text.isEmpty) {
                                        //   dialog(
                                        //       "Silahkan Input Serial Number Terlebih Dahulu!");
                                        // } else {
                                        //   foto_packing1();
                                        // }

                                        foto_packing1();
                                      },
                                      child: Card(
                                        elevation: 0,
                                        child: file_merchant == null
                                            ? Container(
                                                child: Icon(
                                                  Icons.camera_enhance,
                                                  size: 150,
                                                ),
                                              )
                                            : Image.file(
                                                Io.File(file_merchant!.path),
                                                height: 200,
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Serial Number Mesin',
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.qr_code_scanner),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return BCPage(
                                          session: widget.session,
                                          type: "detail_penarikan",
                                          idx: widget.id_jo.toString(),
                                          pic: pic_penyerahan.text.toString(),
                                          tids_update: tids_update,
                                          tids_update_value: tids_value,
                                          foto_merchant: file_merchant,
                                        );
                                      }));
                                    },
                                  )),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              controller: sn,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Nama PIC Penyerahan',
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              controller: pic_penyerahan,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              maxLines: 3,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Catatan Penyerahan',
                              ),
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              controller: catatan_penyerahan,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 65,
                              child: ElevatedButton(
                                  onPressed: (() {
                                    if (pic_penyerahan.text.isEmpty) {
                                      dialog(
                                          "Silahkan Input Nama PIC Penyerahan Terlebih Dahulu!");
                                    } else {
                                      var timezone =
                                          DateTime.now().timeZoneName;

                                      bottomSheetKirim(
                                          widget.session.toString(),
                                          listPenarikan[index]['IDX']
                                              .toString(),
                                          sn.text.toString(),
                                          listPenarikan[index]['TID'],
                                          catatan_penyerahan.text.toString(),
                                          pic_penyerahan.text.toString(),
                                          timezone.toString(),
                                          file_merchant,
                                          tids_update.join(","));
                                    }
                                  }),
                                  child: Text("Submit")),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
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
        ),
      ),
    );
  }

  void foto_packing1() async {
    merchant = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 25,
    );
    if (merchant != null) {
      setState(() {
        file_merchant = Io.File(merchant!.path);
      });
    }
  }

  void get_list_penarikan(String session, String id_jo) {
    futurePenarikan =
        ServicesPenarikan.getDetailPenarikan(session, id_jo).then((value) {
      print(value?.data);
      if (value?.data != null) {
        if (this.mounted) {
          setState(() {
            listPenarikan = value!.data!;
            tids_value = value.data_tid!;
          });
        }
      } else {
        dialog(value?.errormsg);
      }
    });
  }

  void ubah_sn(String snMesin) {
    if (this.mounted) {
      setState(() {
        sn.text = snMesin;
      });
    }
  }

  void ubah_tids(List tids, List tids2) {
    if (this.mounted) {
      setState(() {
        tids_update = tids;
        tids_value = tids2;
      });
    }
  }

  void ubah_pic(String pic) {
    if (this.mounted) {
      setState(() {
        pic_penyerahan.text = pic;
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

  void bottomSheetKirim(
      String session,
      String id_job,
      String sn,
      String tid,
      String catatan_penyerahan,
      String pic_penyerahan,
      String timezone,
      Io.File? foto_merchant,
      String tids_update) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 100),
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Apa Anda Ingin Melakukan Submit Penarikan?"),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            child: const Text('Tidak'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            child: const Text('Ya'),
                            onPressed: () async {
                              dialog(null);
                              DataWs? result =
                                  await ServicesPenarikan.insert_penarikan(
                                      session,
                                      id_job,
                                      sn,
                                      tid,
                                      catatan_penyerahan,
                                      pic_penyerahan,
                                      timezone,
                                      foto_merchant,
                                      tids_update);

                              if (result?.statuscode == "200") {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (ctx) => PenarikanPage(
                                              session: widget.session,
                                            )),
                                    (route) => false);
                              } else if (result == null) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: LinearProgressIndicator(),
                                ));
                              } else {
                                // ScaffoldMessenger.of(context)
                                //     .showSnackBar(SnackBar(
                                //   content: Text("${result.errormsg}"),
                                //   duration: const Duration(seconds: 2),
                                // ));
                                Navigator.of(context).pop();
                                dialog(result.errormsg);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}
