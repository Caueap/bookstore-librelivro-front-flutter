import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:librelivro_front_flutter/models/publisher_model/publisher.dart';
import '../../services/publisher_service/publisher_service.dart';

class PublisherModify extends StatefulWidget {
  final int? id;

  PublisherModify({this.id});

  @override
  State<PublisherModify> createState() => _PublisherModifyState();
}

class _PublisherModifyState extends State<PublisherModify> {
  PublisherService get publisherService => GetIt.instance<PublisherService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  bool get isEditing => widget.id != null;
  bool isLoading = false;
  String errorMessage = '';
  Publisher? publisher;

  @override
  void initState() {
    super.initState();

    setState(() {
      isLoading = true;
    });

    publisherService.getPublisherById(widget.id ?? 0).then((response) {
      setState(() {
        isLoading = false;
      });

      if (response.error) {
        errorMessage = response.errorMessage;
      }
      publisher = response.data!;
      nameController.text = publisher!.name;
      cityController.text = publisher!.city;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Editar editora' : 'Cadastrar editora'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: nameController,
                          decoration:
                              InputDecoration(hintText: 'Nome da editora'),
                          validator: validatePublisherName,
                        ),
                        Container(height: 8),
                        TextFormField(
                          controller: cityController,
                          decoration:
                              InputDecoration(hintText: 'Cidade da editora'),
                          validator: validateCity,
                        ),
                        Container(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 35,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (isEditing) {
                                updatePublisher(context);
                              } else {
                                createPublisher(context);
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context).colorScheme.primary)),
                            child: Text(
                              isEditing ? 'Atualizar' : 'Cadastrar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  )));
  }

  String? validatePublisherName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    } else if (value.length < 3) {
      return 'Mínimo de 3 caracteres';
    } else if (value.length > 50) {
      return 'Máximo de 50 caracteres';
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

  void createPublisher(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final publisher =
          Publisher(name: nameController.text, city: cityController.text);

      final publisherService = PublisherService();
      final result = await publisherService.createPublisher(publisher);

      setState(() {
        isLoading = false;
      });

      final text = result.error ? (result.errorMessage) : 'Editora Cadastrada!';

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

  void updatePublisher(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final publisher =
          Publisher(name: nameController.text, city: cityController.text);

      final publisherService = PublisherService();
      final result =
          await publisherService.updatePublisher(widget.id!, publisher);

      setState(() {
        isLoading = false;
      });

      final text = result.error ? (result.errorMessage) : 'Editora Atualizada!';

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
