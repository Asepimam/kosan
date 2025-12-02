import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kosan_kan/l10n/app_localizations.dart';
import '../../shared/widgets/skeleton_widgets.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  bool _isLoading = true;

  List<Map<String, String>> _favorites = [
    {
      'title': 'Cozy Minimalist Kosan',
      'location': 'Kampus Barat',
      'price': 'Rp1.200.000',
    },
    {'title': 'Aesthetic Loft', 'location': 'Downtown', 'price': 'Rp1.450.000'},
    {'title': 'Studio View', 'location': 'CBD', 'price': 'Rp1.000.000'},
  ];

  Color get accent => const Color(0xFF2AAE9E);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  void _removeFavorite(int index) {
    final removed = _favorites[index];
    setState(() => _favorites.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(
            context,
          ).t('removed_item', params: {'title': removed['title'] ?? ''}),
        ),
        action: SnackBarAction(
          label: AppLocalizations.of(context).t('undo'),
          onPressed: () {
            setState(() => _favorites.insert(index, removed));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accent.withOpacity(0.95), accent.withOpacity(0.72)],
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    AppLocalizations.of(context).t('favorites_title'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Filter coming soon')),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.filter_list, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: _isLoading
                    ? gridSkeleton(context, count: 4)
                    : _favorites.isEmpty
                    ? _buildEmptyState()
                    : GridView.builder(
                        padding: const EdgeInsets.only(bottom: 12, top: 6),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.7,
                            ),
                        itemCount: _favorites.length,
                        itemBuilder: (context, index) {
                          final item = _favorites[index];
                          return _buildFavCard(item, index);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavCard(Map<String, String> item, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.08),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.home_work,
                      size: 48,
                      color: accent.withOpacity(0.9),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: InkWell(
                    onTap: () => _removeFavorite(index),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white70,
                      child: Icon(Icons.favorite, color: accent),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      item['location']!,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const Spacer(),
                    Flexible(
                      child: Text(
                        item['price']!,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: accent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '♡',
            style: TextStyle(fontSize: 64, color: accent.withOpacity(0.9)),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context).t('no_favorites'),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).t('save_instruction'),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () => context.push('/kosan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
              child: Text(AppLocalizations.of(context).t('explore_button')),
            ),
          ),
        ],
      ),
    );
  }
}
