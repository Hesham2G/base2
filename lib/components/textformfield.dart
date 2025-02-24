// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Customformfield extends StatelessWidget {
  final String hinttext;
    
    final TextEditingController mycontroller;
    final String? Function(String?)? validator;
  const Customformfield({super.key, required this.hinttext, required this.mycontroller, required this.validator});

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      validator: validator,
      controller: mycontroller,
                decoration:InputDecoration(
                  hintText: hinttext,
                  hintStyle: TextStyle(fontSize: 14,color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(vertical: 2,horizontal: 20),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: const Color.fromARGB(255, 151, 151, 151))
                  ),
                  enabledBorder:   OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: const Color.fromARGB(255, 174, 174, 174))
                  ),
                ),

               );
  }
}