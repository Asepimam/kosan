import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kosan_kan/data/local/app_prefrence.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      "title": "Kosan Kan — Cari Kos, Gampangkan Hari",
      "body":
          "Cari kos kece dekat kampus atau kerja cuma pakai swipe. Lihat fasilitas, bandingkan harga, dan booking tanpa ribet.",
      "image": "assets/images/image_1.png",
    },
    {
      "title": "Bayar Cepat, Bebas Ribet",
      "body":
          "Pilih metode pembayaran: Virtual Account, e‑wallet, atau QRIS. Simpan QR sebagai bukti, semua tercatat rapi.",
      "image": "assets/images/image_2.png",
    },
    {
      "title": "Fitur untuk Anak Gen‑Z",
      "body":
          "Filter harga & fasilitas, favoritkan kos, dan dapat rekomendasi sesuai gaya hidupmu — semua di satu aplikasi.",
      "image": "assets/images/image_4.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(
          0xFFFAFAFA,
        ), // Same background color as the login form
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _slides.length,
              itemBuilder: (context, index) {
                final slide = _slides[index];
                return Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          flex: 1, // Half the screen for the image
                          child: Image.asset(
                            slide["image"]!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Expanded(
                          flex: 1, // Half the screen for the text content
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  slide["title"]!,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  slide["body"]!,
                                  style: const TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text("Back"),
                    )
                  else
                    const SizedBox(),
                  Row(
                    children: List.generate(
                      _slides.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 12 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.blue
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (_currentPage == _slides.length - 1) {
                        await AppPrefrence.markIntroductionSeen();
                        await Future.delayed(
                          Duration.zero,
                        ); // Ensure context is used synchronously
                        context.go('/auth/login');
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(
                      _currentPage == _slides.length - 1 ? "Done" : "Next",
                    ),
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
