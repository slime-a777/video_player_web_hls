import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

void main() {

  runApp(VideoApp());
}

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    try {
      _controller = VideoPlayerController.network(
          'https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8')
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
      _controller.setVolume(0.0);
      _controller.setPlaybackSpeed(10.0);
    }catch(e)
    {
      print(e);

    }
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      print(_controller);
    });
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              _controller.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : Container(),
              ProgressBar(
                progress: Duration(seconds: 120),
                total: Duration(milliseconds: 60 * 60 * 1000),
                baseBarColor: Colors.black12,
                progressBarColor: Colors.red,
                thumbColor: Colors.red,
                onSeek: (duration) => _controller.seekTo(duration),
              ),
            ],
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}