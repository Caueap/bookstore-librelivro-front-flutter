class BookApiResponse<T> {
  T ?data;
  String errorMessage;
  bool error;

  BookApiResponse({
    this.data,
    this.errorMessage = '',
    this.error=false
    });
}