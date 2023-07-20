


class BookToCreate {
  int id;
  String name;
  String author;
  String releaseDate;
  int amount;
  int? publisherModelId; 

  BookToCreate({
    this.id = 0,
    this.name = '',
    this.author = '',
    this.releaseDate = '',
    this.amount = 0,
    this.publisherModelId,
  }); 

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'author': author,
      'releaseDate': releaseDate,
      'amount': amount,
      'publisherModelId': publisherModelId,
    };
  }
}