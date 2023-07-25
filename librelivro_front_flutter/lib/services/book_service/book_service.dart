
import 'dart:convert';
import 'package:librelivro_front_flutter/components/book_api_response.dart';
import 'package:librelivro_front_flutter/models/book_model/book.dart';
import 'package:http/http.dart' as http;

class BookService {

  static const Api = 'http://192.168.1.3:8080/api2';
  final url = Uri.parse('$Api/book');
  

  static const headers = {
    'Content-Type': 'application/json'
  };
  




  Future<BookApiResponse<List<Book>>> getBooks()  {
    return http.get(url).then((data) {
      
      
      if (data.statusCode == 200) {
        
        final jsonData = jsonDecode(data.body);
        final books = <Book>[]; 
        for (var item in jsonData) {
            books.add(Book.fromJson(item));
        }

        return BookApiResponse<List<Book>>(data: books);
      }
      return BookApiResponse<List<Book>>(error: true, errorMessage: 'An error occured');
    });
    // .catchError((_) => ApiResponse<List<Publisher>>(error: true, errorMessage: 'An error occured2'));
    
  }

  Future<BookApiResponse<Book>> getBookById(int id)  {
    
    var urlId = Uri.parse('$url/$id');

    return http.get(urlId).then((data) {

      if (data.statusCode == 200) {
        final jsonData = jsonDecode(data.body);
        
        
        return BookApiResponse<Book>(data: Book.fromJson(jsonData));
      }
      return BookApiResponse<Book>(error: true, errorMessage: 'An error occured');
    });
    
  }

  Future<BookApiResponse<bool>> createBook(Book book)  {
    return http.post(url, headers: headers, body: json.encode(book.toJson())).
    then((data) {

      if (data.statusCode == 201) {
         
        return BookApiResponse<bool>(data: true);
        }
      return BookApiResponse<bool>(error: true, errorMessage: 'Ocorreu um erro no service');
    });
      }
    

  Future<BookApiResponse<bool>> updateBook(int id, Book book) {
    var urlId = Uri.parse('$url/$id');

    return http.put(urlId, headers: headers, body: json.encode(book.toJson()))
    .then((data) {
      if (data.statusCode == 200) {
        
        return BookApiResponse<bool>(data: true);
        }
      return BookApiResponse<bool>(error: true, errorMessage: 'Ocorreu um erro no service');

    });
    
      }

      Future<BookApiResponse<bool>> deleteBook(int id) {
    var urlId = Uri.parse('$url/$id');

    return http.delete(urlId, headers: headers)
    .then((data) {
      if (data.statusCode == 204) {
        
        return BookApiResponse<bool>(data: true);
        }
      return BookApiResponse<bool>(error: true, errorMessage: 'Ocorreu um erro no service');

    });
    
      }


}