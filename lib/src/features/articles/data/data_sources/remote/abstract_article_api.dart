import '../../../domain/models/article_model.dart';
import '../../../domain/models/article_response_model.dart';
import '../../../domain/models/articles_params.dart';

abstract class AbstractArticleApi {
  // Get all article
  Future<ApiResponse<List<ArticleModel>>> getArticles(ArticlesParams params);
}
