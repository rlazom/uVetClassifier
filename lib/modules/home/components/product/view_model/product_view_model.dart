import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:u_vet_classifyer/common/extensions.dart';
import 'package:u_vet_classifyer/common/providers/loader_state.dart';
import 'package:u_vet_classifyer/services/db_service.dart';


class ProductViewModel extends LoaderViewModel {
  final DbService dbService = DbService();
  final ValueNotifier<Map?> productNotifier = ValueNotifier<Map?>(null);

  TextEditingController productIdCtrl = TextEditingController(text: '');
  TextEditingController productNameCtrl = TextEditingController(text: '');
  TextEditingController providerCtrl = TextEditingController(text: '');
  TextEditingController classificationCtrl = TextEditingController(text: '');

  final ValueNotifier<String?> productImageNotifier = ValueNotifier<String?>(null);
  final ValueNotifier<List<Map<String,dynamic>>?> productBarcodesNotifier = ValueNotifier<List<Map<String,dynamic>>?>(null);

  ProductViewModel();

  @override
  loadData({BuildContext? context, bool forceReload = false}) async {
    super.loadData();
    debugPrint('ProductViewModel - loadData()...');

    if (context != null && productNotifier.value == null) {
      var routeArguments = ModalRoute.of(context)!.settings.arguments;
      productNotifier.value = routeArguments as Map;
      debugPrint('ProductViewModel - loadData()...DONE - productNotifier: "${productNotifier.value}"');

      productIdCtrl.text = productNotifier.value?['product_id'] ?? '';
      productNameCtrl.text = productNotifier.value?['name'] ?? '';
      providerCtrl.text = productNotifier.value?['provider'] ?? '';
      classificationCtrl.text = productNotifier.value?['classification'] ?? '';
      productImageNotifier.value = productNotifier.value?['image'];
    }

    List<Future> list = [
      loadBarcodes(),
    ];

    await Future.wait(list);
    markAsSuccess();
  }

  Future<void> loadBarcodes() async {
    debugPrint('loadBarcodes()...');
    String productUuid = productNotifier.value?['uuid'].trim();
    debugPrint('loadBarcodes() - searchByProductUuid()...');
    List<Map<String,dynamic>>? data = await dbService.searchByProductUuid(productUuid);
    debugPrint('loadBarcodes() - searchByProductUuid()...DONE - data: "$data"');
    // productNotifier.value = data['name'] + ' - ' + data['product_id'] + ')';
    if(data != null && data.isNotEmpty) {
      productBarcodesNotifier.value = List.from(data);
    }
  }

  addBarcode() async {
    debugPrint('addBarcode()...');

    String? barcode;
    try {
      barcode = await FlutterBarcodeScanner.scanBarcode(
        navigator.context.theme.primaryColor.toHex,
        'Cancel',
        true,
        ScanMode.DEFAULT,
      );
    } on PlatformException {
      barcode = 'Failed to get platform version.';
    }
    debugPrint('addBarcode() - barcodeScanResult: "$barcode"');

    if(barcode != '-1') {
      markAsLoading();

      String productUuid = productNotifier.value?['uuid'];
      debugPrint('addBarcode() - addBarcodeToProduct(barcode: "$barcode")...');
      debugPrint('addBarcode() - addBarcodeToProduct(productUuid: "$productUuid")...');
      List<Map<String,dynamic>>? data = await dbService.addBarcodeToProduct(barcode: barcode, productUuid: productUuid);
      debugPrint('addBarcode() - addBarcodeToProduct()...DONE - data: "$data"');

      if(data != null && data.isNotEmpty) {
        List<Map<String, dynamic>>? currentBarcodes = productBarcodesNotifier.value ?? [];
        List<Map<String, dynamic>>? newBarcodes = List.from(data);

        currentBarcodes.addAll(newBarcodes);
        productBarcodesNotifier.value = List.from(currentBarcodes);
      }
    }

    markAsSuccess();
  }

  deleteBarcode(String uuid) async {
    markAsLoading();
    debugPrint('deleteBarcode()...');
    String barcodeUuid = uuid.trim();
    debugPrint('deleteBarcode() - deleteBarcodeUuid("$barcodeUuid")...');

    List<Map<String,dynamic>>? data = await dbService.deleteBarcodeUuid(barcodeUuid);
    debugPrint('deleteBarcode() - deleteBarcodeUuid()...DONE - data: "$data"');
    // productNotifier.value = data['name'] + ' - ' + data['product_id'] + ')';
    if(data != null && data.isNotEmpty) {
      List<Map<String, dynamic>>? currentBarcodes = productBarcodesNotifier.value;
      List deletedBarcodes = List.from(data).map((e) => e['barcode']).toList();

      currentBarcodes?.removeWhere((e) => deletedBarcodes.contains(e['barcode']));
      productBarcodesNotifier.value = List.from(currentBarcodes ?? []);
    }
    markAsSuccess();
  }

  saveProduct() async {
    debugPrint('saveProduct()...');
    markAsLoading();

    String productUuid = productNotifier.value?['uuid'];
    String id = productIdCtrl.text;
    String name = productNameCtrl.text;
    String? provider = providerCtrl.text.isEmpty ? null : providerCtrl.text;
    String? classification = classificationCtrl.text.isEmpty ? null : classificationCtrl.text;
    String? image = productImageNotifier.value;

    debugPrint('saveProduct() - updateProduct()...');
    await dbService.updateProduct(productUuid: productUuid, productId: id, name: name, provider: provider, classification: classification, image: image);
    debugPrint('saveProduct() - updateProduct()...DONE');

    productNotifier.value?['product_id'] = productIdCtrl.text;
    productNotifier.value?['name'] = productNameCtrl.text;
    productNotifier.value?['provider'] = providerCtrl.text;
    productNotifier.value?['classification'] = classificationCtrl.text;

    markAsSuccess();
  }
}
