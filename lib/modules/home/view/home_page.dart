import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/loading_blur_wdt.dart';
import '../view_model/home_view_model.dart';
import '../widgets/product_tile.dart';

class HomePage extends StatelessWidget {
  final HomeViewModel viewModel;

  const HomePage({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (context) => HomeViewModel(),
      child: Consumer<HomeViewModel>(builder: (context, viewModel, _,) {
        if (viewModel.normal) {
          viewModel.scheduleLoadService(() => viewModel.loadData(context: context));
          // return _buildSplash(viewModel, context);
        }

        Widget loadingWdt = const SizedBox.shrink();

        if (viewModel.loading) {
          loadingWdt = const LoadingBlurWdt();
        }


        return Scaffold(
          appBar: AppBar(
            title: const Text('Unified Veterinary Classifier'),
            actions: [
              IconButton(onPressed: viewModel.navigateToCloud, icon: const Icon(Icons.cloud_outlined))
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
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                labelText: 'Search',
                                hintText: 'Name of the product',
                                prefixIcon: const Icon(Icons.manage_search),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: viewModel.clear,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.qr_code),
                                      onPressed: viewModel.scan,
                                    ),
                                  ],
                                ),
                              ),
                              // textAlign: TextAlign.center,
                              controller: viewModel.productNameCtrl,
                              onSubmitted: (_) {
                                viewModel.searchByName();
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      ValueListenableBuilder<List<Map>?>(
                          valueListenable: viewModel.productListNotifier,
                          builder: (context, productList, _) {
                            List<Widget> list = [];
                            if (productList != null) {
                              if (productList.isEmpty) {
                                list = [
                                  const ProductTile(
                                    prefixIcon:
                                        Icon(Icons.assignment_late_outlined),
                                    text: 'No products',
                                    fn: null,
                                  )
                                ];
                              } else {
                                list = productList.map((e) {
                                  String product = e['product_id'] + ' - ' + e['name'];
                                  String? tagStr  = e['classification']?.trim();
                                  int barcodes  = ((e['m_barcode'] ?? []) as List).length;
                                  // print('product: "$product", barcodes: "$barcodes"');

                                  Widget? suffixWdt;
                                  if(barcodes == 0) {
                                    suffixWdt = const FittedBox(child: Icon(Icons.qr_code, color: Colors.orange));
                                  }

                                  Widget? tagWdt;
                                  if(tagStr != null) {
                                    tagWdt = Padding(
                                      padding: const EdgeInsets.only(right: 4.0),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                                          child: Text(tagStr, style: const TextStyle(fontSize: 10.0)),
                                        ),
                                      ),
                                    );
                                  }

                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 8.0),
                                    child: ProductTile(
                                      prefixIcon: const Icon(
                                          Icons.assignment_outlined),
                                      suffixIcon: suffixWdt,
                                      tag: tagWdt,
                                      text: product,
                                      fn: () => viewModel
                                          .navigateToProductDetails(e),
                                    ),
                                  );
                                }).toList();
                              }
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
                : viewModel.addProduct,
            tooltip: 'Add Product',
            backgroundColor: (viewModel.loading || viewModel.normal) ? Colors.grey : null,
            child: const Icon(Icons.add),
          ),
        );
      }),
    );
  }
}
