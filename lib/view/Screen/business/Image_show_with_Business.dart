import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

class Business_image_show extends StatefulWidget {
  static const String routeName = '/business_image_show';

  const Business_image_show({Key key, this.imageUrl}) : super(key: key);

  static Route route({String imageurl}) {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => Business_image_show(imageUrl: imageurl,));
  }
 final String imageUrl;

  @override
  _Business_image_showState createState() => _Business_image_showState();
}

class _Business_image_showState extends State<Business_image_show> {
   Dio dio=Dio();
  @override
  Widget build(BuildContext context) {
    Future<String> getFilePath({String filename})async{
      final dir=await getApplicationDocumentsDirectory();
      return"${dir.path}/$filename";
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(child:Icon(Icons.download) ,onPressed: ()async{
        const String fileName='chatting.jpg';
        String path=await getFilePath(filename: fileName);

        await dio.download(widget.imageUrl, path).then((value){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Download Done"),
          ));
        });
      },),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Theme.of(context).iconTheme.color,
        ),

      ),
      body: Container(
        width: 100.w,
        height: 100.h,

        child: Image.network(widget.imageUrl, loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).iconTheme.color,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes
                  : null,
            ),
          );
        },),
      ),
    );
  }
}
