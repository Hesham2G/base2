// ignore_for_file: use_super_parameters, prefer_const_constructors, use_build_context_synchronously

import 'package:base2/Note/add.dart';
import 'package:base2/Note/edit.dart';
import 'package:base2/categories/add.dart';
import 'package:base2/categories/edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class NoteView extends StatefulWidget {
  final String Categoryid;
  const NoteView({Key? key, required this.Categoryid}) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
 
  List<QueryDocumentSnapshot> data = [] ;

  bool isLoading = true;

  getData()async{

    QuerySnapshot querySnapshot =
       await FirebaseFirestore.instance.
       collection("categories").doc(widget.Categoryid).collection("Note").get();
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
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Addnote(docid: widget.Categoryid)));
      },
      child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Notes"),
        actions: [
          IconButton(onPressed: ()async{
            GoogleSignIn googleSignIn = GoogleSignIn();
            googleSignIn.disconnect();

            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false);
          }, icon: Icon(Icons.exit_to_app)),
        ],
      ),
      body: WillPopScope(child:  isLoading == true ? Center(child: CircularProgressIndicator(),) : GridView.builder(
        itemCount:data.length,
        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 200), 
        itemBuilder: (context,i){
          return InkWell(
            onLongPress: (){
              AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.rightSlide,
                      title: 'Warning',
                      desc: 'Are you sure Do you want Delete this Category.',
                    
                      btnCancelOnPress: ()async{
                      
                      },
                     
                      btnOkOnPress: ()async{
                        await FirebaseFirestore.instance
                        .collection("categories")
                        .doc(widget.Categoryid)
                        .collection("Note")
                        .doc(data[i].id).delete();
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => NoteView(Categoryid: widget.Categoryid)));
                        
                      },
                    ).show();
            },
            
           
             onTap : (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Editnote(
                notedocid: data[i].id,
                 categorydocid: widget.Categoryid,
                  value: data[i]["Note"]
                  )));

             
            },
            child: Card(child: Container(
                    padding: EdgeInsets.all(20),
                    
                     child: Column(children: [
            
              Text("${data[i]["Note"]}")
                     ]
                     ),
                   ),
                   ),
          );
        },
      ), onWillPop: (){
        Navigator.of(context).pushNamedAndRemoveUntil("test",(route) => false);
        return Future.value(false);
      }));

    
  }
}