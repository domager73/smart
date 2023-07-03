import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/data/app_repository.dart';

import '../../data/creating_announcement_manager.dart';

part 'creating_announcement_state.dart';

class CreatingAnnouncementCubit extends Cubit<CreatingAnnouncementState> {
  CreatingAnnouncementManager creatingAnnouncementManager;

  CreatingAnnouncementCubit({required this.creatingAnnouncementManager}) : super(CreatingAnnouncementInitial()) {
    creatingAnnouncementManager.creatingState.stream.listen((event) {
      if (event == LoadingStateEnum.loading) emit(CreatingLoadingState());
      if (event == LoadingStateEnum.success) emit(CreatingSuccessState());
      if (event == LoadingStateEnum.fail) emit(CreatingFailState());
    });
  }

  createAnnouncement() => creatingAnnouncementManager.createAnnouncement();
}