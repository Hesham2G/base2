

// ignore_for_file: non_constant_identifier_names, unused_local_variable, use_super_parameters, use_build_context_synchronously, avoid_print

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:base2/components/custombuttomauth.dart';
import 'package:base2/components/customlogoauth.dart';
import 'package:base2/components/textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 class SignUp extends StatefulWidget {
  
   const SignUp({Key? key}) : super(key: key);
 
   @override
   State<SignUp> createState() => _LoginState();
 }
 
 class _LoginState extends State<SignUp> {
  TextEditingController username =TextEditingController();
  TextEditingController Email =TextEditingController();
  TextEditingController Password =TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>() ;
   @override
   Widget build(BuildContext context) {
     return Scaffold(
      
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
        Form(
          key: formState,
           
          child: Column(
            crossAxisAlignment : CrossAxisAlignment.start,
                 children: [
          
          Container(height: 50,),
              const CustomLogoAuth(),
              Container(height: 20,),
                 const Text("SignUp",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                 Container(height: 10,),
                 const Text("SignUp to Continue Using the App",style: TextStyle(color: Colors.grey),),
                 Container(height: 20,),
          
                 const Text("Username",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
             Container(height: 5,),
                 Customformfield(hinttext: "Enter Your username", mycontroller: username,
                   validator: (val){
                      if (val == "" ){
                        return "You Can't Let It Empty ";
                      }
                      return null;
                    },
                  ),
                Container(height: 20,),
                
                 const Text("Email",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                 Container(height: 5,),
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
                
                 Container(height: 10,),
                 const Text("Password",
                 style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                 Container(height: 10,),
                 Customformfield(hinttext: "Enter Your Password", mycontroller: Password,
                    validator: (val){
                      if (val == "" ){
                        return "You Can't Let It Empty ";
                      }
                      return null;
                    },
                  ),
                 
               
                 
                  Container(
                    alignment: Alignment.topRight,
                    margin: const EdgeInsets.only(top: 10,bottom: 20),
                    child: const Text(
                      textAlign: TextAlign.right,
                      "Forget Password ?",
                    
                                   style: TextStyle(fontSize: 14),),
                  ),
                
            ],
          ),
        ),
          CustomButtonAuth(Title: "SignUp",onPressed: ()async{

            if (formState.currentState!.validate())
            {
              try {
                final credential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email:Email.text ,
                  password: Password.text,
                );
                FirebaseAuth.instance.currentUser!.sendEmailVerification();
                Navigator.of(context).pushReplacementNamed("login");
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print('The password provided is too weak.');
                  AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: 'The password provided is too weak.',

            ).show();
                } else if (e.code == 'email-already-in-use') {
                  print('The account already exists for that email.');
                   AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: 'The account already exists for that email.',

            ).show();
                }
              } catch (e) {
                print(e);
              }

            }



          },),
                 Container(height: 20,),
                  
                
                  Container(height: 20,),
                  
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pushReplacementNamed("login");


                    },
                    child: const Center(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(text: "Have  An Account ?"),
                        TextSpan(text: "Login",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold)),
                      ])),
                    ),
                  )

      ],
      ),)
     );
   }
 }