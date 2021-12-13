import 'package:flutter/material.dart';

class SignOutButton extends StatelessWidget {
  final Function() onPressed;

  const SignOutButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.12,
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextButton(
        child: const Text('Cerrar sesión'),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 0.0,
          ),
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
class UpdateDataButton extends StatelessWidget {
  final Function() onPressed;

  const UpdateDataButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.12,
      width: MediaQuery.of(context).size.width * 0.6,
      child: OutlinedButton(
        child: Text(
          'Actualizar datos',
          style: TextStyle(
            color: Colors.blue[700],
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
              width: 2.0, color: (Colors.blue[700])!),
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 0.0,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class DeleteAccountButton extends StatelessWidget {
  final Function() onPressed;

  const DeleteAccountButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.12,
      width: MediaQuery.of(context).size.width * 0.6,
      child: OutlinedButton(
        child: Text(
          'Eliminar cuenta',
          style: TextStyle(
            color: Colors.blue[700],
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
              width: 2.0, color: (Colors.blue[700])!),
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 0.0,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
