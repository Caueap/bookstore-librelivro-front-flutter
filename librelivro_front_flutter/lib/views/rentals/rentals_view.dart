
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../components/navigation_drawer.dart';
import '../../components/rental_api_response.dart';
import '../../models/rental_model/rental.dart';
import '../../services/book_service/rental_service.dart';

class RentalsView extends StatefulWidget {
  

  @override
  State<RentalsView> createState() => _RentalsViewState();
}

class _RentalsViewState extends State<RentalsView> {

  RentalService get rentalService => GetIt.instance<RentalService>();

  late RentalApiResponse<List<Rental>> rentalsApiResponse;
  bool isLoading = false;

    @override
  void initState() {
    _fetchRentals();
    super.initState();
  }
 
  _fetchRentals() async {
    setState(() {
      isLoading = true;
      
    });
    
    rentalsApiResponse = await rentalService.getRentals();

  

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
        title: Text('Aluguéis'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.of(context)
          // .push(MaterialPageRoute(builder: (_) => UserModify()
          // )).then((_) {
          //   _fetchUsers();
          // });
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
            child: ListView.builder(
              itemCount: rentalsApiResponse.data!.length,
              itemBuilder: (_, index) {
                return Card(
                  child: ExpansionTile(
                    title: Text(
                      rentalsApiResponse.data![index].rentalDate,
                    style: TextStyle(color: Theme.of(context).primaryColor,
                    fontSize: 24)),
                    
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
                        Text('Data esperada de devolução: ${rentalsApiResponse.data![index].expectedDeliveryDate}'),
                        Text('Data de devolução: ${rentalsApiResponse.data![index].deliveryDate}'),
                        Text('Status: ${rentalsApiResponse.data![index].status}'),
                        Text('Livro: ${rentalsApiResponse.data![index].bookModel!.name}'),
                        Text('Usuário: ${rentalsApiResponse.data![index].clientModel!.name}'),
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
                                    // Navigator.of(context)
                                    // .push(MaterialPageRoute(
                                    //   builder: (_) => UserModify(
                                    //     id: userApiResponse.data?[index].id)))
                                    //     .then((data) => {
                                    //       _fetchUsers()
                                    //     });
                                        } ,
                                      ),
                                  IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: ()  {
                                    // final result = await showDialog(
                                    //   context: context,
                                    //   builder: (_) => UserDelete());

                                    //   if (result) {
                                    //     final deleteResult = await userService.deleteUser(userApiResponse.data![index].id);

                                    //     var message;
                                    //     if (deleteResult != null && deleteResult.data == true) {
                                    //        message = 'Usuário excluido';
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
                                    //           _fetchUsers();
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