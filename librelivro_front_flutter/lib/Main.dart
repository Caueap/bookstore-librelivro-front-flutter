import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:librelivro_front_flutter/components/utilities/custom_colors/custom_colors.dart';
import 'package:librelivro_front_flutter/services/book_service/book_service.dart';
import 'package:librelivro_front_flutter/services/client_service/client_service.dart';
import 'package:librelivro_front_flutter/services/publisher_service/publisher_service.dart';
import 'package:librelivro_front_flutter/services/rental_service/rental_service.dart';
import 'package:librelivro_front_flutter/views/dashboard.dart';

void setupLocator() {
  GetIt.instance.registerLazySingleton(() => PublisherService());
  GetIt.instance.registerLazySingleton(() => BookService());
  GetIt.instance.registerLazySingleton(() => ClientService());
  GetIt.instance.registerLazySingleton(() => RentalService());
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
      theme: ThemeData(primarySwatch: teal),
      // localizationsDelegates: [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate
      // ],
      // supportedLocales: [const Locale('pt', 'BR')],

      home: Dashboard(),
    );
  }
}
