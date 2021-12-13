import 'package:flutter/material.dart';

class NameFormField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String? initialValue;

  const NameFormField({Key? key, required this.onChanged, this.initialValue,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextFormField(
        enableInteractiveSelection: false,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22.0,
        ),
        initialValue: initialValue,
        decoration: const InputDecoration(
          isDense: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class AddressFormField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String? initialValue;

  const AddressFormField({
    Key? key,
    required this.onChanged,
    required this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      ),
      initialValue: initialValue,
      decoration: const InputDecoration(
        isDense: true,
      ),
      validator: (val) =>
          val!.isEmpty ? 'Ingrese una dirección de domicilio' : null,
      onChanged: onChanged,
    );
  }
}

class LandlineFormField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String? initialValue;

  const LandlineFormField({
    Key? key,
    required this.onChanged,
    required this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      ),
      initialValue: initialValue,
      decoration: const InputDecoration(
        isDense: true,
      ),
      validator: (val) =>
          val!.isEmpty ? 'Ingrese un número de teléfono fijo' : null,
      onChanged: onChanged,
    );
  }
}

class CellphoneFormField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String? initialValue;

  const CellphoneFormField({
    Key? key,
    required this.onChanged,
    required this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      ),
      initialValue: initialValue,
      decoration: const InputDecoration(
        isDense: true,
      ),
      validator: (val) => val!.isEmpty ? 'Ingrese un número de celular' : null,
      onChanged: onChanged,
    );
  }
}
