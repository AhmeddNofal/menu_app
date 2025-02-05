class Order {
  int? id;
  int? mealId;
  int? userId;
  String? date;

  Order({this.mealId, this.userId, this.date});

  Order.fromMap(Map<String, dynamic> map) {
    id = map["_id"];
    mealId = map["meal"];
    userId = map["user"];
    date = map["date"];
  }

  Map<String, Object?> toMap() {
    var map = {"_id": id, "meal": mealId, "user": userId, "date": date};
    return map;
  }
}
