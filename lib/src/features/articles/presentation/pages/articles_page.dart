import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../core/helper/helper.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/injections.dart';
import '../../../../shared/presentation/pages/background_page.dart';
import '../../../../shared/presentation/widgets/app_loader.dart';
import '../../../../shared/presentation/widgets/custom_app_bar_widget.dart';
import '../../../../shared/presentation/widgets/reload_widget.dart';
import '../../../../shared/presentation/widgets/text_field_widget.dart';
import '../../domain/models/article_model.dart';
import '../../domain/usecases/articles_usecase.dart';
import '../bloc/articles_bloc.dart';
import '../widgets/article_card_widget.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({Key? key}) : super(key: key);

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  ArticlesBloc _bloc =
      ArticlesBloc(articlesUseCase: getItInstance<ArticlesUseCase>());

  // Key for scaffold to open drawer
  GlobalKey<ScaffoldState> _key = GlobalKey();

  // Refresh controller for list view
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool isSearching = false;

  // List of articles
  List<ArticleModel> nyTimesArticles = [];

  // Search text field
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();

  // Period
  int selectedPeriod = 1;

  @override
  void initState() {
    // Call event to get ny times article
    callArticles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundPage(
      scaffoldKey: _key,
      withDrawer: true,
      child: Column(
        children: [
          // Custom App Bar
          CustomAppBarWidget(
            title: isSearching
                ? TextFieldWidget(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    hintText: S.of(context).search,
                    onChanged: (value) {
                      _bloc.add(
                        OnSearchingArticlesEvent(
                          (value?.trim() ?? ""),
                        ),
                      );
                    },
                    suffixIcon: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          isSearching = !isSearching;
                          if (isSearching) {
                            _searchFocusNode.requestFocus();
                          } else {
                            _searchFocusNode.unfocus();
                            _searchController.clear();
                            callArticles();
                          }
                        });
                      },
                      icon: Icon(
                        Icons.close,
                        size: 20,
                      ),
                    ),
                  )
                : Text(
                    S.of(context).ny_times_most_popular,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
            leading: IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                _key.currentState!.openDrawer();
              },
              icon: Icon(
                Icons.menu,
                size: 20,
              ),
            ),
          ),

          // Space
          SizedBox(
            height: Helper.getVerticalSpace(),
          ),

          // List of articles
          Expanded(
            child: BlocConsumer<ArticlesBloc, ArticlesState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is SuccessGetArticlesState) {
                  nyTimesArticles.clear();
                  nyTimesArticles = List.from(state.articles);
                  _refreshController.refreshCompleted(
                    resetFooterState: true,
                  );
                } else if (state is SearchingState) {
                  nyTimesArticles.clear();
                  nyTimesArticles = state.articles;
                }
              },
              builder: (context, state) {
                if (state is LoadingGetArticlesState) {
                  return const AppLoader();
                } else if (state is ErrorGetArticlesState) {
                  return ReloadWidget.error(
                    content: state.errorMsg,
                    onPressed: () {
                      callArticles();
                    },
                  );
                }

                // Check if there is no data
                if (nyTimesArticles.isEmpty) {
                  return ReloadWidget.empty(content: S.of(context).no_data);
                }

                return SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: false,
                    header: WaterDropHeader(
                      waterDropColor: Theme.of(context).cardColor,
                    ),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: null,
                    child: ListView.builder(
                      itemCount: nyTimesArticles.length,
                      itemBuilder: (context, index) {
                        return ArticleCardWidget(
                          nyTimesModel: nyTimesArticles[index],
                        );
                      },
                    ));
              },
            ),
          )
        ],
      ),
    );
  }

  // Refresh method called when pull down list
  void _onRefresh() async {
    _refreshController.requestRefresh();
    callArticles(withLoading: false);
  }

  // Call articles
  callArticles({bool withLoading = true}) {
    _bloc.add(
      OnGettingArticlesEvent(
        _searchController.text.trim(),
        selectedPeriod,
        withLoading: withLoading,
      ),
    );
  }
}
