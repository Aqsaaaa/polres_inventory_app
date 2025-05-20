import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/inventory_repository.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final InventoryRepository repository;

  HistoryBloc({required this.repository}) : super(HistoryInitial()) {
    on<LoadHistory>((event, emit) async {
      emit(HistoryLoading());
      try {
        final historyList = await repository.fetchHistory(status: event.status);
        emit(HistoryLoaded(historyList));
      } catch (e) {
        emit(HistoryError(e.toString()));
      }
    });

    on<CreateHistory>((event, emit) async {
      emit(HistoryLoading());
      try {
        final createdHistory = await repository.createHistory(event.historyData);
        emit(HistoryCreateSuccess(createdHistory));
      } catch (e) {
        emit(HistoryError(e.toString()));
      }
    });

    on<UpdateHistory>((event, emit) async {
      emit(HistoryLoading());
      try {
        final updatedHistory = await repository.updateHistory(event.id, event.updateData);
        emit(HistoryUpdateSuccess(updatedHistory));
      } catch (e) {
        emit(HistoryError(e.toString()));
      }
    });
  }
}
