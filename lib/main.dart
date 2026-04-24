import 'package:flutter/material.dart';
import 'add_product_screen.dart';
import 'product.dart';

void main() {
  runApp(const ExpiryApp());
}

class ExpiryApp extends StatefulWidget {
  const ExpiryApp({super.key});

  @override
  State<ExpiryApp> createState() => _ExpiryAppState();
}

class _ExpiryAppState extends State<ExpiryApp> {
  bool isDark = true;

  void toggleTheme() {
    setState(() {
      isDark = !isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expiry Tracker',
      theme: isDark ? ThemeData.dark() : ThemeData.light(),
      home: HomeScreen(toggleTheme: toggleTheme, isDark: isDark),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDark;

  const HomeScreen(
      {super.key, required this.toggleTheme, required this.isDark});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredProducts = products;

    searchController.addListener(() {
      filterProducts();
    });
  }

  void addProduct(Product product) {
    setState(() {
      products.add(product);
      filterProducts();
    });
  }

  void filterProducts() {
    String query = searchController.text.toLowerCase();

    setState(() {
      filteredProducts = products.where((p) {
        return p.name.toLowerCase().contains(query) ||
            p.category.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.isDark ? const Color(0xFF0F172A) : Colors.grey[200],

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductScreen(),
            ),
          );

          if (result != null) {
            addProduct(result);
          }
        },
        child: const Icon(Icons.add),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔝 Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Expiry Tracker",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: widget.toggleTheme,
                    icon: Icon(
                        widget.isDark ? Icons.light_mode : Icons.dark_mode),
                  )
                ],
              ),

              const SizedBox(height: 15),

              // 🔍 Search
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: "Search products...",
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🎯 Info Card
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.inventory, size: 40),
                    const SizedBox(width: 10),
                    Text("${products.length} items tracked"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: filteredProducts.isEmpty
                    ? const Center(child: Text("No products found"))
                    : ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final p = filteredProducts[index];

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.inventory),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(p.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text("${p.category} • ${p.expiryDate}"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}