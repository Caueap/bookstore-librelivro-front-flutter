
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:librelivro_front_flutter/services/user_service/user_service.dart';

import '../../components/user_api_response.dart';
import '../../models/user_model/User.dart';



class UserModify extends StatefulWidget {

  int? id;

  UserModify({this.id});

  @override
  State<UserModify> createState() => _UserModifyState();

  
}

class _UserModifyState extends State<UserModify> {

  // BookService get bookService => GetIt.instance<BookService>();
  // PublisherService get publisherService => GetIt.instance<PublisherService>();
  UserService get userService => GetIt.instance<UserService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  
  

 
   bool get isEditing => widget.id != null;
   bool isLoading = false;
   String errorMessage = '';
   User? user;
  


  @override
  void initState() {
    getUserByIdInModify();
    super.initState();
  }
 

  getUserByIdInModify () {

   setState(() {
          isLoading = true;
        });

        userService.getUserById(widget.id ?? 0)
        .then((response) {
          
          setState(() {
          isLoading = false;
        });

          if (response.error) {
            errorMessage = response.errorMessage;
          }
          user = response.data!;
          nameController.text = user!.name;
          emailController.text = user!.email;
          cityController.text = user!.city;
          addressController.text = user!.address;
          
        });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar usuário' : 'Cadastrar usuário'
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: isLoading ? Center(child: CircularProgressIndicator())
         : Form( 
          key: formKey,
          child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Nome do usuário'
                ),
                
                
              ),

            Container(height: 8),

            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email'
                ),
                
                
              ),

              Container(height: 8),

              TextFormField(  
              controller: cityController,
              decoration: InputDecoration(
                hintText: 'Cidade'
                ),
               
              ),


              Container(height: 8),

              TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                hintText: 'Endereço'
                ),
                
              ),

              Container(height: 8),

              

                Container(height: 8),

                 SizedBox(
                  width: double.infinity,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (isEditing) {

                        if (formKey.currentState!.validate()) {

                        setState(() {
                          isLoading = true;
                        });

                        // final releaseDate = DateTime.parse(releaseDateController.text);
                        // final formattedReleaseDate = DateFormat('yyyy-MM-dd').format(releaseDate);

                        final user =  User(
                          //Obs: estava dando erro 400 bad request. Tive que adicionar o controller nos
                          //TextField acima. Senão, o nome e a cidade seriam passados nulos.
                          name: nameController.text,
                          email: emailController.text,
                          city: cityController.text,
                          address: addressController.text,
                          
                        );

                        
                        final userService = UserService();
                        final result  = await userService.updateUser(widget.id!, user);

                        setState(() {
                          isLoading = false;
                        });

                        final text = result.error ? (result.errorMessage ?? 'Erro no modify') : 'Usuário Atualizado!';
                        
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                            title: Text('Success'),
                            content: Text(text),
                            actions: [
                              TextButton(
                                child: Text('Ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }) 
                                
                            ]
                          );})
                          .then((data) {
                            if (result.data!) {
                              Navigator.of(context).pop();
                            }
                          });
                        }

                    
                      


                      } else {

                        if (formKey.currentState!.validate()) {

                        setState(() {
                          isLoading = true;
                        });

                        // final releaseDate = DateTime.parse(releaseDateController.text);
                        // final formattedReleaseDate = DateFormat('yyyy-MM-dd').format(releaseDate);

                        

                        final user =  User(
                          //Obs: estava dando erro 400 bad request. Tive que adicionar o controller nos
                          //TextField acima. Senão, o nome e a cidade seriam passados nulos.
                          name: nameController.text,
                          email: emailController.text,
                          city: cityController.text,
                          address: addressController.text
                          
                        );

                        
                        final userService = UserService();
                        final result  = await userService.createUser(user);

                        setState(() {
                          isLoading = false;
                        });

                        final text = result.error ? (result.errorMessage ?? 'Erro no modify') : 'Usuário Cadastrado!';
                        
                        
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                            title: Text('Success'),
                            content: Text(text),
                            actions: [
                              TextButton(
                                child: Text('Ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }) 
                                
                            ]
                          );})
                          .then((data) {
                            if (result.data!) {
                              Navigator.of(context).pop();
                            }
                          });

                        }

                      }
                    
                    },
                      
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty
                        .all<Color>
                        (Theme.of(context).
                        colorScheme.primary)
                        ),

                    child: Text(
                      isEditing ? 'Atualizar' : 'Cadastrar',
                      style: TextStyle(color: Colors.white),
                      ),
                  ),

             
           )

              
          ],
        ),
      ),
      )
    );
  }

  // String? validateBookName(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Este campo é obrigatório';
  //   } else if (value.length < 3) {
  //     return 'Mínimo de 3 caracteres';
  //   } else if (value.length > 50) {
  //     return 'Máximo de 50 caracteres';
  //   }
  //   return null;
  // }

  // String? validateAuthorName(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Este campo é obrigatório';
  //   } else if (value.length < 3) {
  //     return 'Mínimo de 3 caracteres';
  //   } else if (value.length > 50) {
  //     return 'Máximo de 50 caracteres';
  //   }
  //   return null;
  // }

  // String? validateAmount(String? value) {
  
  //  if (value == null || value.isEmpty) {
  //   return 'Este campo é obrigatório';
  // }

  // // Check if the value is a valid integer
  // int? intValue = int.tryParse(value);
  // if (intValue == null) {
  //   return 'Este campo suporta apenas números';
  // }

  // if (intValue < 0) {
  //   return 'Por favor, informe um valor acima de 0';
  // }
  //   return null;
  // }

  // String? validatePublisher(Publisher? value) {
  //   if (value == null) {
  //     return 'Selecione uma editora';
  //   } 
  //   return null;
  // }

}