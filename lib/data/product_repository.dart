import 'package:cloud_firestore/cloud_firestore.dart';

import 'product.dart';

class ProductRepository {
  ProductRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection('products');

  Stream<List<Product>> watchProducts() => _products
      .orderBy('name')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => Product.fromMap(doc.id, doc.data()))
            .toList(growable: false),
      );

  Future<void> save(Product product) async {
    final document = product.id.isEmpty
        ? _products.doc()
        : _products.doc(product.id);
    await document.set(product.toMap());
  }

  Future<void> delete(String id) => _products.doc(id).delete();
}
