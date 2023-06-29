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
    return Scaffold(
      appBar: AppBar(
        title: const Text('uVetClassifier'),
      ),
      body: ChangeNotifierProvider(
        create: (context) => HomeViewModel(),
        child: Consumer<HomeViewModel>(builder: (context, viewModel, _) {
          Widget loadingWdt = const SizedBox.shrink();

          if (viewModel.loading) {
            loadingWdt = const LoadingBlurWdt();
          }
          return Stack(
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
                              if(productList.isEmpty) {
                                list = [const ProductTile(
                                  prefixIcon:
                                  Icon(Icons.assignment_late_outlined),
                                  text: 'No products',
                                  fn: null,
                                )];
                              } else {
                                list = productList.map((e) {
                                  String product =
                                      e['product_id'] + ' - ' + e['name'];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: ProductTile(
                                      prefixIcon:
                                      const Icon(Icons.assignment_outlined),
                                      text: product,
                                      fn: () => viewModel.navigateToProductDetails(e),
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
          );
        }),
      ),
    );
  }
}
