import 'package:flutter/material.dart';

class AddressTextFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String title;
  const AddressTextFormField(
      {required this.textEditingController, required this.title});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      validator: (value) => value!.isEmpty ? 'required' : null,
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: title,
        hintStyle: TextStyle(color: Colors.white),
        labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        hintText: title,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
      ),
    );
  }
}
