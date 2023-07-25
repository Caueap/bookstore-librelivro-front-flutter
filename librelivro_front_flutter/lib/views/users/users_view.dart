
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:librelivro_front_flutter/services/user_service/user_service.dart';
import 'package:librelivro_front_flutter/views/users/users_delete.dart';
import 'package:librelivro_front_flutter/views/users/users_modify.dart';

import '../../components/navigation_drawer.dart';
import '../../components/user_api_response.dart';
import '../../models/user_model/User.dart';

class UsersView extends StatefulWidget {
  

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {

  UserService get userService => GetIt.instance<UserService>();

  late UserApiResponse<List<User>> userApiResponse;
  bool isLoading = false;

    @override
  void initState() {
    _fetchUsers();
    super.initState();
  }
 
  _fetchUsers() async {
    setState(() {
      isLoading = true;
      
    });
    
    userApiResponse = await userService.getUsers();

  

    // await Future.delayed(Duration(seconds: 3));
    setState(() {
      isLoading = false;
      
    });
  }




  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Usuários'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => UserModify()
          )).then((_) {
            _fetchUsers();
          });
        } ,
        child: Icon(Icons.add),
      ),
      body: Builder(
        builder: (_) {
          if (isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (userApiResponse.error) {
            return Center(child: Text(userApiResponse.errorMessage));
          }


          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: userApiResponse.data!.length,
              itemBuilder: (_, index) {
                return Card(
                  child: ExpansionTile(
                    title: Text(
                      userApiResponse.data![index].name,
                    style: TextStyle(color: Theme.of(context).primaryColor,
                    fontSize: 24)),
                    
                    children: [
                      Align(
                        alignment: Alignment.centerLeft, 

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${userApiResponse.data![index].email}'),
                        Text('Cidade: ${userApiResponse.data![index].city}'),
                        Text('Endereço: ${userApiResponse.data![index].address}'),
                      ],
                    ),
                        )
                        ),
                      ),


                        
                            Align(
                            alignment: Alignment.centerRight,  
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit,
                                  color: Theme.of(context).primaryColor),
                                  
                                  onPressed: () {
                                    Navigator.of(context)
                                    .push(MaterialPageRoute(
                                      builder: (_) => UserModify(
                                        id: userApiResponse.data?[index].id)))
                                        .then((data) => {
                                          _fetchUsers()
                                        });
                                        } ,
                                      ),
                                  IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    final result = await showDialog(
                                      context: context,
                                      builder: (_) => UserDelete());

                                      if (result) {
                                        final deleteResult = await userService.deleteUser(userApiResponse.data![index].id);

                                        var message;
                                        if (deleteResult != null && deleteResult.data == true) {
                                           message = 'Usuário excluido';
                                        } else {
                                          message = deleteResult.errorMessage;
                                        }

                                        showDialog(
                                          context: context,
                                          builder: (_) {
                                            return AlertDialog(
                                            title: Text('Sucesso!'),
                                            content: Text(message),
                                            actions: [
                                              TextButton(
                                                child: Text('Ok'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                }) 
                                                
                                            ]
                                          );})
                                          .then((data) {
                                            if (deleteResult.data!) {
                                              _fetchUsers();
                                            }
                                          });
                                      }
                                      print(result);
                                      return result;  
                                  })],
                                
                            
                            ),
                          )],
                  ),
                );
              })
              );
        } ),
    );
  }
}