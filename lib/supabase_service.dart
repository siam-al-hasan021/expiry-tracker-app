import 'package:supabase_flutter/supabase_flutter.dart';
import 'product.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  // 🔹 Add product to database
  Future<void> addProduct(Product product) async {
    await supabase.from('products').insert({
      'name': product.name,
      'category': product.category,
      'expiry': product.expiryDate,
    });
  }

  // 🔹 Fetch all products
  Future<List<Product>> fetchProducts() async {
    final data = await supabase.from('products').select();

    return (data as List)
        .map((item) => Product(
              name: item['name'],
              category: item['category'],
              expiryDate: item['expiry'],
            ))
        .toList();
  }
}