import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelsScreen extends StatefulWidget {
  @override
  _ReelsScreenState createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  List<String> videoPaths = [
    'assets/child.mp4',
    'assets/child1.mp4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reels'),
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: videoPaths.length,
        itemBuilder: (context, index) {
          return VideoPlayerItem(videoPath: videoPaths[index]);
        },
      ),
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String videoPath;

  VideoPlayerItem({required this.videoPath});

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _controller;
  bool _isPlaying = true;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: _togglePlayPause,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _controller.value.isInitialized
                  ? Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
              )
                  : CircularProgressIndicator(),
              if (!_isPlaying)
                Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 100.0,
                ),
            ],
          ),
        ),
        Positioned(
          bottom: 80,
          right: 20,
          child: Column(
            children: [
              IconButton(
                icon: Icon(
                  Icons.thumb_up,
                  color: _isLiked ? Colors.blue : Colors.white,
                ),
                iconSize: 40.0,
                onPressed: _toggleLike,
              ),
              SizedBox(height: 10),
              IconButton(
                icon: Icon(Icons.share, color: Colors.white),
                iconSize: 40.0,
                onPressed: () {
                  // Add share functionality
                },
              ),
              SizedBox(height: 10),
              IconButton(
                icon: Icon(Icons.comment, color: Colors.white),
                iconSize: 40.0,
                onPressed: () {
                  // Add comment functionality
                },
              ),
              SizedBox(height: 10),
              IconButton(
                icon: Icon(Icons.send, color: Colors.white),
                iconSize: 40.0,
                onPressed: () {
                  // Add send functionality
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MainScreen(),
  ));
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReelsScreen()),
            );
          },
          child: Text('Go to Reels'),
        ),
      ),
    );
  }
}
