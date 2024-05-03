import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login.dart';
//import 'dart:typed_data';
import 'package:isi/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
//import 'package:image_picker/image_picker.dart';

import 'notificationList.dart';

class NotificationISI extends StatefulWidget{
  const NotificationISI ({super.key});

  @override 
  State<NotificationISI> createState() => _NotificationISIState();
}

class _NotificationISIState extends State<NotificationISI> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController bodycontroller = TextEditingController();

  List<String> priorities = ["1","2","3","4","5"];
  String? _selectedPriority="1";
  Set<String> _selectedCategories = {};
  QuerySnapshot? categoriesSnapshot, categoriesStream;

  //Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

@override 
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Notification ISI",
            style: TextStyle(
              color:Colors.blue, 
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
    body: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left:20, top: 30, right:20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text("Title",style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(left:10),
            decoration:BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10)
            ),
            child: TextField(
              controller: titlecontroller,
              decoration: InputDecoration(border: InputBorder.none),
            )
          ),

          SizedBox(height: 20),
          Text("Body",style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(left:10),
            decoration:BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10)
            ),
            child: TextField(
              controller: bodycontroller,
              decoration: InputDecoration(border: InputBorder.none),
            )
          ),

          SizedBox(height: 20),
          Text("Category",style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),),
          SizedBox(height: 10),
          Container(
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () {
                    _showMultiSelectBottomSheet(context); 
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text("" ),
                      ),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),

          SizedBox(height: 20),
          Text("Priority",style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),),
          SizedBox(height: 10),
          Container(
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedPriority, 
                  items: priorities.map((String priority) {
                    return DropdownMenuItem<String>(
                      value: priority,
                      child: Text(priority),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPriority = newValue; 
                    });
                  },
                  isExpanded: true,
                  decoration: InputDecoration(border: InputBorder.none),
                )
              ),
              /*
          SizedBox(height: 20),
          _imageData != null? Image.memory(_imageData!,height: 100,): Container(),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _getImage,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.orangeAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.image),
                SizedBox(width: 5),
                Text('Pick Image'),
              ],
            ),
          ),*/
          SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () async{
                String id=randomAlphaNumeric(10);
                if (titlecontroller.text.isEmpty || bodycontroller.text.isEmpty || _selectedCategories.isEmpty){
                  Fluttertoast.showToast(
                        msg: "Please fill all fields",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                }
                else {
                  Map<String, dynamic> notificationInfoMap={
                    "Title": titlecontroller.text,
                    "Body": bodycontroller.text,
                    "Id": id,
                    "Category": _selectedCategories,
                    "Priority": _selectedPriority,
                    //"Image":_imageData,
                  };
                  await DatabaseMethods().addNotificationDetails(notificationInfoMap, id).then((value) {
                      Fluttertoast.showToast(
                        msg: "Notification uploaded successfully !",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                      );
                  });
                  Navigator.push(context,MaterialPageRoute(builder: (context) => NotificationList()));
                }   
              }, 
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, ),
              child: Text("Add",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color:Colors.white))),
          ),

          ],),),
    ),
  );
}

  Future<void> _fetchCategories() async {
    categoriesSnapshot = await FirebaseFirestore.instance.collection('Category').get();
    setState(() {});
  }

   /*Future<void> _getImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageData = Uint8List.fromList(bytes);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }*/



   void _showMultiSelectBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return MultiSelectBottomSheet(
          items: categoriesSnapshot!.docs.map((DocumentSnapshot document) {
            return MultiSelectItem(document['Name'], document['Name']);
          }).toList(),
          initialValue: _selectedCategories.toList(),
          onConfirm: (values) {
            setState(() {
              _selectedCategories = values.cast<String>().toSet();
            });
            
          },
          maxChildSize: 0.8,
        );
      },
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

