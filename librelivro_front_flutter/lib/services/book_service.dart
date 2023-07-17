
import 'dart:convert';

import 'package:librelivro_front_flutter/components/book_api_response.dart';
import 'package:librelivro_front_flutter/models/book_to_get.dart';
import 'package:http/http.dart' as http;

class BookService {

  static const Api = 'http://192.168.1.2:8080/api2';
  final url = Uri.parse('$Api/book');
  

  static const headers = {
    'Content-Type': 'application/json'
  };
  




  Future<BookApiResponse<List<BookToGet>>> getBooks()  {
    return http.get(url).then((data) {
      
      
      if (data.statusCode == 200) {
        
        final jsonData = jsonDecode(data.body);
        final books = <BookToGet>[]; 
        for (var item in jsonData) {
            books.add(BookToGet.fromJson(item));
        }

        return BookApiResponse<List<BookToGet>>(data: books);
      }
      return BookApiResponse<List<BookToGet>>(error: true, errorMessage: 'An error occured');
    });
    // .catchError((_) => ApiResponse<List<Publisher>>(error: true, errorMessage: 'An error occured2'));
    
  }

  // Future<BookApiResponse<Publisher>> getPublisherById(int id)  {
    
  //   var urlId = Uri.parse('$url/$id');

  //   return http.get(urlId).then((data) {

  //     if (data.statusCode == 200) {
  //       final jsonData = jsonDecode(data.body);
        
        
  //       return BookApiResponse<Publisher>(data: Publisher.fromJson(jsonData));
  //     }
  //     return BookApiResponse<Publisher>(error: true, errorMessage: 'An error occured');
  //   });
    
  // }

  // Future<BookApiResponse<bool>> createPublisher(Publisher publisher)  {
  //   return http.post(url, headers: headers, body: json.encode(publisher.toJson())).
  //   then((data) {

  //     if (data.statusCode == 201) {
  //       // final jsonData = jsonDecode(result.body);
  //       // final publishers = <Publisher>[]; 
  //       // for (var item in jsonData) {
  //       //   final publisher = Publisher(
  //                             // Quando passava o id, estava dando erro. Suposição: o id não é passado,
  //                             // é gerado dinamicamente pelo back. O erro era o 415.
            
  //           // id: item['id'],
  //           // name:['name'],
  //           // city:['city']
  //           // );
  //           // publishers.add(publisher);
  //       return BookApiResponse<bool>(data: true);
  //       }
  //     return BookApiResponse<bool>(error: true, errorMessage: 'Ocorreu um erro no service');
  //   });
  //     }
    

  // Future<BookApiResponse<bool>> updatePublisher(int id, Publisher publisher) {
  //   var urlId = Uri.parse('$url/$id');

  //   return http.put(urlId, headers: headers, body: json.encode(publisher.toJson()))
  //   .then((data) {
  //     if (data.statusCode == 200) {
        
  //       return BookApiResponse<bool>(data: true);
  //       }
  //     return BookApiResponse<bool>(error: true, errorMessage: 'Ocorreu um erro no service');

  //   });
    
  //     }

  //     Future<BookApiResponse<bool>> deletePublisher(int id) {
  //   var urlId = Uri.parse('$url/$id');

  //   return http.delete(urlId, headers: headers)
  //   .then((data) {
  //     if (data.statusCode == 204) {
        
  //       return BookApiResponse<bool>(data: true);
  //       }
  //     return BookApiResponse<bool>(error: true, errorMessage: 'Ocorreu um erro no service');

  //   });
    
  //     }


}