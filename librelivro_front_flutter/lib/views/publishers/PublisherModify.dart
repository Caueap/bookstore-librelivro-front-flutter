
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:librelivro_front_flutter/models/publisher_model/publisher.dart';


import '../../services/publisher_service/publisher_service.dart';

class PublisherModify extends StatefulWidget {
 
   int? id;

  PublisherModify({this.id});

  @override
  State<PublisherModify> createState() => _PublisherModifyState();

  
}

class _PublisherModifyState extends State<PublisherModify> {
  PublisherService get publisherService => GetIt.instance<PublisherService>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

   bool get isEditing => widget.id != null;
   bool isLoading = false;
   String errorMessage = '';
   Publisher ?publisher;


  

    
      
      @override
      void initState() {
        super.initState();

        setState(() {
          isLoading = true;
        });

        publisherService.getPublisherById(widget.id ?? 0)
        .then((response) {
          
          setState(() {
          isLoading = false;
        });

          if (response.error) {
            errorMessage = response.errorMessage;
          }
          publisher = response.data!;
          nameController.text = publisher!.name;
          cityController.text = publisher!.city;

        });
        
      }
    

  

  


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
        child: isLoading ? Center(child: CircularProgressIndicator()) : Column(
        children: <Widget>[
           TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Nome da editora'
            ),
           ),

          Container(height: 8),
           
           TextField(
            controller: cityController,
            decoration: InputDecoration(
              hintText: 'Cidade da editora'
            )
           ),

           Container(height: 16),

           SizedBox(
            width: double.infinity,
            height: 35,
             child: ElevatedButton(
              onPressed: () async {
                if (isEditing) {

                  setState(() {
                    isLoading = true;
                  });

                  final publisher =  Publisher(
                    //Obs: estava dando erro 400 bad request. Tive que adicionar o controller nos
                    //TextField acima. Senão, o nome e a cidade seriam passados nulos.
                    name: nameController.text,
                    city: cityController.text 
                  );

                  
                  final publisherService = PublisherService();
                  final result  = await publisherService.updatePublisher(widget.id!, publisher);

                  setState(() {
                    isLoading = false;
                  });

                  final text = result.error ? (result.errorMessage ?? 'Erro no modify') : 'Editora Atualizada!';
                  
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

                } else {

                  setState(() {
                    isLoading = true;
                  });

                  final publisher =  Publisher(
                    //Obs: estava dando erro 400 bad request. Tive que adicionar o controller nos
                    //TextField acima. Senão, o nome e a cidade seriam passados nulos.
                    name: nameController.text,
                    city: cityController.text 
                  );

                  
                  final publisherService = PublisherService();
                  final result  = await publisherService.createPublisher(publisher);

                  setState(() {
                    isLoading = false;
                  });

                  final text = result.error ? (result.errorMessage ?? 'Erro no modify') : 'Editora Cadastrada!';
                  
                  
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
                isEditing ? 'Atualizar' : 'Cadastrar',
                style: TextStyle(color: Colors.white),
                ),
             ),

             
           )
        ],
      ), 
      ) 
      
    );
  
  }
}
