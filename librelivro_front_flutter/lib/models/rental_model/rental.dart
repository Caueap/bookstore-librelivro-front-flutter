


import '../book_model/book.dart';

import '../client_model/client.dart';

class Rental {

  int id;
  String rentalDate;
  String expectedDeliveryDate;
  String deliveryDate;
  String status;
  Book? bookModel;
  Client? clientModel;
  int bookModelId;
  int clientModelId;

  Rental({
    this.id = 0,
    this.rentalDate = '',
    this.expectedDeliveryDate = '',
    this.deliveryDate = '',
    this.status = '',
    this.bookModel,
    this.clientModel,
    this.bookModelId = 0,
    this.clientModelId = 0
  });

  factory Rental.fromJson(Map<String, dynamic> item) {
      return Rental(
            id: item['id'],
            rentalDate: item['rentalDate'],
            expectedDeliveryDate: item['expectedDeliveryDate'],
            deliveryDate: item['deliveryDate'] ?? '',
            status: item['status'], 
            bookModel: Book.fromJson(item['bookModel']),
            clientModel: Client.fromJson(item['clientModel'])
            );

    }

    Map<String, dynamic> toJson() {
    return {
      'rentalDate': rentalDate,
      'expectedDeliveryDate': expectedDeliveryDate,
      'deliveryDate': deliveryDate,
      'bookModelId': bookModelId,
      'clientModelId': clientModelId
    };
  }


}