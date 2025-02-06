import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'constant/search_json.dart';

void main() {
  runApp(MaterialApp(
    home: SearchPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/videos/sample_video.mp4', // Replace with actual local video path
    )..initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: searchImages.length + 1,
          itemBuilder: (context, index) {
            if (index == 2) {
              // Video taking up a vertical 3x2 grid space (right side)
              return Container(
                width: (MediaQuery.of(context).size.width / 3) * 2 + 4,
                height: (MediaQuery.of(context).size.width / 3) * 3 + 8,
                child: _controller.value.isInitialized
                    ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  child: AspectRatio(
                    aspectRatio: 9 / 16, // Reels video aspect ratio
                    child: VideoPlayer(_controller),
                  ),
                )
                    : Center(child: CircularProgressIndicator()),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
              );
            } else if ( index == 5 || index == 6 || index == 9) {
              // Skipping adjacent cells to ensure proper merging
              return SizedBox.shrink();
            } else {
              return ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  searchImages[index < 7 ? index : index - 2],
                  fit: BoxFit.cover,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
