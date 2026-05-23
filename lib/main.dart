 import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => StoreProvider(),
      child: PurpleStoreApp(),
    ),
  );
}

// --- 1. نموذج المنتج (Model) ---
class Product {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });
}

// --- 2. إدارة الحالة (Store Provider) ---
class StoreProvider with ChangeNotifier {
  UserProfile _userProfile = UserProfile(
    name: 'aya alshogaa ', 
    email: 'ayateea0@gmail.com',
    phone: '7771.....',
  
  );

  UserProfile get userProfile => _userProfile;

  void updateProfile(String newName, String newEmail, String newPhone,) {
    _userProfile.name = newName;
    _userProfile.email = newEmail;
    _userProfile.phone = newPhone;
    notifyListeners(); 
  }
  // قائمة المنتجات المعروضة (بيانات تجريبية)
  final List<Product> _products = [
    Product(id: '1', title: 'MEN WATCH ', price: 35.0, imageUrl: 'assets/images/clo7.jpg'),
    Product(id: '2', title: 'WOMEN WATCH ', price: 28.0, imageUrl: 'assets/images/aya.jpg'),
    Product(id: '3', title: 'Couples rings  ', price: 25.0, imageUrl: 'assets/images/cabb.jpg'),
    Product(id: '4', title: 'couples rings  ', price: 32.0, imageUrl: 'assets/images/cabll.jpg'),
    Product(id: '5', title: '  red roses ', price: 31.0, imageUrl: 'assets/images/red.jpg'),
    Product(id: '6', title: '   flower bouquet', price: 42.0, imageUrl: 'assets/images/rose.jpg'),
    Product(id: '7', title: ' cute toeddy bear  ', price: 12.0, imageUrl: 'assets/images/beer.jpg'),
    Product(id: '8', title: '  bear', price: 23.0, imageUrl: 'assets/images/pink.jpg'),
    Product(id: '9', title: '  CHANEL', price: 32.0, imageUrl: 'assets/images/chan.jpg'),
    Product(id: '10', title: '  LiBRE', price: 45.0, imageUrl: 'assets/images/libr.jpg'),
  ];

  final List<Product> _cart = [];

  List<Product> get products => _products;
  List<Product> get cart => _cart;
  List<Product> get favorites => _products.where((p) => p.isFavorite).toList();

  void toggleFavorite(String id) {
    final index = _products.indexWhere((p) => p.id == id);
    _products[index].isFavorite = !_products[index].isFavorite;
    notifyListeners();
  }

  void addToCart(Product product) {
    _cart.add(product);
    notifyListeners();
  }

  void removeFromCart(String id) {
    _cart.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}

// --- 3. تصميم التطبيق الرئيسي ---
class PurpleStoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Color(0xFFFBF7FF),
      ),
      home: MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}


        class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;
  
  // تأكدي أن القائمة تحتوي على الشاشات الأربعة بالترتيب تماماً
  final List<Widget> _screens = [
    HomeScreen(),
    FavoritesScreen(),
    CartScreen(),
    ProfileScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    // حساب عدد المنتجات داخل السلة حالياً لتحديث العداد
    final cartCount = Provider.of<StoreProvider>(context).cart.length;

    return Scaffold(
      body: _screens[_index], // عرض الشاشة الحالية بناءً على الـ index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        type: BottomNavigationBarType.fixed, // يضمن ثبات الأزرار الأربعة تماماً
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          setState(() {
            _index = i; // التنقل الآمن بين المؤشرات (0, 1, 2, 3)
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home), 
            label: "الرئيسية",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite), 
            label: "المفضلة",
          ),
          
          // زر السلة الأصلي بعد دمج العداد داخله بذكاء وبدون تغيير العدد
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('$cartCount', style: const TextStyle(color: Colors.white, fontSize: 10)),
              backgroundColor: Colors.purple,
              isLabelVisible: cartCount > 0, // يظهر الرقم فقط إذا كانت السلة غير فارغة
              child: const Icon(Icons.shopping_cart),
            ),
            label: "السلة",
          ),
          
          const BottomNavigationBarItem(
            icon: Icon(Icons.person), 
            label: "حسابي",
          ),
        ],
      ),
    );
  }
}
        
      
    
  


// --- 4. واجهة المتجر (الرئيسية) ---
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("  kindness- sections"), centerTitle: true, backgroundColor: const Color.fromARGB(255, 217, 141, 231)),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: store.products.length,
        itemBuilder: (ctx, i) => ProductCard(product: store.products[i]),
      ),
    );
  }
}

// كرت المنتج مع زر المفضلة والسلة
class ProductCard extends StatelessWidget {
  final Product product;
  ProductCard({required this.product});
 @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context, listen: false);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Expanded(child: ClipRRect(borderRadius: BorderRadius.vertical(top: Radius.circular(15)), child: Image.asset(product.imageUrl, fit: BoxFit.cover))),
          Text(product.title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text("${product.price} \$", style: TextStyle(color: Colors.purple)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                onPressed: () => store.toggleFavorite(product.id),
              ),
              IconButton(
                icon: Icon(Icons.add_shopping_cart, color: Colors.purple),
                onPressed: () => _showConfirmDialog(context, product),
              ),
            ],
          )
        ],
      ),
    );
  }
}
  void _showConfirmDialog(BuildContext context, Product product) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("تأكيد الإضافة", textAlign: TextAlign.right),
      content: Text(
        "هل تريد إضافة ${product.title} إلى السلة؟", 
        textAlign: TextAlign.right,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text("إلغاء", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
          onPressed: () {
            // التعديل هنا: نقوم بالوصول للـ Provider وإضافة المنتج ليزيد العداد فوراً
            Provider.of<StoreProvider>(context, listen: false).addToCart(product);
            Navigator.pop(ctx); // إغلاق نافذة التأكيد
            
            // إشعار سريع للمستخدم في أسفل الشاشة بتحديث السلة
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم إضافة ${product.title} إلى السلة! 🛒', textAlign: TextAlign.center),
                backgroundColor: Colors.purple,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: const Text("إضافة", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

// --- 5. واجهة السلة (كما في IMG-20260429-WA0024.jpg) ---
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("سلة المشتريات"), backgroundColor: Colors.purple),
      body: store.cart.isEmpty
          ? Center(child: Text("سلتك فارغة، ابدأ بالتسوق الآن"))
          : ListView.builder(
              itemCount: store.cart.length,
              itemBuilder: (ctx, i) => ListTile(
                leading: Image.asset(store.cart[i].imageUrl),
                title: Text(store.cart[i].title),
                trailing: IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => store.removeFromCart(store.cart[i].id)),
              ),
            ),
    );
  }
}

// --- 6. واجهة المفضلة (كما في IMG-20260429-WA0016.jpg) ---
class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("منتجاتي المفضلة"), backgroundColor: Colors.purple),
      body: store.favorites.isEmpty
          ? Center(child: Text("لا توجد منتجات في المفضلة"))
          : ListView.builder(
              itemCount: store.favorites.length,
              itemBuilder: (ctx, i) => ListTile(
                leading: CircleAvatar(backgroundImage: AssetImage(store.favorites[i].imageUrl)),
                title: Text(store.favorites[i].title),
                subtitle: Text("${store.favorites[i].price} \$"),
                trailing: Icon(Icons.favorite, color: Colors.red),
              ),
            ),
    );
    
}
}
 // ==========================================
// 1. واجهة الحساب الشخصي (توضع في نهاية الملف)
// ==========================================
 class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    final user = store.userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('حسابي الشخصي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.purple.shade100,
                child: const Icon(Icons.person, size: 50, color: Colors.purple),
              ),
            ),
            const SizedBox(height: 30),
            _buildProfileCard('name ', user.name, Icons.person_outline),
            _buildProfileCard('gmail ', user.email, Icons.email_outlined),
            _buildProfileCard('phone number ', user.phone, Icons.phone_android),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => _showEditDialog(context, store, user),
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text('تعديل البيانات', style: TextStyle(color: Colors.white, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 209, 154, 219),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        trailing: Icon(icon, color: Colors.purple),
        title: Text(title, textAlign: TextAlign.right, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        subtitle: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
      ),
    );
  }

  void _showEditDialog(BuildContext context, StoreProvider store, UserProfile user) {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل بيانات الحساب', textAlign: TextAlign.center, style: TextStyle(color: Colors.purple)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'الاسم'), textAlign: TextAlign.left),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'البريد الإلكتروني'), textAlign: TextAlign.left),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'رقم الهاتف'), textAlign: TextAlign.left),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
store.updateProfile(nameController.text, emailController.text, phoneController.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تحديث حسابك بنجاح! 🎉', textAlign: TextAlign.center), backgroundColor: Colors.purple),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('حفظ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 2. كلاس هيكل البيانات (تحت الواجهة مباشرة)
// ==========================================
class UserProfile {
  String name;
  String email;
  String phone;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
  });
}
  

