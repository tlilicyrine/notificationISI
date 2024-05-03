import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login.dart';
import 'package:isi/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';
import 'categoryList.dart';

class CategoryISI extends StatefulWidget{
  const CategoryISI ({super.key});

  @override 
  State<CategoryISI> createState() => _CategoryISIState();
}

class _CategoryISIState extends State<CategoryISI> {
  TextEditingController namecontroller = new TextEditingController();
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Category ",
              style: TextStyle(
                color:Colors.blue, 
                fontSize: 24, 
                fontWeight: FontWeight.bold)
            ),
            Text(
              "ISI",
              style: TextStyle(
                color:Colors.orange, 
                fontSize: 24, 
                fontWeight: FontWeight.bold)
            ),

      ],),
      actions: [
            IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(left:20, top: 30, right:20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text("Name",style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(left:10),
            decoration:BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10)
            ),
            child: TextField(
              controller: namecontroller,
              decoration: InputDecoration(border: InputBorder.none),
            )
          ),

          SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () async{
                String id=randomAlphaNumeric(10);
                if (namecontroller.text.isEmpty){
                  Fluttertoast.showToast(
                        msg: "Category name required !",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                }
                else{Map<String, dynamic> categoryInfoMap={
                  "Name": namecontroller.text,
                  "Id": id,
                };
                await DatabaseMethods().addCategoryDetails(categoryInfoMap, id).then((value) {
                    Fluttertoast.showToast(
                      msg: "Category uploaded successfully !",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                    );
                });
                Navigator.push(context,MaterialPageRoute(builder: (context) => CategoryList()));
                }
                }, 
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, ),
              child: Text("Add",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color:Colors.white))),
          ),

          ],),),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}