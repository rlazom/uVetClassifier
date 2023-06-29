import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/widgets/loading_blur_wdt.dart';
import '../../../widgets/product_tile.dart';
import '../view_model/product_view_model.dart';
import '../widgets/product_field.dart';

class ProductPage extends StatelessWidget {
  final ProductViewModel viewModel;

  const ProductPage({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductViewModel>.value(
      value: viewModel,
      child: Consumer<ProductViewModel>(builder: (context, viewModel, _) {
        if (viewModel.normal) {
          viewModel
              .scheduleLoadService(() => viewModel.loadData(context: context));
          // return _buildSplash(viewModel, context);
        }

        Widget loadingWdt = const SizedBox.shrink();

        if (viewModel.loading || viewModel.normal) {
          loadingWdt = const LoadingBlurWdt();
        }

        return Scaffold(
          appBar: AppBar(
            title: ValueListenableBuilder<Map?>(
                valueListenable: viewModel.productNotifier,
                builder: (context, product, _) {
                  return Text(product == null ? '-' : product['name']);
                }),
            actions: [
              IconButton(
                onPressed: viewModel.saveProduct,
                icon: const Icon(Icons.save),
              ),
            ],
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// ID
                      ProductField(
                        fieldCtrl: viewModel.productIdCtrl,
                        prefixIcon: const Icon(Icons.inventory_2_outlined),
                        label: 'Id',
                        hint: 'Id of the product',
                      ),

                      /// NAME
                      ProductField(
                        fieldCtrl: viewModel.productNameCtrl,
                        prefixIcon: const Icon(Icons.assignment_outlined),
                        label: 'Name',
                        hint: 'Name of the product',
                      ),

                      /// PROVIDER
                      ProductField(
                        fieldCtrl: viewModel.providerCtrl,
                        prefixIcon:
                            const Icon(Icons.assignment_returned_outlined),
                        label: 'Provider',
                        hint: 'Provider Name',
                      ),

                      /// CLASSIFICATION
                      ProductField(
                        fieldCtrl: viewModel.classificationCtrl,
                        prefixIcon: const Icon(Icons.class_outlined),
                        label: 'Classification',
                        hint: 'Provider Name',
                      ),

                      const SizedBox(
                        height: 8.0,
                      ),

                      /// BARCODES
                      ValueListenableBuilder<List<Map<String, dynamic>>?>(
                          valueListenable: viewModel.productBarcodesNotifier,
                          builder: (context, barcodes, _) {
                            List<Widget> list = [];
                            if (barcodes == null || barcodes.isEmpty) {
                              list = [
                                const ProductTile(
                                  prefixIcon: Icon(Icons.qr_code),
                                  text: 'No Barcodes',
                                  fn: null,
                                )
                              ];
                            } else {
                              list = barcodes.map((e) {
                                String uuid = e['id'].toString().trim();
                                String barcode = e['barcode'].toString().trim();

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ProductTile(
                                    prefixIcon: const Icon(Icons.qr_code),
                                    suffixIcon: const Icon(Icons.clear),
                                    text: barcode,
                                    fn: null,
                                    suffixFn: () =>
                                        viewModel.deleteBarcode(uuid),
                                  ),
                                );
                              }).toList();
                            }

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: list,
                            );
                          }),
                    ],
                  ),
                ),
              ),
              loadingWdt,
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (viewModel.loading || viewModel.normal)
                ? null
                : viewModel.addBarcode,
            tooltip: 'Add barcode',
            backgroundColor:
                (viewModel.loading || viewModel.normal) ? Colors.grey : null,
            child: const Icon(Icons.qr_code_scanner),
          ),
        );
      }),
    );
  }
}