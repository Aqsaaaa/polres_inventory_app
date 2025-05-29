import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/history/history_bloc.dart';

class DetailBarangComponent extends StatefulWidget {
  final Map<String, dynamic> barang;

  const DetailBarangComponent({Key? key, required this.barang}) : super(key: key);

  @override
  _DetailBarangComponentState createState() => _DetailBarangComponentState();
}

class _DetailBarangComponentState extends State<DetailBarangComponent> {
  bool isLoading = false;

  void _triggerHistory(String status) async {
    setState(() {
      isLoading = true;
    });

    final historyData = {
      'userId': 'currentUserId', // Replace with actual user id from auth or context
      'barangId': widget.barang['id'].toString(),
      'status': status,
      'alasan': status == 'dipinjam' ? 'Pinjam barang' : 'Kembalikan barang',
    };

    final historyBloc = context.read<HistoryBloc>();

    late final subscription;
    subscription = historyBloc.stream.listen((state) {
      if (state is HistoryCreateSuccess || state is HistoryError) {
        setState(() {
          isLoading = false;
        });
        subscription.cancel();
        if (state is HistoryCreateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Status $status berhasil diproses')),
          );
        } else if (state is HistoryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      }
    });

    if (status == 'dipinjam') {
      historyBloc.add(CreateHistory(historyData));
    } else if (status == 'dikembalikan') {
      // For simplicity, create new history for return as well
      historyBloc.add(CreateHistory(historyData));
    }
  }

  @override
  Widget build(BuildContext context) {
    final barang = widget.barang;
    return Scaffold(
      appBar: AppBar(
        title: Text(barang['nama'] ?? 'Detail Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            barang['gambar'] != null
                ? Image.network(
                    'http://10.0.2.2:3000/uploads/${barang['gambar']}',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image_not_supported, size: 100),
            const SizedBox(height: 16),
            Text('Nama: ${barang['nama'] ?? '-'}', style: const TextStyle(fontSize: 18)),
            Text('Kategori: ${barang['kategori'] ?? '-'}', style: const TextStyle(fontSize: 16)),
            Text('Stok: ${barang['stok'] ?? '-'}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _triggerHistory('dipinjam'),
                    child: const Text('Pinjam'),
                  ),
                  ElevatedButton(
                    onPressed: () => _triggerHistory('dikembalikan'),
                    child: const Text('Kembalikan'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
