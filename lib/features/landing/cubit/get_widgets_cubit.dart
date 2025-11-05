import 'package:bloc/bloc.dart';
import 'package:demo25/models/local/fc_widget.dart';
import 'package:demo25/services/api/widget_service.dart';
import 'package:demo25/services/local_storage/isar/isar_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_widgets_state.dart';
part 'get_widgets_cubit.freezed.dart';

class GetWidgetsCubit extends Cubit<GetWidgetsState> {
  GetWidgetsCubit({
    required WidgetService widgetService,
    required IsarService isarService,
  }) : super(const GetWidgetsState.initial()) {
    _widgetService = widgetService;
    _isarService = isarService;
  }

  late WidgetService _widgetService;
  late IsarService _isarService;

  Future<void> getWidgets({
    bool forceRefresh = false,
    String? query,
  }) async {
    emit(const GetWidgetsState.loading());
    try {
      final localWidgets = await _isarService.widgets.list(
        query: query,
      );

      // If we have local data and not forcing refresh, use cached data
      if (localWidgets.isNotEmpty && !forceRefresh) {
        emit(GetWidgetsState.loaded(widgets: localWidgets));
        return;
      }

      // If no local data OR forcing refresh, fetch from network
      if (localWidgets.isEmpty || forceRefresh) {
        await _networkFetch();

        final updatedLocalWidgets = await _isarService.widgets.list(
          query: query,
        );

        if (updatedLocalWidgets.isEmpty) {
          emit(const GetWidgetsState.empty());
          return;
        }
        emit(GetWidgetsState.loaded(widgets: updatedLocalWidgets));
        return;
      }
    } catch (e) {
      emit(GetWidgetsState.error(e.toString()));
    }
  }

  Future<void> _networkFetch() async {
    final widgets = await _widgetService.list(
      limit: 500,
      includes: [
        'properties.signature',
        'properties.attribute',
      ],
    );

    await _isarService.widgets.persistEntities(widgets);
  }
}
