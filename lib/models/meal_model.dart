class Meal {
  int? id;
  String? title;
  String? description;
  String? image;
  List<bool> days = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  Meal({this.title, this.description, this.image});

  Meal.fromMap(Map<String, dynamic> map) {
    id = map["_id"];
    title = map["title"];
    description = map["description"];
    image = map["image"];
    days[0] = map["sunday"] == 1;
    days[1] = map["monday"] == 1;
    days[2] = map["tuesday"] == 1;
    days[3] = map["wednesday"] == 1;
    days[4] = map["thursday"] == 1;
    days[5] = map["friday"] == 1;
    days[6] = map["saturday"] == 1;

  }

  Map<String, Object?> toMap() {
    var map = <String, dynamic>{
      "title": title,
      "description": description,
      "image": image,
      "sunday": days[0],
      "monday": days[1],
      "tuesday": days[2],
      "wednesday": days[3],
      "thursday": days[4],
      "friday": days[5],
      "saturday": days[6],

    };
    if (id != null) {
      map["_id"] = id;
    }

    return map;
  }
}
