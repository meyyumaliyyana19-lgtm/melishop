import 'package:flutter/foundation.dart';

// Model Produk
class Product {
  final String id;
  final String title;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });
}

// Model Item Keranjang
class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });
}

// Model Transaksi
class Purchase {
  final String id;
  final List<CartItem> items;
  final DateTime date;
  final double total;

  Purchase({
    required this.id,
    required this.items,
    required this.date,
    required this.total,
  });
}

class ShopProvider with ChangeNotifier {
  // Daftar Produk Utama MELI SHOP
  final List<Product> _products = [
    Product(
      id: 'p1',
      title: 'FaceWash G2G',
      price: 45500,
      imageUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=300',
    ),
    Product(
      id: 'p2',
      title: 'Micellar G2G',
      price: 40000,
      imageUrl: 'https://images.unsplash.com/photo-1608248597260-60298a000676?w=300',
    ),
    Product(
      id: 'p3',
      title: 'LipSerum G2G',
      price: 47000,
      imageUrl: 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=300',
    ),
    Product(
      id: 'p4',
      title: 'Moisturaizer G2G',
      price: 41500,
      imageUrl: 'https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?w=300',
    ),
  ];

  final List<CartItem> _cartItems = [];
  final List<Purchase> _history = [];

  // Getters
  List<Product> get products => [..._products];
  List<CartItem> get cartItems => [..._cartItems];
  List<Purchase> get history => [..._history];

  int get itemCount => _cartItems.length;

  double get subtotal {
    double total = 0.0;
    for (var item in _cartItems) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  // Fungsi Tambah Produk
  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  // Fungsi Edit Produk
  void editProduct(String id, String title, double price, String imageUrl) {
    final index = _products.indexWhere((p) => p.id == id);
    if (index >= 0) {
      _products[index] = Product(
        id: id,
        title: title,
        price: price,
        imageUrl: imageUrl,
      );
      notifyListeners();
    }
  }

  // Fungsi Hapus Produk
  void deleteProduct(String id) {
    _products.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  // Fungsi Tambah Ke Keranjang
  void addToCart(Product product) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(CartItem(product: product));
    }
    notifyListeners();
  }

  // Fungsi Kurangi Jumlah Item
  void reduceFromCart(String productId) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  // Fungsi Hapus dari Keranjang
  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  // Fungsi Checkout
  void checkout() {
    if (_cartItems.isEmpty) return;

    final copiedItems = _cartItems
        .map((item) => CartItem(
              product: item.product,
              quantity: item.quantity,
            ))
        .toList();

    _history.insert(
      0,
      Purchase(
        id: DateTime.now().toString(),
        items: copiedItems,
        date: DateTime.now(),
        total: subtotal,
      ),
    );

    _cartItems.clear();
    notifyListeners();
  }
}