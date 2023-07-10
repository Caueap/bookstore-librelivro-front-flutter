import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:librelivro_front_flutter/models/api_response.dart';
import 'package:librelivro_front_flutter/services/publisher_service.dart';
import 'package:librelivro_front_flutter/views/publishers/DeletePublisher.dart';
import 'package:librelivro_front_flutter/views/publishers/PublisherModify.dart';
import '../../models/Publisher.dart';
import '../../custom_colors/custom_colors.dart';



class PublisherView extends StatefulWidget {

  @override
  State<PublisherView> createState() => _PublisherViewState();
}

class _PublisherViewState extends State<PublisherView> {
  PublisherService get service => GetIt.instance<PublisherService>();

  late ApiResponse<List<Publisher>> _apiResponse;
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
    
    _apiResponse = await service.getPublishers();

    // await Future.delayed(Duration(seconds: 3));
    setState(() {
      _isLoading = false;
      
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editoras',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => PublisherModify()
          ));
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
            return Dismissible(
            key: ValueKey(_apiResponse.data![index].id),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
          
            },
            confirmDismiss: (direction) async {
              final result = await showDialog(
                context: context,
                builder: (_) => DeletePublisher());
                print(result);
                return result;
          
          
            },
          
            // background: Container(
            //   color: Colors.red,
            //   padding: EdgeInsets.only(left: 16),
            //   child: Align(
            //     child: Icon(
            //       Icons.delete, color: Colors.white
            //       ), 
            //       alignment: Alignment.centerLeft
            //      ),
            // ),
          
            child: Card(
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
                                publisherId: _apiResponse.data?[index].id)));
                                } ,
                              ),
                          IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async  {
                            final result = await showDialog(
                              context: context,
                              builder: (_) => DeletePublisher());
                              print(result);
                              return result;  
                          } ,
                          ),
                      ],
                    ),
                      )
                    ] 

                ),
                  
                  
            )
          );
          }
        )
        );
        }
      )
    );
  }
}
  