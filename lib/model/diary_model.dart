import 'dart:typed_data';

class DiaryModel {
  int? id;
  String title;
  Uint8List imageTopLeft;
  Uint8List imageTopRight;
  Uint8List imageBtmLeft;
  Uint8List imageBtmRight;
  int date;

  DiaryModel({
    this.id,
    required this.title,
    required this.imageTopLeft,
    required this.imageTopRight,
    required this.imageBtmLeft,
    required this.imageBtmRight,
    required this.date,
  });

  factory DiaryModel.fromMap(Map<String, dynamic> map) {
    return DiaryModel(
      id: map['id'],
      title: map['title'],
      imageTopLeft: map['imageTopLeft'],
      imageTopRight: map['imageTopRight'],
      imageBtmLeft: map['imageBtmLeft'],
      imageBtmRight: map['imageBtmRight'],
      date: map['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageTopLeft': imageTopLeft,
      'imageTopRight': imageTopRight,
      'imageBtmLeft': imageBtmLeft,
      'imageBtmRight': imageBtmRight,
      'date': date,
    };
  }
}