
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:librelivro_front_flutter/custom_colors/custom_colors.dart';
import '../components/book_api_response.dart';
import '../components/client_api_response.dart';
import '../components/navigation_drawer.dart';
import '../components/publisher_api_response.dart';
import '../components/rental_api_response.dart';
import '../models/book_model/book.dart';
import '../models/client_model/client.dart';
import '../models/publisher_model/publisher.dart';
import '../models/rental_model/rental.dart';
import '../services/book_service/book_service.dart';
import '../services/publisher_service/publisher_service.dart';
import '../services/rental_service/rental_service.dart';
import '../services/user_service/user_service.dart';

class Dashboard extends StatefulWidget {

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  ClientService get clientService => GetIt.instance<ClientService>();
  PublisherService get publisherService => GetIt.instance<PublisherService>();
  BookService get bookService => GetIt.instance<BookService>();
  RentalService get rentalService => GetIt.instance<RentalService>();

  late ClientApiResponse<List<Client>> clientApiResponse;
  late PublisherApiResponse<List<Publisher>> apiResponse;
  late BookApiResponse<List<Book>> bookApiResponse;
  late BookApiResponse<List<Book>> bookApiResponse2;
  late RentalApiResponse<List<Rental>> rentalsApiResponse;
  List<Book> mostRentedBooks = [];
  int clientsLength = 0;
  int publishersLength = 0;
  int booksLength = 0;
  int rentalsLength = 0;
  bool isLoading = false;
  


void initState() {
    fetchClients(); 
    fetchPublishers();
    fetchBooks();
    fetchRentals();
    fetchMostRentedBooks();
    super.initState();
  }


  fetchClients() async {
    setState(() {
      isLoading = true;    
    });
    
    clientApiResponse = await clientService.getClients();
    clientsLength = clientApiResponse.data!.length;

    setState(() {
      isLoading = false;      
    });
  }
 
  fetchPublishers() async {
    setState(() {
      isLoading = true;
    });
    
    apiResponse = await publisherService.getPublishers();
    publishersLength = apiResponse.data!.length;
    
    setState(() {
      isLoading = false;
    });
  }

  fetchBooks() async {
    setState(() {
      isLoading = true;
    });
    
    bookApiResponse = await bookService.getBooks();
    booksLength = bookApiResponse.data!.length;

    setState(() {
      isLoading = false;      
    });
  }

  fetchRentals() async {
    setState(() {
      isLoading = true;    
    });
    
    rentalsApiResponse = await rentalService.getRentals();
    rentalsLength = rentalsApiResponse.data!.length;
   
    setState(() {
      isLoading = false;
    });
  }

  fetchMostRentedBooks() async {
    setState(() {
      isLoading = true;    
    });
    
    bookApiResponse2 = await bookService.getMostRentedBooks();
    mostRentedBooks = bookApiResponse2.data!;
    
    setState(() {
      isLoading = false;
    });
  }

  final List<IconData> cardIcons = [
      Icons.account_circle,
      Icons.account_balance_outlined,
      Icons.book,
      Icons.recent_actors,
    ];

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Dashboard',
      ),
    ),
    drawer: NavDrawer(),
    body: Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
               if (index == 0) {
                return buildCard(
                  cardIcon: cardIcons[index],
                  title: 'Usuários',
                   count: clientsLength
                   );
              } else if (index == 1) {
                return buildCard(
                  cardIcon: cardIcons[index],
                  title: 'Editoras',
                   count: publishersLength
                   );
              } else if (index == 2) {
                return buildCard(
                  cardIcon: cardIcons[index],
                  title: 'Livros',
                   count: booksLength
                   );
              } else if (index == 3) {
                return buildCard(
                  cardIcon: cardIcons[index],
                  title: 'Aluguéis',
                   count: rentalsLength
                   );
              }
            },
          ),
        ),
        if (mostRentedBooks.isNotEmpty)
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BarChart(
                BarChartData(
                    alignment: BarChartAlignment.center,
                    maxY: mostRentedBooks[0].rentedAmount.toDouble(),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: buildBarGroups(),
                  ),
              ),
            ),
          ),
      ],
    ),
  );
}


  Widget buildCard({
    required IconData cardIcon, 
    required String title,
    required int count
  }) {
    return Card(
      color: teal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              cardIcon,
              size: 48,
              color: Colors.white,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18
                ),
            ),
            SizedBox(height: 8),
            Text(
              '$count',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20
                ),
            )
          ]
          ),
          ),
    );
  }

 
  List<BarChartGroupData> buildBarGroups() {
  return List.generate(mostRentedBooks.length, (index) {
    final book = mostRentedBooks[index];
    return BarChartGroupData(
      x: index,
      barsSpace: 8,
      barRods: [
        BarChartRodData(
          fromY: book.rentedAmount.toDouble(),
          toY: book.rentedAmount.toDouble(),
          color: Colors.blue,
        ),
      ],
    );
  });
}


}