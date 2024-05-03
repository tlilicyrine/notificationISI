import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:isi/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'categoryISI.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});
  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  TextEditingController namecontroller = new TextEditingController();
  Stream? CategoryStream;

  getontheload()async{
    CategoryStream= await DatabaseMethods().getCategoryDetails();
    setState(() {

    });
  }

  @override
  void initState(){
    getontheload();
    super.initState();
  }

  Widget allCategoryDetails(){
    return StreamBuilder(
      stream: CategoryStream,
      builder: (context, AsyncSnapshot snapshot){
        return snapshot.hasData
              ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context,index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text( 
                                  ds["Name"],
                                  style: TextStyle( 
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: (){
                                      namecontroller.text=ds['Name'];
                                      EditCategoryDetail(ds['Id']);
                                    },
                                    child: Icon(Icons.edit, color: Colors.orange),
                                  ),
                                  SizedBox(width:5),
                                  GestureDetector(
                                    onTap: (){
                                        namecontroller.text=ds['Name'];
                                        DeleteCategoryDetail(ds['Id']);
                                    },
                                    child: Icon(Icons.delete, color: Colors.orange),
                                  ),
                              ],
                            ),
                            ],
                        ),
                      ),
                    ),
                  );
                }
              ):Container();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context,MaterialPageRoute(builder: (context) => CategoryISI()));
      } ,child: Icon(Icons.add,color: Colors.lightBlue,),),
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
        ],),
      body:Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          children: [
              Expanded(child: allCategoryDetails()),
          ],
      ),
    ),
    );
  }

  Future EditCategoryDetail(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.6, // Adjust the width as needed
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Colors.blue,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.cancel),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Edit Category",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: namecontroller,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                           if (namecontroller.text.trim().isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Please fill in all fields",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            } else {
                              Map<String, dynamic> updateInfo = {
                                'Name': namecontroller.text,
                                'Id': id,
                              };
                              await DatabaseMethods()
                                  .updateCategoryDetails(id, updateInfo)
                                  .then((value) {
                                Navigator.pop(context);
                              });
                            }
                          },
                          child: Text("Update"),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  Future DeleteCategoryDetail(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.6, // Adjust the width as needed
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Colors.blue,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.cancel),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Delete Category",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Are you sure you want to delete the category \"${namecontroller.text}\"?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          await DatabaseMethods()
                              .deleteCategoryDetails(id)
                              .then((value) {
                            Navigator.pop(context);
                          });
                        },
                        child: Text("Delete"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
 
  }