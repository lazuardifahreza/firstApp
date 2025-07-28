import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firestore.dart';

class FormMahasiswa extends StatefulWidget {
  FormMahasiswa({Key? key}) : super(key : key);

  @override
  State<FormMahasiswa> createState() => _StateFormMahasiswa();
}

class _StateFormMahasiswa extends State<FormMahasiswa> {
  TextEditingController npm = TextEditingController();
  TextEditingController nama = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form')),
      body: Column(
        children: [
          TextField(
            controller: npm,
            decoration: InputDecoration(labelText: 'NPM'),
            maxLength: 10,
            inputFormatters: [
              FilteringTextInputFormatter(RegExp('[0-9]'), allow: true)
            ],
          ),
          TextField(
            controller: nama,
            decoration: InputDecoration(labelText: 'Nama'),
            maxLength: 50,
            inputFormatters: [
              FilteringTextInputFormatter(RegExp('[a-z A-Z]'), allow: true)
            ],
          ),
          ElevatedButton(onPressed: () {
            addMahasiswa(npm.value.text, nama.value.text);
          }, child: Text('Simpan'))
        ],
      ),
    );
  }
}