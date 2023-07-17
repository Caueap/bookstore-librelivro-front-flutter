import 'package:librelivro_front_flutter/models/Publisher.dart';

class BookToGet<T> {
 
  int id;
  String name;
  String author;
  DateTime? releaseDate;
  int amount;
  int rentedAmount;
  Publisher? publisherModel;

  BookToGet
  ({
    this.id = 0,
    this.name = '',
    this.author = '',
    this.releaseDate,
    this.amount = 0,
    this.rentedAmount = 0,
    this.publisherModel
    });

    factory BookToGet.fromJson(Map<String, dynamic> item) {
      return  BookToGet(
            id: item['id'],
            name: item['name'],
            author: item['author'],
            releaseDate: DateTime.parse(item['releaseDate']),
            amount: item['amount'],
            rentedAmount: item['rentedAmount'],
            publisherModel: Publisher.fromJson(item['publisherModel']) 
            );

    }

}