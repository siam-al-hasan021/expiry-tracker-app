import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login_screen.dart';
import 'add_product_screen.dart';
import 'product.dart';
import 'supabase_service.dart';
import 'notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tdmvjfqurzbpfdvovali.supabase.co',
    anonKey: 'sb_publishable_3969sn8jWgq1lEn25Y3qDQ_o9RnpB8y',
  );

  await NotificationService.initialize();

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
      theme: ThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.deepPurple,
      ),
      home: Supabase.instance.client.auth.currentUser == null
          ? const LoginScreen()
          : HomeScreen(
              toggleTheme: toggleTheme,
              isDark: isDark,
            ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDark;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.isDark,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseService service = SupabaseService();

  List<Product> products = [];
  List<Product> filteredProducts = [];

  final TextEditingController searchController =
      TextEditingController();

  Color getExpiryColor(String expiryDate) {
    final expiry = DateTime.parse(expiryDate);
    final today = DateTime.now();

    final daysLeft = expiry.difference(today).inDays;

    if (daysLeft < 0) {
      return Colors.red;
    } else if (daysLeft <= 7) {
      return Colors.orange;
    }

    return Colors.green;
  }

  String getExpiryStatus(String expiryDate) {
    final expiry = DateTime.parse(expiryDate);
    final today = DateTime.now();

    final daysLeft = expiry.difference(today).inDays;

    if (daysLeft < 0) {
      return "Expired";
    } else if (daysLeft <= 7) {
      return "$daysLeft day(s) left";
    }

    return "Safe";
  }

  Future<void> checkExpiryNotifications(
      List<Product> products) async {
    for (final product in products) {
      final expiry =
          DateTime.parse(product.expiryDate);

      final daysLeft = expiry
          .difference(DateTime.now())
          .inDays;

      if (daysLeft >= 0 &&
          daysLeft <= 7) {
        await NotificationService.showNotification(
          title: 'Expiry Warning',
          body:
              '${product.name} expires in $daysLeft day(s)',
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    loadProducts();

    searchController.addListener(() {
      filterProducts();
    });
  }

  Future<void> loadProducts() async {
    final data =
        await service.fetchProducts();

    setState(() {
      products = data;
      filteredProducts = data;
    });

    await checkExpiryNotifications(data);
  }

  Future<void> addProduct(
      Product product) async {
    await service.addProduct(product);

    loadProducts();
  }

  Future<void> deleteProduct(
      int id) async {
    await service.deleteProduct(id);

    loadProducts();
  }

  Future<void> editProduct(
      Product oldProduct) async {
    final nameController =
        TextEditingController(
      text: oldProduct.name,
    );

    final categoryController =
        TextEditingController(
      text: oldProduct.category,
    );

    final expiryController =
        TextEditingController(
      text: oldProduct.expiryDate,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Edit Product",
          ),
          content:
              SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller:
                      nameController,
                  decoration:
                      const InputDecoration(
                    labelText:
                        "Product Name",
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                TextField(
                  controller:
                      categoryController,
                  decoration:
                      const InputDecoration(
                    labelText:
                        "Category",
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                TextField(
                  controller:
                      expiryController,
                  decoration:
                      const InputDecoration(
                    labelText:
                        "Expiry Date",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context);
              },
              child: const Text(
                "Cancel",
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                final updatedProduct =
                    Product(
                  id: oldProduct.id,
                  name:
                      nameController
                          .text,
                  category:
                      categoryController
                          .text,
                  expiryDate:
                      expiryController
                          .text,
                );

                await service
                    .updateProduct(
                  updatedProduct,
                );

                Navigator.pop(
                    context);

                loadProducts();
              },
              child:
                  const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void filterProducts() {
    String query =
        searchController.text
            .toLowerCase();

    setState(() {
      filteredProducts =
          products.where((p) {
        return p.name
                .toLowerCase()
                .contains(query) ||
            p.category
                .toLowerCase()
                .contains(query);
      }).toList();
    });
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth
        .signOut();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const AddProductScreen(),
            ),
          );

          if (result != null) {
            addProduct(result);
          }
        },
      ),

      body: Stack(
        children: [
          // 🌄 BACKGROUND
          Positioned.fill(
            child: Image.asset(
              'assets/images/expn3.png',
              fit: BoxFit.cover,
            ),
          ),

          // 🌑 OVERLAY
          Positioned.fill(
            child: Container(
              color: widget.isDark
                  ? Colors.black.withOpacity(0.7)
                  : Colors.white.withOpacity(0.7),
            ),
          ),

          // 📱 UI
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 🔝 HEADER
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Expiry Tracker",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Row(
                        children: [
                          IconButton(
                            onPressed:
                                widget.toggleTheme,
                            icon: Icon(
                              widget.isDark
                                  ? Icons.light_mode
                                  : Icons.dark_mode,
                            ),
                          ),

                          IconButton(
                            onPressed: logout,
                            icon: const Icon(
                              Icons.logout,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🔍 SEARCH BAR
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(
                        0.2,
                      ),
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: TextField(
                      controller: searchController,
                      style: TextStyle(
                        color: widget.isDark
                            ? Colors.white
                            : Colors.black,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            "Search products...",
                        hintStyle: TextStyle(
                          color: widget.isDark
                              ? Colors.white70
                              : Colors.black54,
                        ),
                        icon: Icon(
                          Icons.search,
                          color: widget.isDark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 📊 INFO CARD
                  AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 500,
                    ),
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(25),
                      gradient:
                          const LinearGradient(
                        colors: [
                          Color(0xFF7C3AED),
                          Color(0xFF3B82F6),
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.inventory_2,
                          size: 45,
                          color: Colors.white,
                        ),

                        const SizedBox(width: 15),

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            const Text(
                              "Tracked Products",
                              style: TextStyle(
                                fontSize: 18,
                                color:
                                    Colors.white70,
                              ),
                            ),

                            Text(
                              "${products.length}",
                              style:
                                  const TextStyle(
                                fontSize: 28,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 📦 PRODUCT LIST
                  Expanded(
                    child: filteredProducts.isEmpty
                        ? const Center(
                            child: Text(
                              "No products found",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount:
                                filteredProducts.length,
                            itemBuilder:
                                (context, index) {
                              final p =
                                  filteredProducts[index];

                              final statusColor =
                                  getExpiryColor(
                                      p.expiryDate);

                              final statusText =
                                  getExpiryStatus(
                                      p.expiryDate);

                              return Container(
                                margin:
                                    const EdgeInsets.only(
                                  bottom: 15,
                                ),
                                padding:
                                    const EdgeInsets.all(
                                  16,
                                ),
                                decoration:
                                    BoxDecoration(
                                  color: statusColor
                                      .withOpacity(
                                    0.15,
                                  ),
                                  borderRadius:
                                      BorderRadius
                                          .circular(20),
                                  border: Border.all(
                                    color: statusColor,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // 📦 ICON
                                    Container(
                                      padding:
                                          const EdgeInsets
                                              .all(12),
                                      decoration:
                                          BoxDecoration(
                                        color: Colors
                                            .deepPurple
                                            .withOpacity(
                                          0.3,
                                        ),
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          15,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.inventory,
                                        size: 30,
                                      ),
                                    ),

                                    const SizedBox(
                                      width: 15,
                                    ),

                                    // 📄 INFO
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          Text(
                                            p.name,
                                            style:
                                                const TextStyle(
                                              fontSize: 18,
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 5,
                                          ),

                                          Text(
                                            p.category,
                                          ),

                                          const SizedBox(
                                            height: 5,
                                          ),

                                          Text(
                                            "Expiry: ${p.expiryDate}",
                                          ),

                                          const SizedBox(
                                            height: 5,
                                          ),

                                          Text(
                                            statusText,
                                            style:
                                                TextStyle(
                                              color:
                                                  statusColor,
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // ✏ EDIT
                                    IconButton(
                                      onPressed: () {
                                        editProduct(p);
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color:
                                            Colors.blue,
                                      ),
                                    ),

                                    // 🗑 DELETE
                                    IconButton(
                                      onPressed: () {
                                        deleteProduct(
                                          p.id!,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors
                                            .redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}