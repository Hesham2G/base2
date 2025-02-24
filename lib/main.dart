import 'package:base2/Auth/login.dart';
import 'package:base2/Auth/signup.dart';
import 'package:base2/categories/add.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:base2/test.dart';




  void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(apiKey: "AIzaSyDGvTwsQyOpfWj9MsSUZM6w4UlrYC30H8w", appId: "base2-e4bd4.firebasestorage.app", messagingSenderId: "28891420618", projectId: "base2-e4bd4",storageBucket: "base2-e4bd4.firebasestorage.app"),
      
      
  );
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  
  


  

    
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[600],
          titleTextStyle: TextStyle(color: Colors.orange,
          fontSize: 19,
           fontWeight: FontWeight.bold
           ),
          iconTheme: IconThemeData(
            color: Colors.orange,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home:(FirebaseAuth.instance.currentUser != null &&FirebaseAuth.instance.currentUser!.emailVerified) ?  Test() :  Login(),
      routes: {
        "signup" : (context) => const SignUp(),
        "login" : (context) => const Login(),
        "test" : (context) => const Test(),
        "add" : (context) => const AddCategory(),
      },
      
     
    );
  }
}
