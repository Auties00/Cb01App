import 'dart:async';

import 'package:cb01/src/constant/color.dart';
import 'package:cb01/src/controller/film_manager.dart';
import 'package:cb01/src/template/film.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class PlayerPage extends StatefulWidget {
  final Film film;
  PlayerPage({Key key, this.film}) : super(key: key);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final FilmManager _manager = FilmManager();
  VideoPlayerController _controller;
  var _progress = 0.0;
  var _film = false;
  var _timer;
  var _future;

  @override
  void initState() {
    super.initState();
    _future = init();
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.pause();
    _controller.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  Future init() async{
    if(widget.film.streamingUrl == null){
      var value = await _manager.findStreamingUrl(widget.film);
      _controller = VideoPlayerController.network(value.substring(1, value.length - 1), formatHint: VideoFormat.hls);
      await _controller.initialize();
      _controller.play();
    }else {
      _controller = VideoPlayerController.network(widget.film.url, formatHint: VideoFormat.hls);
      await _controller.initialize();
      _controller.play();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        body: SafeArea(
          child: FutureBuilder(
            future: _future,
            builder: (context, data){
              if(data.connectionState != ConnectionState.done){
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  ),
                );
              }

              return InkWell(
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    setState(() => _film = true);
                    _timer?.cancel();
                    _timer = Timer(Duration(milliseconds: 2500), () {
                      setState(() => _film = false);
                    });
                  },
                  child: Stack(
                    children: [
                      Center(
                        child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller)
                        ),
                      ),


                      Positioned.fill(
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity: !_film ? 0 : 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: SliderTheme(
                                        data: SliderThemeData(
                                            trackShape: CustomTrackShape(),
                                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                                            thumbColor: Colors.white,
                                            activeTrackColor: Colors.white,
                                            inactiveTrackColor: Colors.white30
                                        ),
                                        child: Slider(
                                          onChanged: (newValue) {
                                            setState(() {
                                              _progress = newValue;
                                            });
                                          },

                                          onChangeEnd: (newValue) {
                                            setState(() {
                                              _controller.seekTo(Duration(milliseconds: (newValue * _controller.value.duration.inMilliseconds).round()));
                                            });
                                          },
                                          value: _progress,
                                        ),
                                      )
                                  )
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _controller.value.isPlaying ? _controller.pause() : _controller.play();
                                      });
                                    },
                                    icon: Icon(
                                      _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                  ),

                                  SizedBox(
                                    width: 10.0,
                                  ),

                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _controller.setVolume(_controller.value.volume > 0 ? 0.0 : 1.0);
                                      });
                                    },
                                    icon: Icon(
                                      _controller.value.volume == 0.0 ? Icons.volume_off : Icons.volume_up,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
              );
            }
          )
        )
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({@required RenderBox parentBox, Offset offset = Offset.zero, @required SliderThemeData sliderTheme, bool isEnabled = false, bool isDiscrete = false}) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}