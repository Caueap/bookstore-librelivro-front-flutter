import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:librelivro_front_flutter/components/navigation_drawer.dart';
import 'package:librelivro_front_flutter/components/publisher_api_response.dart';

import 'package:librelivro_front_flutter/views/publishers/DeletePublisher.dart';
import 'package:librelivro_front_flutter/views/publishers/PublisherModify.dart';
import '../../models/publisher_model/publisher.dart';
import '../../custom_colors/custom_colors.dart';
import '../../services/publisher_service/publisher_service.dart';



class PublisherView extends StatefulWidget { 

  @override
  State<PublisherView> createState() => _PublisherViewState();
}

class _PublisherViewState extends State<PublisherView> {
  PublisherService get publisherService => GetIt.instance<PublisherService>();

  

  late PublisherApiResponse<List<Publisher>> _apiResponse;
  bool _isLoading = false;
  

  @override
  void initState() {
    _fetchPublishers();
    super.initState();
  }

 
  _fetchPublishers() async {
    setState(() {
      _isLoading = true;
      
    });
    
    _apiResponse = await publisherService.getPublishers();

  

    // await Future.delayed(Duration(seconds: 3));
    setState(() {
      _isLoading = false;
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(
          'Editoras',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => PublisherModify()
          )).then((_) {
            _fetchPublishers();
          });
        },
        child: Icon(Icons.add),
      ),
      body: Builder(
        builder: (_) {

          if (_isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (_apiResponse.error) {
            return Center(child: Text(_apiResponse.errorMessage));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                  //  separatorBuilder: (_, __) => Divider(height: 1, color: Colors.green),
                   itemCount: _apiResponse.data!.length,
                   itemBuilder: (_, index) {
                    return Card(
                      child: ExpansionTile(
                          title: Text(
                            _apiResponse.data![index].name,
                            
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                          subtitle: Text(
                            '${_apiResponse.data![index].city}'
                          ),
                          children: [
                            Align(
                            alignment: Alignment.centerRight,  
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit,
                                  color: Theme.of(context).primaryColor),
                                  
                                  onPressed: () {
                                    Navigator.of(context)
                                    .push(MaterialPageRoute(
                                      builder: (_) => PublisherModify(
                                        id: _apiResponse.data?[index].id)))
                                        .then((data) => {
                                          _fetchPublishers()
                                        });
                                        } ,
                                      ),
                                  IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async  {
                                    final result = await showDialog(
                                      context: context,
                                      builder: (_) => DeletePublisher());

                                      if (result) {
                                        final deleteResult = await publisherService.deletePublisher(_apiResponse.data![index].id);

                                        var message;
                                        if (deleteResult != null && deleteResult.data == true) {
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
                                                
                                            ]
                                          );})
                                          .then((data) {
                                            if (deleteResult.data!) {
                                              _fetchPublishers();
                                            }
                                          });
                                      }
                                      print(result);
                                      return result;  
                                  })],
                                
                            
                            ),
                          )],
                          
                      ),
                    );
                    }
                    )
                  );
        }   
      )            
    );}}                    
                          
            
                
                
              
  