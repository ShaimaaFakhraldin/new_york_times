import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../models/article_model.dart';
import '../models/articles_params.dart';

abstract class AbstractArticlesRepository {
  // Gent Ny Times Articles
  Future<Either<Failure, List<ArticleModel>>> getArticles(
      ArticlesParams params);
}
