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
    List<Future> list = [];

    if (context != null && productNotifier.value == null) {
      var routeArguments = ModalRoute.of(context)!.settings.arguments;
      if(routeArguments != null) {
        productNotifier.value = routeArguments as Map;
        debugPrint(
            'ProductViewModel - loadData()...DONE - productNotifier: "${productNotifier
                .value}"');

        productIdCtrl.text = productNotifier.value?['product_id'] ?? '';
        productNameCtrl.text = productNotifier.value?['name'] ?? '';
        providerCtrl.text = productNotifier.value?['provider'] ?? '';
        classificationCtrl.text =
            productNotifier.value?['classification'] ?? '';
        productImageNotifier.value = productNotifier.value?['image'];

        list.add(loadBarcodes());
      }
    }

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
      String? productUuid = productNotifier.value?['uuid'];
      List<Map<String,dynamic>>? data;

      if(productUuid != null) {
        markAsLoading();

        debugPrint('addBarcode() - addBarcodeToProduct(barcode: "$barcode")...');
        debugPrint('addBarcode() - addBarcodeToProduct(productUuid: "$productUuid")...');
        data = await dbService.addBarcodeToProduct(barcode: barcode, productUuid: productUuid);
        debugPrint('addBarcode() - addBarcodeToProduct()...DONE - data: "$data"');
      } else {
        data = [{'id': null, 'barcode': barcode, 'id_product': null}];
      }

      if(data != null && data.isNotEmpty) {
        List<Map<String, dynamic>>? currentBarcodes = productBarcodesNotifier.value ?? [];
        List<Map<String, dynamic>>? newBarcodes = List.from(data);

        currentBarcodes.addAll(newBarcodes);
        productBarcodesNotifier.value = List.from(currentBarcodes);
      }
    }

    markAsSuccess();
  }

  deleteBarcode({String? uuid, required String barcode}) async {
    debugPrint('deleteBarcode()...');
    String? barcodeUuid = uuid?.trim();
    debugPrint('deleteBarcode() - deleteBarcodeUuid("$barcodeUuid")...');
    List<Map<String,dynamic>>? data;

    if(barcodeUuid != null) {
      markAsLoading();
      data = await dbService.deleteBarcodeUuid(barcodeUuid);
      debugPrint('deleteBarcode() - deleteBarcodeUuid()...DONE - data: "$data"');
    } else {
      data = [{'id': null,'barcode': barcode, 'id_product': null}];
    }


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
    bool newProduct = productNotifier.value == null;
    debugPrint('saveProduct(${newProduct ? 'NEW' : 'UPDATE'})...');
    markAsLoading();

    String? productUuid = productNotifier.value?['uuid'];
    String id = productIdCtrl.text;
    String name = productNameCtrl.text;
    String? provider = providerCtrl.text.isEmpty ? null : providerCtrl.text;
    String? classification = classificationCtrl.text.isEmpty ? null : classificationCtrl.text;
    String? image = productImageNotifier.value;
    List<String> barcodes = productBarcodesNotifier.value?.map((e) => e['barcode'].toString()).toList() ?? [];

    debugPrint('saveProduct() - updateProduct()...');
    bool? data = await dbService.upsertProduct(productUuid: productUuid, productId: id, name: name, provider: provider, classification: classification, image: image, barcodes: barcodes);
    debugPrint('saveProduct() - updateProduct()...DONE - data: "$data"');

    productNotifier.value?['product_id'] = productIdCtrl.text;
    productNotifier.value?['name'] = productNameCtrl.text;
    productNotifier.value?['provider'] = providerCtrl.text;
    productNotifier.value?['classification'] = classificationCtrl.text;

    markAsSuccess();
    navigator.pop();
  }

  deleteProduct() async {
    debugPrint('deleteProduct()...');
    markAsLoading();

    String productUuid = productNotifier.value?['uuid'];

    debugPrint('deleteProduct() - deleteProduct()...');
    bool? data = await dbService.deleteProduct(productUuid: productUuid);
    debugPrint('deleteProduct() - deleteProduct()...DONE - data: "$data"');

    markAsSuccess();
    navigator.pop();
  }
}
