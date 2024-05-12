import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/router/app_route_enum.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/utils/constant/app_constants.dart';
import '../../../../shared/presentation/widgets/cached_image_widget.dart';
import '../../domain/models/article_model.dart';

class ArticleCardWidget extends StatefulWidget {
  final ArticleModel nyTimesModel;

  const ArticleCardWidget({Key? key, required this.nyTimesModel})
      : super(key: key);

  @override
  State<ArticleCardWidget> createState() => _ArticleCardWidgetState();
}

class _ArticleCardWidgetState extends State<ArticleCardWidget> {
  String? smallImageUrl;
  String? bigImageUrl;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Small image for list item
    // Check if somethings happened and do not return media
    // If everything seems to be in order we will display the image
    // else display solid circle instead
    if (widget.nyTimesModel.media != null &&
        widget.nyTimesModel.media!.isNotEmpty) {
      if (widget.nyTimesModel.media!.first.mediaMetadata != null &&
          widget.nyTimesModel.media!.first.mediaMetadata!.isNotEmpty) {
        smallImageUrl =
            widget.nyTimesModel.media!.first.mediaMetadata!.first.url;
      }
    }

    // Big image for view and zoom it
    // Check if somethings happened and do not return media
    // If everything seems to be in order we will display the image
    // else display solid circle instead
    if (widget.nyTimesModel.media != null &&
        widget.nyTimesModel.media!.isNotEmpty) {
      if (widget.nyTimesModel.media!.last.mediaMetadata != null &&
          widget.nyTimesModel.media!.last.mediaMetadata!.isNotEmpty) {
        bigImageUrl = widget.nyTimesModel.media!.last.mediaMetadata!.last.url;
      }
    }
    return test();
  }

  Widget test() {
    return Container(
        height: 250,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                // image
                Positioned.fill(
                  child: (smallImageUrl != null)
                      ? Hero(
                          tag: bigImageUrl!,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRouteEnum.articleDetailsPage.name,
                                arguments: widget.nyTimesModel,
                              );
                              // Navigator.pushNamed(
                              //   context,
                              //   AppRouteEnum.photoViewPage.name,
                              //   arguments: {
                              //     "path": bigImageUrl!,
                              //     "fromNet": true,
                              //   },
                              // );
                            },
                            child: CachedImageWidget(
                              imageUrl: smallImageUrl!,
                            ),
                          ),
                        )
                      : Container(
                          color: AppColors.gray,
                        ),
                  //     Image.network(
                  //   "https://images.unsplash.com/photo-1516321165247-4aa89a48be28?q=80&w=3621&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  //   fit: BoxFit.cover,
                  // )
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 110,
                    padding: const EdgeInsets.all(15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.6),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.nyTimesModel.title ?? defaultStr,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(color: Colors.white, fontSize: 18),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.nyTimesModel.abstract ?? defaultStr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.white54, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
