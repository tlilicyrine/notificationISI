//import 'dart:typed_data';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'notificationISI.dart';
import 'login.dart';
import 'package:isi/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import 'package:image_picker/image_picker.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController bodycontroller = TextEditingController();

  Set<String> _selectedCategories = {};
  QuerySnapshot? categoriesSnapshot, categoriesStream;

  List<String> priorities = ["1","2","3","4","5"];
  String? _selectedPriority="1";
  //Uint8List? _imageData;
  Stream? NotificationStream;

  @override
  void initState() {
    super.initState();
    getontheload();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    categoriesSnapshot = await FirebaseFirestore.instance.collection('Category').get();
    setState(() {});
  }

  void getontheload() async {
    NotificationStream = await DatabaseMethods().getNotificationDetails();
    setState(() {});
  }

  Widget allNotificationDetails() {
    return StreamBuilder(
      stream: NotificationStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  List<String> categories = List<String>.from(ds["Category"]); 
                  String allCategories = categories.join(" - "); 
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Title: " + ds["Title"],
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    titlecontroller.text = ds['Title'];
                                    bodycontroller.text = ds['Body'];
                                    _selectedCategories.addAll(categories); 
                                    _selectedPriority = ds['Priority'];
                                    EditNotificationDetail(ds['Id']);
                                  },
                                  child: Icon(Icons.edit, color: Colors.orange),
                                ),
                                SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () {
                                    titlecontroller.text = ds['Title'];
                                    DeleteNotificationDetail(ds['Id']);
                                  },
                                  child: Icon(Icons.delete, color: Colors.orange),
                                ),
                              ],
                            ),
                            Text(
                              'Message: '+ds["Body"],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                             Text(
                              "Categories: $allCategories",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            
                            Text(
                              "Priority: " + ds["Priority"],
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationISI()));
        },
        child: Icon(Icons.add,color: Colors.lightBlue,),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Notification List",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
        margin: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          children: [
            Expanded(child: allNotificationDetails()),
          ],
        ),
      ),
    );
  }

  Future EditNotificationDetail(String id) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.cancel),
                  ),
                  SizedBox(width: 60),
                  Text(
                    "Edit Notification",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Title",
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: titlecontroller,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Body",
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: bodycontroller,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Category",
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
              ),
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
              Text(
                "Priority",
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
              ),
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

          /*SizedBox(height: 20),
          _imageData != null? Image.memory(_imageData!,height: 50,): Container(),
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
                  onPressed: () async {
                    if (titlecontroller.text.trim().isEmpty ||
                        bodycontroller.text.trim().isEmpty ||
                        _selectedCategories.isEmpty ) {
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
                        'Title': titlecontroller.text,
                        'Body': bodycontroller.text,
                        'Id': id,
                        'Category': _selectedCategories,
                        'Priority': _selectedPriority,
                        //"Image":_imageData,
                      };
                      await DatabaseMethods().updateNotificationDetails(id, updateInfo).then((value) {
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
      ),
    ),
  );

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

  Future DeleteNotificationDetail(String id) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.6,
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
                    "Delete Notification",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
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
                    "Are you sure you want to delete the notification \"${titlecontroller.text}\"?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await DatabaseMethods().deleteNotificationDetails(id).then((value) {
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