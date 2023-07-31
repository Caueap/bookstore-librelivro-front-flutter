
import 'dart:convert';

import 'package:librelivro_front_flutter/models/publisher_model/publisher.dart';
import 'package:librelivro_front_flutter/components/publisher_api_response.dart';
import 'package:http/http.dart' as http;

class PublisherService {

  static const Api = 'http://192.168.1.5:8080/api2';
  final url = Uri.parse('$Api/publisher');
  

  static const headers = {
    'Content-Type': 'application/json'
  };



  Future<PublisherApiResponse<List<Publisher>>> getPublishers()  { 
    return http.get(url).then((data) {
      
      
      if (data.statusCode == 200) {
        
        final jsonData = jsonDecode(data.body); 
        final publishers = <Publisher>[]; 
        for (var item in jsonData) {
            publishers.add(Publisher.fromJson(item));
        }

        return PublisherApiResponse<List<Publisher>>(data: publishers);
      }
      return PublisherApiResponse<List<Publisher>>(error: true, errorMessage: 'An error occured');
    });
    // .catchError((_) => ApiResponse<List<Publisher>>(error: true, errorMessage: 'An error occured2'));
    
  }

  Future<PublisherApiResponse<Publisher>> getPublisherById(int id)  {
    
    var urlId = Uri.parse('$url/$id');

    return http.get(urlId).then((data) {

      if (data.statusCode == 200) {
        final jsonData = jsonDecode(data.body);
        
        
        return PublisherApiResponse<Publisher>(data: Publisher.fromJson(jsonData));
      }
      return PublisherApiResponse<Publisher>(error: true, errorMessage: 'An error occured');
    });
    
  }

  Future<PublisherApiResponse<bool>> createPublisher(Publisher publisher)  {
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
        return PublisherApiResponse<bool>(data: true);
        }
      return PublisherApiResponse<bool>(error: true, errorMessage: 'Ocorreu um erro no service');
    });
      }
    

  Future<PublisherApiResponse<bool>> updatePublisher(int id, Publisher publisher) {
    var urlId = Uri.parse('$url/$id');

    return http.put(urlId, headers: headers, body: json.encode(publisher.toJson()))
    .then((data) {
      if (data.statusCode == 200) {
        
        return PublisherApiResponse<bool>(data: true);
        }
      return PublisherApiResponse<bool>(error: true, errorMessage: 'Ocorreu um erro no service');

    });
    
      }

      Future<PublisherApiResponse<bool>> deletePublisher(int id) {
    var urlId = Uri.parse('$url/$id');

    return http.delete(urlId, headers: headers)
    .then((data) {
      if (data.statusCode == 204) {
        
        return PublisherApiResponse<bool>(data: true);
        }
      return PublisherApiResponse<bool>(error: true, errorMessage: 'Ocorreu um erro no service');

    });
    
      }


}