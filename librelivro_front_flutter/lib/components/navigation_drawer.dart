
import 'package:flutter/material.dart';
import 'package:librelivro_front_flutter/custom_colors/custom_colors.dart';
import 'package:librelivro_front_flutter/views/books/books_view.dart';
import 'package:librelivro_front_flutter/views/dashboard.dart';
import 'package:librelivro_front_flutter/views/publishers/publisher_view.dart';
import 'package:librelivro_front_flutter/views/rentals/rentals_view.dart';
import 'package:librelivro_front_flutter/views/clients/clients_view.dart';

class NavDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: teal,
        child: ListView(
          children: [
            SizedBox(height: 30),
            drawerItem(
              icon: Icons.dashboard,
              text: 'Dashboard',
              onClicked: () => selectedItem(context, 0)
            ),
            SizedBox(height: 30),
            drawerItem(
              icon: Icons.account_circle,
              text: 'Usuários',
              onClicked: () => selectedItem(context, 1)
            ),
            SizedBox(height: 30),
            drawerItem(
              icon: Icons.account_balance_outlined,
              text: 'Editoras',
              onClicked: () => selectedItem(context, 2)
            ),
            SizedBox(height: 30),
            drawerItem(
              icon: Icons.book,
              text: 'Livros',
              onClicked: () => selectedItem(context, 3)
            ),
            SizedBox(height: 30),
            drawerItem(
              icon: Icons.recent_actors,
              text: 'Aluguéis',
              onClicked: () => selectedItem(context, 4)
            ),
          ],
        ),
      ),

    );
  }

  Widget drawerItem({
    required IconData icon,
    double iconSize = 30,
    required String text,
    VoidCallback ?onClicked
    }) {

    final defaultColor = Colors.white;

    return ListTile(
      leading: Icon(icon, color: defaultColor,
        size: iconSize),
      title: Text(text,
        style: TextStyle(
        color: defaultColor, fontSize: 22)),
      onTap: onClicked,  
    );

    }

    void selectedItem(BuildContext context, int index) {
      switch (index) {
        case 0:
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Dashboard()));
        break;
        case 1:
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ClientsView()));
        break;
        case 2:
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PublisherView()));
        break;
        case 3:
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BooksView()));
        break;
        case 4:
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => RentalsView()));
        break;
      }

    }

}