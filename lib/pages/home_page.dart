import 'package:flutter/material.dart';
import '../models/amiibo_model.dart';
import '../services/api_service.dart';
import '../services/favorite_service.dart';
import 'detail_page.dart';
import 'favorite_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Amiibo> _amiibos = [];
  List<Amiibo> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Tidak set loading true di sini agar tidak flickering saat refresh dari detail
    try {
      final amiibos = await ApiService.getAllAmiibo();
      final favorites = await FavoriteService.getFavorites();
      if (mounted) {
        setState(() {
          _amiibos = amiibos;
          _favorites = favorites;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _toggleFavorite(Amiibo amiibo) async {
    final isFav = await FavoriteService.isFavorite(amiibo);
    if (isFav) {
      await FavoriteService.removeFavorite(amiibo);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from favorites'), duration: Duration(seconds: 1)),
        );
      }
    } else {
      await FavoriteService.addFavorite(amiibo);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to favorites'), duration: Duration(seconds: 1)),
        );
      }
    }
    _loadData(); // Refresh list untuk update icon
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nintendo Amiibo List', // Sesuai mockup
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      // Switch body content based on index
      body: _currentIndex == 0 ? _buildHomeContent() : const FavoritePage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 0) _loadData(); // Refresh data saat kembali ke home
        },
        selectedItemColor: Colors.red,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator()); // [cite: 14] Loading State
    }

    if (_amiibos.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _amiibos.length,
        itemBuilder: (context, index) {
          final amiibo = _amiibos[index];
          // Cek manual karena object references berbeda
          final isFavorite = _favorites.any(
            (fav) => fav.head == amiibo.head && fav.tail == amiibo.tail,
          );

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(amiibo: amiibo),
                  ),
                ).then((_) => _loadData()); // Refresh saat kembali
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Gambar
                    Hero(
                      tag: 'amiibo-${amiibo.head}-${amiibo.tail}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          amiibo.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Teks
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            amiibo.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            amiibo.gameSeries,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Icon Love
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () => _toggleFavorite(amiibo),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}