import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobileshop_seller_app/global/global.dart';
import 'package:mobileshop_seller_app/mainScreens/home_screen.dart';
import 'package:mobileshop_seller_app/model/product.dart';
import 'package:mobileshop_seller_app/widgets/error_dialoag.dart';
import 'package:mobileshop_seller_app/widgets/progress_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;

class ModelsUploadScreen extends StatefulWidget {
  final Products? model;
  ModelsUploadScreen({this.model});


  @override
  State<ModelsUploadScreen> createState() => _ModelsUploadScreenState();
}

class _ModelsUploadScreenState extends State<ModelsUploadScreen>
{
  XFile? imageXFile; //instance for image from camera
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  defaultScreen(){
    return Scaffold(
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
        title: const Text(
          "Add New Models",
          style: TextStyle(
            fontFamily: "Lobster",
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white70,

          ),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
          },
        ),
      ),
      body: Container(
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
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shop_2_sharp,
                color: Colors.black12,
                size: 150,
              ),
              ElevatedButton(
                child: const Text("Add New Model",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontFamily: "Lobster",
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )
                  ),
                ),
                onPressed: (){
                  takeImage(context);
                },
              ),
            ],
          ),
        ) ,
      ),
    );
  }

  takeImage(mContext)  //passing parameter function to pick image from gsllery or capture image from Camera

  {
    return showDialog(
        context: mContext,
        builder: (context)
        {
          return  SimpleDialog(
            title: const Text("Model Image",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.teal,

              ),),
            children: [
              SimpleDialogOption(
                child: const Text("Capture with Camera",
                  style: TextStyle(
                    color: Colors.grey,
                  ),),
                onPressed: captureImageWithCamera,
              ),
              SimpleDialogOption(
                child: const Text("Select From gallery",
                  style: TextStyle(
                    color: Colors.grey,
                  ),),
                onPressed: pickImageFromGallery,
              ),
              SimpleDialogOption(
                child: const Text("Cancel",
                  style: TextStyle(
                    color: Colors.red,
                  ),),
                onPressed: () => Navigator.pop(context),
              ),

            ],
          );
        }
    );
  }
  captureImageWithCamera() async
  {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(source: ImageSource.camera,   //allow seller to capture image from camera
      maxHeight: 720,
      maxWidth: 1280,
    );
    setState(() {
      imageXFile;  //assign image to this instance
    });


  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(source: ImageSource.gallery,   //allow seller to capture image from camera
      maxHeight: 720,
      maxWidth: 1280,
    );
    setState(() {
      imageXFile;  //assign image to this instance
    });

  }
  modelUploadFormScreen(){
    return Scaffold(
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
        title: const Text(
          "Uploading New Products",
          style: TextStyle(
            fontFamily: "Lobster",
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white70,

          ),
          onPressed: (){
            clearProductUploadForm();
          },
        ),
        actions: [
          TextButton(
            child: const Text("Add",
              style: TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontFamily: "Lobster",
                letterSpacing: 3,
              ),),
            onPressed: uploading ? null : ()=> validateUploadForm(),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading == true ? linearProgress(): Text("nothing"),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                          File(imageXFile!.path)
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.teal,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(Icons.perm_device_info,
              color: Colors.blueAccent,
            ),
            title: Container(
              width: 150,
              child:  TextField(
                style: const TextStyle(
                  color: Colors.black,
                ),
                controller: shortInfoController,
                decoration: const InputDecoration(
                  helperText: "info",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),

            ),

          ),
          const Divider(
            color: Colors.teal,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(Icons.title,
              color: Colors.blueAccent,
            ),
            title: Container(
              width: 150,
              child:  TextField(
                style: const TextStyle(
                  color: Colors.black,
                ),
                controller: titleController,
                decoration: const InputDecoration(
                  helperText: "title",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),

            ),

          ),
          const Divider(
            color: Colors.teal,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(Icons.description,
              color: Colors.blueAccent,
            ),
            title: Container(
              width: 150,
              child:  TextField(
                style: const TextStyle(
                  color: Colors.black,
                ),
                controller: descriptionController,
                decoration: const InputDecoration(
                  helperText: "description",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),

            ),

          ),
          const Divider(
            color: Colors.teal,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on_rounded,
              color: Colors.blueAccent,
            ),
            title: Container(
              width: 150,
              child:  TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: Colors.black,
                ),
                controller: priceController,
                decoration: const InputDecoration(
                  helperText: "Price",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),

            ),

          ),


        ],
      ),

    );
  }
  clearProductUploadForm(){
    setState(() {
      shortInfoController.clear();
      titleController.clear();
      priceController.clear();
      descriptionController.clear();
      imageXFile = null;
    });
  }
  validateUploadForm() async {

    if(imageXFile != null)
    {
      if(shortInfoController.text.isNotEmpty && titleController.text.isNotEmpty && descriptionController.text.isNotEmpty && priceController.text.isNotEmpty)
      {
        setState(() {
          uploading = true;
        });
        //upload image
        String downloadUrl = await uploadImage(File(imageXFile!.path));   //return download Url

        //save info to firebase

        saveInfo(downloadUrl);

      }
      else{
        showDialog(context: context,
            builder: (c)
            {
              return ErrorDialog(
                message: "Please write title and info for product.",
              );
            });
      }

    }
    else
    { showDialog(context: context,
        builder: (c)
        {
          return ErrorDialog(
            message: "Please pick Image for Product.",
          );
        });

    }

  }

  saveInfo(String downloadUrl)
  {
    final ref = FirebaseFirestore.instance.collection("sellers").doc(sharedPreferences!.getString("uid"))
        .collection("products").doc(widget.model!.productID).collection("models");

    ref.doc(uniqueIdName).set({
      "modelID": uniqueIdName,
      "productID" : widget.model!.productID,
      "sellerID" : sharedPreferences!.getString("uid"),
      "sellerName" : sharedPreferences!.getString("name"),
      "shortInfo": shortInfoController.text.toString(),
      "longDescription": descriptionController.text.toString(),
      "price": int.parse(priceController.text),
      "tilte": titleController.text.toString(),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,

    }).then((value){
      final modelsRef = FirebaseFirestore.instance
          .collection("models");
      modelsRef.doc(uniqueIdName).set({
        "modelID": uniqueIdName,
        "productID" : widget.model!.productID,
        "sellerID" : sharedPreferences!.getString("uid"),
        "sellerName" : sharedPreferences!.getString("name"),
        "shortInfo": shortInfoController.text.toString(),
        "longDescription": descriptionController.text.toString(),
        "price": int.parse(priceController.text),
        "tilte": titleController.text.toString(),
        "publishedDate": DateTime.now(),
        "status": "available",
        "thumbnailUrl": downloadUrl,

      });
    }).then((value) {clearProductUploadForm();
    setState(() {
      uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
      uploading = false;
    });
    });

  }
  uploadImage(mImageFile) async   //passing parameter to recive image
      {
    storageRef.Reference reference = storageRef.FirebaseStorage
        .instance.ref()   //making refernece in the firebase Storage
        .child("models"); //name of folder

    storageRef.UploadTask uploadTask = reference.child(uniqueIdName +"jpg").putFile(mImageFile);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;

  }

  @override
  Widget build(BuildContext context) {
    return imageXFile== null ? defaultScreen() : modelUploadFormScreen();
  }
}
