import 'package:flutter/material.dart';
import '../models/amiibo_model.dart';
import '../services/favorite_service.dart';

class DetailPage extends StatefulWidget {
  final Amiibo amiibo;
  const DetailPage({super.key, required this.amiibo});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final isFav = await FavoriteService.isFavorite(widget.amiibo);
    if (mounted) {
      setState(() => _isFavorite = isFav);
    }
  }

  // Menambahkan underscore (_) karena private method
  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await FavoriteService.removeFavorite(widget.amiibo);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from favorites')),
        );
      }
    } else {
      await FavoriteService.addFavorite(widget.amiibo);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to favorites')),
        );
      }
    }
    _checkFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amiibo Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            // FIXED: Menggunakan _toggleFavorite (sesuai nama fungsi)
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Hero
            Hero(
              tag: 'amiibo-${widget.amiibo.head}-${widget.amiibo.tail}',
              child: Container(
                width: double.infinity,
                height: 300,
                color: Colors.grey[100],
                child: Image.network(
                  widget.amiibo.image,
                  fit: BoxFit.contain,
                  // FIXED: Menambahkan parameter (context, error, stackTrace)
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.image_not_supported,
                    size: 100,
                  ),
                ),
              ),
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.amiibo.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.amiibo.character,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[700],
                    ),
                  ),
                  const Divider(height: 32),

                  _buildDetailRow('Game Series', widget.amiibo.gameSeries),
                  _buildDetailRow('Amiibo Series', widget.amiibo.amiiboSeries),
                  _buildDetailRow('Type', widget.amiibo.type),
                  _buildDetailRow('Head', widget.amiibo.head),
                  _buildDetailRow('Tail', widget.amiibo.tail),

                  if (widget.amiibo.release != null) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Release Dates',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...widget.amiibo.release!.entries.map(
                      (entry) => _buildDetailRow(
                        entry.key,
                        entry.value,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          const Text(':  '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}