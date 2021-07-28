import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_news.dart';

class AddNews extends StatefulWidget {
  static const routeName = '/aut';

  @override
  _AddNewsState createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  CollectionReference newsref = FirebaseFirestore.instance.collection('news');

  _delete(var a) {
    newsref.doc("$a").delete().then((value) {
      print('delete success');
    }).catchError((e) {
      print('Error: $e');
    });
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
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => AddNew()));
          }),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'News',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.grid_view),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: FutureBuilder(
            future: newsref.get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: 1 + snapshot.data.docs.length,
                    itemBuilder: (context, i) {
                      if (i == 0)
                        return Column(children: [
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  child: Image.asset(
                                    "assets/images/eng.png",
                                  ),
                                ),
                                Container(
                                  width: 70,
                                  height: 70,
                                  child: Image.asset(
                                    "assets/images/bme.png",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 2,
                          )
                        ]);
                      return ExpansionTile(
                        textColor: Colors.white,
                        tilePadding: EdgeInsets.all(0),
                        children: [
                          SizedBox(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${snapshot.data.docs[i - 1].data()['content']}',
                              softWrap: true,
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${snapshot.data.docs[i - 1].data()['date']}',
                                textAlign: TextAlign.start,
                              ),
                              IconButton(
                                onPressed: () {
                                  _delete(snapshot.data.docs[i - 1].id);
                                  FirebaseStorage.instance
                                      .refFromURL(
                                          '${snapshot.data.docs[i - 1].data()['imgurl']}')
                                      .delete();
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          )
                        ],
                        title: Container(
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                          ),
                          width: 150,
                          height: 150,
                          child: Image.network(
                            "${snapshot.data.docs[i - 1].data()['imgurl']}",
                            fit: BoxFit.contain,
                          ),
                        ),
                        subtitle: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0xff2a61a8), Color(0xff2d377a)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                          ),
                          child: Text(
                            '${snapshot.data.docs[i - 1].data()['title']}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    });
              }
              return Text('error');
            },
          ),
        ),
      ]),
    );
  }
}
