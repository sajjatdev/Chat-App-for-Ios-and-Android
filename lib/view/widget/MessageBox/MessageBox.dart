import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chatting/logic/Business_profile/business_profile_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:popover/popover.dart';
import 'package:sizer/sizer.dart';

class MessageBox extends StatefulWidget {
  const MessageBox({Key key}) : super(key: key);

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  Duration duration = Duration();
  RecorderController recorderController;
  final ImagePicker _picker = ImagePicker();
  bool recorder = false;
  Timer timer;
  bool showFileSection = false;

  @override
  void initState() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
    super.initState();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      final addSeconds = 1;

      setState(() {
        final seconds = duration.inSeconds + addSeconds;
        duration = Duration(seconds: seconds);
      });
    });
  }

  String twoDigits(int n) => n.toString().padLeft(2, "0");

  @override
  Widget build(BuildContext context) {
    final customer = context.watch<BusinessProfileCubit>().state;
    if (customer is HasData_Business_Profile) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 5.w),
        child: Container(
          decoration: BoxDecoration(boxShadow: []),
          child: Column(
            children: [
              Row(
                children: [
                  showFileSection
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              showFileSection = false;
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            color: Theme.of(context).iconTheme.color,
                            size: 20.sp,
                          ))
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              showFileSection = true;
                            });
                          },
                          icon: SvgPicture.asset(
                            "assets/svg/add_message.svg",
                            color: Theme.of(context).iconTheme.color,
                          )),
                  Expanded(
                      child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: recorder
                        ? Container(
                            height: 12.w,
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .iconTheme
                                    .color
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5.sp)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: AudioWaveforms(
                                      enableGesture: false,
                                      waveStyle: WaveStyle(
                                          extendWaveform: true,
                                          showMiddleLine: false,
                                          waveCap: StrokeCap.round,
                                          waveColor: Theme.of(context)
                                              .iconTheme
                                              .color),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.w),
                                      size: Size(100.w, 7.w),
                                      recorderController: recorderController),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.sp),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}",
                                          style: GoogleFonts.roboto(
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              recorder = false;
                                              duration = Duration();
                                              timer.cancel();
                                              recorderController.stop();
                                            });
                                          },
                                          child: Text(
                                            "cancel",
                                            style: GoogleFonts.roboto(
                                              color: Colors.red,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Box(context),
                  )),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Row(
                      children: [
                        if (recorder) ...[
                          IconButton(
                            onPressed: () async {
                              recorderController.refresh();
                              setState(() {
                                duration = Duration();
                              });
                            },
                            icon: Icon(
                              Icons.replay_outlined,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                recorder = false;
                              });
                              timer.cancel();
                            },
                            icon: Icon(
                              Icons.send,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          )
                        ] else ...[
                          FutureBuilder<bool>(
                              future: recorderController.checkPermission(),
                              builder: (context, snapshot) {
                                return IconButton(
                                  onPressed: () async {
                                    setState(() {
                                      recorder = true;
                                    });
                                    startTimer();
                                    await recorderController.record();
                                  },
                                  icon: Icon(
                                    Icons.keyboard_voice,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                );
                              })
                        ]
                      ],
                    ),
                  ),
                ],
              ),
              if (showFileSection) ...[
                AnimatedContainer(
                  curve: Curves.ease,
                  duration: Duration(seconds: 5),
                  height: 25.w,
                  width: 100.w,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FileContainer(
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.image,
                                  size: 20.sp,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                            ),
                            FileContainer(
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.file_present,
                                  size: 20.sp,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                            ),
                            FileContainer(
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.contact_page,
                                  size: 20.sp,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                            ),
                            FileContainer(
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.location_on,
                                  size: 20.sp,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                            )
                          ],
                        )
                      ]),
                )
              ]
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Container Box(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 30.w, minHeight: 10.w),
      child: TextField(
        maxLines: null,
        cursorColor: Theme.of(context).iconTheme.color,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
            hintText: "New message",
            filled: true,
            fillColor: Theme.of(context).iconTheme.color.withOpacity(0.08),
            contentPadding: EdgeInsets.all(5.sp),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10.sp))),
      ),
    );
  }
}

class FileContainer extends StatelessWidget {
  const FileContainer({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.w,
      width: 12.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.sp),
        color: Theme.of(context).iconTheme.color.withOpacity(0.08),
      ),
      child: child,
    );
  }
}
