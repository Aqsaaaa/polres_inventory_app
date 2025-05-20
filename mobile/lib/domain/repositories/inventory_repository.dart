import '../../data/api_service.dart';

class InventoryRepository {
  final ApiService apiService;

  InventoryRepository({required this.apiService});

  Future<List<dynamic>> fetchUsers() async {
    return await apiService.getUsers();
  }

  Future<List<dynamic>> fetchBarang() async {
    return await apiService.getBarang();
  }

  Future<List<dynamic>> fetchHistory({String? status}) async {
    return await apiService.getHistory(status: status);
  }

  Future<dynamic> createHistory(Map<String, dynamic> historyData) async {
    return await apiService.createHistory(historyData);
  }

  Future<dynamic> updateHistory(String id, Map<String, dynamic> updateData) async {
    return await apiService.updateHistory(id, updateData);
  }
}
