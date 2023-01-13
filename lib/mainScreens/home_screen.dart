import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobileshop_seller_app/model/product.dart';
import 'package:mobileshop_seller_app/splashScreen/splashscreen.dart';
import 'package:mobileshop_seller_app/uploadScreen/phone_upload_screen.dart';
import 'package:mobileshop_seller_app/widgets/info_design.dart';
import 'package:mobileshop_seller_app/widgets/my_drawer.dart';
import 'package:mobileshop_seller_app/widgets/progress_bar.dart';
import 'package:mobileshop_seller_app/widgets/text_widget.dart';

import '../authentication/auth_screen.dart';
import '../global/global.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  restrictBlockedSellerForUsingApp() async{
    await FirebaseFirestore.instance.collection("sellers")
        .doc(firebaseAuth.currentUser!.uid)
        .get().then((snapshot){
      if(snapshot.data()!["status"]!= "approved")
      {
        Fluttertoast.showToast(msg: "You have been blocked by admin");
        firebaseAuth.signOut();
        Navigator.push(context, MaterialPageRoute(builder: (c) => MySplashScreen()));
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restrictBlockedSellerForUsingApp();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
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
        title: Text(
          sharedPreferences!.getString("name")!,
          style: const TextStyle(
            fontFamily: "Lobster",
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,

        actions:  //used to display button icon on right side
        [
          IconButton(
            icon: Icon(Icons.post_add,
            color: Colors.teal,),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (c) => const PhoneUploadScreen()));
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true, delegate: TextWidgetHeader(title:"My Products") ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("sellers")
                .doc(sharedPreferences!.getString("uid"))
                .collection("products").orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot)
            {
              return !snapshot.hasData
                  ?SliverToBoxAdapter(
                child: Center(
                  child: circularProgressBar(),
                ),

              )
                  : SliverStaggeredGrid.countBuilder(
                crossAxisCount: 1,
                staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                itemBuilder: (context, index) {
                  Products model = Products.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                  );
                  return InfoDesignWidget(
                    model: model,
                    context: context,
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );

            },
          )
        ],
      ),
    );
  }
}
