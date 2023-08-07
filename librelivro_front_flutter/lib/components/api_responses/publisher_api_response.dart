
class PublisherApiResponse<T> {
  T ?data;
  String errorMessage;
  bool error;

  PublisherApiResponse({
    this.data,
    this.errorMessage = '',
    this.error=false
    });
}