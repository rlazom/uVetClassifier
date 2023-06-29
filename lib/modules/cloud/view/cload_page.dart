import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

import '../../../common/widgets/loading_blur_wdt.dart';
import '../../home/widgets/product_tile.dart';
import '../view_model/cloud_view_model.dart';

class CloudPage extends StatelessWidget {
  final CloudViewModel viewModel;

  const CloudPage({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CloudViewModel>(
      create: (context) => CloudViewModel(),
      child: Consumer<CloudViewModel>(builder: (
        context,
        viewModel,
        _,
      ) {
        if (viewModel.normal) {
          viewModel
              .scheduleLoadService(() => viewModel.loadData(context: context));
          // return _buildSplash(viewModel, context);
        }

        Widget loadingWdt = const SizedBox.shrink();

        if (viewModel.loading) {
          loadingWdt = const LoadingBlurWdt();
        }

        return Scaffold(
          appBar: AppBar(
            // leading: const Icon(Icons.cloud_outlined),
            title: const Row(
              children: [
                Icon(Icons.cloud_outlined),
                SizedBox(width: 8.0),
                Text('Cloud'),
              ],
            ),
            // actions: [
            //   IconButton(onPressed: (){}, icon: Icon(Icons.cloud_outlined))
            // ],
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 8.0,
                      ),
                      ValueListenableBuilder<String?>(
                        valueListenable: viewModel.fileNotifier,
                        builder: (context, file, _) {
                          String? fileName;
                          if(file != null) {
                            fileName = path.basename(file);
                          }

                          return ProductTile(
                            prefixIcon: const Icon(Icons.file_open_outlined),
                            suffixIcon: const Icon(Icons.clear),
                            suffixFn: viewModel.clear,
                            text: fileName ?? 'Load File',
                            fn: viewModel.loadFile,
                          );
                        }
                      ),
                      // InkWell(
                      //   onTap: viewModel.loadFile,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       const Icon(Icons.file_open_outlined),
                      //       ValueListenableBuilder<String?>(
                      //         valueListenable: viewModel.fileNotifier,
                      //         builder: (context, file, _) {
                      //           String? fileName;
                      //           if(file != null) {
                      //             fileName = path.basename(file);
                      //           }
                      //
                      //           return Text(fileName ?? ' Load File');
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      // ),
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
                                    prefixIcon: Icon(Icons.assignment_late_outlined),
                                    text: 'No products',
                                    fn: null,
                                  )
                                ];
                              } else {
                                list = [
                                  ProductTile(
                                    prefixIcon: const Icon(Icons.assignment_outlined),
                                    suffixIcon: const Icon(Icons.upload_file),
                                    suffixFn: viewModel.insertProducts,
                                    text: '${productList.length} products',
                                    fn: null,
                                  )
                                ];
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
        );
      }),
    );
  }
}
