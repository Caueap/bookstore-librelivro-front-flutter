
class ApiResponse<T> {
  T ?data;
  String errorMessage;
  bool error;

  ApiResponse({this.data, this.errorMessage = '', this.error=false});
}