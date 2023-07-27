class RentalApiResponse<T> {
  T ?data;
  String errorMessage;
  bool error;

  RentalApiResponse({
    this.data,
    this.errorMessage = '',
    this.error=false
    });
}