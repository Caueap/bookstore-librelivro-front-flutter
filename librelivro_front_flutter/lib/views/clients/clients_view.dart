import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:librelivro_front_flutter/views/clients/clients_list_card.dart';
import 'package:librelivro_front_flutter/views/clients/clients_modify.dart';
import '../../components/navigation_drawer.dart';
import '../../components/api_responses/client_api_response.dart';
import '../../models/client_model/client.dart';
import '../../services/client_service/client_service.dart';

class ClientsView extends StatefulWidget {
  @override
  State<ClientsView> createState() => _ClientsViewState();
}

class _ClientsViewState extends State<ClientsView> {
  ClientService get clientService => GetIt.instance<ClientService>();

  TextEditingController searchController = TextEditingController();

  late ClientApiResponse<List<Client>> clientApiResponse;
  List<Client>? filteredClients;
  bool isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    _fetchClients();
    searchController.addListener(onSearchChanged);
    super.initState();
  }

  _fetchClients() async {
    setState(() {
      isLoading = true;
    });

    clientApiResponse = await clientService.getClients();
    filteredClients = clientApiResponse.data ?? [];

    // await Future.delayed(Duration(seconds: 3));
    setState(() {
      isLoading = false;
    });
  }

  void onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        if (searchController.text.isEmpty) {
          filteredClients = clientApiResponse.data ?? [];
        } else {
          filteredClients = (clientApiResponse.data ?? [])
              .where((client) =>
                  client.name
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()) ||
                  client.email
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()) ||
                  client.city
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()) ||
                  client.address
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
        title: Text('Usuários'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => ClientModify()))
              .then((_) {
            _fetchClients();
          });
        },
        child: Icon(Icons.add),
      ),
      body: Builder(builder: (_) {
        if (isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (clientApiResponse.error) {
          return Center(child: Text(clientApiResponse.errorMessage));
        }

        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
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
                      itemCount: filteredClients!.length,
                      itemBuilder: (_, index) {
                        return ClientListCard(
                          client: filteredClients![index],
                          reFecth: _fetchClients,
                        );
                      }))
            ]));
      }),
    );
  }
}
