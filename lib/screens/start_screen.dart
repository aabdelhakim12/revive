import 'dart:async';
import 'package:flutter/material.dart';
import 'package:revive/api/notification_api.dart';
import 'package:revive/screens/todo%20list/todolist.dart';
import 'package:revive/widgets/drawer.dart';
import 'package:video_player/video_player.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    NotificationApi.init(initScheduled: true);
    listenNotifications();
    Timer(Duration(seconds: 8), () {
      setState(() {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => DrawerS()));
      });
    });
    _controller = VideoPlayerController.asset('assets/images/gh.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setVolume(0);
        setState(() {});
      });
  }

  void listenNotifications() {
    NotificationApi.onNotifications.stream.listen(onclickedNotification);
  }

  void onclickedNotification(String plyload) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => ToDoList()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: [
            video(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget video() {
    var size = _controller.value.size;
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}
