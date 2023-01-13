import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  //pass parameters tothe calss to access custom feilds
  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  bool? isObsecre = true; // for password to convert password into dots
  bool? enabled = true; // used to allow seller/user to write text or not
  CustomTextField({
    this.controller,
    this.data,
    this.enabled,
    this.hintText,
    this.isObsecre,
});

   @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: enabled, //by defult value true
        controller: controller,
        obscureText: isObsecre!, //not null
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            data, //receiving from class parameter testfeild

            color: Colors.cyan,
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,

        ),
      ),

    );
  }
}


