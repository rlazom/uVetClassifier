import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:provider/provider.dart';

import '../../../common/providers/loader_state.dart';
import '../../../common/providers/user_provider.dart';
import '../../../services/db_service.dart';

class CloudViewModel extends LoaderViewModel {
  final DbService dbService = DbService();
  late UserProvider userProvider;
  final ValueNotifier<String?> fileNotifier = ValueNotifier<String?>(null);
  final ValueNotifier<List<Map>?> productListNotifier =
      ValueNotifier<List<Map>?>(null);

  TextEditingController productNameCtrl = TextEditingController(text: '');

  CloudViewModel();

  @override
  loadData({BuildContext? context, bool forceReload = false}) async {
    debugPrint('CloudViewModel - loadData()');
    userProvider = Provider.of<UserProvider>(navigator.context, listen: false);

    List<Future> list = [];

    await Future.wait(list);
    markAsSuccess();
  }

  clear() {
    fileNotifier.value = null;
    productListNotifier.value = null;
  }

  loadFile() async {
    print('loadFile()...');
    const params = OpenFileDialogParams(
      dialogType: OpenFileDialogType.document,
      fileExtensionsFilter: ['txt'],
      // sourceType: SourceType.,
    );
    final filePath = await FlutterFileDialog.pickFile(params: params);
    print('loadFile() - filePath: "$filePath"');

    if (filePath != null) {
      fileNotifier.value = filePath;

      final file = File(filePath);
      final content = await file.readAsString();
      final lines = content.split('\n');

      List<Map> maps = [];
      for (var line in lines) {
        final columns = line.split('\t');
        if(line.trim().isNotEmpty) {
          print('loadFile() - line: "$line"');

          final id = columns[0].trim();
          final name = columns[1].trim();
          final provider = columns[2].trim();
          final classification = columns[3].trim();

          Map map = {'product_id': id, 'name': name, 'provider': provider, 'classification': classification};
          maps.add(map);
        }
      }

      if(maps.isNotEmpty) {
        productListNotifier.value = List.from(maps);
      }
    }
  }

  insertProducts() async {
    print('insertProducts()...');

    List<Map> newProducts = List.from(productListNotifier.value ?? []);

    if(newProducts.isNotEmpty) {
      markAsLoading();

      List<Future> list = [];
      for (Map product in newProducts) {
        print('insertProducts() - product: "$product"');

        final id = product['product_id'].trim();
        final name = product['name'].trim();
        final provider = product['provider'].trim();
        final classification = product['classification'].trim();

        list.add(dbService.upsertProduct(
            productUuid: null,
            productId: id,
            name: name,
            provider: provider,
            classification: classification,
            image: null,
            barcodes: null));
      }

      await Future.wait(list);
    }
    markAsSuccess();
    navigator.pop();
  }
}
