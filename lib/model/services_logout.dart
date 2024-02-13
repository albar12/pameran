import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jadin_pameran/data/data_ws.dart';

class ServicesLogout {
  static Future<DataWs?> logout(String session) async {
    try {
      var response = await Dio().post(
          "https://pameran.jtracker.id/api_mobile/api_mobile/logout",
          data: jsonEncode({'session': session}));
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
