import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:u_vet_classifyer/common/extensions.dart';

import '../../../common/providers/loader_state.dart';
import '../../../common/providers/user_provider.dart';
import '../../../services/db_service.dart';

class HomeViewModel extends LoaderViewModel {
  final DbService dbService = DbService();
  late UserProvider userProvider;
  final ValueNotifier<List<Map>?> productListNotifier =
      ValueNotifier<List<Map>?>(null);

  TextEditingController productNameCtrl = TextEditingController(text: '');

  HomeViewModel();

  @override
  loadData({BuildContext? context, bool forceReload = false}) async {
    debugPrint('HomeViewModel - loadData()');
    userProvider = Provider.of<UserProvider>(navigator.context, listen: false);

    List<Future> list = [
    ];

    await Future.wait(list);
    markAsSuccess();
  }

  clear({bool controller = true, bool notifiers = true}) {
    if(controller) {
      productNameCtrl.text = '';
    }
    if(notifiers) {
      productListNotifier.value = null;
    }
  }

  scan() async {
    markAsLoading();

    clear();
    String? result;
    try {
      result = await FlutterBarcodeScanner.scanBarcode(
        navigator.context.theme.primaryColor.toHex,
        'Cancel',
        true,
        ScanMode.DEFAULT,
      );
    } on PlatformException {
      result = 'Failed to get platform version.';
    }
    productNameCtrl.text = result;
    debugPrint('scan() - barcodeScanResult: "$result"');

    Map data = await dbService.searchByBarcode(result);
    productListNotifier.value = [data];
    markAsSuccess();
  }

  // copyToClipboard(text) async {
  //   await Clipboard.setData(ClipboardData(text: text!));
  //   showSnackBarMsg(
  //       msg: 'Text "$text" copied to clipboard', context: navigator.context);
  // }

  searchByName() async {
    markAsLoading();

    clear(controller: false);
    String productName = productNameCtrl.text.trim();
    List<Map>? data = await dbService.searchByName(productName);
    // productNotifier.value = data['name'] + ' - ' + data['product_id'] + ')';
    productListNotifier.value = data;
    markAsSuccess();
  }
}
