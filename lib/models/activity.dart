class Activity {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String location;
  final String organizerId;
  final String organizerName;
  final String organizerAvatar;
  final List<String> participantIds;
  final int maxParticipants;
  final String interest;
  final String image;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.organizerId,
    required this.organizerName,
    required this.organizerAvatar,
    required this.participantIds,
    required this.maxParticipants,
    required this.interest,
    required this.image,
  });

  int get currentParticipants => participantIds.length;
  bool get hasSpace => currentParticipants < maxParticipants;
}
