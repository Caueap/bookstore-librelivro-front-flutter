
import 'dart:convert';

import 'package:librelivro_front_flutter/models/Publisher.dart';
import 'package:librelivro_front_flutter/models/api_response.dart';
import 'package:http/http.dart' as http;

class PublisherService {

  static const Api = 'http://192.168.15.80:8080/api2';
  final url = Uri.parse('$Api/publisher');
  

  static const headers = {
    'Content-Type': 'application/json'
  };



  Future<ApiResponse<List<Publisher>>> getPublishers()  {
    return http.get(url).then((data) {

      if (data.statusCode == 200) {
        final jsonData = jsonDecode(data.body);
        final publishers = <Publisher>[]; 
        for (var item in jsonData) {
            publishers.add(Publisher.fromJson(item));
        }
        return ApiResponse<List<Publisher>>(data: publishers);
      }
      return ApiResponse<List<Publisher>>(error: true, errorMessage: 'An error occured');
    });
    
  }

  Future<ApiResponse<Publisher>> getPublisherById(int id)  {
    
    var urlId = Uri.parse('$url/$id');

    return http.get(urlId).then((data) {

      if (data.statusCode == 200) {
        final jsonData = jsonDecode(data.body);
        
        
        return ApiResponse<Publisher>(data: Publisher.fromJson(jsonData));
      }
      return ApiResponse<Publisher>(error: true, errorMessage: 'An error occured');
    });
    
  }

  Future<ApiResponse<bool>> createPublisher(Publisher publisher)  {
    return http.post(url, headers: headers, body: json.encode(publisher.toJson())).
    then((data) {

      if (data.statusCode == 201) {
        // final jsonData = jsonDecode(result.body);
        // final publishers = <Publisher>[]; 
        // for (var item in jsonData) {
        //   final publisher = Publisher(
                              // Quando passava o id, estava dando erro. Suposição: o id não é passado,
                              // é gerado dinamicamente pelo back. O erro era o 415.
            
            // id: item['id'],
            // name:['name'],
            // city:['city']
            // );
            // publishers.add(publisher);
        return ApiResponse<bool>(data: true);
        }
      return ApiResponse<bool>(error: true, errorMessage: 'Ocorreu um erro no service');
    });
      }
    

  Future<ApiResponse<bool>> updatePublisher(int id, Publisher publisher) {
    var urlId = Uri.parse('$url/$id');

    return http.put(urlId, headers: headers, body: json.encode(publisher.toJson()))
    .then((data) {
      if (data.statusCode == 200) {
        
        return ApiResponse<bool>(data: true);
        }
      return ApiResponse<bool>(error: true, errorMessage: 'Ocorreu um erro no service');

    });
    
      }

      Future<ApiResponse<bool>> deletePublisher(int id) {
    var urlId = Uri.parse('$url/$id');

    return http.delete(urlId, headers: headers)
    .then((data) {
      if (data.statusCode == 204) {
        
        return ApiResponse<bool>(data: true);
        }
      return ApiResponse<bool>(error: true, errorMessage: 'Ocorreu um erro no service');

    });
    
      }


}