import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:librelivro_front_flutter/views/rentals/rentals_delete.dart';
import '../../models/rental_model/rental.dart';
import '../../services/rental_service/rental_service.dart';

class RentalListCard extends StatelessWidget {
  RentalService get rentalService => GetIt.instance<RentalService>();

  final Rental rental;
  final VoidCallback? reFetch;
  final String rentalStatus;
  final VoidCallback? handle;

  RentalListCard(
      {required this.rental,
      required this.reFetch,
      required this.rentalStatus,
      required this.handle});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(rental.bookModel!.name,
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
                      Text('Data do aluguel: ${rental.rentalDate}'),
                      Text(
                          'Data esperada de devolução: ${rental.expectedDeliveryDate}'),
                      Text('Data de devolução: ${rental.deliveryDate}'),
                      Text('Usuário: ${rental.clientModel!.name}'),
                    ],
                  ),
                )),
          ),
           // Adding space before status
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: getStatusColor(rental.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: Text(
                        'Status: ${rental.status}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    width: 8), // Adding space between status and Delete button
                IconButton(
                    icon: Icon(Icons.delete,
                        color: rentalStatus == 'Pendente'
                            ? Colors.grey
                            : Colors.red),
                    onPressed: rentalStatus == 'Pendente'
                        ? null
                        : () {
                            deleteRental(context);
                          }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: rentalStatus != 'Pendente' ? null : handle,
                    child: Container(
                      decoration: BoxDecoration(
                        color: rentalStatus != 'Pendente'
                            ? Colors.grey
                            : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Center(
                        child: Text(
                          'Devolver',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Entregue no prazo':
      return Colors.green;
      case 'Entregue antecipadamente':
        return Colors.green;
      case 'Entregue com atraso':
        return Colors.red;
      case 'Pendente':
        return Colors.orange;
      default:
        return Colors.grey; // Default color if none of the above matches
    }
  }

  void deleteRental(BuildContext context) async {
    final result =
        await showDialog(context: context, builder: (_) => RentalDelete());

    if (result) {
      final deleteResult = await rentalService.deleteRental(rental.id);

      var mainMessage = 'Sucesso!';
      var message;
      if (deleteResult.data == true) {
        message = 'Aluguel excluido';
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
          reFetch!();
        }
      });
    }
    print(result);
    return result;
  }
}
