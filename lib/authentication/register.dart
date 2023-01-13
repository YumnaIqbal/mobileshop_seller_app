import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobileshop_seller_app/mainScreens/home_screen.dart';
import 'package:mobileshop_seller_app/widgets/custom_text_feild.dart';
import 'package:mobileshop_seller_app/widgets/error_dialoag.dart';
import 'package:firebase_storage/firebase_storage.dart'as fStroage;
import 'package:mobileshop_seller_app/widgets/loading_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global/global.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey= GlobalKey<FormState>(); //making instane for form
  TextEditingController nameController= TextEditingController();
  TextEditingController passwordController= TextEditingController();
  TextEditingController emailController= TextEditingController();
  TextEditingController confirmPasswordController= TextEditingController();
  TextEditingController phoneController= TextEditingController();
  TextEditingController locationController= TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker= ImagePicker(); //instane for imge

  Position? position;
  List<Placemark>? placeMarks;
  String sellerImageUrl = "";
  String completeAddress= "";


  Future<void> _getImage() async {
    //function allow seller to pic image from the gellery
    imageXFile = await _picker.pickImage(
        source: ImageSource.gallery); //assign image to the imageXFile
    setState(() {
      imageXFile;
    });
  }

    getCurrentLocation() async //function to get location
        {
      Position newPostion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,

      );
      position = newPostion; //asign position
      placeMarks = await placemarkFromCoordinates(
        position!.latitude,
        position!.longitude,
      );

      Placemark pMark = placeMarks![0]; //to get the exact postion on 0 index

      completeAddress = '${pMark.subThoroughfare}  ${pMark
          .thoroughfare} , ${pMark.subLocality} ${pMark.locality}, ${pMark
          .subAdministrativeArea}, ${pMark.administrativeArea} ${pMark
          .postalCode}, ${pMark.country}';


      locationController.text =
          completeAddress; //assign the location to the locationController


    }
    Future<void> formValidation() async
    {
      if (imageXFile == null) {
        showDialog(context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Please select a image",

              );
            }
        );
      }
      else {
        if (passwordController.text == confirmPasswordController.text) {

          if(confirmPasswordController.text.isNotEmpty && emailController.text.isNotEmpty && nameController.text.isNotEmpty && phoneController.text.isNotEmpty && locationController.text.isNotEmpty)
          {
            //start uploading the image or store data to firestore database
            // showDialog(
            //     context: context,
            //     builder: (c)
            //     {
            //       return LoadingDialog(
            //         message: "Registering Account",
            //       );
            //
            //     }
            // );
            String fileName =DateTime.now().millisecondsSinceEpoch.toString();
            fStroage.Reference reference= fStroage.FirebaseStorage.instance.ref().child("Sellers").child(fileName); //reference for image storage
            fStroage.UploadTask uploadTask= reference.putFile(File(imageXFile!.path));
            fStroage.TaskSnapshot taskSnapshot= await uploadTask.whenComplete(() {});
            await taskSnapshot.ref.getDownloadURL().then((url)   //url used to access image
            {
              sellerImageUrl= url;

              //save info to firestore
              authenticateSellerAndSignUp();


            } );

          }
          else{
            showDialog(context: context,
                builder: (c){
                  return ErrorDialog(
                    message: "Please write the complete required info for registration",
                  );
                });
          }

        }
        else
          {
            showDialog(context: context,
                builder: (c){
              return ErrorDialog(
                message: "Password do not match",
              );
                });
          }




        }
      }

      void authenticateSellerAndSignUp() async
      {
        User? currentUser;

        await firebaseAuth.createUserWithEmailAndPassword( //create user with email and password inside firebase auhentication
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
        ).then((auth) {
          currentUser = auth.user; //assign current user to auth

        }).catchError((error){
          Navigator.pop(context);
          showDialog(context: context,
              builder: (c)
          {
            return ErrorDialog(
              message: error.message.toString(), // recieving firebase authentication display error msg automatically like email is in use etc
            );
          });

        });
        if(currentUser != null)
          {

            saveDataToFirestore(currentUser!).then((value) {
              Navigator.pop(context);


              //send user to home page
              Route newRoute = MaterialPageRoute(builder:(c) => HomeScreen());
              Navigator.pushReplacement(context, newRoute);

            });
          }

      }

      // function to save data firestore
  Future saveDataToFirestore(User currentUser) async
  {
    FirebaseFirestore.instance.collection("sellers").doc(currentUser.uid).set({
      "sellerUID": currentUser.uid,
      "sellerEmail": currentUser.email,
      "sellerName": nameController.text.trim(),
      "sellerAvatarUrl": sellerImageUrl,
      "phone": phoneController.text.trim(),
      "address": completeAddress,
      "status": "approved",
      "earings": 0.0,
      "lat": position?.latitude,
      "lng": position?.longitude,

    });
    //save data locally
    //to access the more important data easily
    sharedPreferences = await SharedPreferences.getInstance(); //instance for shared preferences
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("photoUrl", sellerImageUrl);

  }
  

      @override
      Widget build(BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            child: Column(

              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 12,),

                InkWell(
                  onTap: () {
                    _getImage();
                  },

                  child: CircleAvatar(
                    radius: MediaQuery
                        .of(context)
                        .size
                        .width * 0.20,
                    //take the width of 205 of total screen
                    backgroundColor: Colors.white,
                    backgroundImage: imageXFile == null ? null : FileImage(
                        File(imageXFile!.path)),
                    //imagwXfile is a instance whenever a seller selct image from gallery or camera it will assign to it
                    // if this imageXFILE IS NULL THEN IT ASSIGN NULL
                    //else display the original image that the seller is selected
                    child: imageXFile == null
                        ? //if image is null display icon
                    Icon(
                      Icons.add_photo_alternate,
                      size: MediaQuery
                          .of(context)
                          .size
                          .width * 0.20,
                      color: Colors.grey,
                    ) : null,
                  ),
                ),
                const SizedBox(height: 10,),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        data: Icons.person,
                        controller: nameController,
                        hintText: "Name",
                        isObsecre: false,
                      ),
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
                      CustomTextField(
                        data: Icons.lock,
                        controller: confirmPasswordController,
                        hintText: "Confirm Password",
                        isObsecre: true,
                      ),
                      CustomTextField(
                        data: Icons.phone,
                        controller: phoneController,
                        hintText: "Phone",
                        isObsecre: false,
                      ),
                      CustomTextField(
                        data: Icons.my_location,
                        controller: locationController,
                        hintText: "Shop Address",
                        isObsecre: false,
                        enabled: true,
                      ),

                      Container(
                        width: 400,
                        height: 40,
                        alignment: Alignment.center,
                        child: ElevatedButton.icon(
                          label: const Text(
                            "Get my Current Location",
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            try{
                              LocationPermission permission;
                              permission = await Geolocator.checkPermission();
                              if (permission == LocationPermission.denied) {
                                permission = await Geolocator.requestPermission();
                                if (permission ==
                                    LocationPermission.deniedForever) {
                                  return Future.error('Location Not Available');
                                }
                                return await getCurrentLocation();
                              }
                            }catch(e){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString()))
                              );
                            }throw Exception(
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('error'))
                                ),
                            );
                          },


                          style: ElevatedButton.styleFrom(
                            primary: Colors.amber,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30,),
                ElevatedButton(
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold,),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.cyan,
                      padding: EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                    ),
                    onPressed: () {
                      formValidation();

                    }
                ),
                const SizedBox(height: 30,),
              ],
            ),
          ),
        );
      }
    }
