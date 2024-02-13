import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testtt/data/reels_model.dart';

/// The repository fetches the data from the same directory from git.
/// This is just to demonstrate fetching from a remote (workflow).
class Repository with ChangeNotifier {
  List<ReelsModelHolder> reels = [];
  late PageController pageController;
  Future<List<ReelsModelHolder>> getWhatsappStories2() async {
    try {
      final response = await rootBundle.loadString('assets/data.json');

      var data = jsonDecode(response);
      data = data['data'];
      final res = data.map<ReelsModelHolder>((it) {
        return ReelsModelHolder.fromJson(it);
      }).toList();

      reels = res;
      notifyListeners();

      return res;
    } catch (e) {
      print(e);
      return [];
    }
  }

  void setSeen(int pageIndex, int id) {
    if (id < 1) return;

    final index = reels.indexWhere((page) => page.reels.any((e) => e.id == id));
    var story = reels[index].reels.firstWhere((e) => e.id == id);
    story.isSeen = true;
  }

  //================================================================================================
  //================================================================================================
  //================================================================================================
  //================================================================================================
  //================================================================================================
  //================================================================================================
  //================================================================================================
  //================================================================================================
  //================================================================================================
  //================================================================================================
  //================================================================================================
  //================================================================================================
  //================================================================================================
  //================================================================================================
  //================================================================================================
  static MediaType _translateType(String? type) {
    if (type == "image") {
      return MediaType.image;
    }

    if (type == "video") {
      return MediaType.video;
    }

    return MediaType.text;
  }

  static Future<List<WhatsappStory>> getWhatsappStories() async {
    // final uri =
    //     "https://raw.githubusercontent.com/blackmann/storyexample/master/lib/data/whatsapp.json";
    // final response = await get(Uri.parse(uri));

    // get data from whatsapp.json file
    final response = await rootBundle.loadString('assets/whatsapp.json');

    var data = jsonDecode(response);
    data = data['data'];
    final res = data.map<WhatsappStory>((it) {
      return WhatsappStory(
          caption: it['caption'],
          media: it['media'],
          duration: double.parse(it['duration']),
          when: it['when'],
          mediaType: _translateType(it['mediaType']),
          color: it['color']);
    }).toList();

    return res;
  }
}

enum MediaType { image, video, text }

class WhatsappStory {
  final MediaType? mediaType;
  final String? media;
  final double? duration;
  final String? caption;
  final String? when;
  final String? color;
  final bool isViewed;

  WhatsappStory({
    this.mediaType,
    this.media,
    this.duration,
    this.caption,
    this.when,
    this.color,
    this.isViewed = false,
  });
}

class Highlight {
  final String? image;
  final String? headline;

  Highlight({this.image, this.headline});
}
