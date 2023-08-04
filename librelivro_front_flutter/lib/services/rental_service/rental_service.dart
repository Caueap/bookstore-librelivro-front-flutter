import 'dart:convert';

import 'package:librelivro_front_flutter/components/rental_api_response.dart';
import '../../models/rental_model/rental.dart';
import 'package:http/http.dart' as http;

class RentalService {

  static const Api = 'http://192.168.1.5:8080/api2';
  final url = Uri.parse('$Api/rental');
  

  static const headers = {
    'Content-Type': 'application/json'
  };
  

  Future<RentalApiResponse<List<Rental>>> getRentals()  {
    return http.get(url).then((data) {
      
      
      if (data.statusCode == 200) {
        
        final jsonData = jsonDecode(utf8.decode(data.body.codeUnits));
        final rentals = <Rental>[]; 
        for (var item in jsonData) {
            rentals.add(Rental.fromJson(item));
        }

        return RentalApiResponse<List<Rental>>(data: rentals);
      }
      return RentalApiResponse<List<Rental>>(error: true, errorMessage: 'An error occured');
    });
    // .catchError((_) => ApiResponse<List<Publisher>>(error: true, errorMessage: 'An error occured2'));
    
  }

  Future<RentalApiResponse<Rental>> getRentalById(int id)  {
    
    var urlId = Uri.parse('$url/$id');

    return http.get(urlId).then((data) {

      if (data.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(data.body.codeUnits));
        
        
        return RentalApiResponse<Rental>(data: Rental.fromJson(jsonData));
      }
      return RentalApiResponse<Rental>(error: true, errorMessage: 'An error occured');
    });
    
  }

  Future<RentalApiResponse<bool>> createRental(Rental rental)  {
    return http.post(url, headers: headers, body: json.encode(rental.toJson())).
    then((data) {

      if (data.statusCode == 201) {
         
        return RentalApiResponse<bool>(data: true);
      }

      if (data.statusCode == 400) {
        final dataBody = jsonDecode(data.body);
        final backError = dataBody['message'];
      return RentalApiResponse<bool>(error: true, errorMessage: backError);
      }
      return RentalApiResponse<bool>(error: true, errorMessage: 'erro na service');
    });
      }
    

  Future<RentalApiResponse<bool>> updateRental(int id, Rental rental) {
    var urlId = Uri.parse('$url/$id');

    return http.put(urlId, headers: headers, body: json.encode(rental.toJson()))
    .then((data) {
      if (data.statusCode == 200) {
        
        return RentalApiResponse<bool>(data: true);
        }
      return RentalApiResponse<bool>(error: true, errorMessage: 'Ocorreu um erro no service');

    });
    
      }

      Future<RentalApiResponse<bool>> deleteRental(int id) {
    var urlId = Uri.parse('$url/$id');

    return http.delete(urlId, headers: headers)
    .then((data) {
      if (data.statusCode == 204) {
        
        return RentalApiResponse<bool>(data: true);
        }
      return RentalApiResponse<bool>(error: true, errorMessage: 'Ocorreu um erro no service');

    });
    
      }


}