
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:librelivro_front_flutter/main.dart';
import '../../models/book_model/books.dart';
import 'package:librelivro_front_flutter/models/book_model/books.dart';

import 'package:librelivro_front_flutter/services/publisher_service/publisher_service.dart';
import '../../components/publisher_api_response.dart';
import '../../models/publisher_model/Publisher.dart';
import 'package:intl/intl.dart';

import '../../services/book_service/book_service.dart';

 
class BookModify extends StatefulWidget {


    
  int? id;

  BookModify({this.id});

  @override
  State<BookModify> createState() => _BookModifyState();

  
}

class _BookModifyState extends State<BookModify> {

  BookService get bookService => GetIt.instance<BookService>();
  PublisherService get publisherService => GetIt.instance<PublisherService>();

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

  getBookByIdInModify () {

   setState(() {
          isLoading = true;
        });

        bookService.getBookById(widget.id ?? 0)
        .then((response) {
          
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
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar livro' : 'Cadastrar livro'
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: isLoading ? Center(child: CircularProgressIndicator()) : Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Nome do livro'
                ),
              ),

            Container(height: 8),

            TextField(
              controller: authorController,
              decoration: InputDecoration(
                hintText: 'Autor'
                ),
              ),

              Container(height: 8),

              TextField(  
              controller: releaseDateController,
              decoration: InputDecoration(
                hintText: 'Data de lançamento'
                ),
              ),

              Container(height: 8),

              TextField(
              controller: amountController,
              decoration: InputDecoration(
                hintText: 'Quantidade'
                ),
              ),

              Container(height: 8),

              DropdownButtonFormField<Publisher>(
                  value: selectedPublisher,
                  hint: Text('Selecione uma editora'), // Placeholder text
                  items: publishers!.map((Publisher selectedPublisher) {
                    return DropdownMenuItem<Publisher>(
                      value: selectedPublisher,
                      child: Text(selectedPublisher.name), // Display the publisher name in the dropdown
                    );
                  }).toList(),
                  onChanged: (newPublisher) {
                    setState(() {
                      selectedPublisher = newPublisher;
                    });
                  },
                ),

                Container(height: 8),

                 SizedBox(
                  width: double.infinity,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (isEditing) {

                        setState(() {
                          isLoading = true;
                        });

                        final releaseDate = DateTime.parse(releaseDateController.text);
                        final formattedReleaseDate = DateFormat('yyyy-MM-dd').format(releaseDate);

                        final book =  Book(
                          //Obs: estava dando erro 400 bad request. Tive que adicionar o controller nos
                          //TextField acima. Senão, o nome e a cidade seriam passados nulos.
                          name: nameController.text,
                          author: authorController.text,
                          releaseDateTo: formattedReleaseDate,
                          amount: int.parse(amountController.text),
                          publisherModelId: selectedPublisher!.id
                        );

                        
                        final bookService = BookService();
                        final result  = await bookService.updateBook(widget.id!, book);

                        setState(() {
                          isLoading = false;
                        });

                        final text = result.error ? (result.errorMessage ?? 'Erro no modify') : 'Livro Atualizado!';
                        
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

                      } else {

                        setState(() {
                          isLoading = true;
                        });

                        final releaseDate = DateTime.parse(releaseDateController.text);
                        final formattedReleaseDate = DateFormat('yyyy-MM-dd').format(releaseDate);

                        final book =  Book(
                          //Obs: estava dando erro 400 bad request. Tive que adicionar o controller nos
                          //TextField acima. Senão, o nome e a cidade seriam passados nulos.
                          name: nameController.text,
                          author: authorController.text,
                          releaseDateTo: formattedReleaseDate,
                          amount: int.parse(amountController.text),
                          publisherModelId: selectedPublisher!.id
                          
                        );

                        
                        final bookService = BookService();
                        final result  = await bookService.createBook(book);

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
    );
  }
}