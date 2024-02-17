import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum Level { urgent, basic, important }

class Task {
  String? name;
  Color? color;
  DateTime? time;
  String? place;
  String id;
  Level? le;

  Task({
    this.name,
    this.color,
    this.time,
    this.place,
    this.le,
    String? id,
  }) : id = id ?? Uuid().v4(); // Sử dụng Uuid để tạo ID mặc định

  // Phương thức chuyển từ JSON thành đối tượng Task
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['name'],
      color: Color(json['color']),
      time: DateTime.parse(json['time']),
      place: json['place'],
      le: json['le'] != null ? Level.values[json['le']] : null,
      id: json['id'],
    );
  }

  // Phương thức chuyển từ đối tượng Task thành JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color': color != null
          ? color!.value
          : null, // Chuyển đổi Color thành giá trị integer
      'time': time != null
          ? time!.toIso8601String()
          : null, // Chuyển đổi DateTime thành chuỗi ISO 8601
      'place': place,
      'id': id,
      'le': le != null ? le!.index : null, // Chuyển đổi Level thành index
    };
  }
}
