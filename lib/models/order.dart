class Order {
  DeliveryLocation? deliveryLocation;
  String? id;
  String? userId;
  String? userName;
  List<Dishes>? dishes;
  int? subtotal;
  int? total;
  int? deliveryFee;
  String? paymentMethod;
  String? deliveryAdress;
  String? createdAt;
  String? updatedAt;

  Order(
      {this.deliveryLocation,
      this.id,
      this.userId,
      this.userName,
      this.dishes,
      this.subtotal,
      this.total,
      this.deliveryFee,
      this.paymentMethod,
      this.deliveryAdress,
      this.createdAt,
      this.updatedAt});

  Order.fromJson(Map<String, dynamic> json) {
    deliveryLocation = json['deliveryLocation'] != null
        ? new DeliveryLocation.fromJson(json['deliveryLocation'])
        : null;
    id = json['_id'];
    userId = json['userId'];
    userName = json['userName'];
    if (json['dishes'] != null) {
      dishes = <Dishes>[];
      json['dishes'].forEach((v) {
        dishes!.add(new Dishes.fromJson(v));
      });
    }
    subtotal = json['subtotal'];
    total = json['total'];
    deliveryFee = json['deliveryFee'];
    paymentMethod = json['paymentMethod'];
    deliveryAdress = json['deliveryAdress'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}

class DeliveryLocation {
  double? lat;
  double? long;

  DeliveryLocation({this.lat, this.long});

  DeliveryLocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    long = json['long'];
  }
}

class Dishes {
  String? name;
  int? qty;
  String? image;
  String? coments;
  int? price;
  String? dishId;
  String? id;

  Dishes(
      {this.name,
      this.qty,
      this.image,
      this.coments,
      this.price,
      this.dishId,
      this.id});

  Dishes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    qty = json['qty'];
    image = json['image'];
    coments = json['coments'];
    price = json['price'];
    dishId = json['dishId'];
    id = json['_id'];
  }
}
