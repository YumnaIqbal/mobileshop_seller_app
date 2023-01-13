import 'package:flutter/material.dart';
import 'package:mobileshop_seller_app/widgets/progress_bar.dart';

class LoadingDialog extends StatelessWidget
{
  final String? message; //parameter

  LoadingDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
         circularProgressBar(),
          SizedBox(height: 10,),
          Text(message! + ", Please wait..."), //+ concaretetion add message and please wait text
          //message from the register.dart
        ],
      ),
    );
  }
}
