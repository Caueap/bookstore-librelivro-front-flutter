import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../components/client_api_response.dart';
import '../../models/client_model/client.dart';


class ClientService {

  static const Api = 'http://192.168.1.5:8080/api2';
  final url = Uri.parse('$Api/client');
  

  static const headers = {
    'Content-Type': 'application/json'
  };
  

  Future<ClientApiResponse<List<Client>>> getClients()  {
    return http.get(url).then((data) {
      
      
      if (data.statusCode == 200) {
        
        final jsonData = jsonDecode(utf8.decode(data.body.codeUnits));
        final clients = <Client>[]; 
        for (var item in jsonData) {
            clients.add(Client.fromJson(item));
        }

        return ClientApiResponse<List<Client>>(data: clients);
      }
      return ClientApiResponse<List<Client>>(error: true, errorMessage: 'An error occured');
    });
    // .catchError((_) => ApiResponse<List<Publisher>>(error: true, errorMessage: 'An error occured2'));
    
  }

  Future<ClientApiResponse<Client>> getUserById(int id)  {
    
    var urlId = Uri.parse('$url/$id');

    return http.get(urlId).then((data) {

      if (data.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(data.body.codeUnits));
        
        
        return ClientApiResponse<Client>(data: Client.fromJson(jsonData));
      }
      return ClientApiResponse<Client>(error: true, errorMessage: 'An error occured');
    });
    
  }

  Future<ClientApiResponse<bool>> createUser(Client client)  {
    return http.post(url, headers: headers, body: json.encode(client.toJson())).
    then((data) {

      if (data.statusCode == 201) {
         
        return ClientApiResponse<bool>(data: true);
        }
      return ClientApiResponse<bool>(error: true, errorMessage: 'Ocorreu um erro no service');
    });
      }
    

  Future<ClientApiResponse<bool>> updateUser(int id, Client client) {
    var urlId = Uri.parse('$url/$id');

    return http.put(urlId, headers: headers, body: json.encode(client.toJson()))
    .then((data) {
      if (data.statusCode == 200) {
        
        return ClientApiResponse<bool>(data: true);
        }
      return ClientApiResponse<bool>(error: true, errorMessage: 'Ocorreu um erro no service');

    });
    
      }

      Future<ClientApiResponse<bool>> deleteUser(int id) {
    var urlId = Uri.parse('$url/$id');

    return http.delete(urlId, headers: headers)
    .then((data) {
      if (data.statusCode == 204) {
        
        return ClientApiResponse<bool>(data: true);
        }
      return ClientApiResponse<bool>(error: true, errorMessage: 'Ocorreu um erro no service');

    });
    
      }


}