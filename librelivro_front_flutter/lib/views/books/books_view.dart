import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:librelivro_front_flutter/models/book_model/book.dart';
import 'package:librelivro_front_flutter/views/books/book_modify.dart';
import 'package:librelivro_front_flutter/views/books/books_list_card.dart';
import '../../components/api_responses/book_api_response.dart';
import '../../components/navigation_drawer.dart';
import '../../services/book_service/book_service.dart';

class BooksView extends StatefulWidget {
  @override
  State<BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
  BookService get bookService => GetIt.instance<BookService>();

  TextEditingController searchController = TextEditingController();

  late BookApiResponse<List<Book>> bookApiResponse;
  List<Book>? filteredBooks;
  bool isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    _fetchBooks();
    searchController.addListener(onSearchChanged);
    super.initState();
  }

  _fetchBooks() async {
    setState(() {
      isLoading = true;
    });

    bookApiResponse = await bookService.getBooks();
    filteredBooks = bookApiResponse.data ?? [];

    // await Future.delayed(Duration(seconds: 3));
    setState(() {
      isLoading = false;
    });
  }

  void onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        if (searchController.text.isEmpty) {
          filteredBooks = bookApiResponse.data ?? [];
        } else {
          filteredBooks = (bookApiResponse.data ?? [])
              .where((book) =>
                  book.name
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()) ||
                  book.author
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()) ||
                  book.releaseDateFrom
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()) ||
                  book.amount
                      .toString()
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()) ||
                  book.rentedAmount
                      .toString()
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()) ||
                  book.publisherModel!.name
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()))
              .toList();
        }
      });
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
              .push(MaterialPageRoute(builder: (_) => BookModify()))
              .then((_) {
            _fetchBooks();
          });
        },
        child: Icon(Icons.add),
      ),
      body: Builder(builder: (_) {
        if (isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (bookApiResponse.error) {
          return Center(child: Text(bookApiResponse.errorMessage));
        }

        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                    hintText: 'Pesquisar',
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0)),
                onChanged: (value) {
                  // Call the search method when the user types
                  onSearchChanged();
                },
              ),
              Container(height: 8),
              Expanded(
                  child: ListView.builder(
                      itemCount: filteredBooks!.length,
                      itemBuilder: (_, index) {
                        return BookListCard(
                            book: filteredBooks![index], reFetch: _fetchBooks);
                      }))
            ]));
      }),
    );
  }
}
