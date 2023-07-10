
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:librelivro_front_flutter/custom_colors/custom_colors.dart';
import 'package:librelivro_front_flutter/services/publisher_service.dart';
import './views/publishers/PublisherView.dart';

void setupLocator() {
  GetIt.instance.registerLazySingleton(() => PublisherService());
   
}

void main() {
  setupLocator();
  runApp(App());
}  
  

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biblioteca',
      theme: ThemeData(
        primarySwatch: teal
      ),
      home: PublisherView(),
    );
  }
}