import 'dart:convert';
import 'dart:io' as Io;

import 'package:dio/dio.dart';
import 'package:jadin_pameran/data/data_ws.dart';

class ServicesAktifitas {
  static Future<DataWs?> insert_aktifitas(
      String session,
      var foto_aktifitas1,
      var foto_aktifitas2,
      var foto_aktifitas3,
      String catatan,
      String timezone,
      String tid) async {
    print(foto_aktifitas1);
    var bytesFotoAktifitas1 = foto_aktifitas1 != null
        ? Io.File(foto_aktifitas1?.path).readAsBytesSync()
        : foto_aktifitas1;
    String image_aktifitas1 =
        bytesFotoAktifitas1 != null ? base64Encode(bytesFotoAktifitas1) : '';

    var bytesFotoAktifitas2 = foto_aktifitas2 != null
        ? Io.File(foto_aktifitas2.path).readAsBytesSync()
        : foto_aktifitas2;
    String image_aktifitas2 =
        bytesFotoAktifitas2 != null ? base64Encode(bytesFotoAktifitas2) : '';

    final bytesFotoAktifitas3 = foto_aktifitas3 != null
        ? Io.File(foto_aktifitas3.path).readAsBytesSync()
        : foto_aktifitas3;
    String image_aktifitas3 =
        bytesFotoAktifitas3 != null ? base64Encode(bytesFotoAktifitas3) : '';

    FormData formData = FormData.fromMap({
      "session": session.toString(),
      "foto_aktifitas1": image_aktifitas1,
      "foto_aktifitas2": image_aktifitas2,
      "foto_aktifitas3": image_aktifitas3,
      "catatan": catatan.toString(),
      "timezone": timezone.toString(),
      "tid": tid.toString(),
    });
    try {
      var response = await Dio().post(
        "https://pameran.jtracker.id/api_mobile/api_mobile/insert_aktifitas",
        data: formData,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
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
      return DataWs(errormsg: e.toString());
    }
  }

  static Future<DataWs?> getListAktifitas(String session) async {
    try {
      var response = await Dio().post(
        "https://pameran.jtracker.id/api_mobile/api_mobile/list_aktifitas",
        data: jsonEncode({'session': session}),
      );
      if (response.statusCode == 200) {
        return DataWs(
            statuscode: response.data['ErrorCode'],
            errormsg: response.data['ErrorMessage'],
            data: response.data['data']);
      }
      return null;
    } on DioError catch (e) {
      if (e.response?.statusCode == 500) {}
    } catch (e) {
      // throw Exception(e.toString());
      return DataWs(
        errormsg: e.toString(),
      );
    }
  }
}
