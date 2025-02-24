import 'package:base2/Note/view.dart';
import 'package:base2/components/custombuttomauth.dart';
import 'package:base2/components/customtextfieldadd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Editnote extends StatefulWidget {
  final String notedocid;
  final String value;
  final String categorydocid;
  const Editnote({super.key,  required this.notedocid, required this.categorydocid, required this.value});

  @override
  State<Editnote> createState() => _EditnoteState();
}

class _EditnoteState extends State<Editnote> {
  
  GlobalKey<FormState>  formState = GlobalKey<FormState>();
  TextEditingController Note = TextEditingController();
  
  bool isLoading = false;
   

   EditNote()async{
     CollectionReference Collectionnote = FirebaseFirestore.instance.collection("categories").doc(widget.categorydocid).collection("Note");
    if (formState.currentState!.validate()) {
      try{
        isLoading = true;
        setState(() {
          
        });
       await Collectionnote.doc(widget.notedocid).update(
        {"Note" : Note.text  });
       
        
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => NoteView(Categoryid: widget.categorydocid)));
      }catch(e){
         isLoading = false;
        setState(() {});
       
        AwesomeDialog(
                      context :context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Error $e',
                      desc: 'You have a problem connecting to the network.',
                    ).show();
        
      }
      
      }
   }
   @override
  void initState() {
    Note.text = widget.value;
    super.initState();
  }
   @override
  void dispose() {
    super.dispose();
    // TODO: implement dispose
    
    Note.dispose();
  }

      


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Notes"),
        
      ),
      body: Form(
        key:formState ,
        child:isLoading ? Center(child: CircularProgressIndicator(),) : Column(children: [
          
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: CustomformfieldAdd(hinttext: "Enter The Note", mycontroller: Note, validator: (val){
              if(val == ""){
                return "You Can't Let it Empty ";
              }
            }),
          ),

          CustomButtonAuth(Title: "Edit", onPressed: (){
            EditNote();
          },)
        ],),
      ),
      
    );
  }
}