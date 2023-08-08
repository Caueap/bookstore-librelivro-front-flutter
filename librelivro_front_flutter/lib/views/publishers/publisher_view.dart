import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:librelivro_front_flutter/components/navigation_drawer.dart';
import 'package:librelivro_front_flutter/components/api_responses/publisher_api_response.dart';
import 'package:librelivro_front_flutter/views/publishers/PublisherModify.dart';
import 'package:librelivro_front_flutter/views/publishers/publishers_list_card.dart';
import '../../models/publisher_model/publisher.dart';
import '../../services/publisher_service/publisher_service.dart';

class PublisherView extends StatefulWidget {
  @override
  State<PublisherView> createState() => _PublisherViewState();
}

class _PublisherViewState extends State<PublisherView> {
  PublisherService get publisherService => GetIt.instance<PublisherService>();

  TextEditingController searchController = TextEditingController();

  late PublisherApiResponse<List<Publisher>> apiResponse;
  List<Publisher>? filteredPublishers;
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    _fetchPublishers();
    searchController.addListener(onSearchChanged);
    super.initState();
  }

  _fetchPublishers() async {
    setState(() {
      _isLoading = true;
    });

    apiResponse = await publisherService.getPublishers();
    filteredPublishers = apiResponse.data ?? [];

    setState(() {
      _isLoading = false;
    });
  }

  void onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        if (searchController.text.isEmpty) {
          filteredPublishers = apiResponse.data ?? [];
        } else {
          filteredPublishers = (apiResponse.data ?? [])
              .where((publisher) =>
                  publisher.name
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()) ||
                  publisher.city
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()))
              .toList();
        }
      });
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
                .push(MaterialPageRoute(builder: (_) => PublisherModify()))
                .then((_) {
              _fetchPublishers();
            });
          },
          child: Icon(Icons.add),
        ),
        body: Builder(builder: (_) {
          if (_isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (apiResponse.error) {
            return Center(child: Text(apiResponse.errorMessage));
          }

          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                        hintText: 'Pesquisar',
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0)),
                    onChanged: (value) {
                      // Call the search method when the user types
                      onSearchChanged();
                    },
                  ),
                  Container(height: 8),
                  Expanded(
                    child: ListView.builder(
                        //  separatorBuilder: (_, __) => Divider(height: 1, color: Colors.green),
                        itemCount: filteredPublishers?.length,
                        itemBuilder: (_, index) {
                          return PublisherListCard(
                            publisher: filteredPublishers![index],
                            reFetch: _fetchPublishers
                          );
                        }),
                  )
                ],
              ));
        }));
  }
}
