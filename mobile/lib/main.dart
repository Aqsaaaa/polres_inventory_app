import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/api_service.dart';
import 'domain/repositories/inventory_repository.dart';
import 'presentation/bloc/inventory/inventory_bloc.dart';
import 'presentation/bloc/history/history_bloc.dart';
import 'presentation/bloc/navigation/navigation_cubit.dart';
import 'presentation/pages/inventory_page.dart';
import 'presentation/pages/history_page.dart';

void main() {
  final apiService = ApiService(baseUrl: 'http://10.0.2.2:3000');
  final repository = InventoryRepository(apiService: apiService);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final InventoryRepository repository;

  const MyApp({Key? key, required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => InventoryBloc(repository: repository)),
        BlocProvider(create: (_) => HistoryBloc(repository: repository)),
      ],
      child: MaterialApp(
        title: 'Inventory App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, state) {
        final pages = [
          const InventoryPage(),
          const HistoryPage(),
        ];
        return Scaffold(
          body: pages[state],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state,
            onTap: (index) => context.read<NavigationCubit>().updateIndex(index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Inventory'),
              BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
            ],
          ),
        );
      },
    );
  }
}
