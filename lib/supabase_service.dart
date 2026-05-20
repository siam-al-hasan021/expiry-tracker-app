import 'package:supabase_flutter/supabase_flutter.dart';
import 'product.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  // ✅ ADD PRODUCT
  Future<void> addProduct(Product product) async {
    final user = supabase.auth.currentUser;

    await supabase.from('products').insert({
      'name': product.name,
      'category': product.category,
      'expiry': product.expiryDate,
      'user_id': user!.id,
    });
  }

  // ✅ FETCH PRODUCTS
  Future<List<Product>> fetchProducts() async {
    final user = supabase.auth.currentUser;

    final data = await supabase
        .from('products')
        .select()
        .eq('user_id', user!.id)
        .order('created_at', ascending: false);

    return (data as List)
        .map(
          (item) => Product(
            id: item['id'],
            name: item['name'],
            category: item['category'],
            expiryDate: item['expiry'],
          ),
        )
        .toList();
  }

  // ✅ DELETE PRODUCT
  Future<void> deleteProduct(int id) async {
    await supabase
        .from('products')
        .delete()
        .eq('id', id);
  }

  // ✅ UPDATE PRODUCT
  Future<void> updateProduct(Product product) async {
    await supabase
        .from('products')
        .update({
          'name': product.name,
          'category': product.category,
          'expiry': product.expiryDate,
        })
        .eq('id', product.id!);
  }
}