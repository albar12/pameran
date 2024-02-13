import 'dart:developer';
// import 'dart:html';
import 'dart:io' as Io;

import 'package:flutter/material.dart';
import 'package:jadin_pameran/aktifitas/aktifitas_page.dart';
import 'package:jadin_pameran/model/services_pemasangan.dart';
import 'package:jadin_pameran/pemasangan/pemasangan_form_page.dart';
import 'package:jadin_pameran/pemasangan/pemasangan_page.dart';
import 'package:jadin_pameran/penarikan/detail_penarikan_page.dart';
import 'package:jadin_pameran/penarikan/penarikan_page.dart';
import 'package:jadin_pameran/qc/qc_form_page.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

class BCPage extends StatefulWidget {
  final String? session;
  final String? produk;
  final String? tid;
  final String? type;
  final String? sub_type;
  final String? sn_mesin;
  final String? sn_provider;
  final String? sn_psam;
  final String? idx;
  final String? waktu_start;
  final Io.File? foto_mesin;
  final Io.File? foto_merchant;
  final Io.File? foto_struk;
  final String? pic;
  final String? tel_pic;
  final String? catatan;
  final String? fotoMesinNetwork;
  final String? fotoStrukNetwork;
  final String? idjo;
  final String? area;
  final List? tids_update;
  final List? tids_update_value;

  const BCPage({
    super.key,
    this.session,
    this.produk,
    this.tid,
    this.type,
    this.sn_mesin,
    this.sn_provider,
    this.sn_psam,
    this.sub_type,
    this.idx,
    this.waktu_start,
    this.foto_mesin,
    this.foto_merchant,
    this.foto_struk,
    this.pic,
    this.tel_pic,
    this.catatan,
    this.fotoMesinNetwork,
    this.fotoStrukNetwork,
    this.idjo,
    this.area,
    this.tids_update,
    this.tids_update_value,
  });

  @override
  State<BCPage> createState() => _BCPageState();
}

class _BCPageState extends State<BCPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'BARCODE');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.

  void resume() async {
    await controller?.resumeCamera();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    resume();
    // print("testing file");
    // print(widget.foto_mesin);
  }

  @override
  // void reassemble() {
  //   super.reassemble();
  //   print(Platform.isAndroid);
  //   if (Platform.isAndroid) {
  //     controller!.resumeCamera();
  //   }
  //   controller!.pauseCamera();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.100
        : 600.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
          borderRadius: 10,
          borderLength: 5,
          borderWidth: 2,
          // cutOutSize: scanArea
          cutOutHeight: 75,
          cutOutWidth: 300),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      if (widget.type == 'pemasangan') {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (ctx) => PemasanganPage(
                      session: widget.session.toString(),
                      sn_mesin: scanData.code.toString(),
                    )),
            (route) => false);
      } else if (widget.type == 'pemasangan_form') {
        if (widget.sub_type == "sn_mesin") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (ctx) => PemasanganFormPage(
                        session: widget.session.toString(),
                        sn_mesin: scanData.code.toString(),
                        id: widget.idx.toString(),
                        tid: widget.tid.toString(),
                        waktu_start: widget.waktu_start.toString(),
                        foto_mesin: widget.foto_mesin,
                        foto_merchant: widget.foto_merchant,
                        foto_struk: widget.foto_struk,
                        pic: widget.pic.toString(),
                        telp_pic: widget.pic.toString(),
                        catatan: widget.catatan.toString(),
                        fotoMesinNetwork: widget.fotoMesinNetwork,
                        fotoStrukNetwork: widget.fotoStrukNetwork,
                        idjo: widget.idjo,
                      )),
              (route) => false);

          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return PemasanganFormPage(
          //     session: widget.session.toString(),
          //     sn_mesin: scanData.code.toString(),
          //   );
          // }));
        }
      } else if (widget.type == 'penarikan') {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (ctx) => PenarikanPage(
                      session: widget.session.toString(),
                      sn_mesin: scanData.code.toString(),
                    )),
            (route) => false);
      } else if (widget.type == 'detail_penarikan') {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (ctx) => DetailPenarikanPage(
                      session: widget.session.toString(),
                      sn_mesin: scanData.code.toString(),
                      id_jo: widget.idx.toString(),
                      pic_penyerahan: widget.pic.toString(),
                      tids_update2: widget.tids_update,
                      tids_update2_value: widget.tids_update_value,
                      foto_merchant2: widget.foto_merchant,
                    )),
            (route) => false);
      } else if (widget.type == 'qc_form') {
        if (widget.sub_type == "sn_mesin") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (ctx) => QcFormPage(
                        session: widget.session.toString(),
                        sn_mesin: scanData.code.toString(),
                        id: widget.idx.toString(),
                        tid: widget.tid.toString(),
                        waktu_start: widget.waktu_start.toString(),
                        foto_mesin: widget.foto_mesin,
                        foto_merchant: widget.foto_merchant,
                        foto_struk: widget.foto_struk,
                        pic: widget.pic.toString(),
                        telp_pic: widget.pic.toString(),
                        catatan: widget.catatan.toString(),
                      )),
              (route) => false);

          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return PemasanganFormPage(
          //     session: widget.session.toString(),
          //     sn_mesin: scanData.code.toString(),
          //   );
          // }));
        }
      } else if (widget.type == 'akrifitas_form') {
        if (widget.sub_type == "sn_mesin") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (ctx) => AktifitasPage(
                        session: widget.session.toString(),
                        sn: scanData.code.toString(),
                      )),
              (route) => false);

          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return PemasanganFormPage(
          //     session: widget.session.toString(),
          //     sn_mesin: scanData.code.toString(),
          //   );
          // }));
        }
      }
    });
    controller.pauseCamera();
    controller.resumeCamera();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
