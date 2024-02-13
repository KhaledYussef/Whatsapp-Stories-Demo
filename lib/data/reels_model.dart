import 'package:story_view/story_view.dart';

enum UserType { Admins, Companies, RealStateAgents, Customers, Adviser, Unknown, Lawyer }

class ReelsModelHolder {
  int id;
  String? referenceName;
  String? logoUrl;
  bool isSeen;
  List<ReelsModel> reels;
  StoryController controller = StoryController();
  ReelsModelHolder({
    required this.id,
    this.referenceName,
    this.logoUrl,
    required this.reels,
    required this.isSeen,
  });

  factory ReelsModelHolder.fromJson(Map<String, dynamic> json) {
    return ReelsModelHolder(
      id: json['id'],
      referenceName: json['referenceName'],
      logoUrl: json['logoUrl'],
      reels: List<ReelsModel>.from(
        json['reels'].map((reel) => ReelsModel.fromJson(reel)),
      ),
      isSeen: json['isSeen'],
    );
  }
}

class ReelsModel {
  int id;
  String? url;
  bool? isExpired;
  DateTime? endDate;
  DateTime? acceptedDate;
  bool? isSeen;
  bool? isVideo;
  int? durationInSeconds;
  String? referenceId;
  String? referenceName;
  String? logoUrl;
  UserType? referenceType;

  String get when {
    final now = DateTime.now();
    final diff = now.difference(acceptedDate!);
    if (diff.inDays > 0) {
      return "${diff.inDays}d";
    } else if (diff.inHours > 0) {
      return "${diff.inHours}h";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes}m";
    } else {
      return "now";
    }
  }

  ReelsModel({
    required this.id,
    required this.url,
    required this.isExpired,
    required this.endDate,
    required this.acceptedDate,
    required this.isSeen,
    required this.isVideo,
    required this.durationInSeconds,
    required this.referenceId,
    required this.referenceName,
    required this.logoUrl,
    required this.referenceType,
  });

  factory ReelsModel.fromJson(Map<String, dynamic> json) {
    return ReelsModel(
      id: json['id'],
      url: json['url'],
      isExpired: json['isExpired'],
      endDate: DateTime.parse(json['endDate']),
      acceptedDate: DateTime.parse(json['acceptedDate']),
      isSeen: json['isSeen'],
      isVideo: json['isVideo'],
      durationInSeconds: json['durationInSeconds'],
      referenceId: json['referenceId'],
      referenceName: json['referenceName'],
      logoUrl: json['logoUrl'],
      referenceType: UserType.values[json['referenceType']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'isExpired': isExpired,
      'endDate': endDate?.toIso8601String(),
      'acceptedDate': acceptedDate?.toIso8601String(),
      'isSeen': isSeen,
      'isVideo': isVideo,
      'durationInSeconds': durationInSeconds,
      'referenceId': referenceId,
      'referenceName': referenceName,
      'logoUrl': logoUrl,
      'referenceType': referenceType?.index,
    };
  }
}
