import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/Business_profile/business_profile_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:popover/popover.dart';
import 'package:sizer/sizer.dart';

class MessageBox extends StatefulWidget {
  const MessageBox({Key key}) : super(key: key);

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  RecorderController recorderController;
  final ImagePicker _picker = ImagePicker();
  bool recorder = false;

  @override
  void initState() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final customer = context.watch<BusinessProfileCubit>().state;
    if (customer is HasData_Business_Profile) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 5.w),
        child: Row(
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: SvgPicture.asset(
                "assets/svg/add_message.svg",
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                showPopover(
                  context: context,
                  transitionDuration: const Duration(milliseconds: 150),
                  bodyBuilder: (context) => const ListItems(),
                  onPop: () => print('Popover was popped!'),
                  direction: PopoverDirection.top,
                  width: 20.w,
                  height: 30.w,
                  arrowHeight: 0,
                  arrowWidth: 0,
                );
              },
            ),
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
                                    waveCap: StrokeCap.square,
                                    waveThickness: 1.3,
                                    showDurationLabel: true,
                                    waveColor:
                                        Theme.of(context).iconTheme.color),
                                padding: EdgeInsets.symmetric(vertical: 2.w),
                                size: Size(100.w, 7.w),
                                recorderController: recorderController),
                          ),
                          // Expanded(
                          //     child: Text(durcation(
                          //         duration:
                          //             recorderController.)))
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
                      },
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    )
                  ] else ...[
                    IconButton(
                      onPressed: () async {
                        setState(() {
                          recorder = true;
                        });
                        await recorderController.record();
                      },
                      icon: Icon(
                        Icons.keyboard_voice,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    )
                  ]
                ],
              ),
            ),
          ],
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
            hintText: "Chatter message",
            filled: true,
            fillColor: Theme.of(context).iconTheme.color.withOpacity(0.1),
            contentPadding: EdgeInsets.all(5.sp),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10.sp))),
      ),
    );
  }
}

String durcation({Duration duration}) {
  return "${duration.inMinutes} ${duration.inSeconds}";
}

class ListItems extends StatelessWidget {
  const ListItems({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            height: 50,
            color: Colors.amber[100],
            child: const Center(child: Text('Entry A')),
          ),
        ),
      ],
    );
  }
}
