import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../managers/announcement_manager.dart';


part 'announcement_state.dart';

class AnnouncementsCubit extends Cubit<AnnouncementsState> {
  final AnnouncementManager _announcementManager;

  AnnouncementsCubit({required AnnouncementManager announcementManager})
      : _announcementManager = announcementManager,
        super(AnnouncementInitial()) {
    loadAnnounces();
  }

  void loadAnnounces() async {
    emit(AnnouncementsLoadingState());
    try {
      await _announcementManager.addLimitAnnouncements();
      emit(AnnouncementsSuccessState());
    } catch (e) {
      emit(AnnouncementsFailState());
      rethrow;
    }
  }
}