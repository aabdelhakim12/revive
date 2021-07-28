import 'dart:io';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addnewsScreen.dart';

class AddNew extends StatefulWidget {
  @override
  _AddNewState createState() => _AddNewState();
}

class _AddNewState extends State<AddNew> {
  final _formKey = GlobalKey<FormState>();
  CollectionReference newsref = FirebaseFirestore.instance.collection('news');

  String _title;
  String _content;
  DateTime _date = DateTime.now();
  String _imageurl;
  TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormater = DateFormat('EEE,d MMM yyyy');
  File file;
  var imagepicker = ImagePicker();

  _handleDatePicker() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormater.format(date);
    }
  }

  showloading(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('loading ....'),
            content: Container(
              height: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        });
  }

  _submit() async {
    if (_formKey.currentState.validate()) {
      if (file == null)
        return AwesomeDialog(
            context: context,
            title: 'Error',
            body: Container(
                padding: EdgeInsets.all(10),
                child: Text('please choose image')),
            dialogType: DialogType.ERROR)
          ..show();
      _formKey.currentState.save();
      showloading(context);
      print('$_title, $_content , $_date');
      var rand = Random().nextInt(1000000000);
      var refimg = FirebaseStorage.instance.ref('newsimges/$_title$rand');
      await refimg.putFile(file);
      _imageurl = await refimg.getDownloadURL();
      newsref.add({
        'title': _title,
        'content': _content,
        'date': _dateFormater.format(_date),
        'imgurl': _imageurl,
      });
      Navigator.of(context).pop();
      Navigator.pop(context, MaterialPageRoute(builder: (_) => AddNews()));
    }
  }

  bool isdark;

  getPref() async {
    if (isdark == null) isdark = false;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      isdark = preferences.getBool('isDark');
      if (preferences.getBool('isDark') == null) isdark = false;
    });
  }

  @override
  void initState() {
    _dateController.text = _dateFormater.format(_date);
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Add new news'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff2a61a8), Color(0xff2d377a)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
        ),
      ),
      body: Stack(children: [
        Container(
          height: size.height,
          width: double.infinity,
          child: Image.asset(
            isdark ? 'assets/images/BackB.jpg' : 'assets/images/BackWh.jpg',
            fit: BoxFit.cover,
          ),
        ),
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: 'title',
                      labelStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onTap: () => FocusScope.of(context).unfocus(),
                    validator: (input) =>
                        input.trim().isEmpty ? 'please enter a title' : null,
                    onSaved: (input) => _title = input,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLines: 7,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: 'content',
                      labelStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onTap: () => FocusScope.of(context).unfocus(),
                    validator: (input) =>
                        input.trim().isEmpty ? 'please enter a content' : null,
                    onSaved: (input) => _content = input,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: TextFormField(
                      readOnly: true,
                      controller: _dateController,
                      style: TextStyle(fontSize: 18),
                      onTap: _handleDatePicker,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        labelStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: BorderRadius.circular(30)),
                    child: TextButton(
                      child: Text(
                        '  Add Image  ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      onPressed: () => showBottomSheet(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: BorderRadius.circular(30)),
                    child: TextButton(
                      child: Text(
                        '  Add  ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      onPressed: () => _submit(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  showBottomSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (content) {
          return Container(
            height: 190,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Image',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () async {
                    var picked = await ImagePicker()
                        .getImage(source: ImageSource.gallery);
                    if (picked != null) {
                      file = File(picked.path);
                    }
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Icon(Icons.photo_outlined),
                        Text('  From Gallery'),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 2,
                  thickness: 2,
                ),
                InkWell(
                  onTap: () async {
                    var picked = await ImagePicker()
                        .getImage(source: ImageSource.camera);
                    if (picked != null) {
                      file = File(picked.path);
                    }
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt_outlined),
                        Text('  From Camera'),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
