import '../components/product/product_component.dart';
import '../view/home_page.dart';
import '../view_model/home_view_model.dart';

class HomeRoutes {
  static const String root = '/home';
  static const String product = '$root${ProductComponent.route}';

  const HomeRoutes();
}

final homeRoutesMap = {
  HomeRoutes.root: (context) => HomePage(
    viewModel: HomeViewModel(),
  ),
  HomeRoutes.product: (context) => ProductPage(
    viewModel: ProductViewModel(),
  ),
};
