import 'dart:convert';
import 'dart:io' as Io;

import 'package:dio/dio.dart';
import 'package:jadin_pameran/data/data_ws.dart';
import 'package:jadin_pameran/model/merchant_data.dart';
import 'package:jadin_pameran/model/sql_pemasangan.dart';

class ServicesPemasangan {
  static Future<DataWs?> getListPemasangan(String session, String sn) async {
    try {
      var response = await Dio().post(
          "https://pameran.jtracker.id/api_mobile/api_mobile/list_data",
          data: jsonEncode({'session': session, 'tid': sn})
          // options: Options(headers: {
          //   "Content-Type": "application/x-www-form-urlencoded",
          //   "Authorization": "Barer dfd",
          //   "access-control-allow-headers": "*"
          // })
          );
      // print(response.data['ErrorMessage']);
      print(response.statusCode);

      if (response.statusCode == 200) {
        // print(response.data['data']);
        // print(response.data['data'].contains("1"));
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

  static Future<String?> getTidSn(String session, String sn) async {
    try {
      var response = await Dio().post(
          "https://pameran.jtracker.id/api_mobile/api_mobile/sn_tid",
          data: jsonEncode({'session': session, 'sn': sn})
          // options: Options(headers: {
          //   "Content-Type": "application/x-www-form-urlencoded",
          //   "Authorization": "Barer dfd",
          //   "access-control-allow-headers": "*"
          // })
          );
      // print(response.data['ErrorMessage']);
      print(response.statusCode);

      if (response.statusCode == 200) {
        // print(response.data['data']);
        // print(response.data['data'].contains("1"));
        return response.data['data'][0]['tid'];
      }
      return null;
    } on DioError catch (e) {
      print(e.message);
      if (e.response?.statusCode == 500) {
        return e.message.toString();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<DataWs?> getListQC(String session) async {
    try {
      var response = await Dio().post(
          "https://pameran.jtracker.id/api_mobile/api_mobile/qc_list",
          data: jsonEncode({'session': session})
          // options: Options(headers: {
          //   "Content-Type": "application/x-www-form-urlencoded",
          //   "Authorization": "Barer dfd",
          //   "access-control-allow-headers": "*"
          // })
          );
      // print(response.data['ErrorMessage']);
      print(response.statusCode);

      if (response.statusCode == 200) {
        // print(response.data['data']);
        // print(response.data['data'].contains("1"));
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

  static Future<DataWs?> insert_pemasangan(
      String session,
      String id_job,
      String tid,
      String sn,
      Io.File? foto_mesin,
      // Io.File foto_merchant,
      Io.File foto_struk,
      // Io.File foto_optional,
      String catatan,
      String pic,
      String no_pic,
      String timezone) async {
    // final bytesFotoMesin = Io.File(foto_mesin.path).readAsBytesSync();
    // String image_mesin = base64Encode(bytesFotoMesin);

    var send_foto_mesin = foto_mesin?.path != null ? foto_mesin?.path : '';
    final bytesFotoMesin = send_foto_mesin != ''
        ? Io.File(send_foto_mesin!).readAsBytesSync()
        : null;
    String? image_mesin =
        bytesFotoMesin != null ? base64Encode(bytesFotoMesin) : null;

    // final bytesFotoMerchant = Io.File(foto_merchant.path).readAsBytesSync();
    // String image_merchant = base64Encode(bytesFotoMerchant);

    final bytesFotoStruk = Io.File(foto_struk.path).readAsBytesSync();
    String image_struk = base64Encode(bytesFotoStruk);

    // final bytesFotoOptional = Io.File(foto_optional.path).readAsBytesSync();
    // var image_optional = base64Encode(bytesFotoOptional);

    FormData formData = FormData.fromMap({
      "session": session.toString(),
      "id_job": id_job.toString(),
      "tid": tid.toString(),
      "sn": sn.toString(),
      "foto_mesin": image_mesin,
      // "foto_merchant": image_merchant,
      "foto_struk": image_struk,
      // "foto_optional": image_optional,
      "pic": pic.toString(),
      "no_pic": no_pic.toString(),
      "catatan": catatan.toString(),
      "timezone": timezone.toString()
    });
    try {
      var response = await Dio().post(
        "https://pameran.jtracker.id/api_mobile/api_mobile/insert_data",
        data: formData,
        options: Options(contentType: Headers.formUrlEncodedContentType),
        onSendProgress: (count, total) {
          print("${(count / total * 100).toStringAsFixed(0)}%");
          // var total_count = (count / total * 100).toStringAsFixed(0);
          // // return total_count;
        },
      );
      // print(response.data['ErrorMessage']);
      print(response.statusCode);

      if (response.statusCode == 200) {
        // print(response.data['data']);
        // print(response.data['data'].contains("1"));
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
      // throw Exception(e.toString());
    }
  }

  static Future<DataWs?> getListPemasanganTeknisi(
      String session, String sn) async {
    try {
      var response = await Dio().post(
          "https://pameran.jtracker.id/api_mobile/api_mobile/list_data_teknisi",
          data: jsonEncode({'session': session, 'tid': sn})
          // options: Options(headers: {
          //   "Content-Type": "application/x-www-form-urlencoded",
          //   "Authorization": "Barer dfd",
          //   "access-control-allow-headers": "*"
          // })
          );
      // print(response.data['ErrorMessage']);
      print(response.statusCode);

      if (response.statusCode == 200) {
        // print(response.data['data']);
        // print(response.data['data'].contains("1"));
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

  static Future<DataWs?> getListPemasanganTeknisi2(String session) async {
    try {
      var response = await Dio().post(
          "https://pameran.jtracker.id/api_mobile/api_mobile/list_pemasangan_data_teknisi",
          data: jsonEncode({'session': session.toString()})
          // options: Options(headers: {
          //   "Content-Type": "application/x-www-form-urlencoded",
          //   "Authorization": "Barer dfd",
          //   "access-control-allow-headers": "*"
          // })
          );
      // print(response.data['ErrorMessage']);
      print(response.statusCode);
      print(jsonEncode({'session': session}));

      if (response.statusCode == 200) {
        print(response.data['data']);
        // print(response.data['data'].contains("1"));

        // final jsonData = response.data['data'];
        // final data = jsonData as List<dynamic>;
        // for (var item in data) {
        //   final merchantData = MerchantData.fromJson(item);
        //   await SQLPemasangan.insertPemasangan(merchantData);
        // }

        // final List<MerchantData> merchants =
        //     await SQLPemasangan.getAllPemasangan();
        // final List<Map<String, dynamic>> jsonDataList =
        //     merchants.map((merchant) => merchant.toJson()).toList();
        // final Map<String, dynamic> result = {'data': jsonDataList};

        print("local");
        // print(result['data']);
        // print(response.data['data']);

        // data: response.data['data'])
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
      print("ini error");
      print(e);
      // throw Exception(e.toString());
    }
  }

  static Future<DataWs?> update_pemasangan(
      String session,
      String id,
      String id_job,
      String tid,
      String sn,
      Io.File foto_merchant,
      String catatan,
      String pic,
      String no_pic,
      String timezone,
      String tids) async {
    // final bytesFotoMesin = Io.File(foto_mesin.path).readAsBytesSync();
    // String image_mesin = base64Encode(bytesFotoMesin);

    final bytesFotoMerchant = Io.File(foto_merchant.path).readAsBytesSync();
    String image_merchant = base64Encode(bytesFotoMerchant);

    // final bytesFotoStruk = Io.File(foto_struk.path).readAsBytesSync();
    // String image_struk = base64Encode(bytesFotoStruk);

    // final bytesFotoOptional = Io.File(foto_optional.path).readAsBytesSync();
    // var image_optional = base64Encode(bytesFotoOptional);

    FormData formData = FormData.fromMap({
      "session": session.toString(),
      "id": id.toString(),
      "id_job": id_job.toString(),
      "tid": tid.toString(),
      "sn": sn.toString(),
      "foto_merchant": image_merchant,
      "pic": pic.toString(),
      "no_pic": no_pic.toString(),
      "catatan": catatan.toString(),
      "timezone": timezone.toString(),
      "tids_update": tids
    });
    try {
      var response = await Dio().post(
        "https://pameran.jtracker.id/api_mobile/api_mobile/update_data",
        data: formData,
        options: Options(contentType: Headers.formUrlEncodedContentType),
        onSendProgress: (count, total) {
          print("${(count / total * 100).toStringAsFixed(0)}%");
          // var total_count = (count / total * 100).toStringAsFixed(0);
          // // return total_count;
        },
      );
      // print(response.data['ErrorMessage']);
      print(response.statusCode);

      if (response.statusCode == 200) {
        // print(response.data['data']);
        // print(response.data['data'].contains("1"));
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
      // throw Exception(e.toString());
    }
  }
}
