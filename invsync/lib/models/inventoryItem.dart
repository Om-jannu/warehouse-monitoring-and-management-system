class InventoryItem {
  final String id;
  final String itemName;
  final String lastUpdated;
  final int? quantity;

  InventoryItem({
    required this.id,
    required this.itemName,
    required this.lastUpdated,
    this.quantity,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      itemName: json['itemName'],
      lastUpdated: json['lastUpdated'],
      quantity: json['quantity'] != null ? int.parse(json['quantity']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemName': itemName,
      'lastUpdated': lastUpdated,
      'quantity': quantity?.toString(),
    };
  }
}
