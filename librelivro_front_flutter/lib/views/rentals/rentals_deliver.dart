import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../components/book_api_response.dart';
import '../../components/publisher_api_response.dart';
import '../../components/user_api_response.dart';
import '../../models/book_model/book.dart';
import '../../models/client_model/client.dart';
import '../../models/rental_model/rental.dart';
import '../../services/book_service/book_service.dart';
import '../../services/rental_service/rental_service.dart';
import '../../services/user_service/user_service.dart';



class RentalDeliver extends StatefulWidget {


    
  int? id;

  RentalDeliver({this.id});

  @override
  State<RentalDeliver> createState() => _RentalDeliverState();

  
}

class _RentalDeliverState extends State<RentalDeliver> {


  RentalService get rentalService => GetIt.instance<RentalService>();
  BookService get bookService => GetIt.instance<BookService>();
  ClientService get clientService => GetIt.instance<ClientService>();
  

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  
  
  final TextEditingController deliveryDateController= TextEditingController();
  
  
  

   bool get isEditing => widget.id != null;
   bool isLoading = false;
   String errorMessage = '';
   Rental? rental;
   Book? book;
   Client? client;
  String rentalDate = '';
  String expectedDeliveryDate = '';


  @override
  void initState() {
   
    getRentalByIdInModify();
    super.initState();
  }

  

  getRentalByIdInModify () {

   setState(() {
          isLoading = true;
        });

        rentalService.getRentalById(widget.id ?? 0)
        .then((response) {
          
          setState(() {
          isLoading = false;
        });

          if (response.error) {
            errorMessage = response.errorMessage;
          }
          rental = response.data!;
          rentalDate = rental!.rentalDate;
          expectedDeliveryDate = rental!.expectedDeliveryDate;
          deliveryDateController.text = rental!.deliveryDate;
          book = rental!.bookModel;
          client = rental!.clientModel;
          
          
          
          

        });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Devolver Livro'
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
              controller: deliveryDateController,
              decoration: InputDecoration(
                hintText: 'Data de devolução'
                ),
                onTap: () async {
                  DateTime? pickeddate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now());

                  if (pickeddate != null) {
                    setState(() {
                       deliveryDateController.text = DateFormat('dd/MM/yyyy').format(pickeddate);
                    });
                  }
                },
                validator: validateDelivery,
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
                          rentalDate: rentalDate,
                          expectedDeliveryDate: expectedDeliveryDate,
                          deliveryDate: deliveryDateController.text,
                          bookModelId: book!.id,
                          clientModelId: client!.id
                          
                          
                        );

                        
                        final rentalService = RentalService();
                        final result  = await rentalService.updateRental(widget.id!, rental);

                        setState(() {
                          isLoading = false;
                        });

                        final text = result.error ? (result.errorMessage ?? 'Erro no modify') : 'Aluguel atualizado!';
                        
                        
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
                      'Devolver',
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

  String? validateDelivery(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    
  }
    return null;

}

}