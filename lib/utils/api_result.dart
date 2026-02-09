sealed class ApiResult<T> {
  const ApiResult();
}

class Success<T> extends ApiResult<T> {
  final T data;
  final String? message;

  const Success(this.data, this.message);
}

class Failure<T> extends ApiResult<T> {
  final String? message;
  final int? statusCode;
  final dynamic error;

  const Failure({this.message, this.statusCode, this.error});
}
