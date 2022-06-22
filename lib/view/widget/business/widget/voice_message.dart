import 'dart:io';
import 'dart:math';
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:sizer/sizer.dart';
import 'package:wave_progress_bars/wave_progress_bars.dart';

class voice_message extends StatefulWidget {
  voice_message(
      {Key key, this.Room_Data, this.myUID, this.isDarkMode, this.isreceiver})
      : super(key: key);
  final Map<String, dynamic> Room_Data;
  final String myUID;
  final bool isDarkMode;
  final bool isreceiver;

  @override
  _voice_messageState createState() => _voice_messageState();
}

class _voice_messageState extends State<voice_message> {
  AudioPlayer audioPlayer;
  bool isplay = false;

  Duration duration = Duration.zero;
  Duration positions = Duration.zero;

  @override
  void initState() {
    audioPlayer = AudioPlayer();

    Get_audio_data();

    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event != null ? event : Duration.zero;
      });
    });

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isplay = state == PlayerState.PLAYING;
        print(isplay);
      });
    });

    audioPlayer.onAudioPositionChanged.listen((position) {
      setState(() {
        positions = position;
      });
    });
    super.initState();
  }

  void Get_audio_data() async {
    final file =
        await DefaultCacheManager().downloadFile(widget.Room_Data['message']);

    if (file.file.path != null) {
      setState(() {
        audioPlayer.setUrl(file.file.path, isLocal: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.centerRight,
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  height: 10.w,
                  width: 10.w,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: IconButton(
                      onPressed: () {
                        if (isplay) {
                          audioPlayer.pause();
                        } else {
                          audioPlayer.play(widget.Room_Data['message']);
                        }
                        audioPlayer.onPlayerCompletion.listen((event) {
                          setState(() {
                            isplay = false;
                          });
                        });
                      },
                      icon: isplay == false
                          ? Icon(
                              Icons.play_arrow,
                              color: widget.isreceiver == true
                                  ? Theme.of(context).iconTheme.color
                                  : Colors.black,
                            )
                          : Icon(
                              Icons.pause,
                              color: widget.isreceiver == true
                                  ? Theme.of(context).iconTheme.color
                                  : Colors.black,
                            )),
                ),
                Slider(
                  divisions: 1,
                  thumbColor: Colors.grey,
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey.shade300,
                  value: positions.inSeconds.toDouble(),
                  min: 0,
                  max: duration.inSeconds.toDouble(),
                  onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await audioPlayer.seek(position);
                    await audioPlayer.resume();
                  },
                ),
                SizedBox(
                  width: 5.w,
                ),
                isplay
                    ? Text(
                        formateTime(duration - positions),
                        style: TextStyle(color: Colors.white),
                      )
                    : Text(
                        formateTime(duration),
                        style: TextStyle(color: Colors.white),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formateTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minute = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [if (duration.inHours > 0) hours, minute, seconds].join(':');
  }
}
