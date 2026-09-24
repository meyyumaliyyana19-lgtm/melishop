import 'package:flutter/material.dart';

void main() {
  runApp(const MeliShopApp());
}

class MeliShopApp extends StatelessWidget {
  const MeliShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MELI SHOP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFF0F5),
        primaryColor: const Color(0xFFE91E63),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE91E63),
          primary: const Color(0xFFE91E63),
          secondary: const Color(0xFFFF69B4),
        ),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

// Model Data Produk
class Product {
  final String id;
  final String name;
  final double price;
  final String imagePath;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
  });
}

// Model Data Keranjang
class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // Daftar Produk Menggunakan Gambar Lokal dari Folder Assets
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'FaceWash G2G',
      price: 45500,
      imagePath: 'assets/facewash.png',
    ),
    Product(
      id: '2',
      name: 'Micellar G2G',
      price: 40000,
      imagePath: 'assets/micellar.png',
    ),
    Product(
      id: '3',
      name: 'LipSerum G2G',
      price: 47000,
      imagePath: 'assets/lipserum.png',
    ),
    Product(
      id: '4',
      name: 'Moisturaizer G2G',
      price: 41500,
      imagePath: 'assets/moisturizer.png',
    ),
  ];

  late List<CartItem> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = [
      CartItem(product: _products[2], quantity: 1),
      CartItem(product: _products[3], quantity: 1),
    ];
  }

  int get _totalCartItems =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  String _formatRupiah(double amount) {
    return 'Rp ${amount.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  void _addToCart(Product product) {
    setState(() {
      final index =
          _cartItems.indexWhere((item) => item.product.id == product.id);
      if (index >= 0) {
        _cartItems[index].quantity++;
      } else {
        _cartItems.add(CartItem(product: product, quantity: 1));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} berhasil ditambahkan!'),
        backgroundColor: const Color(0xFFE91E63),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(
        products: _products,
        cartCount: _totalCartItems,
        onAddToCart: _addToCart,
        onOpenCart: () => setState(() => _selectedIndex = 2),
        formatRupiah: _formatRupiah,
      ),
      const CategoryScreen(),
      CartScreen(
        cartItems: _cartItems,
        formatRupiah: _formatRupiah,
        onIncrement: (index) => setState(() => _cartItems[index].quantity++),
        onDecrement: (index) {
          setState(() {
            if (_cartItems[index].quantity > 1) {
              _cartItems[index].quantity--;
            }
          });
        },
        onRemove: (index) => setState(() => _cartItems.removeAt(index)),
        onBackToHome: () => setState(() => _selectedIndex = 0),
      ),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: const Color(0xFFFFD1DC),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_outlined, 'Beranda'),
            _buildNavItem(1, Icons.grid_view, 'Kategori'),
            _buildNavItem(2, Icons.shopping_cart_outlined, 'Keranjang',
                badgeCount: _totalCartItems),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label,
      {int badgeCount = 0}) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            badgeCount > 0
                ? Badge.count(
                    count: badgeCount,
                    backgroundColor: const Color(0xFFE91E63),
                    child: Icon(icon,
                        color: isSelected
                            ? const Color(0xFFE91E63)
                            : Colors.grey[600],
                        size: 22),
                  )
                : Icon(icon,
                    color: isSelected
                        ? const Color(0xFFE91E63)
                        : Colors.grey[600],
                    size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFFE91E63) : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter Garis Gelombang Biru
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2196F3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
        size.width * 0.25, size.height * 0.9, size.width * 0.5, size.height * 0.5);
    path.quadraticBezierTo(
        size.width * 0.75, 0, size.width, size.height * 0.6);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// 1. HALAMAN BERANDA (HOME)
// ---------------------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  final List<Product> products;
  final int cartCount;
  final Function(Product) onAddToCart;
  final VoidCallback onOpenCart;
  final String Function(double) formatRupiah;

  const HomeScreen({
    super.key,
    required this.products,
    required this.cartCount,
    required this.onAddToCart,
    required this.onOpenCart,
    required this.formatRupiah,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'MELI SHOP',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE91E63),
                      letterSpacing: 0.5,
                    ),
                  ),
                  IconButton(
                    icon: Badge.count(
                      count: cartCount,
                      isLabelVisible: cartCount > 0,
                      backgroundColor: const Color(0xFFE91E63),
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Color(0xFFE91E63),
                        size: 28,
                      ),
                    ),
                    onPressed: onOpenCart,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CustomPaint(
                size: const Size(double.infinity, 20),
                painter: WavePainter(),
              ),
            ],
          ),
        ),

        // Grid Produk
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      width: 105,
                      height: 105,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFDE4ED),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          product.imagePath,
                          width: 105,
                          height: 105,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.sanitizer_rounded,
                              size: 48,
                              color: Colors.pink[300],
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatRupiah(product.price),
                      style: const TextStyle(
                        color: Color(0xFFE91E63),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 120,
                      height: 34,
                      child: ElevatedButton.icon(
                        onPressed: () => onAddToCart(product),
                        icon: const Icon(Icons.shopping_cart_outlined,
                            size: 14),
                        label: const Text(
                          'Tambah',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFDE4ED),
                          foregroundColor: const Color(0xFFE91E63),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 2. HALAMAN KERANJANG BELANJA (CART)
// ---------------------------------------------------------------------------
class CartScreen extends StatelessWidget {
  final List<CartItem> cartItems;
  final String Function(double) formatRupiah;
  final Function(int) onIncrement;
  final Function(int) onDecrement;
  final Function(int) onRemove;
  final VoidCallback onBackToHome;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.formatRupiah,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.onBackToHome,
  });

  @override
  Widget build(BuildContext context) {
    double subtotal = 0;
    for (var item in cartItems) {
      subtotal += item.product.price * item.quantity;
    }
    double ongkir = 0;
    double totalPembayaran = subtotal + ongkir;

    int totalItemCount = cartItems.fold(0, (sum, item) => sum + item.quantity);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFFE91E63)),
                onPressed: onBackToHome,
              ),
              const SizedBox(width: 8),
              const Text(
                'Keranjang Belanja',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE91E63),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: cartItems.isEmpty
              ? const Center(
                  child: Text(
                    'Keranjang Belanja Kosong',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 55,
                            height: 55,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFDE4ED),
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                item.product.imagePath,
                                width: 55,
                                height: 55,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatRupiah(item.product.price),
                                  style: const TextStyle(
                                    color: Color(0xFFE91E63),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDE4ED),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () => onDecrement(index),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: Icon(Icons.remove,
                                        size: 16, color: Color(0xFFE91E63)),
                                  ),
                                ),
                                Text(
                                  '${item.quantity} x',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE91E63),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => onIncrement(index),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: Icon(Icons.add,
                                        size: 16, color: Color(0xFFE91E63)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Color(0xFFE91E63), size: 20),
                            onPressed: () => onRemove(index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),

        // Rincian Pembayaran
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDE4ED),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.bookmark_border,
                            size: 16, color: Color(0xFFE91E63)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Subtotal ($totalItemCount Item)',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    formatRupiah(subtotal),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE91E63),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ongkos Kirim',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                  Text(
                    formatRupiah(ongkir),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Pembayaran',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    formatRupiah(totalPembayaran),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE91E63),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Proses Checkout Berhasil!'),
                        backgroundColor: Color(0xFFE91E63),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_bag_outlined,
                      color: Colors.white),
                  label: const Text(
                    'Checkout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF2A6D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 3. HALAMAN KATEGORI
// ---------------------------------------------------------------------------
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Kategori',
        style: TextStyle(color: Color(0xFFE91E63), fontSize: 16),
      ),
    );
  }
}