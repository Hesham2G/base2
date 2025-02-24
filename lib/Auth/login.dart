// ignore_for_file: non_constant_identifier_names, unused_local_variable, use_build_context_synchronously, avoid_print

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:base2/components/textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../components/custombuttomauth.dart';
import '../components/customlogoauth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();



 GlobalKey<FormState> formState = GlobalKey<FormState>() ;
 bool isLoading = false;
  
  Future signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  if(googleUser == null){
    return ;
  }

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  await FirebaseAuth.instance.signInWithCredential(credential);
  Navigator.of(context).pushNamedAndRemoveUntil("test",(route) => false);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:isLoading ? Center(child: CircularProgressIndicator()) :  Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const CustomLogoAuth(),
                  const SizedBox(height: 20),
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Login to Continue Using the App",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Customformfield(
                    hinttext: "Enter Your Email",
                    mycontroller: Email,
                    validator: (val){
                      if (val == "" ){
                        return "You Can't Let It Empty ";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Customformfield(
                    hinttext: "Enter Your Password",
                    mycontroller: Password,
                     validator: (val){
                      if (val == "" ){
                        return "You Can't Let It Empty ";
                      }
                      return null;
                    },
                  ),
                  InkWell(
                    onTap: ()async{
                      if(Email.text == ""){
                        AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
                      title: 'Warning',
                      desc: 'Please You Should Apply your Email To Send a new Password to your Email.',
                    ).show();
                        return;
                      };
                      try{
                        await FirebaseAuth.instance.sendPasswordResetEmail(email: Email.text);
                        AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.rightSlide,
                      title: 'Reset Your Password',
                      desc: 'A password reset has been sent to your email.',
                    ).show();

                      }catch(e){
                        AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Error',
                      desc: 'The Email you Applied not correct Please check and try again.',
                    ).show();

                      }

                                          
                       
                    },
                    child: Container(
                      alignment: Alignment.topRight,
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      child: const Text(
                        "Forget Password?",
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomButtonAuth(
              Title: "Login",
              onPressed: () async {
                if(formState.currentState!.validate()){
                  try {
                     isLoading = true;
                    setState(() {});
                  final credential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                    email: Email.text.trim(),
                    password: Password.text.trim(),
                  );
                    isLoading = false;
                    setState(() {});
                  

                  // Navigate to the next page
                  if(credential.user!.emailVerified){
                    Navigator.of(context).pushReplacementNamed("test");
                  }else{
                    FirebaseAuth.instance.
                    currentUser!.sendEmailVerification();
                     AwesomeDialog(
                      context: context,
                      dialogType: DialogType.infoReverse,
                      animType: AnimType.rightSlide,
                      title: 'Warning',
                      desc: 'Please you should Verifie Your Account First.',
                    ).show();

                  }
                } on FirebaseAuthException catch (e) {
                   isLoading = false;
                    setState(() {});
                  String errorMessage;

                  if (e.code == 'user-not-found') {
                    errorMessage = 'No user found for that email.';
                  } else if (e.code == 'wrong-password') {
                    errorMessage = 'Wrong password provided for that user.';
                  } else {
                    errorMessage = 'Something went wrong. Please try again.';
                  }

                  // Show error dialog
                  if (context.mounted) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Login Failed',
                      desc: errorMessage,
                    ).show();
                  }
                } catch (e) {
                  if (context.mounted) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Error',
                      desc: 'An unexpected error occurred. Please try again later.',
                    ).show();
                  }
                }
                }else{
                  print("Not Valid");
                }
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Or Login With",
              textAlign: TextAlign.center,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              height: 40,
              color: Colors.red[700],
              textColor: Colors.white,
              onPressed: () {
                signInWithGoogle();

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Google "),
                  Image.asset(
                    "images/Google3.jpg",
                    width: 25,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed("signup");
              },
              child: const Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "Don't Have An Account?"),
                      TextSpan(
                        text: " Register",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
