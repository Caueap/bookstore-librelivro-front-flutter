
import 'package:flutter/material.dart';
import '../components/navigation_drawer.dart';

class Dashboard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
        ),
      ),
      drawer: NavDrawer(),
      
    );
  }
}