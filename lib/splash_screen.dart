import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'grocerry_kit/SignIn.dart';
import 'grocerry_kit/store_package/stores_list_screen.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _url ='';
  // Splash Screen Time
  @override
  void initState() {
    Timer(const Duration(milliseconds: 4000), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return SignInPage();
      }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Firestore.instance.collection('splashImage').document('splashImage').get().then((value){
      _url = value.data['url'];
    });
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: CachedNetworkImage(
          imageUrl: _url,
          placeholder: (context, url) => const CircleAvatar(
            backgroundColor: Colors.amber,
            radius: 125,
          ),
          imageBuilder: (context, image) => CircleAvatar(
            backgroundImage: image,
            radius: 125,
          ),
        ),
      ),
    );
  }
}
