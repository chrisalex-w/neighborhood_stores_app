import 'package:flutter/material.dart';
import 'package:neighborhood_stores_app/shared/constants.dart';

const profileInputDecoration = InputDecoration(
  isDense: true,
);

class NameFormField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const NameFormField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: textInputDecoration.copyWith(labelText: 'Nombre'),
      validator: (val) => val!.isEmpty ? 'Ingrese un nombre' : null,
      onChanged: onChanged,
    );
  }
}

class EmailFormField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const EmailFormField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: textInputDecoration.copyWith(labelText: 'Correo electrónico'),
      validator: (val) => val!.isEmpty ? 'Ingrese un correo electrónico' : null,
      onChanged: onChanged,
    );
  }
}

class PasswordFormField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const PasswordFormField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: textInputDecoration.copyWith(
        labelText: 'Contraseña',
        errorMaxLines: 2,
      ),
      obscureText: true,
      validator: (val) => val!.length < 6
          ? 'Ingrese una contraseña de al menos 6 caracteres'
          : null,
      onChanged: onChanged,
    );
  }
}

class AddressFormField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const AddressFormField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: textInputDecoration.copyWith(labelText: 'Dirección'),
      validator: (val) =>
          val!.isEmpty ? 'Ingrese una dirección de domicilio' : null,
      onChanged: onChanged,
    );
  }
}

class LandlineFormField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const LandlineFormField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: textInputDecoration.copyWith(labelText: 'Teléfono fijo'),
      validator: (val) =>
          val!.isEmpty ? 'Ingrese un número de teléfono fijo' : null,
      onChanged: onChanged,
    );
  }
}

class CellphoneFormField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const CellphoneFormField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: textInputDecoration.copyWith(labelText: 'Celular'),
      validator: (val) => val!.isEmpty ? 'Ingrese un número de celular' : null,
      onChanged: onChanged,
    );
  }
}