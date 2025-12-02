import 'package:flutter/material.dart';
import '../../shared/widgets/skeleton_widgets.dart';

class BookedPage extends StatefulWidget {
  const BookedPage({Key? key}) : super(key: key);

  @override
  State<BookedPage> createState() => _BookedPageState();
}

class _BookedPageState extends State<BookedPage> {
  final List<Map<String, dynamic>> _bookings = List.generate(
    4,
    (i) => {
      'id': i + 1,
      'title': [
        'Cozy Minimalist Kosan',
        'Aesthetic Loft',
        'Budget Room',
        'Studio View',
      ][i % 4],
      'dates': '01/12/2025 - 31/12/2025',
      'price': 'Rp${(900 + i * 150)}.000',
      'status': i % 3 == 0
          ? 'Confirmed'
          : (i % 3 == 1 ? 'Pending' : 'Cancelled'),
    },
  );

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // simulate loading
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  Color get accent => const Color(0xFF2AAE9E);

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
    // simulate update: shuffle statuses
    setState(() {
      for (int i = 0; i < _bookings.length; i++) {
        if (_bookings[i]['status'] != 'Cancelled') {
          _bookings[i]['status'] = (i % 2 == 0) ? 'Confirmed' : 'Pending';
        }
      }
    });
  }

  void _cancelBooking(int id) {
    setState(() {
      final idx = _bookings.indexWhere((b) => b['id'] == id);
      if (idx != -1) _bookings[idx]['status'] = 'Cancelled';
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Booking cancelled')));
  }

  Widget _statusChip(String status) {
    final theme = Theme.of(context);
    Color bg;
    Color fg = theme.colorScheme.onSecondary;
    switch (status) {
      case 'Confirmed':
        bg = theme.colorScheme.secondary;
        fg = theme.colorScheme.onSecondary;
        break;
      case 'Pending':
        bg = Colors.orange;
        fg = Colors.white;
        break;
      case 'Cancelled':
      default:
        bg = theme.colorScheme.onSurface.withOpacity(0.12);
        fg = theme.colorScheme.onSurface;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: fg, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> b) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
      child: Row(
        children: [
          // image placeholder
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.06),
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.bed,
                size: 40,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          b['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      _statusChip(b['status']),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    b['dates'],
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          b['price'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (b['status'] != 'Cancelled') ...[
                        TextButton.icon(
                          onPressed: () {
                            // chat owner (placeholder)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Open chat')),
                            );
                          },
                          icon: const Icon(Icons.chat_bubble_outline, size: 16),
                          label: const Text(
                            'Chat',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        const SizedBox(width: 4),
                        TextButton(
                          onPressed: () => _cancelBooking(b['id']),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ] else ...[
                        TextButton(
                          onPressed: null,
                          child: const Text(
                            'No actions',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: _isLoading
              ? listCardSkeleton(context, count: 3)
              : (_bookings.isEmpty
                    ? ListView(
                        children: [
                          const SizedBox(height: 120),
                          Center(
                            child: Icon(
                              Icons.event_busy,
                              size: 84,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Center(
                            child: Text(
                              'No bookings yet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Center(
                            child: Text(
                              'Start exploring kosan and book your favorite place!',
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 12, bottom: 16),
                        itemCount: _bookings.length,
                        itemBuilder: (context, index) =>
                            _buildBookingCard(_bookings[index]),
                      )),
        ),
      ),
    );
  }
}
