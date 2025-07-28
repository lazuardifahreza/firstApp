import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'form.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        // apiKey: "AIzaSyDaWbS4YT0QlqC8Pi64O-I6Bro0_QC-jN4",
      apiKey: "AIzaSyDZpiSLTmexvBMFmzaR1u1tHHXWqgNB5sE", // current_key
        // appId: "1:489919808349:android:ba7755a64fd9fe31a65eb4",
        appId: "1:319239445954:android:35a103b9a05761a9abca5b", // mobilesdk_app_id
        messagingSenderId: "319239445954", // project_number
        // messagingSenderId: "489919808349",
      projectId: "mahasiswa-dbda3" // project_id
    )
        // projectId: "crud-firebase-e765b")
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // final Stream<QuerySnapshot> products;
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
          title: 'Mahasiswa'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);
// final items = Product.getProducts();
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List data = [];

  @override
  void initState() {
    super.initState();

    CollectionReference mhs = FirebaseFirestore.instance.collection('mhs');

    mhs.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        setState(() {
          data.add(element.data());
        });
      });
    });
  }
  
  Future<void> addBinatang(String nama, String habitat, int jumlah) {
    CollectionReference binatang = FirebaseFirestore.instance.collection('binatang');

    return binatang.add({
      'nama': nama,
      'habitat': habitat,
      'jumlah': jumlah
    }).then((value) => print("Binatang added successfully!"))
        .catchError((error) => print("Failed to add binatang: $error"));
  }

  Future<void> fetchBinatang() {
    CollectionReference binatang = FirebaseFirestore.instance.collection('binatang');

    return binatang.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        setState(() {
          data.add(element.data());
        });

        print('data ${element.id} => ${element.data()}');
      });
    }).catchError((error) => print("Failed to fetch binatang: $error"));
  }

  Future<void> updateBinatang(String binatangId, String nama, String habitat, int jumlah) {
    CollectionReference binatang = FirebaseFirestore.instance.collection('binatang');

    return binatang.doc(binatangId).update({'nama': nama, 'habitat': habitat, 'jumlah': jumlah})
        .then((value) => print("Binatang updated successfullty!"))
        .catchError((error) => print("Failed to update binatang: $error"));
  }

  Future<void> deleteBinatang(String binatangId) {
    CollectionReference binatang = FirebaseFirestore.instance.collection('binatang');

    return binatang.doc(binatangId).delete()
        .then((value) => print("Binatang deleted successfully!"))
        .catchError((error) => print("Failed to deleted binatang: $error"));
  }

  Future<void> filterBinatang(String column, String val) {
    CollectionReference binatang = FirebaseFirestore.instance.collection('binatang');

    return binatang.where(column, isEqualTo: val).get()
        .then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((element) {
            print('${element.id} => ${element.data()}');
          });
        })
        .catchError((error) => print("Failed to filter binatang: $error"));
  }

  Future<void> fetchUserByAge(int minAge) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return users.where('age', isGreaterThan: minAge).get()
        .then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((element) {
            print('${element.id} => ${element.data()}');
          });
        })
        .catchError((error) => print("Failed to fetch users: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            var row = data[index];

            if (index == 0)
              return Column(
                children: [
                  ElevatedButton(onPressed: () => (
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return FormMahasiswa();
                    }))
                  ), child: Text('Tambah Data')),
                  ListTile(
                    title: Text(row['npm']),
                    subtitle: Text(row['nama']),
                  )
                ],
              );
            else
              return ListTile(
                title: Text(row['npm']),
                subtitle: Text(row['nama']),
              );
          },
        ),
      ),
      // body: FutureBuilder<FirebaseApp>(
      //   future: Firebase.initializeApp(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       return const WidgetListBinatang();
      //     }
      //
      //     return const WidgetNotification(
      //         message: "Tidak dapat mengkoneksikan dengan firebase !!");
      //   },
      // )
    );
  }
}

// class WidgetListBinatang extends StatelessWidget {
//   const WidgetListBinatang({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     CollectionReference<Binatang> binatangs = FirebaseFirestore.instance
//         .collection("binatang")
//         .withConverter<Binatang>(
//         fromFirestore: (snapshots, _) => Binatang.fromJson2(snapshots.data()),
//             // Binatang.fromJson(snapshots.data()),
//         toFirestore: (binatang, _) => binatang.toJson());
//
//     return StreamBuilder<QuerySnapshot<Binatang>>(
//         stream: binatangs.snapshots(),
//         builder: (contextStream, snapshotStream) {
//           if (snapshotStream.connectionState == ConnectionState.active) {
//             return ListView(
//               children: List<Widget>.generate(
//                   snapshotStream.data!.size,
//                       (index) => ItemBinatang(
//                       binatang: snapshotStream.data!.docs[index].data())),
//             );
//           }
//
//           if (snapshotStream.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           return const WidgetNotification(
//               message: "Terdapat kesalahan dalam pengambilan data");
//         });
//   }
// }

// class ItemBinatang extends StatelessWidget {
//   final Binatang binatang;
//   const ItemBinatang({Key? key, required this.binatang}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),
//       decoration: const BoxDecoration(),
//       child: Row(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 this.binatang.nama,
//                 style: const TextStyle(
//                   color: Colors.black87,
//                   fontSize: 18,
//                   letterSpacing: 1.3,
//                 ),
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//               Text(
//                 this.binatang.habitat,
//                 style: const TextStyle(
//                   color: Colors.black45,
//                   fontSize: 11,
//                   letterSpacing: 0.3,
//                 ),
//               )
//             ],
//           ),
//           Expanded(
//               child: Container(
//                 alignment: Alignment.centerRight,
//                 child: Text(
//                   this.binatang.jumlah.toString(),
//                   style: const TextStyle(
//                     color: Colors.black87,
//                     fontSize: 18,
//                   ),
//                 ),
//               ))
//         ],
//       ),
//     );
//   }
// }

class WidgetNotification extends StatelessWidget {
  final String message;

  const WidgetNotification({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(this.message),
        ],
      ),
    );
  }
}