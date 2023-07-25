import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../components/user_api_response.dart';
import '../../models/user_model/User.dart';

class UserService {

  static const Api = 'http://192.168.1.3:8080/api2';
  final url = Uri.parse('$Api/client');
  

  static const headers = {
    'Content-Type': 'application/json'
  };
  

  Future<UserApiResponse<List<User>>> getUsers()  {
    return http.get(url).then((data) {
      
      
      if (data.statusCode == 200) {
        
        final jsonData = jsonDecode(data.body);
        final users = <User>[]; 
        for (var item in jsonData) {
            users.add(User.fromJson(item));
        }

        return UserApiResponse<List<User>>(data: users);
      }
      return UserApiResponse<List<User>>(error: true, errorMessage: 'An error occured');
    });
    // .catchError((_) => ApiResponse<List<Publisher>>(error: true, errorMessage: 'An error occured2'));
    
  }

  Future<UserApiResponse<User>> getUserById(int id)  {
    
    var urlId = Uri.parse('$url/$id');

    return http.get(urlId).then((data) {

      if (data.statusCode == 200) {
        final jsonData = jsonDecode(data.body);
        
        
        return UserApiResponse<User>(data: User.fromJson(jsonData));
      }
      return UserApiResponse<User>(error: true, errorMessage: 'An error occured');
    });
    
  }

  Future<UserApiResponse<bool>> createUser(User user)  {
    return http.post(url, headers: headers, body: json.encode(user.toJson())).
    then((data) {

      if (data.statusCode == 201) {
         
        return UserApiResponse<bool>(data: true);
        }
      return UserApiResponse<bool>(error: true, errorMessage: 'Ocorreu um erro no service');
    });
      }
    

  Future<UserApiResponse<bool>> updateUser(int id, User user) {
    var urlId = Uri.parse('$url/$id');

    return http.put(urlId, headers: headers, body: json.encode(user.toJson()))
    .then((data) {
      if (data.statusCode == 200) {
        
        return UserApiResponse<bool>(data: true);
        }
      return UserApiResponse<bool>(error: true, errorMessage: 'Ocorreu um erro no service');

    });
    
      }

      Future<UserApiResponse<bool>> deleteUser(int id) {
    var urlId = Uri.parse('$url/$id');

    return http.delete(urlId, headers: headers)
    .then((data) {
      if (data.statusCode == 204) {
        
        return UserApiResponse<bool>(data: true);
        }
      return UserApiResponse<bool>(error: true, errorMessage: 'Ocorreu um erro no service');

    });
    
      }


}