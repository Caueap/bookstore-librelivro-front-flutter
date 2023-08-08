import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../models/publisher_model/publisher.dart';
import '../../services/publisher_service/publisher_service.dart';
import 'DeletePublisher.dart';
import 'PublisherModify.dart';

class PublisherListCard extends StatelessWidget {
  PublisherService get publisherService => GetIt.instance<PublisherService>();

  final Publisher publisher;
  final VoidCallback? reFetch;

  PublisherListCard({
    required this.publisher,
     this.reFetch
     });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(
          publisher.name,
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
        ),
        subtitle: Text('${publisher.city}'),
        children: [
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
                            builder: (_) => PublisherModify(id: publisher.id)))
                        .then((data) => {reFetch!()});
                  },
                ),
                IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      deletePublisher(context);
                    })
              ],
            ),
          )
        ],
      ),
    );
  }

  void deletePublisher(BuildContext context) async {
    final result =
        await showDialog(context: context, builder: (_) => DeletePublisher());

    if (result) {
      final deleteResult = await publisherService.deletePublisher(publisher.id);

      var message;
      if (deleteResult.data == true) {
        message = 'Editora excluida';
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
          reFetch!();
        }
      });
    }
    print(result);
    return result;
  }
}
