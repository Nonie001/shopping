import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/bloc/brand_bloc.dart';
import 'package:shop/cart/shopping_cart.dart';

import 'apple_page.dart';
import 'samsung_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brand App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.green,
      ),
      darkTheme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ApiBloc apiBloc;

  @override
  Widget build(BuildContext context) {
    apiBloc = BlocProvider.of<ApiBloc>(context);
    apiBloc.add(FetchDataEvent());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brand'),
      ),
      body: Center(
        child: BlocBuilder<ApiBloc, ApiState>(
          builder: (context, state) {
            if (state.data.isNotEmpty) {
              final List<Map<String, String>> data = state.data;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  return Center(
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: SizedBox(
                        height: 150,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                item['logo']!,
                                width: 60,
                                height: 60,
                              ),
                              const SizedBox(height: 8), // ระยะห่างระหว่าง logo และ font
                              Text(
                                item['name']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            if (item['name'] == 'Apple') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ApplePage(),
                                ),
                              );
                            } else if (item['name'] == 'Samsung') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SamsungPage(),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state.data.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Text("Error occurred!");
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ShoppingCartPage()),
          );
        },
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
