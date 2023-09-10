// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/favorites/bloc/favourites_cubit.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/utils/fonts.dart';

import '../../feature/announcement/bloc/announcement_cubit.dart';
import '../../utils/colors.dart';

class AnnouncementContainer extends StatefulWidget {
  AnnouncementContainer(
      {super.key, required this.announcement, this.liked = false});

  final Announcement announcement;
  bool liked;

  @override
  State<AnnouncementContainer> createState() => _AnnouncementContainerState();
}

class _AnnouncementContainerState extends State<AnnouncementContainer> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double imageWidth = width / 2 - 25;
    final double imageHeight = (width / 2 - 25) * 1.032;

    return InkWell(
      focusColor: AppColors.empty,
      hoverColor: AppColors.empty,
      highlightColor: AppColors.empty,
      splashColor: AppColors.empty,
      onTap: () async {
        BlocProvider.of<AnnouncementCubit>(context)
            .loadAnnouncementById(widget.announcement.announcementId);
        Navigator.pushNamed(context, '/announcement_screen');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
              future: widget.announcement.futureBytes,
              builder: (context, snapshot) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: snapshot.hasData
                      ? Image.memory(
                          width: imageWidth,
                          widget.announcement.bytes,
                          fit: BoxFit.cover,
                          height: imageHeight,
                          frameBuilder:
                              ((context, child, frame, wasSynchronouslyLoaded) {
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: frame != null
                                  ? child
                                  : Container(
                                      height: imageHeight,
                                      width: imageWidth,
                                      color: Colors.grey[300],
                                    ),
                            );
                          }),
                        )
                      : Container(
                          height: imageHeight,
                          width: imageWidth,
                          color: Colors.grey[300],
                        ),
                );
              }),
          const SizedBox(
            height: 10,
          ),
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
            height: 5,
          ),
          Row(
            children: [
              Text(
                widget.announcement.creatorData.name,
                style: widget.announcement.creatorData.verified
                    ? AppTypography.font12lightGray.copyWith(
                        color: const Color(0xFF0F7EE4),
                        fontWeight: FontWeight.w400)
                    : AppTypography.font12lightGray
                        .copyWith(fontWeight: FontWeight.w400),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (widget.announcement.creatorData.verified) ...[
                const SizedBox(
                  width: 5,
                ),
                SvgPicture.asset(
                  'Assets/icons/verified-user.svg',
                  width: 12,
                )
              ]
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset('Assets/icons/point.svg'),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: RichText(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(children: [
                      TextSpan(
                          text: ' ${widget.announcement.placeData.name}',
                          style: AppTypography.font14black),
                      // TextSpan(
                      //     text: '  ${widget.announcement.creatorData.distance}',
                      //     style: AppTypography.font14lightGray),
                    ])),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.announcement.stringPrice,
                style: AppTypography.font16boldRed,
                textDirection: TextDirection.ltr,
              ),
              InkWell(
                  focusColor: AppColors.empty,
                  hoverColor: AppColors.empty,
                  highlightColor: AppColors.empty,
                  splashColor: AppColors.empty,
                  onTap: () async {
                    bool res;
                    if (!widget.liked) {
                      res = await BlocProvider.of<FavouritesCubit>(context)
                          .like(widget.announcement.announcementId);
                    } else {
                      res = await BlocProvider.of<FavouritesCubit>(context)
                          .unlike(widget.announcement.announcementId);
                    }

                    if (res) {
                      setState(() {
                        widget.liked = !widget.liked;
                      });
                    }
                  },
                  child: SvgPicture.asset('Assets/icons/follow.svg',
                      width: 24,
                      height: 24,
                      color:
                          widget.liked ? AppColors.red : AppColors.whiteGray))
            ],
          )
        ],
      ),
    );
  }
}
