import 'barcode.dart';

class Product {
  final String uuid;
  final String id;
  final String name;
  final String provider;
  final String classification;
  final String image;
  final List<Barcode> barcodes;

  Product({
    required this.uuid,
    required this.id,
    required this.name,
    required this.provider,
    required this.classification,
    required this.image,
    required this.barcodes,
  });
}
