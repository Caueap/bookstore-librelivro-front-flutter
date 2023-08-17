import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:librelivro_front_flutter/components/utilities/custom_colors/custom_colors.dart';
import '../components/api_responses/book_api_response.dart';
import '../components/api_responses/client_api_response.dart';
import '../components/navigation_drawer.dart';
import '../components/api_responses/publisher_api_response.dart';
import '../components/api_responses/rental_api_response.dart';
import '../models/book_model/book.dart';
import '../models/client_model/client.dart';
import '../models/publisher_model/publisher.dart';
import '../models/rental_model/rental.dart';
import '../services/book_service/book_service.dart';
import '../services/publisher_service/publisher_service.dart';
import '../services/rental_service/rental_service.dart';
import '../services/client_service/client_service.dart';

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
  List<Book> rentedBooks = [];
  // List<Book> mostRentedBooks = [];
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
    // fetchMostRentedBooks();
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
    rentedBooks = bookApiResponse.data!;

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

  // fetchMostRentedBooks() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   bookApiResponse2 = await bookService.getMostRentedBooks();
  //   mostRentedBooks = bookApiResponse2.data!;

  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  final List<IconData> cardIcons = [
    Icons.account_circle,
    Icons.account_balance_outlined,
    Icons.book,
    Icons.recent_actors,
  ];

  Map<String, double> generateDataMap(List<Book> books) {
    Map<String, double> dataMap = {};
    double totalRentals =
        books.fold(0, (sum, book) => sum + book.rentedAmount.toDouble());

    for (Book book in books) {
      double percentage = (book.rentedAmount.toDouble() / totalRentals) * 100;
      dataMap[book.name] = percentage;
    }

    return dataMap;
  }

  Map<String, double> dataMap = {
    'Category A': 5,
    'Category B': 3,
    'Category C': 2,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Dashboard',
          ),
        ),
        drawer: NavDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 400,
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
                          count: clientsLength);
                    } else if (index == 1) {
                      return buildCard(
                          cardIcon: cardIcons[index],
                          title: 'Editoras',
                          count: publishersLength);
                    } else if (index == 2) {
                      return buildCard(
                          cardIcon: cardIcons[index],
                          title: 'Livros',
                          count: booksLength);
                    } else if (index == 3) {
                      return buildCard(
                          cardIcon: cardIcons[index],
                          title: 'Aluguéis',
                          count: rentalsLength);
                    }
                    return null;
                  },
                ),
              ),
              
                 Container(
                  color: Theme.of(context).colorScheme.primary,
                  margin: EdgeInsets.all(4.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: PieChart(
                      dataMap: generateDataMap(rentedBooks),
                      animationDuration: Duration(milliseconds: 800),
                      chartLegendSpacing: 32,
                      chartRadius: MediaQuery.of(context).size.width / 2.7,
                      initialAngleInDegree: 0,
                      chartType: ChartType.disc,
                      ringStrokeWidth: 32,
                      centerText: "",
                      legendOptions: LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.bottom,
                        showLegends: true,
                        legendTextStyle: TextStyle(
                          color: Colors.white
                        )
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: false,
                      ),
                    ),
                  ),
                ),
              
            ],
          ),
        ));
  }

  Widget buildCard(
      {required IconData cardIcon, required String title, required int count}) {
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
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                '$count',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            ]),
      ),
    );
  }
}
