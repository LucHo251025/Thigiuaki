class Product {
  const Product({
    this.id = '',
    required this.name,
    required this.price,
    required this.soluong,
    this.image = '',
  });

  // Firestore document ID is metadata, not an extra stored field.
  final String id;
  final String name;
  final double price;
  final int soluong;
  final String image;

  Map<String, Object> toMap() => {
    'name': name.trim(),
    'price': price,
    'soluong': soluong,
    'image': image,
  };

  factory Product.fromMap(String id, Map<String, dynamic> map) => Product(
    id: id,
    name: map['name'] as String? ?? '',
    price: (map['price'] as num?)?.toDouble() ?? 0,
    soluong: (map['soluong'] as num?)?.toInt() ?? 0,
    image: map['image'] as String? ?? '',
  );
}
