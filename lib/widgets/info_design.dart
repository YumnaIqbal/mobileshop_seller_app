import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobileshop_seller_app/global/global.dart';
import 'package:mobileshop_seller_app/mainScreens/item_screen.dart';
import 'package:mobileshop_seller_app/model/product.dart';




class InfoDesignWidget extends StatefulWidget
{
  Products? model;
  BuildContext? context;

  InfoDesignWidget({this.model, this.context});

  @override
  _InfoDesignWidgetState createState() => _InfoDesignWidgetState();
}



class _InfoDesignWidgetState extends State<InfoDesignWidget> {
  deleteProduct(String productID){
    FirebaseFirestore.instance.collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("products").doc(productID).delete();

    Fluttertoast.showToast(msg: "product deleted Successfully");
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (c) => ModelsScreen(model: widget.model)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 310,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              Image.network(
                  widget.model!.thumbnailUrl!,
                  height: 220.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 1.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.model!.productTitle!,
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 20,
                      fontFamily: "Train",
                    ),
                  ),
                  IconButton(onPressed: (){
                    deleteProduct(widget.model!.productID!);

                  },
                      icon: Icon(
                        Icons.delete_sweep,
                        color: Colors.teal,
                      ))
                ],
              ),
              Text(
                widget.model!.productInfo!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
