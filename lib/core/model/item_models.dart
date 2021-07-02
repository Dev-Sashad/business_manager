

class SalesModel{
    SalesModel({
      this.date,
      this.item,
      this.price,
      this.quantitySold
    });

    String item;
    int quantitySold;
    int price;
    DateTime date;



    factory SalesModel.fromJson(Map<String, dynamic> json) => SalesModel(
        item: json["Item"],
        quantitySold: json["Quantity_sold"],
        price: json["Price"],
        date: json["Date"],
    );

    Map<String, dynamic> toJson() => {
        "Item": item,
        "Quantity_sold": quantitySold,
        "Price": price,
        "Date": date,
    };
}