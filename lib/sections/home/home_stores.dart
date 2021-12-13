import 'package:flutter/material.dart';
import 'package:neighborhood_stores_app/models/store.dart';
import 'package:neighborhood_stores_app/sections/store/store_catalog.dart';
import 'package:neighborhood_stores_app/services/database.dart';
import 'package:neighborhood_stores_app/shared/constants.dart';
import 'package:neighborhood_stores_app/shared/search_bar.dart';
import 'package:neighborhood_stores_app/shared/store_tile.dart';

class HomeStores extends StatefulWidget {
  const HomeStores({Key? key}) : super(key: key);

  @override
  _HomeStoresState createState() => _HomeStoresState();
}

class _HomeStoresState extends State<HomeStores> {
  final ScrollController _scrollController;
  final DatabaseService _databaseService;

  List<Store> _stores = [];
  String storeCategory = '';

  bool _isLoadingStores = true;
  _HomeStoresState() :
        _databaseService = DatabaseService(),
        _scrollController = ScrollController();

  _getStores() async {
    setState(() => _isLoadingStores = true);
    _stores = await _databaseService.getStores(storeCategory);
    setState(() => _isLoadingStores = false);
  }

  _setCategoryFilter(int searchFilter) {
    setState(() {
      switch (searchFilter) {
        case 0:
          storeCategory = '';
          _getStores();
          break;
        case 1:
          storeCategory = 'Restaurante';
          _getStores();
          break;
        case 2:
          storeCategory = 'Supermercado';
          _getStores();
          break;
        case 3:
          storeCategory = 'Cafetería';
          _getStores();
          break;
        case 4:
          storeCategory = 'Ferretería';
          _getStores();
          break;
      }
    });
  }

  _searchStore(String name) async {
    if (name.isNotEmpty) {
      setState(() => _isLoadingStores = false);
      _stores = await _databaseService.searchStore(name, storeCategory);
      setState(() => _isLoadingStores = false);
    } else {
      _getStores();
    }
  }

  @override
  void initState() {
    super.initState();

    _getStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomSearchBar(
            hintText: 'Buscar',
            onChanged: _searchStore,
            setCategoryFilter: _setCategoryFilter,
          ),
          _isLoadingStores == true
            ? indicatorDotsBouncing
            : Positioned(
              top: MediaQuery.of(context).size.height * 0.080,
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: ListView.separated(
                controller: _scrollController,
                itemCount: _stores.length,
                itemBuilder: (context, index) {
                  final Store store = _stores[index];
                  return GestureDetector(
                    child: StoreTile(store: store),
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoreCatalog(
                            store: store,
                          ),
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              ),
          ),
        ],
      ),
    );
  }
}