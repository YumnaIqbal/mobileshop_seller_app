import 'package:flutter/material.dart';
import 'package:mobileshop_seller_app/authentication/login.dart';
import 'package:mobileshop_seller_app/authentication/register.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration:const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.teal,
                    Colors.white,

                  ],
                      begin:  FractionalOffset(0.0, 0.0),
                  end:  FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                )
              ),
            ),
            automaticallyImplyLeading: false, //for removing go back sign
            title: const Text("MobileShop",
        style: TextStyle(
          fontSize: 30,
          color: Colors.white,
          fontFamily:" Lobster",
        ),
          ),
            centerTitle: true,
            bottom: const TabBar(
                tabs: [
              Tab(
                icon: Icon(Icons.lock ,color: Colors.white,),
                text: "Login",

              ),
                  Tab(
                    icon: Icon(Icons.person ,color: Colors.white,),
                    text: "Register",

                  ),

            ],
              indicatorColor: Colors.white,
              indicatorWeight: 6,

            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                colors: [
                  Colors.teal,
                  Colors.white,
                ]
              )
            ),
            child: TabBarView(
              children: [
                LoginScreen(),
                RegisterScreen(),
              ],
            ),
          ),
        ));
  }
}
