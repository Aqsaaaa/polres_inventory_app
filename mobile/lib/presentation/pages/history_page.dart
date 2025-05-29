import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/history/history_bloc.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _statuses = ['Semua', 'dipinjam', 'dikembalikan'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statuses.length, vsync: this);
    context.read<HistoryBloc>().add(LoadHistory(status: null));
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        final status = _statuses[_tabController.index];
        context.read<HistoryBloc>().add(LoadHistory(status: status == 'Semua' ? null : status));
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildHistoryList(List<dynamic> historyList) {
    if (historyList.isEmpty) {
      return const Center(child: Text('No history records found'));
    }
    return ListView.builder(
      itemCount: historyList.length,
      itemBuilder: (context, index) {
        final item = historyList[index];
        return ListTile(
          title: Text('User ID: ${item['userId'] ?? '-'}'),
          subtitle: Text('Barang ID: ${item['barangId'] ?? '-'} | Status: ${item['status'] ?? '-'}'),
          trailing: Text(item['date'] != null ? DateTime.parse(item['date']).toLocal().toString() : ''),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _statuses.map((status) => Tab(text: status)).toList(),
        ),
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HistoryLoaded) {
            return _buildHistoryList(state.historyList);
          } else if (state is HistoryError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => CreateHistoryDialog(),
          );
        },
        tooltip: 'Create History',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CreateHistoryDialog extends StatefulWidget {
  const CreateHistoryDialog({super.key});

  @override
  _CreateHistoryDialogState createState() => _CreateHistoryDialogState();
}

class _CreateHistoryDialogState extends State<CreateHistoryDialog> {
  final _formKey = GlobalKey<FormState>();
  String? userId;
  String? barangId;
  String? status;
  String? alasan;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create History'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'User ID'),
                onSaved: (value) => userId = value,
                validator: (value) => value == null || value.isEmpty ? 'Please enter User ID' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Barang ID'),
                onSaved: (value) => barangId = value,
                validator: (value) => value == null || value.isEmpty ? 'Please enter Barang ID' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Status'),
                items: ['dipinjam', 'dikembalikan'].map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (value) => status = value,
                validator: (value) => value == null || value.isEmpty ? 'Please select status' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Alasan'),
                onSaved: (value) => alasan = value,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final historyData = {
                'userId': userId,
                'barangId': barangId,
                'status': status,
                'alasan': alasan,
              };
              context.read<HistoryBloc>().add(CreateHistory(historyData));
              Navigator.of(context).pop();
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
