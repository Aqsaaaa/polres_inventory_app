part of 'inventory_bloc.dart';

abstract class InventoryState {}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final List<dynamic> barangList;

  InventoryLoaded(this.barangList);
}

class InventoryError extends InventoryState {
  final String message;

  InventoryError(this.message);
}
