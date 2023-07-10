
import 'dart:convert';

import 'package:librelivro_front_flutter/models/Publisher.dart';
import 'package:librelivro_front_flutter/models/api_response.dart';
import 'package:http/http.dart' as http;

class PublisherService {

  static const Api = 'http://192.168.15.80:8080/api2';
  final url = Uri.parse('$Api/publisher');



  Future<ApiResponse<List<Publisher>>> getPublishers() async {
    var result = await http.get(url);
    
      if (result.statusCode == 200) {
        final jsonData = jsonDecode(result.body);
        final publishers = <Publisher>[];
        for (var item in jsonData) {
          final publisher = Publisher(
            id: item['id'],
            name: item['name'],
            city: item['city']
            );
            publishers.add(publisher);
        }
        return ApiResponse<List<Publisher>>(data: publishers);
      }
      return ApiResponse<List<Publisher>>(error: true, errorMessage: 'An error occured');
    
    

    

  }
}