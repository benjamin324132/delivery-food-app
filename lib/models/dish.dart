class Dish {
  Loc? loc;
  String? id;
  String? name;
  String? image;
  int? price;
  String? desc;
  bool? active;
  String? createdAt;
  String? updatedAt;
  String? category;

  Dish(
      {this.loc,
      this.id,
      this.name,
      this.image,
      this.price,
      this.desc,
      this.active,
      this.createdAt,
      this.updatedAt,
      this.category});

  Dish.fromJson(Map<String, dynamic> json) {
    loc = json['loc'] != null ? new Loc.fromJson(json['loc']) : null;
    id = json['_id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    desc = json['desc'];
    active = json['active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    category = json['category'];
  }
}

class Loc {
  List<double>? coordinates;
  String? type;

  Loc({this.coordinates, this.type});

  Loc.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<double>();
    type = json['type'];
  }
}
