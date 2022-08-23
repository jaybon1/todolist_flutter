// 처음에 곹통으로 오는 JSON 형식에 따라서 제작
class ResDto<T> {
  // 제네릭 타입을 사용하려면, freezed를 사용 X
  late final int code;
  late final String message;
  late final T? data;

  ResDto({int code = -1, String message = "예기치 못한 에러가 발생했습니다.", T? data}) {
    this.code = code;
    this.message = message;
    this.data = data;
  }
}
