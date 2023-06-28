import 'package:provider/provider.dart';
import 'package:u_vet_classifyer/common/providers/user_provider.dart';



var providers = [
  ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider()),
];