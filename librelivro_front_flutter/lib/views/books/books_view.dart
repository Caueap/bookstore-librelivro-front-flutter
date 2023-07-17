
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:librelivro_front_flutter/models/book_to_get.dart';
import 'package:librelivro_front_flutter/services/book_service.dart';

import '../../components/book_api_response.dart';
import '../../components/navigation_drawer.dart';


class BooksView extends StatefulWidget { 
  
  @override
  State<BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
  
  BookService get bookService => GetIt.instance<BookService>();

  late BookApiResponse<List<BookToGet>> bookApiResponse;
  bool isLoading = false;

    @override
  void initState() {
    _fetchBooks();
    super.initState();
  }
 
  _fetchBooks() async {
    setState(() {
      isLoading = true;
      
    });
    
    bookApiResponse = await bookService.getBooks();

  

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
        title: Text('Livros'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {} ,
        child: Icon(Icons.add),
      ),
      body: Builder(
        builder: (_) {
          if (isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (bookApiResponse.error) {
            return Center(child: Text(bookApiResponse.errorMessage));
          }


          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: bookApiResponse.data!.length,
              itemBuilder: (_, index) {
                return Card(
                  child: ExpansionTile(
                    title: Text(
                      bookApiResponse.data![index].name,
                    style: TextStyle(color: Theme.of(context).primaryColor)),
                    subtitle: Text(
                      'Editora: ${bookApiResponse.data![index].publisherModel!.name}' ),
                    children: [
                            Align(
                            alignment: Alignment.centerRight,  
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit,
                                  color: Theme.of(context).primaryColor),
                                  
                                  onPressed: () {
                                    // Navigator.of(context)
                                    // .push(MaterialPageRoute(
                                    //   builder: (_) => PublisherModify(
                                    //     id: _apiResponse.data?[index].id)))
                                    //     .then((data) => {
                                    //       _fetchPublishers()
                                    //     });
                                        } ,
                                      ),
                                  IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: ()  {
                                    // final result = await showDialog(
                                    //   context: context,
                                    //   builder: (_) => DeletePublisher());

                                    //   if (result) {
                                    //     final deleteResult = await publisherService.deletePublisher(_apiResponse.data![index].id);

                                    //     var message;
                                    //     if (deleteResult != null && deleteResult.data == true) {
                                    //        message = 'Editora excluida';
                                    //     } else {
                                    //       message = deleteResult.errorMessage;
                                    //     }

                                    //     showDialog(
                                    //       context: context,
                                    //       builder: (_) {
                                    //         return AlertDialog(
                                    //         title: Text('Sucesso!'),
                                    //         content: Text(message),
                                    //         actions: [
                                    //           TextButton(
                                    //             child: Text('Ok'),
                                    //             onPressed: () {
                                    //               Navigator.of(context).pop();
                                    //             }) 
                                                
                                    //         ]
                                    //       );})
                                    //       .then((data) {
                                    //         if (deleteResult.data!) {
                                    //           _fetchPublishers();
                                    //         }
                                    //       });
                                    //   }
                                    //   print(result);
                                    //   return result;  
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
