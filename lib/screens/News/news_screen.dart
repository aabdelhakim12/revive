import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsScreen extends StatefulWidget {
  static const routeName = '/news';
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

CollectionReference newsref = FirebaseFirestore.instance.collection('news');

class _NewsScreenState extends State<NewsScreen> {
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        title: Row(
          children: [
            Image.asset(
              'assets/images/news.png',
              height: 25,
              fit: BoxFit.contain,
            ),
            Text(
              '  BME News',
              style: TextStyle(color: Colors.white),
            ),
          ],
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
                                  width: 80,
                                  height: 80,
                                  child: Image.asset(
                                    "assets/images/revivelogo.png",
                                    color: isdark ? Colors.white : null,
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
                          Text(
                            '${snapshot.data.docs[i - 1].data()['content']}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${snapshot.data.docs[i - 1].data()['date']}',
                              textAlign: TextAlign.start,
                            ),
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
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
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
