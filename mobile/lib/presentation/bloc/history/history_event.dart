part of 'history_bloc.dart';

abstract class HistoryEvent {}

class LoadHistory extends HistoryEvent {
  final String? status;

  LoadHistory({this.status});
}

class CreateHistory extends HistoryEvent {
  final Map<String, dynamic> historyData;

  CreateHistory(this.historyData);
}

class UpdateHistory extends HistoryEvent {
  final String id;
  final Map<String, dynamic> updateData;

  UpdateHistory(this.id, this.updateData);
}
