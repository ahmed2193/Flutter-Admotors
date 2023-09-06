import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:video_player/video_player.dart';

class PlayerVideoView extends StatefulWidget {
  const PlayerVideoView(this.videoPath);
  final String videoPath;
  @override
  _PlayerVideoAndPopPageState createState() => _PlayerVideoAndPopPageState();
}

class _PlayerVideoAndPopPageState extends State<PlayerVideoView> {
  VideoPlayerController? _videoPlayerController;
  bool finishedPlaying = false;
  bool startedPlaying = false;

  @override
  void initState() {
    super.initState();

    _videoPlayerController =
        VideoPlayerController.file(File(widget.videoPath));
    _videoPlayerController!.addListener(() {
      if (_videoPlayerController!.value.duration == _videoPlayerController!.value.position) {
        setState(() {
          finishedPlaying = true;
        });
      }
      if (_videoPlayerController!.value.position == const Duration(seconds: 0, minutes: 0, hours: 0)) {
       setState((){
        startedPlaying = true;
       });
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController!.pause();
    _videoPlayerController!.dispose();
    super.dispose();
  }

  Future<bool> started() async {
    if (!_videoPlayerController!.value.isInitialized) {
      await _videoPlayerController!.initialize();
      await _videoPlayerController!.play();
    }
    return true;
  }

  IconData getPlayIconData() {
    if (startedPlaying) {
       startedPlaying = false;
       return Icons.pause;
    }
    else if (finishedPlaying) {
      finishedPlaying = false;
      return Icons.play_arrow;
    }
    else {
      if(_videoPlayerController!.value.isPlaying)
        return Icons.pause;
      else {
        // ignore: unnecessary_null_comparison
        if (_videoPlayerController!.value.size == null)
          return Icons.pause;
        else
          return Icons.play_arrow;  
      }  
    }
    // if (_videoPlayerController.value.isPlaying) {
    //   return Icons.pause;
    // } else {
    //   if (_videoPlayerController.value.size == null)
    //     return Icons.pause;
    //   else
    //     return Icons.play_arrow;  
    // } 
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Material(
          elevation: 0,
          child: Center(
            child: FutureBuilder<bool>(
              future: started(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.data == true) {
                  return AspectRatio(
                    aspectRatio: _videoPlayerController!.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController!),
                  );
                } else {
                  return const Text('waiting for video to load');
                }
              },
            ),
          ),
        ),
        Positioned(
              left: PsDimens.space16,
              top: Platform.isIOS ? PsDimens.space60 : PsDimens.space40,
              child: GestureDetector(
                child: Container(
                    width: 50,
                    height: 50,
                    child: Icon(Icons.clear, color: PsColors.black)),
                onTap: () {
                  Navigator.pop(context);
                },
              )),
              Positioned(
          bottom: PsDimens.space16,
          right: PsDimens.space16,
          child: FloatingActionButton(
            backgroundColor: PsColors.mainColor,
            onPressed: () {
              setState(() {
                _videoPlayerController!.value.isPlaying
                    ? _videoPlayerController!.pause()
                    : _videoPlayerController!.play();
              });
            },
            child: Icon(
              getPlayIconData()       
            ),
          ),
        ),        
      ],
    );
  }
}