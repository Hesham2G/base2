// ignore_for_file: use_super_parameters, prefer_const_constructors, use_build_context_synchronously

import 'package:base2/Note/view.dart';
import 'package:base2/categories/add.dart';
import 'package:base2/categories/edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
 
  List<QueryDocumentSnapshot> data = [] ;

  bool isLoading = true;

  getData()async{

    QuerySnapshot querySnapshot =
       await FirebaseFirestore.instance.collection("categories").where("id" ,isEqualTo: FirebaseAuth.instance.currentUser!.uid).get() ;
       await Future.delayed(Duration(seconds: 1));
    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {
      
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed:(){
        Navigator.of(context).pushNamed("add");
      },
      child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("HomePage"),
        actions: [
          IconButton(onPressed: ()async{
            GoogleSignIn googleSignIn = GoogleSignIn();
            googleSignIn.disconnect();

            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false);
          }, icon: Icon(Icons.exit_to_app)),
        ],
      ),
      body: isLoading == true ? Center(child: CircularProgressIndicator(),) : GridView.builder(
        itemCount:data.length,
        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 200), 
        itemBuilder: (context,i){
          return InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => NoteView(Categoryid: data[i].id))) ;
            },
            onLongPress: (){
              AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.rightSlide,
                      title: 'Warning',
                      desc: 'Are you sure Do you want Delete this Category.',
                      btnCancelText: "Delete",
                      btnCancelOnPress: ()async{
                        await FirebaseFirestore.instance.collection("categories").doc(data[i].id).delete();
                          Navigator.of(context).pushNamed("test");
                      },
                      btnOkText: "Edit",
                      btnOkOnPress: ()async{
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditCategory(docid: data[i].id, OldName: data[i]["name"])));
                        
                      },
                    ).show();
            },
            child: Card(child: Container(
                    padding: EdgeInsets.all(10),
                     child: Column(children: [
             Image.asset("images/Note2.png",height: 140,),
              Text("${data[i]["name"]}")
                     ]),
                   ),
                   ),
          );
        },
      ));

    
  }
}