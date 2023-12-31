import 'package:librelivro_front_flutter/models/publisher_model/publisher.dart';

class Book {
 
  int id;
  String name;
  String author;
  String releaseDateFrom;
  String releaseDateTo;
  int amount;
  int rentedAmount;
  Publisher? publisherModel; 
  int? publisherModelId;

  Book
  ({
    this.id = 0,
    this.name = '',
    this.author = '',
    this.releaseDateFrom = '',
    this.releaseDateTo = '',
    this.amount = 0,
    this.rentedAmount = 0,
    this.publisherModel,
    this.publisherModelId
    });

    factory Book.fromJson(Map<String, dynamic> item) {
      return  Book(
            id: item['id'],
            name: item['name'],
            author: item['author'],
            releaseDateFrom: item['releaseDate'],
            amount: item['amount'],
            rentedAmount: item['rentedAmount'],
            publisherModel: Publisher.fromJson(item['publisherModel']) 
            );

    }

     Map<String, dynamic> toJson() {
    return {
      'name': name,
      'author': author,
      'releaseDate': releaseDateTo,
      'amount': amount,
      'publisherModelId': publisherModelId,
    };
  }

}