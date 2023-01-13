import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobileshop_seller_app/global/global.dart';
import 'package:mobileshop_seller_app/model/models.dart';
import 'package:mobileshop_seller_app/splashScreen/splashscreen.dart';
import 'package:mobileshop_seller_app/widgets/simple_app_bar.dart';


class ModelDetailScreen extends StatefulWidget {
  final Models? model;
  ModelDetailScreen({this.model});

  @override
  State<ModelDetailScreen> createState() => _ModelDetailScreenState();
}

class _ModelDetailScreenState extends State<ModelDetailScreen> {

  TextEditingController counterTextEditingController = TextEditingController();
   deleteProduct(String modelID){
     FirebaseFirestore.instance
         .collection("sellers")
         .doc(sharedPreferences!.getString("uid"))
         .collection("products").doc(widget.model!.productID!)
         .collection("models").doc(modelID).delete().then((value) {
           FirebaseFirestore.instance.collection("models").doc(modelID).delete();
           
           Navigator.push(context, MaterialPageRoute(builder: (c) =>const MySplashScreen()));
           Fluttertoast.showToast(msg: "prodcut deleted Successfully");

     });
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: SimpleAppBar(title: sharedPreferences!.getString("name"),),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.model!.thumbnailUrl.toString()),



            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.title.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.longDescription.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 10),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.price.toString() + " Rs",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),

            const SizedBox(height: 10,),

            Center(
              child: InkWell(
                onTap: ()
                {
                  //delete product
                  deleteProduct(widget.model!.productID!);

                },
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.cyan,
                          Colors.amber,
                        ],
                        begin:  FractionalOffset(0.0, 0.0),
                        end:  FractionalOffset(1.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      )
                  ),
                  width: MediaQuery.of(context).size.width - 13,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Delete this Product",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
