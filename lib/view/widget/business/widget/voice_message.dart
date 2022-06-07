
import 'dart:math';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';



class voice_message extends StatefulWidget {

  voice_message({Key key, this.Room_Data, this.myUID, this.isDarkMode,this.isreceiver})
      : super(key: key);
  final Map<String, dynamic> Room_Data;
  final String myUID;
  final bool isDarkMode;
  final bool isreceiver;


  @override
  _voice_messageState createState() => _voice_messageState();
}

class _voice_messageState extends State<voice_message> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isplay=false;
  Random random = new Random();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    audioPlayer.setUrl(widget.Room_Data['message']);
    return Container(
      child: Align(
          alignment: Alignment.centerRight,
        child: Stack(
             children: [
               Row(
                 children: [
                   Container(
                     child: IconButton(onPressed: (){
                       if(isplay){
                         audioPlayer.pause();
                         setState(() {
                           isplay=false;
                         });
                       }else{
                         audioPlayer.play(widget.Room_Data['message']);
                         setState(() {
                           isplay=true;
                         });
                       }
                       audioPlayer.onPlayerCompletion.listen((event) {
                         setState(() {
                           isplay=false;
                         });

                       });

                     }, icon:isplay==false? Icon(Icons.play_arrow,color:widget.isreceiver==true? Theme.of(context).iconTheme.color:Colors.white,): Icon(Icons.pause,color:widget.isreceiver==true? Theme.of(context).iconTheme.color:Colors.white ,)),
                   ),

                   for(var i =0; i<=40; i++)...[
                     Container(height:random.nextInt(5).toDouble() ,width: 2,color:widget.isreceiver==true? Theme.of(context).iconTheme.color:Colors.white,margin: EdgeInsets.only(right: 1.5),),
                   ],


                SizedBox(width: 5.w,),
                   StreamBuilder<Duration>(
                       stream: audioPlayer.onDurationChanged,
                       builder: (context,AsyncSnapshot<Duration> snapshot) {
                         if(snapshot.hasData){
                           var data=snapshot.data;
                           return Text("${data.inMinutes}:${data.inSeconds.toString()}",style: TextStyle(color: widget.isreceiver==true? Theme.of(context).iconTheme.color:Colors.white),);
                         }
                         return CupertinoActivityIndicator(color: Theme.of(context).iconTheme.color,);

                       }
                   ),


                 ],
               ),
             ],
           ),



      ),
    );
  }
}
