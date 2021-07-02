
class StockModel{
    StockModel({
      this.item,
      this.price,
      this.quantity
    }); 

    String item;
    int quantity;
    int price;

    factory StockModel.fromJson(Map<String, dynamic> json) => StockModel(
        item: json["item"],
        quantity: json["quantity"],
        price: json["Price"],
    );

    Map<String, dynamic> toJson() => {
        "item": item,
        "quantity": quantity,
        "price": price,
    };
}