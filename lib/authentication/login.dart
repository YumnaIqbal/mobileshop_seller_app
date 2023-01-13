import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobileshop_seller_app/authentication/auth_screen.dart';
import 'package:mobileshop_seller_app/mainScreens/home_screen.dart';
import 'package:mobileshop_seller_app/widgets/custom_text_feild.dart';
import 'package:mobileshop_seller_app/widgets/error_dialoag.dart';
import 'package:mobileshop_seller_app/widgets/loading_dialog.dart';

import '../global/global.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey= GlobalKey<FormState>();
  TextEditingController passwordController= TextEditingController();
  TextEditingController emailController= TextEditingController();

  formValidation(){
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty)
    {
      //login
      loginNow();

    }
    else{
      showDialog(context: context,
          builder: (c)
      {
        return ErrorDialog(
          message: "Please enter Email/Password",
        );
      });
    }
  }


  loginNow() async {
    showDialog(context: context,
        builder: (c)
    {
      return LoadingDialog(
        message: "Checking Authoriation",
      );
    });

    User? currentUser;

    await firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
    password: passwordController.text.trim(),
    ).then((auth) {
      currentUser= auth.user!;

    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c)
          {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });

    if(currentUser != null){
      readDataAndSetDataLocally(currentUser!);

    }

  }

  Future readDataAndSetDataLocally(User currentUser) async
  {
    await FirebaseFirestore.instance.collection("sellers") //reteriving or receving the data from forestore using the snapshot
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
          if(snapshot.exists)
          {
            if(snapshot.data()!["status"]=="approved"){
              await sharedPreferences!.setString("uid", currentUser.uid);
              await sharedPreferences!.setString("email", snapshot.data()!["sellerEmail"]);
              await sharedPreferences!.setString("name", snapshot.data()!["sellerName"]);
              await sharedPreferences!.setString("photoUrl", snapshot.data()!["sellerAvatarUrl"]);

              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
            }
            else{
              firebaseAuth.signOut();

              Navigator.pop(context);
              Fluttertoast.showToast(msg: "Admin has blocked your account. \n\n connect here: admin1@gmail.com");

            }

          }
          else{
            firebaseAuth.signOut();

            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (c) => const AuthScreen()));

            showDialog(
                context: context,
                builder: (c)
                {
                  return ErrorDialog(
                    message:"No record Exist",
                  );
                });
          }

    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Image.asset(
                "images/seller.jpg",
                height: 270,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.email,
                  controller: emailController,
                  hintText: "Email",
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: "Password",
                  isObsecre: true,
                ),
              ],
            ),
          ),
          ElevatedButton(
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.cyan,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            ),
            onPressed: (){
              formValidation();
            },


          ),
          const SizedBox(height: 30,),
        ],
      ),
    );
  }
}
