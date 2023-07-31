import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:librelivro_front_flutter/views/rentals/rentals_delete.dart';
import 'package:librelivro_front_flutter/views/rentals/rentals_modify.dart';
import '../../components/navigation_drawer.dart';
import '../../components/rental_api_response.dart';
import '../../models/book_model/book.dart';
import '../../models/rental_model/rental.dart';
import '../../services/rental_service/rental_service.dart';
import '../../models/client_model/client.dart';


class RentalsView extends StatefulWidget {

  int? id;

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
          .push(MaterialPageRoute(builder: (_) => RentalModify()
          )).then((_) {
            _fetchRentals();
          });
        } ,
        child: Icon(Icons.add),
      ),
      body: Builder(
        builder: (_) {
          if (isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (rentalsApiResponse.error) {
            return Center(child: Text(rentalsApiResponse.errorMessage));
          }


          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar',
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(vertical: 16.0)
              ),
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

              
                return Card(
                  child: ExpansionTile(
                    title: Text(
                      filteredRentals![index].bookModel!.name,
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
                        Text('Data do aluguel: ${filteredRentals![index].rentalDate}'),
                        Text('Data esperada de devolução: ${filteredRentals![index].expectedDeliveryDate}'),
                        Text('Data de devolução: ${filteredRentals?[index].deliveryDate}'),
                        Text('Status: ${filteredRentals![index].status}'),
                        Text('Usuário: ${filteredRentals![index].clientModel!.name}'),
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
                                  icon: Icon(Icons.check_circle,
                                  color: rentalStatus != 'Pendente' ? Colors.grey : Theme.of(context).primaryColor),
                                  
                                  onPressed: rentalStatus != 'Pendente' ? null : () {
                                    int rentalId = rentalsApiResponse.data![index].id;
                                    handleRentalId(rentalId);
                                    
                                    
                                    
                                    


                                    

        
                                        } ,
                                        
                                      ),

                                      

          

                                  IconButton(
                                  icon: Icon(Icons.delete,
                                  color: rentalStatus == 'Pendente' ? Colors.grey : Colors.red),
                                  onPressed: rentalStatus == 'Pendente' ? null : () async {
                                    final result = await showDialog(
                                      context: context,
                                      builder: (_) => RentalDelete());

                                      if (result) {
                                        final deleteResult = await rentalService.deleteRental(rentalsApiResponse.data![index].id);

                                        var message;
                                        if (deleteResult != null && deleteResult.data == true) {
                                           message = 'Aluguel excluido';
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
                                              _fetchRentals();
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
              
          )
          ]
          )
            );
        }
              )
    );
              
      
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


                        

      
                        final rental =  Rental(
                          rentalDate: retrievedRental.rentalDate,
                          expectedDeliveryDate: retrievedRental.expectedDeliveryDate,
                          deliveryDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                          bookModelId: retrievedRental.bookModel!.id,
                          clientModelId: retrievedRental.clientModel!.id
                          
                          
                        );

                      
                        final result  = await rentalService.updateRental(rentalId, rental);
                        
                        

                        setState(() {
                          isLoading = false;
                          
                        });

                        final text = result.error ? (result.errorMessage ?? 'Erro na view') : 'Livro entregue!';
                        
                        
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
                          );}).then((data) {
                            if (result.data!) {
                              _fetchRentals();
                            }
                          });
                          
  }

}