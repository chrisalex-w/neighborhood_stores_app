import 'package:flutter/material.dart';
import 'package:neighborhood_stores_app/sections/orders/orders.dart';
import 'package:neighborhood_stores_app/sections/profile/authenticate/register.dart';

import 'package:neighborhood_stores_app/sections/profile/authenticate/sign_in.dart';
import 'package:neighborhood_stores_app/sections/profile/logged/profile.dart';
import 'package:neighborhood_stores_app/services/auth.dart';

import 'home/home_products.dart';
import 'home/home_stores.dart';
import 'orders/shopping_cart.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar({Key? key}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  final AuthService _authService = AuthService();

  int _selectedIndex = 0;
  bool _showProfile = true;
  bool _showSignIn = true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _selectScreen() {
  Widget currentWidget = Container();

    switch(_selectedIndex) {
      case 0:
        currentWidget = const HomeStores();
        break;
      case 1:
        currentWidget = HomeProducts();
        break;
      case 2:
        currentWidget = const Orders();
        break;
      case 3:
        String? userId = _authService.getCurrentUser()?.uid;

        if (_showProfile && userId != null) {
          currentWidget = Profile(
              navigateToSignIn: navigateToSignIn);
        } else {
          if (_showSignIn) {
            currentWidget = SignIn(
              navigateToRegister: navigateToRegister,
              navigateToProfile: navigateToProfile,
            );
          } else {
            currentWidget = Register(
              navigateToSignIn: navigateToSignIn,
              navigateToProfile: navigateToProfile,
            );
          }
        }
        break;
    }

    return currentWidget;
  }

  void navigateToSignIn() {
    setState(() {
      _showProfile = false;
      _showSignIn = true;
    });
  }

  void navigateToRegister() {
    setState(() => _showSignIn = false);
  }

  void navigateToProfile() {
    setState(() => _showProfile = true);
  }

  void setNavigationRoute(int index, bool isLoginPage) {
    setState(() {
      _selectedIndex = index;

    });
  }

  void setNavigationPage(int index, Widget pageWidget) {
    setState(() {
      _selectedIndex = index;

    });
  }

  static const List _menuOptions = [
    'Negocios', 'Productos', 'Pedidos', ''];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //backgroundColor: Colors.transparent, // Important when hiding keyboard
      //backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text(
          _menuOptions.elementAt(_selectedIndex),
          style: const TextStyle(fontSize: 17.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () async {

          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShoppingCart(),
                ),
              );
              setState(() => _selectedIndex = 1);
            },
          ),
        ],
      ),
      //resizeToAvoidBottomInset: false,
      body: _selectScreen(), //_menuOptions.elementAt(_selectedIndex)['widget'],,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_work_rounded),
            label: 'Negocios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_module_rounded),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Perfil',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.black,
        iconSize: 28.0,
        selectedFontSize: 14.0,
        unselectedFontSize: 14.0,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}