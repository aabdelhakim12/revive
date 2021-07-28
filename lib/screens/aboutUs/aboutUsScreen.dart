import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class AboutUsScreen extends StatefulWidget {
  static const routeName = '/about';

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
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
    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
    super.initState();
  }

  var style =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22);
  var decoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    gradient: LinearGradient(
        colors: [Color(0xff2a61a8), Color(0xff2d377a)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight),
  );

  Widget info(BuildContext context, title, name, pos) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      width: double.infinity,
      decoration: decoration,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.blue[900],
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
          Text(name, style: style, textAlign: TextAlign.center),
          Text(pos, style: style, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  ScrollController scrollController;
  bool dialVisible = true;

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      marginEnd: 20,
      marginBottom: 10,
      icon: Icons.link,
      activeIcon: Icons.link,
      buttonSize: 60.0,
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.white,
      overlayOpacity: 0.2,
      tooltip: 'websites',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.2),
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),
      orientation: SpeedDialOrientation.Up,
      gradientBoxShape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xff2a61a8), Color(0xff2d377a)],
      ),
      children: [
        SpeedDialChild(
          child: Image.asset('assets/images/bme.png', height: 50),
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.0),
          labelStyle: TextStyle(fontSize: 18.0, color: Colors.white),
          onTap: () => _launchURL('http://engpro.mans.edu.eg/bme/'),
        ),
        SpeedDialChild(
          child: Icon(
            Icons.facebook,
            color: Colors.white,
            size: 45,
          ),
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.0),
          labelStyle: TextStyle(fontSize: 18.0, color: Colors.white),
          onTap: () => _launchURL('http://www.facebook.com/ReviveTeamMu/'),
        ),
        SpeedDialChild(
          child: Image.asset('assets/images/youtube.png', height: 50),
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.0),
          labelStyle: TextStyle(fontSize: 18.0, color: Colors.white),
          onTap: () => _launchURL(
              'https://www.youtube.com/channel/UCKR8MtC7vRNK3Mo3vE-oC2A'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: buildSpeedDial(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff2a61a8), Color(0xff2d377a)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.grid_view),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 35,
            ),
            Text(
              ' About Us',
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
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width * 0.18,
                      height: size.width * 0.18,
                      child: Image.asset(
                        "assets/images/eng.png",
                      ),
                    ),
                    Container(
                      width: size.width * 0.2,
                      height: size.width * 0.2,
                      child: Image.asset(
                        "assets/images/revivelogo.png",
                        color: isdark ? Colors.white : null,
                      ),
                    ),
                    Container(
                      width: size.width * 0.18,
                      height: size.width * 0.18,
                      child: Image.asset(
                        "assets/images/bme.png",
                      ),
                    ),
                  ],
                ),
                Divider(),
                info(context, ' تحت رعاية  ', ' أ.د. محمد عبدالعظيم ',
                    'عميد كلية الهندسة-جامعة المنصورة'),
                info(context, 'تحت ريادة  ', ' أ.د. حسام الدين صلاح مصطفى ',
                    'مدير برنامج الهندسة الطبية والحيوية'),
                info(context, 'تحت إشراف', ' د. إيهاب هاني عبدالحي',
                    'منسق برنامج الهندسة الطبية والحيوية'),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: decoration,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text('فكرة',
                            style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                      ),
                      Text('هاجر محمد طاهر', style: style),
                      Text(' و محمود أمين عوض',
                          style: style, textAlign: TextAlign.center),
                      Text('Revive قائدا فريق',
                          style: style, textAlign: TextAlign.center),
                    ],
                  ),
                ),
                info(context, 'تصميم', 'يونس رأفت مصطفى',
                    'Revive مسئول لجنة التصميم بفريق'),
                info(context, 'تنفيذ ', 'أحمد عبدالحكيم محمد',
                    'Revive مسئول لجنة البرمجيات بفريق'),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> _launchURL(_url) async => await launch(_url);
}
