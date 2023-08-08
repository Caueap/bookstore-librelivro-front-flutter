import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:librelivro_front_flutter/views/rentals/rental_list_card.dart';
import 'package:librelivro_front_flutter/views/rentals/rentals_create.dart';
import '../../components/navigation_drawer.dart';
import '../../components/api_responses/rental_api_response.dart';
import '../../models/book_model/book.dart';
import '../../models/rental_model/rental.dart';
import '../../services/rental_service/rental_service.dart';
import '../../models/client_model/client.dart';

class RentalsView extends StatefulWidget {
  final int? id;

  RentalsView({this.id});

  @override
  State<RentalsView> createState() => _RentalsViewState();
}

class _RentalsViewState extends State<RentalsView> {
  
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RentalService get rentalService => GetIt.instance<RentalService>();

  TextEditingController searchController = TextEditingController();

  late RentalApiResponse<List<Rental>> rentalsApiResponse;
  List<Rental>? filteredRentals;
  bool isLoading = false;
  String errorMessage = '';
  Rental? rental;
  Book? book;
  Client? client;
  String rentalDate = '';
  String expectedDeliveryDate = '';
  String deliveryDate = '';
  Timer? _debounce;

  @override
  void initState() {
    _fetchRentals();
    searchController.addListener(onSearchChanged);

    super.initState();
  }

  _fetchRentals() async {
    setState(() {
      isLoading = true;
    });

    rentalsApiResponse = await rentalService.getRentals();
    filteredRentals = rentalsApiResponse.data ?? [];

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
          filteredRentals = rentalsApiResponse.data ?? [];
        } else {
          filteredRentals = (rentalsApiResponse.data ?? [])
              .where((rental) =>
                  rental.rentalDate
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()) ||
                  rental.expectedDeliveryDate
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()) ||
                  rental.deliveryDate
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()) ||
                  rental.status
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()) ||
                  rental.bookModel!.name
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()) ||
                  rental.clientModel!.name
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
          title: Text('Aluguéis'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => RentalCreate()))
                .then((_) {
              _fetchRentals();
            });
          },
          child: Icon(Icons.add),
        ),
        body: Builder(builder: (_) {
          if (isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (rentalsApiResponse.error) {
            return Center(child: Text(rentalsApiResponse.errorMessage));
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
                        itemCount: filteredRentals!.length,
                        itemBuilder: (_, index) {
                          final rental = rentalsApiResponse.data![index];
                          final rentalStatus = rental.status;
                          return RentalListCard(
                              rental: filteredRentals![index],
                              reFetch: _fetchRentals,
                              rentalStatus: rentalStatus,
                              handleRentalId: handleRentalId(filteredRentals![index].id));
                        }))
              ]));
        }));
  }

  handleRentalId(int rentalId) async {
    setState(() {
      isLoading = true;
    });

    final rentalService = RentalService();
    final response = await rentalService.getRentalById(rentalId);

    setState(() {
      isLoading = false;
    });

    if (response.error) {
      errorMessage = response.errorMessage;
    }

    Rental retrievedRental = response.data!;

    final rental = Rental(
        rentalDate: retrievedRental.rentalDate,
        expectedDeliveryDate: retrievedRental.expectedDeliveryDate,
        deliveryDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
        bookModelId: retrievedRental.bookModel!.id,
        clientModelId: retrievedRental.clientModel!.id);

    final result = await rentalService.updateRental(rentalId, rental);

    setState(() {
      isLoading = false;
    });

    final text = result.error ? (result.errorMessage) : 'Livro entregue!';

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
        _fetchRentals();
      }
    });
  }
}
