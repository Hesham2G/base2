import 'package:base2/components/custombuttomauth.dart';
import 'package:base2/components/customtextfieldadd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class EditCategory extends StatefulWidget {
  final String docid ;
  final String OldName;
  const EditCategory({super.key, required this.docid, required this.OldName});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  GlobalKey<FormState>  formState = GlobalKey<FormState>();
  TextEditingController Name = TextEditingController();
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');
  bool isLoading = false;
   

   EditCategory()async{
    if (formState.currentState!.validate()) {
      try{
        isLoading = true;
        setState(() {
          
        });
      await categories.doc(widget.docid).update({
        "name" : Name.text
      });
       
        
      Navigator.of(context).pushNamedAndRemoveUntil("test", (route) => false);
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
    
    Name.dispose();
  }
   @override
  void initState() {
    // TODO: implement initState
    Name.text = widget.OldName;
  }

      


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Category"),
        
      ),
      body: Form(
        key:formState ,
        child:isLoading ? Center(child: CircularProgressIndicator(),) : Column(children: [
          
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: CustomformfieldAdd(hinttext: "Enter Name", mycontroller: Name, validator: (val){
              if(val == ""){
                return "You Can't Let it Empty ";
              }
            }),
          ),

          CustomButtonAuth(Title: "Edit", onPressed: (){
            EditCategory();
          },)
        ],),
      ),
      
    );
  }
}