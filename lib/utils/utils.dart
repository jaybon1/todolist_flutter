import 'dart:convert';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:todolist/model/dto/common/res_dto.dart';

class Utils {
  static final logger = Logger();

  static Future<ResDto<T>> handleResDto<T>(Response response, {Function? handleData}) {
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = jsonDecode(response.bodyString!);
      return Future(() => ResDto<T>(
          code: decodedResponse["code"],
          message: decodedResponse["message"],
          data: handleData != null ? handleData(decodedResponse["data"]) : null));
    } else if (response.bodyString != null) {
      final Map<String, dynamic> decodedResponseBody = jsonDecode(response.bodyString!);
      final responseDto = ResDto<T>(
        code: decodedResponseBody["code"],
        message: decodedResponseBody["message"],
      );
      if (response.statusCode == 401) {
        // 인증 실패
        logger.e(responseDto.message);
        return Future(() => responseDto);
      } else if (response.statusCode == 403) {
        // 인가 실패
        logger.e(responseDto.message);
        return Future(() => responseDto);
      } else if (response.statusCode == 400) {
        // 잘못된 요청
        logger.e(responseDto.message);
        return Future(() => responseDto);
      } else if (response.statusCode == 500) {
        // 서버 에러
        logger.e(responseDto.message);
        return Future(() => responseDto);
      } else {
        // 객체는 왔으나 알수 없는 에러
        logger.e(responseDto.message);
        return Future(() => responseDto);
      }
    } else {
      // 통신 에러
      final responseDto = ResDto<T>();
      logger.e(responseDto.message);
      return Future(() => responseDto);
    }
  }

// static Future<ResDto<T>> handleErrorResDto<T>(Response response) {
//   if (response.bodyString != null) {
//     final Map<String, dynamic> decodedResponseBody = jsonDecode(response.bodyString!);
//     final responseDto = ResDto<T>(
//       code: decodedResponseBody["code"],
//       message: decodedResponseBody["message"],
//     );
//     if (response.statusCode == 401) {
//       // 인증 실패
//       logger.e(responseDto.message);
//       return Future(() => responseDto);
//     } else if (response.statusCode == 403) {
//       // 인가 실패
//       logger.e(responseDto.message);
//       return Future(() => responseDto);
//     } else if (response.statusCode == 400) {
//       // 잘못된 요청
//       logger.e(responseDto.message);
//       return Future(() => responseDto);
//     } else if (response.statusCode == 500) {
//       // 서버 에러
//       logger.e(responseDto.message);
//       return Future(() => responseDto);
//     } else {
//       // 객체는 왔으나 알수 없는 에러
//       logger.e(responseDto.message);
//       return Future(() => responseDto);
//     }
//   } else {
//     // 통신 에러
//     final responseDto = ResDto<T>();
//     logger.e(responseDto.message);
//     return Future(() => responseDto);
//   }
// }
}
