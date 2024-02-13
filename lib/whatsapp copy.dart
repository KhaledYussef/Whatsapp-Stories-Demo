import 'package:flutter/material.dart';

import 'package:story_view/story_view.dart';

import 'repository.dart';
import 'util.dart';
import 'widgets.dart';

class Whatsapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<WhatsappStory>>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StoryPages(
              stories: snapshot.data,
            );
          }

          if (snapshot.hasError) {
            return ErrorView();
          }

          return const Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(),
            ),
          );
        },
        future: Repository.getWhatsappStories(),
      ),
    );
  }
}

//================================================
//================================================

class StoryPages extends StatefulWidget {
  const StoryPages({super.key, this.stories});
  final List<WhatsappStory>? stories;

  @override
  State<StoryPages> createState() => _StoryPagesState();
}

class _StoryPagesState extends State<StoryPages> {
  // page controller
  late PageController _pageController;
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return StoryViewDelegate(
            stories: widget.stories,
          );
        },
      ),
    );
  }
}

//================================================
//================================================

class StoryViewDelegate extends StatefulWidget {
  final List<WhatsappStory>? stories;

  StoryViewDelegate({this.stories});

  @override
  _StoryViewDelegateState createState() => _StoryViewDelegateState();
}

class _StoryViewDelegateState extends State<StoryViewDelegate> {
  final StoryController controller = StoryController();
  List<StoryItem> storyItems = [];

  String? when = "";

  @override
  void initState() {
    super.initState();
    widget.stories!.forEach((story) {
      if (story.mediaType == MediaType.text) {
        storyItems.add(
          StoryItem.text(
            title: story.caption!,
            backgroundColor: HexColor(story.color!),
            duration: Duration(
              milliseconds: (story.duration! * 1000).toInt(),
            ),
          ),
        );
      }

      if (story.mediaType == MediaType.image) {
        storyItems.add(StoryItem.pageImage(
          url: story.media!,
          controller: controller,
          caption: story.caption,
          duration: Duration(
            milliseconds: (story.duration! * 1000).toInt(),
          ),
        ));
      }

      if (story.mediaType == MediaType.video) {
        storyItems.add(
          StoryItem.pageVideo(
            story.media!,
            controller: controller,
            duration: Duration(milliseconds: (story.duration! * 1000).toInt()),
            caption: story.caption,
          ),
        );
      }
    });

    when = widget.stories![0].when;
  }

  Widget _buildProfileView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage("https://avatars2.githubusercontent.com/u/5024388?s=460&u=d260850b9267cf89188499695f8bcf71e743f8a7&v=4"),
        ),
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Not Grッ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                when!,
                style: TextStyle(
                  color: Colors.white38,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        StoryView(
          storyItems: storyItems,
          controller: controller,
          onComplete: () {
            Navigator.of(context).pop();
          },
          onVerticalSwipeComplete: (v) {
            if (v == Direction.down) {
              Navigator.pop(context);
            }
          },
          onStoryShow: (storyItem) {
            int pos = storyItems.indexOf(storyItem);

            // the reason for doing setState only after the first
            // position is becuase by the first iteration, the layout
            // hasn't been laid yet, thus raising some exception
            // (each child need to be laid exactly once)
            if (pos > 0) {
              setState(() {
                when = widget.stories![pos].when;
              });
            }
          },
        ),
        Container(
          padding: EdgeInsets.only(
            top: 48,
            left: 16,
            right: 16,
          ),
          child: _buildProfileView(),
        )
      ],
    );
  }
}
