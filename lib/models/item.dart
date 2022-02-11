class Item {
  String? title;
  bool? done;

  Item({this.title, this.done});

  // Converts api json to dart's map
  Item.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    done = json['done'];
  }

  // Converts dart's map to api json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['done'] = done;

    return data;
  }
}
