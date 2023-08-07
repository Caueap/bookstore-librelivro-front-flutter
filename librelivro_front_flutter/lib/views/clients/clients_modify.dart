import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../models/client_model/client.dart';
import '../../services/client_service/client_service.dart';

class ClientModify extends StatefulWidget {
  int? id;
  

  ClientModify({this.id});

  @override
  State<ClientModify> createState() => _ClientModifyState();
}

class _ClientModifyState extends State<ClientModify> {
  // BookService get bookService => GetIt.instance<BookService>();
  // PublisherService get publisherService => GetIt.instance<PublisherService>();
  ClientService get userService => GetIt.instance<ClientService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool get isEditing => widget.id != null;
  bool isLoading = false;
  String errorMessage = '';
  Client? client;

  @override
  void initState() {
    getUserByIdInModify();
    super.initState();
  }

  getUserByIdInModify() {
    setState(() {
      isLoading = true;
    });

    userService.getClientById(widget.id ?? 0).then((response) {
      setState(() {
        isLoading = false;
      });

      if (response.error) {
        errorMessage = response.errorMessage;
      }
      client = response.data!;
      nameController.text = client!.name;
      emailController.text = client!.email;
      cityController.text = client!.city;
      addressController.text = client!.address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(isEditing ? 'Editar usuário' : 'Cadastrar usuário')),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration:
                            InputDecoration(hintText: 'Nome do usuário'),
                        validator: validateUserName,
                      ),
                      Container(height: 8),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(hintText: 'Email'),
                        validator: validateEmail,
                      ),
                      Container(height: 8),
                      TextFormField(
                        controller: cityController,
                        decoration: InputDecoration(hintText: 'Cidade'),
                        validator: validateCity,
                      ),
                      Container(height: 8),
                      TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(hintText: 'Endereço'),
                        validator: validateAddress,
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

                                final client = Client(
                                  //Obs: estava dando erro 400 bad request. Tive que adicionar o controller nos
                                  //TextField acima. Senão, o nome e a cidade seriam passados nulos.
                                  name: nameController.text,
                                  email: emailController.text,
                                  city: cityController.text,
                                  address: addressController.text,
                                );

                                final clientService = ClientService();
                                final result = await clientService.updateClient(
                                    widget.id!, client);

                                setState(() {
                                  isLoading = false;
                                });

                                final text = result.error
                                    ? (result.errorMessage ?? 'Erro no modify')
                                    : 'Usuário Atualizado!';

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
                                          ]);
                                    }).then((data) {
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

                                final client = Client(
                                    //Obs: estava dando erro 400 bad request. Tive que adicionar o controller nos
                                    //TextField acima. Senão, o nome e a cidade seriam passados nulos.
                                    name: nameController.text,
                                    email: emailController.text,
                                    city: cityController.text,
                                    address: addressController.text);

                                final clientService = ClientService();
                                final result =
                                    await clientService.createClient(client);

                                setState(() {
                                  isLoading = false;
                                });

                                final text = result.error
                                    ? (result.errorMessage ?? 'Erro no modify')
                                    : 'Usuário Cadastrado!';

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
                                          ]);
                                    }).then((data) {
                                  if (result.data!) {
                                    Navigator.of(context).pop();
                                  }
                                });
                              }
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).colorScheme.primary)),
                          child: Text(
                            isEditing ? 'Atualizar' : 'Cadastrar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ));
  }

  String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    } else if (value.length < 3) {
      return 'Mínimo de 3 caracteres';
    } else if (value.length > 50) {
      return 'Máximo de 50 caracteres';
    }
    return null;
  }

  String? validateEmail(String? value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Por favor, informe um formato de Email válido';
    }

    return null;
  }

  String? validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    } else if (value.length < 3) {
      return 'Mínimo de 3 caracteres';
    } else if (value.length > 50) {
      return 'Máximo de 50 caracteres';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    } else if (value.length < 3) {
      return 'Mínimo de 3 caracteres';
    } else if (value.length > 50) {
      return 'Máximo de 50 caracteres';
    }
    return null;
  }
}
