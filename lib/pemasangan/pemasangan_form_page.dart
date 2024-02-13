import 'dart:convert';
import 'dart:io' as Io;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jadin_pameran/barcode_page.dart';
import 'package:jadin_pameran/data/data_ws.dart';
import 'package:jadin_pameran/model/services_pemasangan.dart';
import 'package:jadin_pameran/pemasangan/pemasangan_page.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class PemasanganFormPage extends StatefulWidget {
  String? session;
  String? id;
  String? tid;
  String? sn_mesin;
  Io.File? foto_mesin;
  Io.File? foto_merchant;
  Io.File? foto_struk;
  String? waktu_start;
  String? pic;
  String? telp_pic;
  String? catatan;
  String? fotoMesinNetwork;
  String? fotoStrukNetwork;
  String? idjo;
  List? tids = [];
  String? area;

  PemasanganFormPage({
    super.key,
    this.session,
    this.id,
    this.tid,
    this.sn_mesin,
    this.foto_mesin,
    this.foto_merchant,
    this.foto_struk,
    this.waktu_start,
    this.pic,
    this.telp_pic,
    this.catatan,
    this.fotoMesinNetwork,
    this.fotoStrukNetwork,
    this.idjo,
    this.tids,
    this.area,
  });

  @override
  State<PemasanganFormPage> createState() => _PemasanganFormPageState();
}

class _PemasanganFormPageState extends State<PemasanganFormPage> {
  TextEditingController tid = TextEditingController();
  TextEditingController area = TextEditingController();
  TextEditingController no = TextEditingController();
  TextEditingController sn = TextEditingController();
  TextEditingController pic = TextEditingController();
  TextEditingController telp_pic = TextEditingController();
  TextEditingController catatan = TextEditingController();

  String? progressString;
  String? waktuStart;

  bool count_time = false;
  bool indicatorProgress = false;

  XFile? merchant;
  XFile? mesin;
  XFile? struk;
  XFile? optional;

  Io.File? file_merchant;
  Io.File? file_mesin;
  Io.File? file_struk;
  Io.File? file_optional;

  List tids_update = [];

  bool isChecked = false;

  // List tids_updatex = [];

  final ImagePicker _picker = ImagePicker();

  final stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("testing file balik");
    print(widget.foto_mesin);
    if (this.mounted) {
      setState(() {
        tid.text = widget.tid.toString();
        no.text = widget.idjo.toString();
        area.text = widget.area.toString();
      });
    }

    if (widget.sn_mesin != null) {
      ubah_sn(widget.sn_mesin.toString());
    }

    if (widget.foto_mesin != null) {
      if (this.mounted) {
        setState(() {
          file_mesin = widget.foto_mesin;
        });
      }
    }

    if (widget.foto_merchant != null) {
      if (this.mounted) {
        setState(() {
          file_merchant = widget.foto_merchant;
        });
      }
    }

    if (widget.foto_struk != null) {
      if (this.mounted) {
        setState(() {
          file_struk = widget.foto_struk;
        });
      }
    }

    if (widget.waktu_start != null) {
      if (this.mounted) {
        setState(() {
          waktuStart = widget.waktu_start;
        });
      }
    }

    if (widget.pic != null) {
      if (this.mounted) {
        setState(() {
          pic.text = widget.pic!;
        });
      }
    }

    if (widget.telp_pic != null) {
      if (this.mounted) {
        setState(() {
          telp_pic.text = widget.telp_pic!;
        });
      }
    }

    if (widget.catatan != null) {
      if (this.mounted) {
        setState(() {
          catatan.text = widget.catatan!;
        });
      }
    }

    // indicator();
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
                    builder: (ctx) => PemasanganPage(
                          session: widget.session,
                        )),
                (route) => true);
          },
        ),
        title: Text("Form Pemasangan"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              children: [
                // TextField(
                //   readOnly: true,
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(),
                //     labelText: 'No',
                //   ),
                //   keyboardType: TextInputType.text,
                //   textInputAction: TextInputAction.done,
                //   controller: no,
                // ),
                // SizedBox(
                //   height: 10,
                // ),
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
                // SizedBox(
                //   height: 10,
                // ),
                // Row(
                //   children: [
                //     waktuStart != null
                //         ? Text(
                //             "${waktuStart}",
                //             style: TextStyle(
                //               fontSize: 13,
                //               fontFamily: 'Helvetica',
                //               fontWeight: FontWeight.bold,
                //             ),
                //           )
                //         : Text(""),
                //     Spacer(),
                //     Column(
                //       children: [
                //         SizedBox(
                //           width: 100,
                //           height: 50,
                //           child: ElevatedButton(
                //             style: ButtonStyle(
                //               backgroundColor:
                //                   MaterialStateProperty.all<Color>(Colors.red),
                //             ),
                //             onPressed: (() {
                //               var now = new DateTime.now();
                //               var formatter =
                //                   new DateFormat('yyyy-MM-dd kk:mm:ss');
                //               String formattedDate = formatter.format(now);
                //               print(formattedDate);
                //               if (waktuStart == null) {
                //                 setState(() {
                //                   waktuStart = formattedDate;
                //                 });
                //               }
                //             }),
                //             child: Text("Start"),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Area',
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  controller: area,
                ),
                SizedBox(
                  height: 10,
                ),
                // TextField(
                //   decoration: InputDecoration(
                //       border: OutlineInputBorder(),
                //       labelText: 'Serial Number Mesin',
                //       suffixIcon: IconButton(
                //         icon: Icon(Icons.qr_code_scanner),
                //         onPressed: () {
                //           // if (waktuStart == null) {
                //           //   dialog("Silahkan Lakukan Start Terlebih dahulu");
                //           // } else {
                //           Navigator.push(context,
                //               MaterialPageRoute(builder: (context) {
                //             return BCPage(
                //               session: widget.session,
                //               type: "pemasangan_form",
                //               sub_type: "sn_mesin",
                //               tid: widget.tid.toString(),
                //               idx: widget.id.toString(),
                //               waktu_start: waktuStart,
                //               foto_mesin: file_mesin,
                //               foto_merchant: file_merchant,
                //               foto_struk: file_struk,
                //               pic: pic.text.toString(),
                //               tel_pic: telp_pic.text.toString(),
                //               catatan: catatan.text.toString(),
                //               fotoMesinNetwork: widget.fotoMesinNetwork,
                //               fotoStrukNetwork: widget.fotoStrukNetwork,
                //               idjo: widget.idjo,
                //             );
                //           }));
                //           // }

                //           print(file_mesin);
                //         },
                //       )),
                //   keyboardType: TextInputType.text,
                //   textInputAction: TextInputAction.done,
                //   controller: sn,
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                if (widget.tids!.length > 0)
                  for (var i = 0; i < widget.tids!.length; i++)
                    CheckboxListTile(
                      title: Text(
                          '${widget.tids?[i]['tid']} (${widget.tids?[i]['sn']})'),
                      value: tids_update.contains(widget.tids?[i]['tid'])
                          ? true
                          : false,
                      onChanged: (bool? value) {
                        // if (tids_update.contains(widget.tids?[i])) {
                        //   setState(() {
                        //     tids_update.remove(value);
                        //   });
                        // } else {
                        //   setState(() {
                        //     tids_update.add(value);
                        //   });
                        // }
                        print("checkbox");
                        print(widget.tids?[i]);
                        print(value);
                        print(tids_update.contains(widget.tids?[i]['tid']));
                        if (value == true) {
                          tids_update.add(widget.tids?[i]['tid']);
                        } else {
                          tids_update.remove(widget.tids?[i]['tid']);
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
                      side: new BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(4.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Foto Merchant",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
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
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      side: new BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(4.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Foto Mesin / Serial Number Mesin",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
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

                            // foto_mesin();
                          },
                          child: Card(
                            elevation: 0,
                            child: Image.network(
                              widget.fotoMesinNetwork!,
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
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      side: new BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(4.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Foto Struk",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            // if (sn.text.isEmpty) {
                            //   dialog(
                            //       "Silahkan Input Serial Number Terlebih Dahulu!");
                            // } else {
                            //   foto_struk();
                            // }

                            // foto_struk();
                          },
                          child: Card(
                            elevation: 0,
                            child: Image.network(
                              widget.fotoStrukNetwork!,
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
                // Card(
                //   elevation: 0,
                //   shape: RoundedRectangleBorder(
                //       side: new BorderSide(color: Colors.black, width: 2.0),
                //       borderRadius: BorderRadius.circular(4.0)),
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Column(
                //       children: [
                //         Row(
                //           children: [
                //             Text(
                //               "Foto Optional",
                //               style: TextStyle(
                //                   fontWeight: FontWeight.bold, fontSize: 15),
                //             ),
                //           ],
                //         ),
                //         InkWell(
                //           onTap: () {
                //             if (sn.text.isEmpty) {
                //               dialog(
                //                   "Silahkan Input Serial Number Terlebih Dahulu!");
                //             } else {
                //               foto_struk();
                //             }
                //           },
                //           child: Card(
                //               elevation: 0,
                //               child: file_optional == null
                //                   ? Container(
                //                       child: Icon(
                //                         Icons.camera_enhance,
                //                         size: 150,
                //                       ),
                //                     )
                //                   : Image.file(
                //                       Io.File(file_optional!.path),
                //                       height: 200,
                //                     )),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nama PIC Merchant',
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  controller: pic,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'No Telpon PIC Merchant',
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  controller: telp_pic,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Keterangan',
                  ),
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  controller: catatan,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  child: ElevatedButton(
                      onPressed: (() {
                        // indicator();
                        // if (sn.text.isEmpty) {
                        //   dialog("Serial Number Wajib Diisi!");
                        // }
                        // else if (file_mesin == null) {
                        //   dialog("Foto Mesin Wajib Diisi!");
                        // }
                        if (file_merchant == null) {
                          dialog("Foto Merchant Wajib Diisi!");
                        }
                        // else if (file_struk == null) {
                        //   dialog("Foto Struk Wajib Diisi!");
                        // }
                        // else if (pic.text.isEmpty) {
                        //   dialog("Nama PIC Merchant Wajib Diisi!");
                        // } else if (telp_pic.text.isEmpty) {
                        //   dialog("No Telpon PIC Merchant Wajiib Diisi!");
                        // }
                        else {
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //   content: LinearProgressIndicator(),
                          //   duration: const Duration(seconds: 4),
                          // ));
                          print("ini join");
                          print(tids_update.join(","));

                          var timezone = DateTime.now().timeZoneName;
                          bottomSheetKirim(
                              widget.session.toString(),
                              file_merchant!,
                              timezone.toString(),
                              sn.text.toString(),
                              pic.text.toString(),
                              telp_pic.text.toString(),
                              widget.idjo.toString(),
                              widget.id.toString(),
                              widget.tid.toString(),
                              catatan.text.toString(),
                              tids_update.join(","));
                        }
                      }),
                      child: Text("Submit")),
                )
              ],
            ),
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

  void foto_mesin() async {
    mesin = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (mesin != null) {
      setState(() {
        file_mesin = Io.File(mesin!.path);
      });
    }
  }

  void foto_struk() async {
    struk = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    if (struk != null) {
      setState(() {
        file_struk = Io.File(struk!.path);
      });
    }
  }

  void foto_optional() async {
    optional = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    setState(() {
      file_optional = Io.File(optional!.path);
    });
  }

  void ubah_sn(String sn_mesin) {
    if (this.mounted) {
      setState(() {
        sn.text = sn_mesin;
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
      Io.File foto_merchant,
      String timezone,
      String sn,
      String pic,
      String telp_pic,
      String id_job,
      String id,
      String tid,
      String catatan,
      String tids) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        if (indicatorProgress) {
          return Container(
            height: 50,
            child: Center(
              child: LinearProgressIndicator(),
            ),
          );
        } else {
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
                        Text("Apa Anda Ingin Melakukan Submit Pemasangan?"),
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
                                    await ServicesPemasangan.update_pemasangan(
                                        session.toString(),
                                        id,
                                        id_job,
                                        tid,
                                        sn,
                                        foto_merchant,
                                        catatan,
                                        pic,
                                        telp_pic,
                                        timezone,
                                        tids);

                                print(progressString);

                                if (result?.statuscode == "200") {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (ctx) => PemasanganPage(
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
        }
      },
    );
  }
}
