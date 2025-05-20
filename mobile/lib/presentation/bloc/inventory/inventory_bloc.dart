import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/inventory_repository.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final InventoryRepository repository;

  InventoryBloc({required this.repository}) : super(InventoryInitial()) {
    on<LoadInventory>((event, emit) async {
      emit(InventoryLoading());
      try {
        final barangList = await repository.fetchBarang();
        emit(InventoryLoaded(barangList));
      } catch (e) {
        emit(InventoryError(e.toString()));
      }
    });
  }
}
