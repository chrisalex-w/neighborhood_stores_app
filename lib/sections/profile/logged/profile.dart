import 'package:flutter/material.dart';
import 'package:neighborhood_stores_app/models/user.dart';
import 'package:neighborhood_stores_app/services/auth.dart';
import 'package:neighborhood_stores_app/services/database.dart';
import 'package:neighborhood_stores_app/shared/constants.dart';

import 'form_buttons.dart';
import 'form_fields.dart';

class Profile extends StatefulWidget {
  final VoidCallback? navigateToSignIn;

  const Profile({Key? key, this.navigateToSignIn}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool loading = false;
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  String? userId;
  UserData? userData;
  String error = '';

  _getUserData() async {
    setState(() => loading = true);

    userId = _authService.getCurrentUser()!.uid;
    userData = await DatabaseService().getUserData(userId);
    userData!.email = _authService.getCurrentUser()!.email;

    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    userData = UserData();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    if (loading == true) {
      return indicatorDotsBouncing;
    } else {
      return Container(
        height: double.infinity,
        color: Colors.white, // Important when hiding keyboard
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 36.0,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.account_circle,
                          size: 70,
                          color: Colors.blue[700],
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NameFormField(
                            initialValue: userData!.name,
                            onChanged: (val) =>
                                setState(() => {userData!.name = val}),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              userData!.email ?? '',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16.0,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  Divider(color: Colors.grey[600]),
                  const SizedBox(height: 24.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dirección',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        AddressFormField(
                          initialValue: userData!.address,
                          onChanged: (val) =>
                              setState(() => {userData!.address = val}),
                        ),
                        const SizedBox(height: 32.0),
                        Text(
                          'Teléfono fijo',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        LandlineFormField(
                          initialValue: userData!.landline,
                          onChanged: (val) =>
                              setState(() => {userData!.landline = val}),
                        ),
                        const SizedBox(height: 32.0),
                        Text(
                          'Celular',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        CellphoneFormField(
                          initialValue: userData!.cellphone,
                          onChanged: (val) =>
                              setState(() => {userData!.cellphone = val}),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  SignOutButton(onPressed: () async {
                    await _authService.signOut();
                    widget.navigateToSignIn!();
                  }),
                  const SizedBox(height: 16.0),
                  UpdateDataButton(onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await DatabaseService(userId: userId)
                          .updateUserData(userData!);
                    }
                  }),
                  const SizedBox(height: 16.0),
                  DeleteAccountButton(onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _authService.deleteUser();

                      if (_authService.getCurrentUser() == null) {
                        await DatabaseService(userId: userId).deleteUserData();
                      } else {
                        await _authService.signOut();
                      }
                      widget.navigateToSignIn!();
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
