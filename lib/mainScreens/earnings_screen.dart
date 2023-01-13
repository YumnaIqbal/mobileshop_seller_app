import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobileshop_seller_app/global/global.dart';
import 'package:mobileshop_seller_app/splashScreen/splashscreen.dart';


class EarningsScreen extends StatefulWidget
{
  const EarningsScreen({Key? key}) : super(key: key);

  @override
  _EarningsScreenState createState() => _EarningsScreenState();
}




class _EarningsScreenState extends State<EarningsScreen>
{
  double sellerTotalEarnings = 0;

  retrieveSellerEarnings() async
  {
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .get().then((snap)
    {
      setState(() {
        sellerTotalEarnings = double.parse(snap.data()!["earings"].toString());
      });
    });
  }

  @override
  void initState() {
    super.initState();

    retrieveSellerEarnings();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                "Rs " + sellerTotalEarnings!.toString(),
                style: const TextStyle(
                  fontSize: 80,
                  color: Colors.white,
                  fontFamily: "Signatra"
                ),
              ),

              const Text(
                "Total Earnings",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    letterSpacing: 3,
                    fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 20,
                width: 200,
                child: Divider(
                  color: Colors.white,
                  thickness: 1.5,
                ),
              ),

              const SizedBox(height: 40.0,),

             ElevatedButton(
               child: Text(
                 "Go back",
                 style: TextStyle(
                   fontSize: 12,
                   fontWeight: FontWeight.bold,
                   color: Colors.white
                 ),
               ),

               onPressed:() {
                 Navigator.push(context, MaterialPageRoute(builder: (c) => MySplashScreen()));
               }


             ),
            ],
          ),
        ),
      ),
    );
  }
}
