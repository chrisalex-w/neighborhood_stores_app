import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final Function() onPressed;
  final bool isForSignInForm;

  const SignInButton({
    Key? key,
    required this.onPressed,
    this.isForSignInForm = true,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    if (isForSignInForm) {
      return SizedBox(
        height: MediaQuery.of(context).size.width * 0.12,
        width: double.infinity,
        child: TextButton(
          child: const Text('Ingresar'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15.0,
            ),
            primary: Colors.white,
            backgroundColor: Colors.blue[600],
          ),
          onPressed: onPressed,
        ),
      );
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.width * 0.12,
        width: double.infinity,
        child: OutlinedButton(
          child: Text(
            'Iniciar sesión',
            style: TextStyle(
              color: Colors.blue[700],
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 2.0, color: (Colors.blue[700])!),
            padding: const EdgeInsets.only(),
          ),
          onPressed: onPressed,
        ),
      );
    }
  }
}

class CreateAccountButton extends StatelessWidget {
  final Function() onPressed;

  const CreateAccountButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.12,
      width: double.infinity,
      child: OutlinedButton(
        child: Text(
          'Crear cuenta',
          style: TextStyle(
            color: Colors.blue[700],
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: 2.0, color: (Colors.blue[700])!),
          padding: const EdgeInsets.only(),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  final Function() onPressed;

  const RegisterButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.12,
      width: double.infinity,
      child: TextButton(
        child: const Text('Registrarse'),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.only(),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15.0,
          ),
          primary: Colors.white,
          backgroundColor: Colors.blue[600],
        ),
        onPressed: onPressed,
      ),
    );
  }
}
