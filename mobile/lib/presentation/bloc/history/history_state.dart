part of 'history_bloc.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<dynamic> historyList;

  HistoryLoaded(this.historyList);
}

class HistoryCreateSuccess extends HistoryState {
  final dynamic createdHistory;

  HistoryCreateSuccess(this.createdHistory);
}

class HistoryUpdateSuccess extends HistoryState {
  final dynamic updatedHistory;

  HistoryUpdateSuccess(this.updatedHistory);
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}
