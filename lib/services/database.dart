import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fride/models/custom_user.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  //Collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Future setUserData({String? name, String? role}) async {
    return await userCollection.doc(uid).set({"name": name, "role": role});
  }

  Future setUserLocationData({double? lat, double? lng}) async {
    return await userCollection.doc(uid).update({
      "lat": lat,
      "lng": lng,
    });
  }

  CustomUser userDataFromSnapshot(DocumentSnapshot snapshot) {
    return CustomUser(
      name: snapshot.get("name"),
      role: snapshot.get("role"),
      uid: uid,
    );
  }

  List<CustomUser> _usersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CustomUser(
        name: doc.get("name") ?? "no name",
        role: doc.get("role") ?? "no role",
        uid: uid,
      );
    }).toList();
  }

  Stream<CustomUser> get userData {
    return userCollection.doc(uid).snapshots().map(userDataFromSnapshot);
  }

  Stream<List<CustomUser>> users() {
    return userCollection.snapshots().map(_usersListFromSnapshot);
  }

}
