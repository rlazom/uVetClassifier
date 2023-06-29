import '../view/cload_page.dart';
import '../view_model/cloud_view_model.dart';

class CloudRoutes {
  static const String root = '/cloud';

  const CloudRoutes();
}

final cloudRoutesMap = {
  CloudRoutes.root: (context) => CloudPage(
    viewModel: CloudViewModel(),
  ),
};
