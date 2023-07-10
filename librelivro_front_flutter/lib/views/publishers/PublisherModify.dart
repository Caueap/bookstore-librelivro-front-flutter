
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:librelivro_front_flutter/models/Publisher.dart';

class PublisherModify extends StatelessWidget {

   int? publisherId;
   bool get isEditing => publisherId != null;

  PublisherModify({this.publisherId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar editora' : 'Cadastrar editora'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
        children: <Widget>[
           TextField(
            decoration: InputDecoration(
              hintText: 'Nome da editora'
            ),
           ),

          Container(height: 8),
           
           TextField(
            decoration: InputDecoration(
              hintText: 'Cidade da editora'
            )
           ),

           Container(height: 16),

           SizedBox(
            width: double.infinity,
            height: 35,
             child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                },
               child: Text(
                'Atualizar',
                style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty
                  .all<Color>
                  (Theme.of(context).
                  colorScheme.primary)
                  ),
             ),
           )
        ],
      ), 
      ) 
      
    );
  }
}