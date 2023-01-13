import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobileshop_seller_app/authentication/auth_screen.dart';

import '../global/global.dart';
import '../mainScreens/home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen>
{
  stratTimer()
  {

    Timer(const Duration(seconds: 5), () async{
      // if the seller is already sign up
      if(firebaseAuth.currentUser != null)
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
      }
      else{
        // if the user is not sign up
        Navigator.push(context, MaterialPageRoute(builder: (c)=> AuthScreen()));
      }


    });
  }


  @override //this fuction runs automatically when user come to the slpashscreen
  void initState(){
    super.initState();
    stratTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset("images/splash.jpg"),
            ),
           const SizedBox(height: 15,),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Selling Mobile Online",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 35,
                  fontFamily: "Signatra",
                  letterSpacing: 3,

                ),
                  ),
            )
          ],
        ),
      ),
    );
  }
}
