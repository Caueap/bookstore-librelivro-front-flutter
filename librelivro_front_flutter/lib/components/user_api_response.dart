class UserApiResponse<T> {
  T ?data;
  String errorMessage;
  bool error;

  UserApiResponse({
    this.data,
    this.errorMessage = '',
    this.error=false
    });
}