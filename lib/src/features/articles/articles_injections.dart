import '../../core/network/dio_network.dart';
import '../../core/utils/injections.dart';
import 'data/data_sources/local/articles_shared_prefs.dart';
import 'data/data_sources/remote/articles_impl_api.dart';
import 'data/repositories/articles_repo_impl.dart';
import 'domain/repositories/abstract_articles_repository.dart';
import 'domain/usecases/articles_usecase.dart';

initArticlesInjections() {
  getItInstance
      .registerSingleton<ArticlesImplApi>(ArticlesImplApi(DioNetwork.appAPI));
  getItInstance.registerSingleton<AbstractArticlesRepository>(
      ArticlesRepositoryImpl(getItInstance()));
  getItInstance.registerSingleton<ArticlesSharedPrefs>(
      ArticlesSharedPrefs(getItInstance()));
  getItInstance
      .registerSingleton<ArticlesUseCase>(ArticlesUseCase(getItInstance()));
}
