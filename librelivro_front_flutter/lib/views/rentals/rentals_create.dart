




import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../components/api_responses/book_api_response.dart';
import '../../components/api_responses/publisher_api_response.dart';
import '../../components/api_responses/client_api_response.dart';
import '../../models/book_model/book.dart';
import '../../models/client_model/client.dart';
import '../../models/rental_model/rental.dart';
import '../../services/book_service/book_service.dart';
import '../../services/client_service/client_service.dart';
import '../../services/rental_service/rental_service.dart';





class RentalCreate extends StatefulWidget {


    
  int? id;

  RentalCreate({this.id});

  @override
  State<RentalCreate> createState() => _RentalCreateState();

  
}

class _RentalCreateState extends State<RentalCreate> {


  RentalService get rentalService => GetIt.instance<RentalService>();
  BookService get bookService => GetIt.instance<BookService>();
  ClientService get clientService => GetIt.instance<ClientService>();
  

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController rentalDateController = TextEditingController();
  final TextEditingController expectedDeliveryDateController = TextEditingController();
  final TextEditingController deliveryDateController= TextEditingController();
  final TextEditingController statusController = TextEditingController();
  
  

  late BookApiResponse<List<Book>> bookApiResponse;
   List<Book>? books = [];
   Book? selectedBook;
   late ClientApiResponse<List<Client>> clientApiResponse;
   List<Client>? clients = [];
   Client? selectedClient;
   bool get isEditing => widget.id != null;
   bool isLoading = false;
   String errorMessage = '';
   Book? book;
   String? datevar;


  @override
  void initState() {
    fetchBooks();
    fetchClients();
    // getBookByIdInModify();
    super.initState();
  }

  fetchBooks() async {
    setState(() {
      isLoading = true;
    });

    bookApiResponse = await bookService.getBooks();

    setState(() {
      isLoading = false;
      if (!bookApiResponse.error) {
        books = bookApiResponse.data ?? [];
        // If the selectedPublisher is already set and not in the new list of publishers,
        // reset it to null to avoid showing an invalid value in the dropdown.
        // if (selectedPublisher != null && !publishers.contains(selectedPublisher)) {
        //   selectedPublisher = null;
        // }
      } else {
        // Handle the error case if needed
        errorMessage = bookApiResponse.errorMessage;
      }
    });
  }

  fetchClients() async {
    setState(() {
      isLoading = true;
    });

    clientApiResponse = await clientService.getClients();

    setState(() {
      isLoading = false;
      if (!clientApiResponse.error) {
        clients = clientApiResponse.data ?? [];
        // If the selectedPublisher is already set and not in the new list of publishers,
        // reset it to null to avoid showing an invalid value in the dropdown.
        // if (selectedPublisher != null && !publishers.contains(selectedPublisher)) {
        //   selectedPublisher = null;
        // }
      } else {
        // Handle the error case if needed
        errorMessage = clientApiResponse.errorMessage;
      }
    });
  }

 

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar livro' : 'Cadastrar livro'
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
              controller: rentalDateController,
              decoration: InputDecoration(
                hintText: 'Data do aluguel'
                ),
                onTap: () async {
                  DateTime? pickeddate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now());

                  if (pickeddate != null) {
                    setState(() {
                       rentalDateController.text = DateFormat('dd/MM/yyyy').format(pickeddate);
                    });
                  }
                },
                validator: validateRentalDate,
              ),

              Container(height: 8),
            
              TextFormField(  
              controller: expectedDeliveryDateController,
              decoration: InputDecoration(
                hintText: 'Data esperada de devolução'
                ),
                onTap: () async {
                  DateTime? pickeddate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 30)));

                  if (pickeddate != null) {
                    setState(() {
                       expectedDeliveryDateController.text = DateFormat('dd/MM/yyyy').format(pickeddate);
                    });
                  }
                },
                validator: validateExpectedDeliveryDate,
              ),

              DropdownButtonFormField<Book>(
                  value: selectedBook,
                  hint: Text('Selecione um livro'), // Placeholder text
                  items: books!.map((Book selectedBook) {
                    return DropdownMenuItem<Book>(
                      value: selectedBook,
                      child: Text(selectedBook.name), // Display the publisher name in the dropdown
                    );
                
                  }).toList(),
                  onChanged: (newBook) {
                    setState(() {
                      selectedBook = newBook;
                    });
                  },
                  validator: validateBook,
                ),

                Container(height: 8),

                DropdownButtonFormField<Client>(
                  value: selectedClient,
                  hint: Text('Selecione um usuário'), // Placeholder text
                  items: clients!.map((Client selectedClient) {
                    return DropdownMenuItem<Client>(
                      value: selectedClient,
                      child: Text(selectedClient.name), // Display the publisher name in the dropdown
                    );
                
                  }).toList(),
                  onChanged: (newClient) {
                    setState(() {
                      selectedClient = newClient;
                    });
                  },
                  validator: validateClient,
                ),

                Container(height: 8),

                

                 SizedBox(
                  width: double.infinity,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () async {
                      

                        if (formKey.currentState!.validate()) {

                        setState(() {
                          isLoading = true;
                        });

                        // final releaseDate = DateTime.parse(releaseDateController.text);
                        // final formattedReleaseDate = DateFormat('yyyy-MM-dd').format(releaseDate);

                        

                        final rental =  Rental(
                          //Obs: estava dando erro 400 bad request. Tive que adicionar o controller nos
                          //TextField acima. Senão, o nome e a cidade seriam passados nulos.
                          rentalDate: rentalDateController.text,
                          expectedDeliveryDate: expectedDeliveryDateController.text,
                          bookModelId: selectedBook!.id,
                          clientModelId: selectedClient!.id
                          
                          
                        );

                        
                        final rentalService = RentalService();
                        final result  = await rentalService.createRental(rental);

                        setState(() {
                          isLoading = false;
                        });

                        final text = result.error ? (result.errorMessage ?? 'Erro no modify') : 'Livro Cadastrado!';
                        
                        
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

  String? validateRentalDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    }
    return null;
  }

  String? validateExpectedDeliveryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    }
    return null;
  }

  String? validateBook(Book? value) {
    if (value == null) {
      return 'Selecione um livro';
    }
    return null;
  }

  String? validateClient(Client? value) {
    if (value == null) {
      return 'Selecione um usuário';
    }
    return null;
  }
  

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