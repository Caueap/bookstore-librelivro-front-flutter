
import 'package:flutter/material.dart';

class DeletePublisher extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Warning'
        ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
           child: Text(
            'Yes'
           )
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
           child: Text(
            'No'
           )
        )
      ],  

    );
  }
}