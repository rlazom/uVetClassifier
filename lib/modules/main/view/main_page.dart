import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/providers/user_provider.dart';
import '../../../common/extensions.dart';
import '../view_model/main_view_model.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  Widget _buildSplash(MainViewModel viewModel, BuildContext context) {
    List<Widget> stackList = [];
    var mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    double shortestSide3 = mediaQuery.size.shortestSide / 3;

    stackList.add(
      Center(
        child: Padding(
          padding:
          EdgeInsets.only(top: isLandscape ? 40.0 : 100.0, bottom: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: isLandscape ? 0 : 120,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (viewModel.loading)
                      Consumer<UserProvider>(
                          builder: (context, userProvider, child) {

                            int percent = 0;
                            if (userProvider.servicesReloaded > 0) {
                              percent = (userProvider.servicesReloaded /
                                  userProvider.servicesToReload *
                                  100)
                                  .toInt();
                            }
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: shortestSide3,
                                  height: shortestSide3,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    alignment: Alignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        key: const Key('circular_loading'),
                                        value: userProvider.servicesReloaded <= 0
                                            ? null
                                            : userProvider.servicesReloaded /
                                            userProvider.servicesToReload,
                                        color: context.theme.primaryColor.withOpacity(0.6),
                                      ),
                                      if (percent > 0)
                                        Padding(
                                          padding: const EdgeInsets.all(32.0),
                                          child: FittedBox(
                                            child: Text(
                                              '$percent%',
                                              style: TextStyle(
                                                color: context.theme.primaryColor.withOpacity(0.7),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Stack(
      key: const Key('main_page_stack_key'),
      children: stackList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => MainViewModel(),
        child: Consumer<MainViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.normal) {
              viewModel.scheduleLoadService(viewModel.loadData);
              return _buildSplash(viewModel, context);
            }
            return _buildSplash(viewModel, context);
          },
        ),
      ),
    );
  }
}
