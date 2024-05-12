import 'package:dartz/dartz.dart';
import 'package:new_york_times/src/core/network/error/exceptions.dart';

import '../../../../core/network/error/failures.dart';
import '../../domain/models/article_model.dart';
import '../../domain/models/articles_params.dart';
import '../../domain/repositories/abstract_articles_repository.dart';
import '../data_sources/remote/articles_impl_api.dart';

class ArticlesRepositoryImpl extends AbstractArticlesRepository {
  final ArticlesImplApi articlesApi;

  ArticlesRepositoryImpl(
    this.articlesApi,
  );

  // Gent Ny Times Articles
  @override
  Future<Either<Failure, List<ArticleModel>>> getArticles(
      ArticlesParams params) async {
    try {
      final result = await articlesApi.getArticles(params);
      return Right(result.results ?? []);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left(CancelTokenFailure(e.message, e.statusCode));
    }
  }
}
