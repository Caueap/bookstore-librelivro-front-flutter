import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:librelivro_front_flutter/views/clients/users_delete.dart';

import '../../models/client_model/client.dart';
import '../../services/client_service/client_service.dart';
import 'clients_modify.dart';

class ClientListCard extends StatelessWidget {
  ClientService get clientService => GetIt.instance<ClientService>();

  final Client client;
  VoidCallback? reFecth;

  ClientListCard({required this.client, this.reFecth});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(client.name,
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
                      Text('Email: ${client.email}'),
                      Text('Cidade: ${client.city}'),
                      Text('Endereço: ${client.address}'),
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
                            builder: (_) => ClientModify(id: client.id)))
                        .then((value) => {reFecth!()});
                  },
                ),
                IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      deleteClient(context);
                    })
              ],
            ),
          )
        ],
      ),
    );
  }

  void deleteClient(BuildContext context) async {
    final result =
        await showDialog(context: context, builder: (_) => UserDelete());

    if (result) {
      final deleteResult = await clientService.deleteClient(client.id);

      var message;
      if (deleteResult != null && deleteResult.data == true) {
        message = 'Usuário excluido';
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
                ]);
          }).then((data) {
        if (deleteResult.data!) {
          reFecth!();
        }
      });
    }
    print(result);
    return result;
  }
}
