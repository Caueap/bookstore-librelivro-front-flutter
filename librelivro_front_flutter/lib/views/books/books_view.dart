
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:librelivro_front_flutter/models/book_model/book.dart';

import 'package:librelivro_front_flutter/views/books/book_modify.dart';
import 'package:librelivro_front_flutter/views/books/books_delete.dart';

import '../../components/book_api_response.dart';
import '../../components/navigation_drawer.dart';
import '../../services/book_service/book_service.dart';


class BooksView extends StatefulWidget {  
  
  @override
  State<BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
  
  BookService get bookService => GetIt.instance<BookService>();

  late BookApiResponse<List<Book>> bookApiResponse;
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
        onPressed: () {
          Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => BookModify()
          )).then((_) {
            _fetchBooks();
          });
        } ,
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
                    style: TextStyle(color: Theme.of(context).primaryColor,
                    fontSize: 20)),
                    
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
                        Text('Autor: ${bookApiResponse.data![index].author}'),
                        Text('Data de lançamento: ${bookApiResponse.data![index].releaseDateFrom}'),
                        Text('Quantidade em estoque: ${bookApiResponse.data![index].amount}'),
                        Text('Quantidade Alugada: ${bookApiResponse.data![index].rentedAmount}'),
                        Text('Editora: ${bookApiResponse.data![index].publisherModel!.name}'),
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
                                      builder: (_) => BookModify(
                                        id: bookApiResponse.data?[index].id)))
                                        .then((data) => {
                                          _fetchBooks()
                                        });
                                        } ,
                                      ),
                                  IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async  {
                                    final result = await showDialog(
                                      context: context,
                                      builder: (_) => BookDelete());

                                      if (result) {
                                        final deleteResult = await bookService.deleteBook(bookApiResponse.data![index].id);

                                        var message;
                                        if (deleteResult != null && deleteResult.data == true) {
                                           message = 'Livro excluido';
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
                                              _fetchBooks();
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
