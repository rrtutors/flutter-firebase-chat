
class ProductModel{
  String name;
  int id;


  ProductModel(this.name,this.id);

  static fromMap(Map<dynamic,dynamic>map)
  {
    return ProductModel(map['name'],map['Id']);
  }
}