import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smart/feature/main/bloc/announcement_manager.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/button/custom_text_button.dart';

import '../../../utils/colors.dart';
import '../../../widgets/accaunt/account_small_info.dart';
import '../../../widgets/button/custom_icon_button.dart';
import '../../../widgets/images/network_image.dart';
import '../bloc/announcement_cubit.dart';

int activePage = 0;

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    PageController pageController =
        PageController(viewportFraction: 0.9, initialPage: activePage);

    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<AnnouncementCubit, AnnouncementState>(
      builder: (context, state) {
        if (state is AnnouncementSuccessState) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.empty,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.black,
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        focusColor: AppColors.empty,
                        hoverColor: AppColors.empty,
                        highlightColor: AppColors.empty,
                        splashColor: AppColors.empty,
                        onTap: () {
                          setState(() {
                            isLiked = !isLiked;
                          });
                        },
                        child: SvgPicture.asset(
                          'Assets/icons/follow.svg',
                          width: 24,
                          height: 24,
                          color: isLiked ? AppColors.red : AppColors.whiteGray,
                        ),
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      InkWell(
                        focusColor: AppColors.empty,
                        hoverColor: AppColors.empty,
                        highlightColor: AppColors.empty,
                        splashColor: AppColors.empty,
                        onTap: () {},
                        child: SvgPicture.asset(
                          'Assets/icons/three_dots.svg',
                          width: 24,
                          height: 24,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            body: SizedBox(
              width: width,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.fast),
                child: Column(
                  children: [
                    SizedBox(
                      width: width,
                      height: 260,
                      child: InkWell(
                        focusColor: AppColors.empty,
                        hoverColor: AppColors.empty,
                        highlightColor: AppColors.empty,
                        splashColor: AppColors.empty,
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const PhotoViews()));
                        },
                        child: PageView.builder(
                            itemCount: state.data.images.length,
                            pageSnapping: true,
                            controller: pageController,
                            onPageChanged: (int page) {
                              setState(() {
                                activePage = page;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: CustomNetworkImage(
                                  width: 320,
                                  height: 258,
                                  url: state.data.images[index],
                                ),
                              );
                            }),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          indicators(state.data.images.length, activePage),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'Assets/icons/calendar.svg',
                                color: AppColors.lightGray,
                                width: 16,
                                height: 16,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                state.data.createdAt,
                                style: AppTypography.font14lightGray
                                    .copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'Assets/icons/eye.svg',
                                color: AppColors.lightGray,
                                width: 16,
                                height: 16,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(state.data.totalViews.toString(),
                                  style: AppTypography.font14lightGray
                                      .copyWith(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 6),
                      alignment: Alignment.topLeft,
                      child: Text(
                        state.data.title,
                        style: AppTypography.font18black,
                        softWrap: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 12, 15, 18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset('Assets/icons/point.svg'),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: ' ${state.data.creatorData.place}',
                                style: AppTypography.font14black),
                            TextSpan(
                                text: '  ${state.data.creatorData.distance}',
                                style: AppTypography.font14lightGray),
                          ]))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            state.data.stringPrice,
                            style: AppTypography.font22red,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        CustomTextButton.withIcon(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          disableColor: AppColors.red,
                          width: MediaQuery.of(context).size.width - 62,
                          callback: () {},
                          text: 'Écrire',
                          styleText: AppTypography.font14white,
                          icon: SvgPicture.asset(
                            'Assets/icons/email.svg',
                            color: Colors.white,
                            width: 24,
                            height: 24,
                          ),
                        ),
                        CustomIconButton(
                          callback: () {},
                          icon: 'Assets/icons/phone.svg',
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextButton.withIcon(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      callback: () {},
                      text: 'Offrir votre prix',
                      styleText: AppTypography.font14black,
                      icon: SvgPicture.asset('Assets/icons/dzd.svg'),
                      disableColor: AppColors.backgroundLightGray,
                    ),
                    const SizedBox(
                      height: 26,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Text(
                            'Caractéristiques',
                            style: AppTypography.font18black
                                .copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.fast),
                      child: Column(
                        children: state.data.staticParameters.parameters
                            .map((e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        e.key,
                                        style: AppTypography.font14lightGray,
                                      ),
                                      Text(
                                        e.currentValue,
                                        style: AppTypography.font14black
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: AppTypography.font16black
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 30,
                      child: Text(
                        state.data.description,
                        style: AppTypography.font14black.copyWith(height: 2),
                        softWrap: true,
                      ),
                    ),
                    const SizedBox(
                      height: 26,
                    ),
                    AccountSmallInfo(
                      creatorData: state.data.creatorData,
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: AppAnimations.circleFadingAnimation,
            ),
          );
        }
      },
    );
  }
}

List<Widget> indicators(imagesLength, currentIndex) {
  return List<Widget>.generate(imagesLength, (index) {
    return Container(
      margin: const EdgeInsets.all(3),
      width: 5,
      height: 5,
      decoration: BoxDecoration(
          color: currentIndex == index ? AppColors.red : AppColors.lightGray,
          shape: BoxShape.circle),
    );
  });
}

class PhotoViews extends StatefulWidget {
  const PhotoViews({super.key});

  @override
  State<PhotoViews> createState() => _PhotoViewsState();
}

class _PhotoViewsState extends State<PhotoViews> {
  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: activePage);

    final currentAnnouncement =
        RepositoryProvider.of<AnnouncementManager>(context).lastAnnouncement;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const AnnouncementScreen()));
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AnnouncementScreen()));
                  },
                  child: const Icon(Icons.arrow_back))
            ],
          ),
        ),
        body: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(currentAnnouncement.images[index]),
              initialScale: PhotoViewComputedScale.contained * 0.8,
            );
          },
          onPageChanged: (int page) {
            setState(() {
              activePage = page;
            });
          },
          itemCount: currentAnnouncement!.images.length,
          loadingBuilder: (context, event) => const Center(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(),
            ),
          ),
          pageController: pageController,
        ),
      ),
    );
  }
}
