import 'package:flutter/material.dart';

class TextWidgetHeader extends SliverPersistentHeaderDelegate {

  String? title;
  TextWidgetHeader({
    this.title});


  @override
  Widget build(BuildContext context, double shrinkOffset, bool overLapsContent,) {
    return InkWell(
      child: Container(
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
        height: 80.0,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: InkWell(
          child: Text(
            title!,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontFamily: "Signatra",
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,

            ),),
        ),
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 50;

  @override
  // TODO: implement minExtent
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;

}
