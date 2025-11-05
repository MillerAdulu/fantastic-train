part of 'get_widgets_cubit.dart';

@freezed
class GetWidgetsState with _$GetWidgetsState {
  const factory GetWidgetsState.initial() = _Initial;
  const factory GetWidgetsState.loading() = _Loading;
  const factory GetWidgetsState.loaded({required List<FCLocalWidget> widgets}) =
      _Loaded;
  const factory GetWidgetsState.empty() = _Empty;
  const factory GetWidgetsState.error(String message) = _Error;
}
