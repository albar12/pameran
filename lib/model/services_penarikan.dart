import 'dart:convert';
import 'dart:io' as Io;

import 'package:dio/dio.dart';
import 'package:jadin_pameran/data/data_ws.dart';

class ServicesPenarikan {
  static Future<DataWs?> getListPenarikan(String session, String tid) async {
    try {
      var response = await Dio().post(
          "https://pameran.jtracker.id/api_mobile/api_mobile/list_data_tarikan",
          data: jsonEncode({'session': session, 'tid': tid}));
      print(response.statusCode);

      if (response.statusCode == 200) {
        return DataWs(
            statuscode: response.data['ErrorCode'],
            errormsg: response.data['ErrorMessage'],
            data: response.data['data']);
      }
      return null;
    } on DioError catch (e) {
      print(e.message);
      if (e.response?.statusCode == 500) {
        return DataWs(
          errormsg: e.message.toString(),
        );
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<DataWs?> getDetailPenarikan(
      String session, String id_jo) async {
    try {
      var response = await Dio().post(
          "https://pameran.jtracker.id/api_mobile/api_mobile/list_detail_tarikan",
          data: jsonEncode(
              {'session': session.toString(), 'id_jo': id_jo.toString()}));
      print(response.statusCode);

      if (response.statusCode == 200) {
        return DataWs(
          statuscode: response.data['ErrorCode'],
          errormsg: response.data['ErrorMessage'],
          data: response.data['data'],
          data_tid: response.data["data"][0]['TID_Merchant'],
        );
      }
      return null;
    } on DioError catch (e) {
      print(e.message);
      if (e.response?.statusCode == 500) {
        return DataWs(
          errormsg: e.message.toString(),
        );
      }
    } catch (e) {
      // throw Exception(e.toString());
      return DataWs(errormsg: e.toString());
    }
  }

  static Future<DataWs?> insert_penarikan(
      String session,
      String id_job,
      String sn,
      String tid,
      String catatan_penyerahan,
      String pic_penyerahan,
      String timezone,
      Io.File? foto_merchant,
      String tids_update) async {
    var send_foto_merchant =
        foto_merchant?.path != null ? foto_merchant?.path : '';
    final bytesFotoMerchant = send_foto_merchant != ''
        ? Io.File(send_foto_merchant!).readAsBytesSync()
        : null;
    String? image_merchant =
        bytesFotoMerchant != null ? base64Encode(bytesFotoMerchant) : null;
    print(tids_update.toString());
    FormData formData = FormData.fromMap({
      "session": session.toString(),
      "id_job": id_job.toString(),
      "tid": tid.toString(),
      "sn": sn.toString(),
      "pic": pic_penyerahan.toString(),
      "catatan": catatan_penyerahan.toString(),
      "foto_merchant": image_merchant.toString(),
      "tids_update": tids_update.toString(),
      "timezone": timezone.toString()
    });
    try {
      var response = await Dio().post(
          "https://pameran.jtracker.id/api_mobile/api_mobile/insert_data_tarikan",
          data: formData);
      print(response.statusCode);

      if (response.statusCode == 200) {
        return DataWs(
            statuscode: response.data['ErrorCode'],
            errormsg: response.data['ErrorMessage'],
            data: response.data['data']);
      }
      return null;
    } on DioError catch (e) {
      print(e.message);
      if (e.response?.statusCode == 500) {
        return DataWs(
          errormsg: e.message.toString(),
        );
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
