import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isi/service/database.dart';

import 'login.dart';
import 'model.dart';

class Student extends StatefulWidget {
  final String id;
  const Student({required this.id, Key? key}) : super(key: key);

  @override
  _StudentState createState() => _StudentState(id: id);
}

class _StudentState extends State<Student> {
  String id;
  var role;
  var email;
  String? _selectedCategory; 
  StudentModel loggedInUser = StudentModel();
  List<String> categories = [];

  
  Stream? NotificationStream;

  _StudentState({required this.id});

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get()
        .then((value) {
      this.loggedInUser = StudentModel.fromMap(value.data()!);
      setState(() {
        email = loggedInUser.email.toString();
        role = loggedInUser.role.toString();
        id = loggedInUser.uid.toString();
        _selectedCategory = loggedInUser.subscribedCategory;
      });
    });
    _fetchCategories();
    getontheload();
  }

  Future<void> _fetchCategories() async {
    QuerySnapshot? snapshot = await FirebaseFirestore.instance.collection('Category').get();
    List<String> categoryNames = snapshot.docs.map((doc) => doc['Name'] as String).toList();
    setState(() {
      categories = categoryNames;
    });
  }
void getontheload() async {
    NotificationStream = await DatabaseMethods().getNotificationStudents(id,_selectedCategory);
    setState(() {});
  }

  
  Widget allNotificationDetails() {
  if (_selectedCategory == null) {
    return Center(
      child: Text("Please subscribe to a category first"),
    );
  }
  return StreamBuilder(
    stream: DatabaseMethods().getNotificationStudents(id, _selectedCategory),
    builder: (context, AsyncSnapshot snapshot) {
      return snapshot.hasData && snapshot.data.docs.isNotEmpty
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
          : Center(
              child: Text("No notifications available"),
            );
    },
  );
}



@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Student ISI",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
          onPressed: () {
            _showSubscriptionDialog(context);
          },
          icon: Icon(Icons.subscriptions),
        ),
            IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

   body: NotificationStream != null
        ? Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Column(
              children: [
                Expanded(child: allNotificationDetails()),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          ),
    );
  }


  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  Future<void> _showSubscriptionDialog(BuildContext context) async {
  String? selectedCategory = _selectedCategory;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Subscribe to Category"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
                  value: _selectedCategory, 
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue; 
                    });
                  },
                  isExpanded: true,
                  decoration: InputDecoration(border: InputBorder.none),
                )
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _subscribeToCategory(selectedCategory!);
              _selectedCategory=selectedCategory;
              Navigator.of(context).pop();
            },
            child: Text('Subscribe'),
          ),
        ],
      );
    },
  );
}

  Future<void> _subscribeToCategory(String category) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(id);
    await userRef.update({'subscribedCategory': category});
    setState(() {
      _selectedCategory = category;
      getontheload();
    });
  }
}