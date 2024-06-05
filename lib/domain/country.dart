class Country {

  late String name;
  late bool favorite;

  Country(this.name) {
    favorite = false;
  }

  @override
  bool operator ==(Object other) {
    var country = other as Country;
    return name == country.name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return '{Name: $name, Favorite: $favorite}';
  }

}