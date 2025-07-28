import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> fetchMahasiswa() {
  CollectionReference mhs = FirebaseFirestore.instance.collection('mhs');

  return mhs.get().then((QuerySnapshot snapshot) {
    snapshot.docs.forEach((element) {

    });
  }).catchError((error) => print("Failed to fetch mahasiswa: $error"));
}

Future<void> updateMahasiswa(String mhsId, String npm, String nama) {
  CollectionReference mhs = FirebaseFirestore.instance.collection('mhs');

  return mhs.doc(mhsId).update({'npm': npm, 'nama': nama})
      .then((value) => print("Mahasiswa updated successfullty!"))
      .catchError((error) => print("Failed to update mahasiswa: $error"));
}

Future<void> addMahasiswa(String npm, String nama) {
  CollectionReference mhs = FirebaseFirestore.instance.collection('mhs');

  return mhs.add({
    'npm': npm,
    'nama': nama
  }).then((value) => print("Mahasiswa added successfully!"))
    .catchError((error) => print("Failed to add mahasiswa: $error"));
}

Future<void> deleteMahasiswa(String mhsId) {
  CollectionReference mhs = FirebaseFirestore.instance.collection('mhs');

  return mhs.doc(mhsId).delete()
      .then((value) => print("Mahasiswa deleted successfully!"))
      .catchError((error) => print("Failed to deleted mahasiswa: $error"));
}