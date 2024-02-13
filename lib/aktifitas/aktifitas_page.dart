import 'dart:io' as Io;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jadin_pameran/aktifitas/list_aktifitas_page.dart';
import 'package:jadin_pameran/barcode_page.dart';
import 'package:jadin_pameran/data/data_ws.dart';
import 'package:jadin_pameran/home/home_page.dart';
import 'package:jadin_pameran/model/services_aktifitas.dart';
import 'package:jadin_pameran/model/services_pemasangan.dart';

class AktifitasPage extends StatefulWidget {
  final String? session;
  final String? sn;
  const AktifitasPage({
    super.key,
    this.session,
    this.sn,
  });

  @override
  State<AktifitasPage> createState() => _AktifitasPageState();
}

class _AktifitasPageState extends State<AktifitasPage> {
  TextEditingController catatan = TextEditingController();
  TextEditingController tid = TextEditingController();
  TextEditingController area = TextEditingController();
  TextEditingController solusi_perbaikan = TextEditingController();
  TextEditingController pergantian_tid = TextEditingController();
  TextEditingController pergantian_simcard = TextEditingController();
  TextEditingController pergantian_psam = TextEditingController();
  TextEditingController other = TextEditingController();
  TextEditingController sn = TextEditingController();
  TextEditingController mid = TextEditingController();
  TextEditingController merchant = TextEditingController();

  XFile? aktifitas1;
  Io.File? file_aktifitas1;
  Io.File? null_aktifitas1;

  XFile? aktifitas2;
  Io.File? file_aktifitas2;

  XFile? aktifitas3;
  Io.File? file_aktifitas3;

  String? jenis_kerusakan;
  String? status;

  bool visibleOther = false;
  bool visibleForm = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (this.mounted) {
      // if (widget.sn.toString() != "" && widget.sn.toString() != null) {
      //   ServicesPemasangan.getTidSn(
      //           widget.session.toString(), widget.sn.toString())
      //       .then((value) {
      //     setState(() {
      //       tid.text = value!;
      //       visibleForm = true;
      //     });
      //   });
      // }

      setState(() {
        sn.text = widget.sn.toString() != null ? widget.sn.toString() : '';
      });
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
                    builder: (ctx) => ListAktifitasPage(
                          session: widget.session,
                        )),
                (route) => true);
          },
        ),
        title: Text("Aktifitas"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'TID/MID/Merchant',
                        // suffixIcon: IconButton(
                        //   icon: Icon(Icons.qr_code_scanner),
                        //   onPressed: () {
                        //     // if (waktuStart == null) {
                        //     //   dialog("Silahkan Lakukan Start Terlebih dahulu");
                        //     // } else {
                        //     Navigator.push(context,
                        //         MaterialPageRoute(builder: (context) {
                        //       return BCPage(
                        //         session: widget.session,
                        //         type: "akrifitas_form",
                        //         sub_type: "sn_mesin",
                        //         // tid: widget.tid.toString(),
                        //         // idx: widget.id.toString(),
                        //         // waktu_start: waktuStart,
                        //         // foto_mesin: file_mesin,
                        //         // // foto_merchant: file_merchant,
                        //         // foto_struk: file_struk,
                        //         // pic: pic.text.toString(),
                        //         // tel_pic: telp_pic.text.toString(),
                        //         // catatan: catatan.text.toString(),
                        //       );
                        //     }));
                        //     // }
                        //   },
                        // ),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      controller: sn,
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
                              // Navigator.of(context).pushAndRemoveUntil(
                              //     MaterialPageRoute(
                              //         builder: (ctx) => QcPage(
                              //               session: widget.session,
                              //             )),
                              //     (route) => true);
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
                              // setState(() {
                              //   visible = true;
                              // });

                              ServicesPemasangan.getTidSn(
                                      widget.session.toString(),
                                      sn.text.toString())
                                  .then((value) {
                                print("cek");
                                print(value);
                                final splitted = value?.split('_');
                                setState(() {
                                  tid.text = splitted![0];
                                  mid.text = splitted![1];
                                  merchant.text = splitted![2];
                                  visibleForm = true;
                                });
                              });
                            }
                          }),
                          child: Text("Cek"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Visibility(
                  visible: visibleForm,
                  child: Column(
                    children: [
                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'TID',
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        controller: tid,
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
                        controller: mid,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'MERCHANT',
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        controller: merchant,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Jenis Kerusakan",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ],
                          ),
                          RadioListTile(
                            title: Text(
                              "Connecting",
                              style: TextStyle(),
                            ),
                            value: 'Connecting',
                            groupValue: jenis_kerusakan,
                            onChanged: (value) {
                              setState(() {
                                jenis_kerusakan = value;
                                visibleOther = false;
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text(
                              "Security Allert",
                              style: TextStyle(),
                            ),
                            value: 'Security Allert',
                            groupValue: jenis_kerusakan,
                            onChanged: (value) {
                              setState(() {
                                jenis_kerusakan = value;
                                visibleOther = false;
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text(
                              "Permintaan Faktur",
                              style: TextStyle(),
                            ),
                            value: 'Permintaan Faktur',
                            groupValue: jenis_kerusakan,
                            onChanged: (value) {
                              setState(() {
                                jenis_kerusakan = value;
                                visibleOther = false;
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text(
                              "Mati Total",
                              style: TextStyle(),
                            ),
                            value: 'Mati Total',
                            groupValue: jenis_kerusakan,
                            onChanged: (value) {
                              setState(() {
                                jenis_kerusakan = value;
                                visibleOther = false;
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text(
                              "Training Penggunaan EDC",
                              style: TextStyle(),
                            ),
                            value: 'Training Penggunaan EDC',
                            groupValue: jenis_kerusakan,
                            onChanged: (value) {
                              setState(() {
                                jenis_kerusakan = value;
                                visibleOther = false;
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text(
                              "Pengecekan",
                              style: TextStyle(),
                            ),
                            value: 'Pengecekan',
                            groupValue: jenis_kerusakan,
                            onChanged: (value) {
                              setState(() {
                                jenis_kerusakan = value;
                                visibleOther = false;
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text(
                              "Other",
                              style: TextStyle(),
                            ),
                            value: 'Other',
                            groupValue: jenis_kerusakan,
                            onChanged: (value) {
                              setState(() {
                                jenis_kerusakan = value;
                                visibleOther = true;
                              });
                            },
                          ),
                          Visibility(
                            visible: visibleOther,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Other',
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              controller: other,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Solusi Perbaikan',
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        controller: solusi_perbaikan,
                        maxLines: 2,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Pergantian TID',
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        controller: pergantian_tid,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Pergantian ICCID / Simcard',
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        controller: pergantian_simcard,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Pergantian PSAM',
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        controller: pergantian_psam,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Status",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ],
                          ),
                          RadioListTile(
                            title: Text(
                              "Berhasil",
                              style: TextStyle(),
                            ),
                            value: 'Berhasil',
                            groupValue: status,
                            onChanged: (value) {
                              setState(() {
                                status = value;
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text(
                              "Gagal",
                              style: TextStyle(),
                            ),
                            value: 'Gagal',
                            groupValue: status,
                            onChanged: (value) {
                              setState(() {
                                status = value;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Catatan Aktifitas',
                        ),
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        controller: catatan,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(4.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Foto Aktifitas 1",
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
                                  //   foto_mesin();
                                  // }

                                  foto_mesin();
                                },
                                child: Card(
                                    elevation: 0,
                                    child: file_aktifitas1 == null
                                        ? Container(
                                            child: Icon(
                                              Icons.camera_enhance,
                                              size: 150,
                                            ),
                                          )
                                        : Image.file(
                                            Io.File(file_aktifitas1!.path),
                                            height: 200,
                                          )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(4.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Foto Aktifitas 2",
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
                                  //   foto_mesin();
                                  // }

                                  foto_aktifitas2();
                                },
                                child: Card(
                                    elevation: 0,
                                    child: file_aktifitas2 == null
                                        ? Container(
                                            child: Icon(
                                              Icons.camera_enhance,
                                              size: 150,
                                            ),
                                          )
                                        : Image.file(
                                            Io.File(file_aktifitas2!.path),
                                            height: 200,
                                          )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(4.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Foto Aktifitas 3",
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
                                  //   foto_mesin();
                                  // }

                                  foto_aktifitas3();
                                },
                                child: Card(
                                    elevation: 0,
                                    child: file_aktifitas3 == null
                                        ? Container(
                                            child: Icon(
                                              Icons.camera_enhance,
                                              size: 150,
                                            ),
                                          )
                                        : Image.file(
                                            Io.File(file_aktifitas3!.path),
                                            height: 200,
                                          )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 1,
                        height: 65,
                        child: ElevatedButton(
                          onPressed: (() {
                            if (catatan.text.isEmpty) {
                              dialog(
                                  "Silahkan Input Catatan Aktifitas Terlebih Dahulu!");
                            } else {
                              var timezone = DateTime.now().timeZoneName;

                              if (file_aktifitas1 != null) {
                                var aktifitas1 = file_aktifitas1;
                              } else {
                                var aktifitas1 = '0';
                              }

                              if (file_aktifitas2 != null) {
                                var aktifitas2 = file_aktifitas2;
                              } else {
                                var aktifitas2 = '0';
                              }

                              if (file_aktifitas3 != null) {
                                var aktifitas3 = file_aktifitas3;
                              } else {
                                var aktifitas3 = '0';
                              }

                              // print("testing");
                              // print(aktifitas1);

                              String? send_jenisKerusakan = visibleOther == true
                                  ? other.text.toString()
                                  : jenis_kerusakan;

                              bottomSheetKirim(
                                  widget.session.toString(),
                                  aktifitas1,
                                  aktifitas2,
                                  aktifitas3,
                                  timezone.toString(),
                                  catatan.text.toString(),
                                  tid.text.toString(),
                                  area.text.toString(),
                                  send_jenisKerusakan,
                                  solusi_perbaikan.text.toString(),
                                  pergantian_tid.text.toString(),
                                  pergantian_simcard.text.toString(),
                                  pergantian_psam.text.toString(),
                                  status);
                            }
                          }),
                          child: Text("Submit"),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void foto_mesin() async {
    aktifitas1 = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (aktifitas1 != null) {
      setState(() {
        file_aktifitas1 = Io.File(aktifitas1!.path);
      });
    }
  }

  void foto_aktifitas2() async {
    aktifitas2 = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (aktifitas2 != null) {
      setState(() {
        file_aktifitas2 = Io.File(aktifitas2!.path);
      });
    }
  }

  void foto_aktifitas3() async {
    aktifitas3 = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (aktifitas3 != null) {
      setState(() {
        file_aktifitas3 = Io.File(aktifitas3!.path);
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
      // Io.File foto_aktifitas1,
      var foto_aktifitas1,
      var foto_aktifitas2,
      var foto_aktifitas3,
      String timezone,
      String catatan,
      String tid,
      String area,
      String? jenis_kerusakan,
      String solusi_perbaikan,
      String pergantian_tid,
      String pergantian_simcard,
      String pergantian_psam,
      String? status) {
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
                      Text("Apa Anda Ingin Melakukan Submit Aktifitas?"),
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
                                  await ServicesAktifitas.insert_aktifitas(
                                      session,
                                      foto_aktifitas1,
                                      foto_aktifitas2,
                                      foto_aktifitas3,
                                      catatan,
                                      timezone,
                                      tid,
                                      area,
                                      jenis_kerusakan,
                                      solusi_perbaikan,
                                      pergantian_tid,
                                      pergantian_simcard,
                                      pergantian_psam,
                                      status);

                              print(result?.statuscode);
                              if (result?.statuscode == '200') {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (ctx) => ListAktifitasPage(
                                              session: session,
                                            )),
                                    (route) => false);
                              } else {
                                Navigator.of(context).pop();
                                dialog(result?.errormsg);
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
