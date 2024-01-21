import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/announcement/ui/widgets/settings_bottom_sheet.dart';
import 'package:smart/feature/announcement_editing/bloc/announcement_edit_cubit.dart';
import 'package:smart/feature/auth/data/auth_repository.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/images/announcement_image.dart';

import '../../feature/announcement/bloc/announcement/announcement_cubit.dart';
import '../../utils/colors.dart';

class AnnouncementContainerHorizontal extends StatefulWidget {
  const AnnouncementContainerHorizontal(
      {super.key,
      required this.announcement,
      this.width,
      this.height,
      required this.likeCount,});

  final double? width, height;
  final Announcement announcement;
  final String likeCount;

  @override
  State<AnnouncementContainerHorizontal> createState() =>
      _AnnouncementContainerHorizontalState();
}

class _AnnouncementContainerHorizontalState
    extends State<AnnouncementContainerHorizontal> {
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double imageWidth = widget.width ?? width / 2 - 25;
    final double imageHeight = widget.height ?? (width / 2 - 25) * 1.032;

    return GestureDetector(
        onTap: () async {
          BlocProvider.of<AnnouncementCubit>(context)
              .loadAnnouncementById(widget.announcement.id);
          Navigator.pushNamed(context, AppRoutesNames.announcement);
        },
        child: Container(
          height: 118,
          width: double.infinity,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: AnnouncementImage(
                  announcement: widget.announcement,
                  width: imageWidth,
                  height: imageHeight,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: imageWidth,
                      child: Text(
                        widget.announcement.title,
                        style: AppTypography.font12dark,
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'Assets/icons/eye.svg',
                          width: 16,
                          fit: BoxFit.fitWidth,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          widget.announcement.totalViews.toString(),
                          style: AppTypography.font12black
                              .copyWith(color: AppColors.lightGray),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SvgPicture.asset(
                          'Assets/icons/follow.svg',
                          color: AppColors.lightGray,
                          width: 16,
                          fit: BoxFit.fitWidth,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          widget.likeCount,
                          style: AppTypography.font12black
                              .copyWith(color: AppColors.lightGray),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: width - imageWidth - 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.announcement.stringPrice,
                            style: AppTypography.font16boldRed,
                            textDirection: TextDirection.ltr,
                          ),
                          InkWell(
                            onTap: () {
                              if (widget.announcement.creatorData.uid ==
                                  RepositoryProvider.of<AuthRepository>(context)
                                      .userId) {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    showDragHandle: true,
                                    builder: (ctx) {
                                      return SettingsBottomSheet(
                                          announcement: widget.announcement);
                                    });
                              }
                            },
                            child: Container(
                              width: 26,
                              height: 16,
                              padding: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                'Assets/icons/three_dots.svg',
                                color: AppColors.lightGray,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}