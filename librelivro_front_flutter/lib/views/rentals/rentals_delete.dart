
import 'package:flutter/material.dart';

class RentalDelete extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Deseja excluir esse aluguel?'
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