class Items {
  String? id;
  String? name;
  String? latitude;
  String? longitude;
  String? country;
  String? city;

  Items(
      {this.id,
      this.name,
      this.latitude,
      this.longitude,
      this.country,
      this.city});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    country = json['country'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['country'] = country;
    data['city'] = city;
    return data;
  }
}
