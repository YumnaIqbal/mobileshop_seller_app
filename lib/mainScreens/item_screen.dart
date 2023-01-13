import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mobileshop_seller_app/global/global.dart';
import 'package:mobileshop_seller_app/model/models.dart';
import 'package:mobileshop_seller_app/model/product.dart';
import 'package:mobileshop_seller_app/uploadScreen/item_upload_screen.dart';
import 'package:mobileshop_seller_app/uploadScreen/phone_upload_screen.dart';
import 'package:mobileshop_seller_app/widgets/info_design.dart';
import 'package:mobileshop_seller_app/widgets/model_design.dart';
import 'package:mobileshop_seller_app/widgets/my_drawer.dart';
import 'package:mobileshop_seller_app/widgets/progress_bar.dart';
import 'package:mobileshop_seller_app/widgets/text_widget.dart';

class ModelsScreen extends StatefulWidget {
  final Products? model;
  ModelsScreen({this.model});



  @override
  State<ModelsScreen> createState() => _ModelsScreenState();
}

class _ModelsScreenState extends State<ModelsScreen> {
  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.library_add,
              color: Colors.teal,),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (c) => ModelsUploadScreen(model: widget.model)));
            },
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true, delegate: TextWidgetHeader(title: "My "+widget.model!.productTitle.toString()+ "'s Models")),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("sellers")
                .doc(sharedPreferences?.getString("uid"))
                .collection("products").doc(widget.model?.productID)
                .collection("models").orderBy("publishedDate", descending: true)
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
                staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                itemBuilder: (context, index) {
                  Models model = Models.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                  );
                  return ModelsDesignWidget(
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
