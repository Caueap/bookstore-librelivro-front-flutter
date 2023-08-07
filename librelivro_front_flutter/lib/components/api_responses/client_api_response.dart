class ClientApiResponse<T> {
  T ?data;
  String errorMessage;
  bool error;

  ClientApiResponse({
    this.data,
    this.errorMessage = '',
    this.error=false
    });
}