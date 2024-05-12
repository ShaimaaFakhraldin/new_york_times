import '../core/utils/injections.dart';
import 'data/data_sources/app_shared_prefs.dart';

initAppInjections() {
  getItInstance
      .registerFactory<AppSharedPrefs>(() => AppSharedPrefs(getItInstance()));
}
