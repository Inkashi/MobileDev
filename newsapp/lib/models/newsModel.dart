class Newsmodel {
  int id;
  String name;
  String description;
  String category;
  String image_src;
  DateTime date;

  Newsmodel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.image_src,
    required this.date,
  });

  factory Newsmodel.fromData(Map<String, dynamic> data) {
    return Newsmodel(
        id: data["id"],
        name: data['name'],
        description: data["description"],
        category: data["category"],
        image_src: data["image_src"],
        date: DateTime.parse(data["date"]));
  }

  Map<String, dynamic> tomap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "category": category,
      "image_src": image_src,
      "date": date.toString(),
    };
  }
}
