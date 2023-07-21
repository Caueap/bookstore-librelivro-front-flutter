
import 'package:flutter/material.dart';

class BookDelete extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Deseja excluir esse livro?'
        ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
           child: Text(
            'Sim'
           )
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
           child: Text(
            'Não'
           )
        )
      ],  

    );
  }
}