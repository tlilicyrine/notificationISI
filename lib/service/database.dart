import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  Future addNotificationDetails(Map<String, dynamic> notificationInfoMap, String id) async{
    return await FirebaseFirestore.instance.collection("Notification").doc(id).set(notificationInfoMap);
  }

  Future addCategoryDetails(Map<String, dynamic> categoryInfoMap, String id) async{
    return await FirebaseFirestore.instance.collection("Category").doc(id).set(categoryInfoMap);
  }

  Future<Stream<QuerySnapshot>> getNotificationDetails() async{
    return await FirebaseFirestore.instance.collection("Notification").orderBy('Priority',descending: true).snapshots();
  }

  Future<Stream<QuerySnapshot>> getCategoryDetails() async{
    return await FirebaseFirestore.instance.collection("Category").snapshots();
  }

  Future updateNotificationDetails(String id, Map<String, dynamic> updateInfo) async{
    return await FirebaseFirestore.instance.collection("Notification").doc(id).update(updateInfo);
  }

  Future updateCategoryDetails(String id, Map<String, dynamic> updateInfo) async{
    return await FirebaseFirestore.instance.collection("Category").doc(id).update(updateInfo);
  }

  Future deleteNotificationDetails(String id) async{
    return await FirebaseFirestore.instance.collection("Notification").doc(id).delete();
  }

  Future deleteCategoryDetails(String id) async{
    return await FirebaseFirestore.instance.collection("Category").doc(id).delete();
  }

  Stream<QuerySnapshot> getNotificationStudents(String userId, String? category) {
  return FirebaseFirestore.instance.collection('Notification').where('Category', arrayContains: category) .snapshots();
}

}