import 'package:hive_ce/hive.dart';
import 'package:safe_verify/shared/models/safe_account_model.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([
  AdapterSpec<SafeAccount>(),
])

class HiveAdapters {}