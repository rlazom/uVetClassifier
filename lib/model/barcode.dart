import 'package:u_vet_classifyer/model/product.dart';

class Barcode {
  final String id;
  final String barcode;
  final Product product;

  Barcode({
    required this.id,
    required this.barcode,
    required this.product,
  });
}
