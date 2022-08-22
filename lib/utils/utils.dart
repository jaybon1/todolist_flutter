import 'dart:convert';
import 'package:get/get.dart';
import 'package:todolist/model/dto/common/response_dto.dart';

class Utils {
  static void _errorAlert(Response response) {
    final Map<String, dynamic> decodedResponseBody =
    jsonDecode(response.bodyString!);
    ResponseDto<dynamic> responseDto = ResponseDto<dynamic>(
      code: decodedResponseBody["code"],
      message: decodedResponseBody["message"],
    );
    Get.snackbar("알림", responseDto.message);
  }

  static void _defaultErrorAlert() {
    Get.snackbar("알림", ResponseDto().message);
  }

  static void errorHandle(Response response) {
    if (response.bodyString != null) {
      if (response.statusCode == 401) {
        // 인증 실패
        _errorAlert(response);
      } else if (response.statusCode == 403) {
        // 인가 실패
        _errorAlert(response);
      } else if (response.statusCode == 400) {
        // 잘못된 요청
        _errorAlert(response);
      } else if (response.statusCode == 500) {
        // 서버 에러
        _errorAlert(response);
      } else {
        // 객체는 왔으나 알수 없는 에러
        _errorAlert(response);
      }
    } else {
      // 통신 에러
      _defaultErrorAlert();
    }
  }
}
