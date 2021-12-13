import 'package:flutter/material.dart';
import 'package:neighborhood_stores_app/models/user.dart';
import 'package:neighborhood_stores_app/services/auth.dart';
import 'package:neighborhood_stores_app/shared/constants.dart';

import 'form_buttons.dart';
import 'form_fields.dart';

class Register extends StatefulWidget {
  final VoidCallback? navigateToProfile;
  final VoidCallback? navigateToSignIn;

  const Register({Key? key, this.navigateToProfile, this.navigateToSignIn})
      : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String error = '';
  UserData? userData;

  @override
  void initState() {
    super.initState();
    userData = UserData();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return indicatorDotsBouncing;
    } else {
      return Container(
        color: Colors.blue[700],
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Align(
            child: Container(
              padding: const EdgeInsets.only(bottom: 20.0),
              margin: const EdgeInsets.only(
                top: 20.0,
                bottom: 20.0,
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Text(
                      'Crear cuenta',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        children: <Widget>[
                          NameFormField(
                            onChanged: (val) =>
                                setState(() => {userData!.name = val}),
                          ),
                          const SizedBox(height: 16.0),
                          EmailFormField(
                            onChanged: (val) =>
                                setState(() => {userData!.email = val}),
                          ),
                          const SizedBox(height: 16.0),
                          PasswordFormField(
                            onChanged: (val) =>
                                setState(() => {userData!.password = val}),
                          ),
                          const SizedBox(height: 16.0),
                          AddressFormField(
                            onChanged: (val) =>
                                setState(() => {userData!.address = val}),
                          ),
                          const SizedBox(height: 16.0),
                          LandlineFormField(
                            onChanged: (val) =>
                                setState(() => {userData!.landline = val}),
                          ),
                          const SizedBox(height: 16.0),
                          CellphoneFormField(
                            onChanged: (val) =>
                                setState(() => {userData!.cellphone = val}),
                          ),
                          const SizedBox(height: 40.0),
                          Text(
                            error,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          RegisterButton(onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);

                              dynamic result = await _authService
                                  .registerWithEmailAndPassword(userData!);

                              if (result == null) {
                                setState(() {
                                  error = 'Correo inválido o ya registrado';
                                  loading = false;
                                });
                              } else {
                                widget.navigateToProfile!();
                              }
                            }
                          }),
                          const SizedBox(height: 12.0),
                          SignInButton(
                            isForSignInForm: false,
                            onPressed: () => widget.navigateToSignIn!(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}