import 'package:bloc/bloc.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/constant/app_constants.dart';
import '../../domain/models/article_model.dart';
import '../../domain/models/articles_params.dart';
import '../../domain/usecases/articles_usecase.dart';

part 'articles_event.dart';
part 'articles_state.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  final ArticlesUseCase articlesUseCase;

  // List of articles
  List<ArticleModel> allArticles = [];

  ArticlesBloc({required this.articlesUseCase})
      : super(LoadingGetArticlesState()) {
    on<OnGettingArticlesEvent>(_onGettingArticlesEvent);
    on<OnSearchingArticlesEvent>(_onSearchingEvent);
  }

// Getting articles event
  _onGettingArticlesEvent(
      OnGettingArticlesEvent event, Emitter<ArticlesState> emitter) async {
    if (event.withLoading) {
      emitter(LoadingGetArticlesState());
    }

    final result = await articlesUseCase.call(
      ArticlesParams(
        period: event.period,
      ),
    );
    result.fold((l) {
      if (l is CancelTokenFailure) {
        emitter(LoadingGetArticlesState());
      } else {
        emitter(ErrorGetArticlesState(l.errorMessage));
      }
    }, (r) {
      // Return list of articles with filtered by search text
      allArticles = r;
      emitter(SuccessGetArticlesState(_runFilter(event.text)));
    });
  }

  // Searching event
  _onSearchingEvent(
      OnSearchingArticlesEvent event, Emitter<ArticlesState> emitter) async {
    emitter(
      SearchingState(
        _runFilter(event.text),
      ),
    );
  }

  // This function is called whenever the text field changes
  List<ArticleModel> _runFilter(
    String text,
  ) {
    List<ArticleModel> results = [];
    if (text.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = List.from(allArticles);
    } else {
      results = allArticles.where((user) {
        return (user.title ?? defaultStr)
            .toLowerCase()
            .contains(text.toLowerCase());
      }).toList();
    }
    return results;
  }
}
