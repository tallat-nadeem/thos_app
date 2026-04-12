import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class ReelsScreen extends StatefulWidget {
  @override
  _ReelsScreenState createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  List reels = [];

  @override
  void initState() {
    super.initState();
    fetchReels();
  }

  Future<void> fetchReels() async {
    final response = await http.get(
      Uri.parse('https://thos-new-backend.vercel.app/api/reels'),
    );

    if (response.statusCode == 200) {
      setState(() {
        reels = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (reels.isEmpty) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: reels.length,
        itemBuilder: (context, index) {
          return VideoItem(url: reels[index]['videoUrl']);
        },
      ),
    );
  }
}

class VideoItem extends StatefulWidget {
  final String url;
  VideoItem({required this.url});

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
        controller.play();
        controller.setLooping(true);
      });
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}