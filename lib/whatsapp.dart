import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:story_view/story_view.dart';
import 'package:testtt/data/reels_model.dart';

import 'repository.dart';

class Whatsapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryPages(),
    );
  }
}

//================================================
//================================================

class StoryPages extends StatefulWidget {
  const StoryPages({super.key});

  @override
  State<StoryPages> createState() => _StoryPagesState();
}

class _StoryPagesState extends State<StoryPages> {
  // page controller

  @override
  void initState() {
    context.read<Repository>().pageController = PageController(initialPage: 0, keepPage: false);
    var pageController = context.read<Repository>().pageController;
    pageController.addListener(() {
      pageController.position.isScrollingNotifier.addListener(() {
        var controller = context.read<Repository>().reels[pageController.page!.toInt()].controller;
        if (pageController.position.isScrollingNotifier.value == true) {
          if (controller.playbackNotifier.value != PlaybackState.pause) {
            controller.pause();
          }
        } else {
          var controller = context.read<Repository>().reels[pageController.page!.toInt()].controller;
          if (controller.playbackNotifier.value != PlaybackState.play) {
            controller.play();
          }
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var pages = context.watch<Repository>().reels;
    return Scaffold(
      body: PageView.builder(
        onPageChanged: (value) {
          var controller = pages[value].controller;
          controller.pause();
          controller.play();
        },
        controller: context.read<Repository>().pageController,
        itemCount: pages.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return StoryViewDelegate(
            page: pages[index],
          );
        },
      ),
    );
  }
}

//================================================
//================================================

class StoryViewDelegate extends StatefulWidget {
  final ReelsModelHolder page;

  const StoryViewDelegate({required this.page});

  @override
  _StoryViewDelegateState createState() => _StoryViewDelegateState();
}

class _StoryViewDelegateState extends State<StoryViewDelegate> {
  List<StoryItem> storyItems = [];

  String? when = "";
  List<ReelsModel> stories = [];
  @override
  void initState() {
    super.initState();
    if (widget.page.controller.playbackNotifier.isClosed) {
      widget.page.controller = StoryController();
    }
    stories = widget.page.reels;
    for (var story in stories) {
      // if (story.is == MediaType.text) {
      //   storyItems.add(
      //     StoryItem.text(
      //       title: story.caption!,
      //       backgroundColor: HexColor(story.color!),
      //       duration: Duration(
      //         milliseconds: (story.duration! * 1000).toInt(),
      //       ),
      //     ),
      //   );
      // }

      if (story.isVideo == false) {
        storyItems.add(StoryItem.pageImage(
          url: story.url!,
          controller: widget.page.controller,
          caption: story.referenceName,
          duration: Duration(
            milliseconds: (story.durationInSeconds! * 1000).toInt(),
          ),
        ));
      }

      if (story.isVideo == true) {
        storyItems.add(
          StoryItem.pageVideo(
            story.url!,
            controller: widget.page.controller,
            duration: Duration(milliseconds: (story.durationInSeconds! * 1000).toInt()),
            caption: story.referenceName,
          ),
        );
      }
    }

    when = stories[0].when;
    // move to the story at the current index
    moveToNext();

    // widget.page.controller.next();
  }

  void moveToNext() async {
    // get index of the first isssen story from the list
    int index = stories.lastIndexWhere((element) => element.isSeen == true);
    if (index == stories.length - 1 || index == -1) {
      return;
    }
    // for loop to move to the next story
    for (var i = 0; i < index + 1; i++) {
      widget.page.controller.next();
      await Future.delayed(const Duration(milliseconds: 1));
    }
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
    widget.page.controller.dispose();
    super.dispose();
  }

  int currentstoryIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        StoryView(
          storyItems: storyItems,
          controller: widget.page.controller,
          onComplete: () {
            Navigator.of(context).pop();
          },
          onVerticalSwipeComplete: (v) {
            // if (v == Direction.down) {
            //   Navigator.pop(context);
            // }

            print(v);
          },
          onStoryShow: (storyItem) {
            int pos = storyItems.indexOf(storyItem);
            currentstoryIndex = pos;
            // set is seen
            var pageIndex = context.read<Repository>().reels.indexOf(widget.page);

            context.read<Repository>().setSeen(pageIndex, stories[pos].id);

            // the reason for doing setState only after the first
            // position is becuase by the first iteration, the layout
            // hasn't been laid yet, thus raising some exception
            // (each child need to be laid exactly once)
            if (pos > 0) {
              setState(() {
                when = stories[pos].when;
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
        ),
        GestureDetector(
          onTapUp: (details) {
            if (details.localPosition.direction > 1.0) {
              if (currentstoryIndex != 0) {
                widget.page.controller.previous();
              } else {
                context.read<Repository>().pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
              }
              print('Left');
            }
            if (details.localPosition.direction < 1.0) {
              if (currentstoryIndex != storyItems.length - 1) {
                widget.page.controller.next();
              } else {
                if (context.read<Repository>().reels.length - 1 != context.read<Repository>().pageController.page!.toInt()) {
                  context.read<Repository>().pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                } else {
                  Navigator.pop(context);
                }
              }

              print('Right');
            }
          },
        ),
      ],
    );
  }
}
