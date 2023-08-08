import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../models/book_model/book.dart';
import 'package:librelivro_front_flutter/services/publisher_service/publisher_service.dart';
import '../../components/api_responses/publisher_api_response.dart';
import '../../models/publisher_model/publisher.dart';
import 'package:intl/intl.dart';
import '../../services/book_service/book_service.dart';

class BookModify extends StatefulWidget {
  final int? id;

  BookModify({this.id});

  @override
  State<BookModify> createState() => _BookModifyState();
}

class _BookModifyState extends State<BookModify> {
  BookService get bookService => GetIt.instance<BookService>();
  PublisherService get publisherService => GetIt.instance<PublisherService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  TextEditingController releaseDateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController rentedAmountController = TextEditingController();

  late PublisherApiResponse<List<Publisher>> publisherApiResponse;
  List<Publisher>? publishers = [];
  Publisher? selectedPublisher;
  bool get isEditing => widget.id != null;
  bool isLoading = false;
  String errorMessage = '';
  Book? book;
  String? datevar;

  @override
  void initState() {
    fetchPublishers();
    getBookByIdInModify();
    super.initState();
  }

  fetchPublishers() async {
    setState(() {
      isLoading = true;
    });

    publisherApiResponse = await publisherService.getPublishers();

    setState(() {
      isLoading = false;
      if (!publisherApiResponse.error) {
        publishers = publisherApiResponse.data ?? [];
        // If the selectedPublisher is already set and not in the new list of publishers,
        // reset it to null to avoid showing an invalid value in the dropdown.
        // if (selectedPublisher != null && !publishers.contains(selectedPublisher)) {
        //   selectedPublisher = null;
        // }
      } else {
        // Handle the error case if needed
        errorMessage = publisherApiResponse.errorMessage;
      }
    });
  }

  getBookByIdInModify() {
    setState(() {
      isLoading = true;
    });

    bookService.getBookById(widget.id ?? 0).then((response) {
      setState(() {
        isLoading = false;
      });

      if (response.error) {
        errorMessage = response.errorMessage;
      }
      book = response.data!;
      nameController.text = book!.name;
      authorController.text = book!.author;
      releaseDateController.text = book!.releaseDateFrom.toString();
      amountController.text = book!.amount.toString();
      rentedAmountController.text = book!.rentedAmount.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text(isEditing ? 'Editar livro' : 'Cadastrar livro')),
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
                        decoration: InputDecoration(hintText: 'Nome do livro'),
                        validator: validateBookName,
                      ),
                      Container(height: 8),
                      TextFormField(
                        controller: authorController,
                        decoration: InputDecoration(hintText: 'Autor'),
                        validator: validateAuthorName,
                      ),
                      Container(height: 8),
                      TextFormField(
                        controller: releaseDateController,
                        decoration:
                            InputDecoration(hintText: 'Data de lançamento'),
                        onTap: () async {
                          DateTime? pickeddate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(0000),
                              lastDate: DateTime.now());

                          if (pickeddate != null) {
                            setState(() {
                              releaseDateController.text =
                                  DateFormat('dd/MM/yyyy').format(pickeddate);
                            });
                          }
                        },
                        validator: validateReleaseDate,
                      ),
                      Container(height: 8),
                      TextFormField(
                        controller: amountController,
                        decoration: InputDecoration(hintText: 'Quantidade'),
                        validator: validateAmount,
                      ),
                      Container(height: 8),
                      DropdownButtonFormField<Publisher>(
                        value: selectedPublisher,
                        hint: Text('Selecione uma editora'), // Placeholder text
                        items: publishers!.map((Publisher selectedPublisher) {
                          return DropdownMenuItem<Publisher>(
                            value: selectedPublisher,
                            child: Text(selectedPublisher
                                .name), // Display the publisher name in the dropdown
                          );
                        }).toList(),
                        onChanged: (newPublisher) {
                          setState(() {
                            selectedPublisher = newPublisher;
                          });
                        },
                        validator: validatePublisher,
                      ),
                      Container(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 35,
                        child: ElevatedButton(
                          onPressed: () {
                            if (isEditing) {
                              updateBook(context);
                            } else {
                              createBook(context);
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

  String? validateBookName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    } else if (value.length < 3) {
      return 'Mínimo de 3 caracteres';
    } else if (value.length > 50) {
      return 'Máximo de 50 caracteres';
    }
    return null;
  }

  String? validateAuthorName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    } else if (value.length < 3) {
      return 'Mínimo de 3 caracteres';
    } else if (value.length > 50) {
      return 'Máximo de 50 caracteres';
    }
    return null;
  }

  String? validateReleaseDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    }
    return null;
  }

  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    }

    // Check if the value is a valid integer
    int? intValue = int.tryParse(value);
    if (intValue == null) {
      return 'Este campo suporta apenas números';
    }

    if (intValue < 0) {
      return 'Por favor, informe um valor acima de 0';
    }
    return null;
  }

  String? validatePublisher(Publisher? value) {
    if (value == null) {
      return 'Selecione uma editora';
    }
    return null;
  }

  void createBook(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final book = Book(
          name: nameController.text,
          author: authorController.text,
          releaseDateTo: releaseDateController.text,
          amount: int.parse(amountController.text),
          publisherModelId: selectedPublisher!.id);

      final bookService = BookService();
      final result = await bookService.createBook(book);

      setState(() {
        isLoading = false;
      });

      final text = result.error ? (result.errorMessage) : 'Livro Cadastrado!';

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

  void updateBook(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final book = Book(
          name: nameController.text,
          author: authorController.text,
          releaseDateTo: releaseDateController.text,
          amount: int.parse(amountController.text),
          publisherModelId: selectedPublisher!.id);

      final bookService = BookService();
      final result = await bookService.updateBook(widget.id!, book);

      setState(() {
        isLoading = false;
      });

      final text = result.error ? (result.errorMessage) : 'Livro Atualizado!';

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
