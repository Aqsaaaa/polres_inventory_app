import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/inventory/inventory_bloc.dart';
import '../components/detail_barang.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<InventoryBloc>().add(LoadInventory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) {
          print('InventoryPage state: $state');
          if (state is InventoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is InventoryLoaded) {
            final barangList = state.barangList;
            print('Loaded barangList: $barangList');
            if (barangList.isEmpty) {
              return const Center(child: Text('No items found'));
            }
            return ListView.builder(
              itemCount: barangList.length,
              itemBuilder: (context, index) {
                final item = barangList[index];
                return ListTile(
                  title: Text(item['nama'] ?? 'No Name'),
                  subtitle: Text('Kategori: ${item['kategori'] ?? '-'} | Stok: ${item['stok'] ?? '-'}'),
                  leading: item['gambar'] != null
                      ? Image.network('http://10.0.2.2:3000/uploads/${item['gambar']}', width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.image_not_supported),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailBarangComponent(barang: item),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is InventoryError) {
            print('InventoryError: ${state.message}');
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
