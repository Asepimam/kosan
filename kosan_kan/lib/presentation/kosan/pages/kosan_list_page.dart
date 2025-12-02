import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KosanListPage extends StatefulWidget {
  final String? filter;
  const KosanListPage({Key? key, this.filter}) : super(key: key);

  @override
  State<KosanListPage> createState() => _KosanListPageState();
}

class _KosanListPageState extends State<KosanListPage> {
  late List<Map<String, String>> _items;
  bool _isLoading = true;
  late List<Map<String, String>> _baseItems;
  int? _filterMinPrice;
  int? _filterMaxPrice;
  final Set<String> _filterFacilities = {};

  @override
  void initState() {
    super.initState();
    // Simulate fetching filtered data
    Future.delayed(const Duration(milliseconds: 500), () {
      final base = List.generate(
        12,
        (i) => {
          'id': '$i',
          'title': 'Kosan ${i + 1}',
          'location': ['UTI', 'CBD', 'Kampus', 'Barat'][i % 4],
          'price': 'Rp${(500 + i * 100)}.000',
          'desc': 'Cozy room with essential amenities',
          'facilities': (i % 2 == 0) ? 'Wi‑Fi,AC,Private' : 'Wi‑Fi,Parking',
        },
      );

      _baseItems = base;
      if (widget.filter != null && widget.filter!.isNotEmpty) {
        _items = base
            .where(
              (b) =>
                  b['title']!.toLowerCase().contains(
                    widget.filter!.toLowerCase(),
                  ) ||
                  b['location']!.toLowerCase().contains(
                    widget.filter!.toLowerCase(),
                  ),
            )
            .toList();
      } else {
        _items = base;
      }

      if (mounted) setState(() => _isLoading = false);
    });
  }

  void _openFilterSheet() async {
    final minController = TextEditingController(
      text: _filterMinPrice != null ? _filterMinPrice.toString() : '',
    );
    final maxController = TextEditingController(
      text: _filterMaxPrice != null ? _filterMaxPrice.toString() : '',
    );
    final facilities = <String>['Wi‑Fi', 'AC', 'Private', 'Parking'];
    final selected = Set<String>.from(_filterFacilities);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: minController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Min price (k)',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: maxController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Max price (k)',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Facilities',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: facilities.map((f) {
                      final isSelected = selected.contains(f);
                      return FilterChip(
                        label: Text(f),
                        selected: isSelected,
                        onSelected: (v) {
                          setSheetState(() {
                            if (v) {
                              selected.add(f);
                            } else {
                              selected.remove(f);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final min = int.tryParse(minController.text);
                          final max = int.tryParse(maxController.text);
                          _applyFilters(min, max, selected);
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _applyFilters(int? min, int? max, Set<String> facilities) {
    _filterMinPrice = min;
    _filterMaxPrice = max;
    _filterFacilities
      ..clear()
      ..addAll(facilities);

    setState(() {
      _items = _baseItems.where((item) {
        final price = _parsePrice(item['price'] ?? '0');
        if (_filterMinPrice != null && price < (_filterMinPrice! * 1000))
          return false;
        if (_filterMaxPrice != null && price > (_filterMaxPrice! * 1000))
          return false;
        if (_filterFacilities.isNotEmpty) {
          final itemFac = (item['facilities'] ?? '')
              .split(',')
              .map((s) => s.trim())
              .toSet();
          if (!_filterFacilities.every((f) => itemFac.contains(f)))
            return false;
        }
        return true;
      }).toList();
    });
  }

  int _parsePrice(String raw) {
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.filter == null || widget.filter!.isEmpty
              ? 'Kosan'
              : 'Kosan: ${widget.filter}',
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black54),
            onPressed: _openFilterSheet,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final item = _items[index];
                final tags = (item['facilities'] ?? '').split(',');
                return InkWell(
                  onTap: () {
                    // navigate to detail and pass the item via extra
                    context.push('/kosan/detail?id=${item['id']}', extra: item);
                  },
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // image / thumbnail
                          Container(
                            width: 96,
                            height: 86,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.home,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // main info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        item['location']!,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['desc'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 13,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    if (tags.isNotEmpty) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          tags[0],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                    if (tags.length > 1) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          tags[1],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                    if (tags.length > 2) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          tags[2],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // price and action — constrain width so row doesn't overflow on small screens
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 110),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item['price']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2AAE9E),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () => context.push(
                                    '/kosan/detail?id=${item['id']}',
                                    extra: item,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2AAE9E),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    minimumSize: const Size(64, 36),
                                  ),
                                  child: const Text(
                                    'View',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: _items.length,
            ),
    );
  }
}
