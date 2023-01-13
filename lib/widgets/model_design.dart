import 'package:flutter/material.dart';
import 'package:mobileshop_seller_app/mainScreens/item_screen.dart';
import 'package:mobileshop_seller_app/mainScreens/model_detail_screen.dart';
import 'package:mobileshop_seller_app/model/models.dart';
import 'package:mobileshop_seller_app/model/product.dart';




class ModelsDesignWidget extends StatefulWidget
{
  Models? model;
  BuildContext? context;

  ModelsDesignWidget({this.model, this.context});

  @override
  _ModelsDesignWidgetState createState() => _ModelsDesignWidgetState();
}



class _ModelsDesignWidgetState extends State<ModelsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (c) => ModelDetailScreen(model: widget.model,)));

      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 280,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              Text(
                '${widget.model!.title}',
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                  fontFamily: "Train",
                ),
              ),
              Image.network(
                '${widget.model!.thumbnailUrl}',
                height: 220.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 1.0,),

              Text(
                '${widget.model!.shortInfo}',
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
