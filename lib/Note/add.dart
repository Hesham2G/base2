import 'package:base2/Note/view.dart';
import 'package:base2/components/custombuttomauth.dart';
import 'package:base2/components/customtextfieldadd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Addnote extends StatefulWidget {
  final String docid;
  const Addnote({super.key, required this.docid});

  @override
  State<Addnote> createState() => _AddnoteState();
}

class _AddnoteState extends State<Addnote> {
  
  GlobalKey<FormState>  formState = GlobalKey<FormState>();
  TextEditingController Note = TextEditingController();
  
  bool isLoading = false;
   

   AddNote()async{
     CollectionReference Collectionnote = FirebaseFirestore.instance.collection("categories").doc(widget.docid).collection("Note");
    if (formState.currentState!.validate()) {
      try{
        isLoading = true;
        setState(() {
          
        });
      DocumentReference respones = await Collectionnote.add(
        {"Note" : Note.text  });
       
        
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => NoteView(Categoryid: widget.docid)), );
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

          CustomButtonAuth(Title: "Add", onPressed: (){
            AddNote();
          },)
        ],),
      ),
      
    );
  }
}