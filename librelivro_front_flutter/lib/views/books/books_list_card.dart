import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/book_model/book.dart';
import '../../services/book_service/book_service.dart';
import 'book_modify.dart';
import 'books_delete.dart';

class BookListCard extends StatelessWidget {
  BookService get bookService => GetIt.instance<BookService>();

  final Book book;
  final VoidCallback reFetch;

  BookListCard({
    required this.book,
     required this.reFetch
     });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(book.name,
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 20)),
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
                      Text('Autor: ${book.author}'),
                      Text('Data de lançamento: ${book.releaseDateFrom}'),
                      Text('Quantidade em estoque: ${book.amount}'),
                      Text('Quantidade Alugada: ${book.rentedAmount}'),
                      Text('Editora: ${book.publisherModel!.name}'),
                    ],
                  ),
                )),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (_) => BookModify(id: book.id)))
                        .then((data) => {reFetch()});
                  },
                ),
                IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {})
              ],
            ),
          )
        ],
      ),
    );
  }

  void deletePublisher(BuildContext context) async {
    final result =
        await showDialog(context: context, builder: (_) => BookDelete());

    if (result) {
      final deleteResult = await bookService.deleteBook(book.id);
      var mainMessage = 'Sucesso!';
      var message;
      if (deleteResult.data == true) {
        message = 'Livro excluido';
      } else {
        message = deleteResult.errorMessage;
        mainMessage = 'Ops...';
      }

      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
                title: Text(mainMessage),
                content: Text(message),
                actions: [
                  TextButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ]);
          }).then((data) {
        if (deleteResult.data!) {
          reFetch();
        }
      });
    }
    print(result);
    return result;
  }
}
