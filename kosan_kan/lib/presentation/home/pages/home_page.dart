import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kosan_kan/l10n/app_localizations.dart';
import '../../shared/widgets/skeleton_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _featuredController = PageController(
    viewportFraction: 0.88,
  );
  int _featuredPage = 0;
  final Set<int> _liked = {};
  bool _isLoading = true;

  final List<Map<String, String>> _featured = [
    {
      'title': 'Cozy Minimalist Kosan',
      'subtitle': 'Near campus • AC • Fast Wi‑Fi',
      'price': 'Rp1.200.000',
    },
    {
      'title': 'Kosan Aesthetic Loft',
      'subtitle': 'Natural light • Study-friendly',
      'price': 'Rp1.450.000',
    },
    {
      'title': 'Budget Friendly',
      'subtitle': 'Shared kitchen • Community vibes',
      'price': 'Rp850.000',
    },
  ];

  final List<Map<String, String>> _rooms = List.generate(
    6,
    (i) => {
      'title': 'Kamar ${i + 1}',
      'location': 'Kawasan ${['UTI', 'CBD', 'Kampus', 'Barat'][i % 4]}',
      'price': '${(700 + i * 150)}k',
    },
  );

  @override
  void initState() {
    super.initState();
    _featuredController.addListener(() {
      final p = _featuredController.page ?? 0.0;
      setState(() => _featuredPage = p.round());
    });
    // simulate initial loading state (replace with real API call)
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _featuredController.dispose();
    super.dispose();
  }

  Color get accent => const Color(0xFF2AAE9E);

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        children: [
          Text(
            'KosanKan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: accent,
            ),
          ),
          const Spacer(),
          CircleAvatar(
            radius: 18,
            backgroundColor: accent,
            child: const Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        color: theme.colorScheme.surface,
        elevation: 1,
        borderRadius: BorderRadius.circular(12),
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Cari kosan, area, atau fasilitas',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onSubmitted: (q) {
            // TODO: wire search
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Searching: $q')));
          },
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final theme = Theme.of(context);
    final cats = ['All', 'Near Campus', 'Budget', 'Luxury', 'Study Room'];
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final active = index == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: active ? accent : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: accent.withOpacity(0.15),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                cats[index],
                style: TextStyle(
                  color: active
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: cats.length,
      ),
    );
  }

  Widget _buildFeatured() {
    final theme = Theme.of(context);
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _featuredController,
        itemCount: _featured.length,
        itemBuilder: (context, index) {
          final item = _featured[index];
          final bool active = index == _featuredPage;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            margin: EdgeInsets.only(
              right: 12,
              left: index == 0 ? 16 : 0,
              top: active ? 0 : 8,
              bottom: active ? 0 : 8,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accent.withOpacity(0.95), accent.withOpacity(0.7)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                // navigate to kosan list filtered by this featured item
                final filter = Uri.encodeQueryComponent(item['title']!);
                context.push('/kosan?filter=$filter');
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onPrimary.withOpacity(
                              0.14,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item['price']!,
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      item['title']!,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['subtitle']!,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary.withOpacity(0.9),
                      ),
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

  Widget _buildFeaturedSkeleton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: featuredSkeletonRow(),
    );
  }

  Widget _buildRoomCard(int index) {
    final room = _rooms[index];
    final liked = _liked.contains(index);
    return GestureDetector(
      onTap: () {
        // navigate to kosan detail, pass room as extra
        final item = {
          'id': '$index',
          'title': room['title']!,
          'location': room['location']!,
          'price': room['price']!,
          'desc': 'Detail for ${room['title']!}',
        };
        context.push('/kosan/detail?id=$index', extra: item);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 110,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.06),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Icon(
                      Icons.bed,
                      size: 56,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.45),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: InkWell(
                      onTap: () => setState(
                        () => liked ? _liked.remove(index) : _liked.add(index),
                      ),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surface.withOpacity(0.9),
                        child: Icon(
                          liked ? Icons.favorite : Icons.favorite_border,
                          color: liked
                              ? accent
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.7),
                          size: 18,
                        ),
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
                    room['title']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        room['location']!,
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          room['price']!,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(),
            const SizedBox(height: 6),
            _buildSearch(),
            const SizedBox(height: 12),
            _buildCategories(),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _isLoading ? _buildFeaturedSkeleton() : _buildFeatured(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context).t('recommended'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => context.push('/kosan'),
                    child: Text(
                      AppLocalizations.of(context).t('see_all'),
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _isLoading
                    ? gridSkeleton(context, count: 4)
                    : GridView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.72,
                            ),
                        itemCount: _rooms.length,
                        itemBuilder: (context, index) => _buildRoomCard(index),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
