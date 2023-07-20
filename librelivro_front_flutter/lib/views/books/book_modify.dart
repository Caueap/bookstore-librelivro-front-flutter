
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:librelivro_front_flutter/main.dart';
import 'package:librelivro_front_flutter/models/book_model/book_to_create.dart';

import 'package:librelivro_front_flutter/services/publisher_service/publisher_service.dart';
import '../../components/publisher_api_response.dart';
import '../../models/publisher_model/Publisher.dart';
import 'package:intl/intl.dart';

import '../../services/book_service/book_service.dart';

 
class BookModify extends StatefulWidget {


    
  int? id;

  @override
  State<BookModify> createState() => _BookModifyState();

  
}

class _BookModifyState extends State<BookModify> {

  BookService get bookService => GetIt.instance<BookService>();
  PublisherService get publisherService => GetIt.instance<PublisherService>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController releaseDateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  late PublisherApiResponse<List<Publisher>> publisherApiResponse;
   List<Publisher>? publishers = [];
   Publisher? selectedPublisher;
   bool get isEditing => widget.id != null;
   bool isLoading = false;
   String errorMessage = '';

  @override
  void initState() {
    fetchPublishers();
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

                        // setState(() {
                        //   isLoading = true;
                        // });

                        // final publisher =  Publisher(
                        //   //Obs: estava dando erro 400 bad request. Tive que adicionar o controller nos
                        //   //TextField acima. Senão, o nome e a cidade seriam passados nulos.
                        //   name: nameController.text,
                        //   city: cityController.text 
                        // );

                        
                        // final publisherService = PublisherService();
                        // final result  = await publisherService.updatePublisher(widget.id!, publisher);

                        // setState(() {
                        //   isLoading = false;
                        // });

                        // final text = result.error ? (result.errorMessage ?? 'Erro no modify') : 'Editora Atualizada!';
                        
                        // showDialog(
                        //   context: context,
                        //   builder: (_) {
                        //     return AlertDialog(
                        //     title: Text('Success'),
                        //     content: Text(text),
                        //     actions: [
                        //       TextButton(
                        //         child: Text('Ok'),
                        //         onPressed: () {
                        //           Navigator.of(context).pop();
                        //         }) 
                                
                        //     ]
                        //   );})
                        //   .then((data) {
                        //     if (result.data!) {
                        //       Navigator.of(context).pop();
                        //     }
                        //   });

                      } else {

                        setState(() {
                          isLoading = true;
                        });

                        final releaseDate = DateTime.parse(releaseDateController.text);
                        final formattedReleaseDate = DateFormat('yyyy-MM-dd').format(releaseDate);

                        final bookToCreate =  BookToCreate(
                          //Obs: estava dando erro 400 bad request. Tive que adicionar o controller nos
                          //TextField acima. Senão, o nome e a cidade seriam passados nulos.
                          name: nameController.text,
                          author: authorController.text,
                          releaseDate: formattedReleaseDate,
                          amount: int.parse(amountController.text),
                          publisherModelId: selectedPublisher!.id
                          
                        );

                        
                        final bookService = BookService();
                        final result  = await bookService.createBook(bookToCreate);

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