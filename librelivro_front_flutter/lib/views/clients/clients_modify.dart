import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../components/utilities/validations/validations.dart';
import '../../models/client_model/client.dart';
import '../../services/client_service/client_service.dart';

class ClientModify extends StatefulWidget {
  final int? id;

  ClientModify({this.id});

  @override
  State<ClientModify> createState() => _ClientModifyState();
}

class _ClientModifyState extends State<ClientModify> {
  ClientService get userService => GetIt.instance<ClientService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Validations validations = Validations();

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
      client = response.data;
      if (client != null) {
        nameController.text = client!.name;
        emailController.text = client!.email;
        cityController.text = client!.city;
        addressController.text = client!.address;
      }
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
                        validator: validateForNameAndCityAndAddressFields,
                      ),
                      Container(height: 8),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(hintText: 'Email'),
                        validator: validations.validateEmail,
                      ),
                      Container(height: 8),
                      TextFormField(
                        controller: cityController,
                        decoration: InputDecoration(hintText: 'Cidade'),
                        validator: validateForNameAndCityAndAddressFields,
                      ),
                      Container(height: 8),
                      TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(hintText: 'Endereço'),
                        validator: validateForNameAndCityAndAddressFields,
                      ),
                      Container(height: 8),
                      Container(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 35,
                        child: ElevatedButton(
                          onPressed: () {
                            if (isEditing) {
                              updateClient(context);
                            } else {
                              createClient(context);
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

  String? validateForNameAndCityAndAddressFields(String? value) {
    final validations = Validations();

    final notEmpty = validations.validateFieldNotEmpty(value);
    if (notEmpty != null) {
      return notEmpty;
    }

    final validName = validations.validateEntityName(value);
    if (validName != null) {
      return validName;
    }
    return null;
  }

  void createClient(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final client = Client(
          name: nameController.text,
          email: emailController.text,
          city: cityController.text,
          address: addressController.text);

      final clientService = ClientService();
      final result = await clientService.createClient(client);

      setState(() {
        isLoading = false;
      });

      final text = result.error ? (result.errorMessage) : 'Usuário Cadastrado!';

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

  void updateClient(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final client = Client(
        name: nameController.text,
        email: emailController.text,
        city: cityController.text,
        address: addressController.text,
      );

      final clientService = ClientService();
      final result = await clientService.updateClient(widget.id!, client);

      setState(() {
        isLoading = false;
      });

      final text = result.error ? (result.errorMessage) : 'Usuário Atualizado!';

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
}
