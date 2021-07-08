import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  //Collection reference
  final CollectionReference _locationReference =
      FirebaseFirestore.instance.collection("locations");
}
