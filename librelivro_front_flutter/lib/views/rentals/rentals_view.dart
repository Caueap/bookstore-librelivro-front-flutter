
import 'package:flutter/material.dart';

import '../../components/navigation_drawer.dart';

class RentalsView extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Aluguéis'),
      ),
    );
  }
}