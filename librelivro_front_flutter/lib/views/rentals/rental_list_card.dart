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
  final dynamic handleRentalId;

  RentalListCard(
      {required this.rental,
      required this.reFetch,
      required this.rentalStatus,
      required this.handleRentalId});

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
                      Text('Data esperada de devolução: ${rental.expectedDeliveryDate}'),
                      Text('Data de devolução: ${rental.deliveryDate}'),
                      Text('Status: ${rental.status}'),
                      Text('Usuário: ${rental.clientModel!.name}'),
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
                  icon: Icon(Icons.check_circle,
                      color: rentalStatus != 'Pendente'
                          ? Colors.grey
                          : Theme.of(context).primaryColor),
                  onPressed: rentalStatus != 'Pendente'
                      ? null
                      : () {
                          int rentalId = rental.id;
                          handleRentalId(rentalId);
                        },
                ),
                IconButton(
                    icon: Icon(Icons.delete,
                        color: rentalStatus == 'Pendente'
                            ? Colors.grey
                            : Colors.red),
                    onPressed: rentalStatus == 'Pendente'
                        ? null
                        : () {
                            deleteRental(context);
                          })
              ],
            ),
          )
        ],
      ),
    );
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
