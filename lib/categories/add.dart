import 'package:base2/components/custombuttomauth.dart';
import 'package:base2/components/customtextfieldadd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState>  formState = GlobalKey<FormState>();
  TextEditingController Name = TextEditingController();
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');
  bool isLoading = false;
   

   AddCategory()async{
    if (formState.currentState!.validate()) {
      try{
        isLoading = true;
        setState(() {
          
        });
      DocumentReference respones = await categories.add({"name" : Name.text , "id" : FirebaseAuth.instance.currentUser!.uid});
       
        
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category"),
        
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

          CustomButtonAuth(Title: "Add", onPressed: (){
            AddCategory();
          },)
        ],),
      ),
      
    );
  }
}