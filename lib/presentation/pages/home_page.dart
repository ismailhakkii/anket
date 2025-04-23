import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math;
import 'dart:ui';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  double _currentPage = 0;
  late AnimationController _animationController;
  
  final List<CardItem> _items = [
    CardItem(
      title: 'Anketler',
      description: 'Tüm anketlerinizi görüntüleyin ve katılımcı oy sonuçlarını takip edin',
      icon: Icons.bar_chart,
      gradient: const LinearGradient(
        colors: [Color(0xFF6448FE), Color(0xFF5FC6FF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      route: '/survey',
    ),
    CardItem(
      title: 'Yeni Anket',
      description: 'Hızlıca yeni bir anket oluşturun ve hedef kitlenizle paylaşın',
      icon: Icons.add_chart,
      gradient: const LinearGradient(
        colors: [Color(0xFFFA7D75), Color(0xFFC23D61)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      route: '/create_survey',
    ),
    CardItem(
      title: 'Karar Çarkı',
      description: 'Karar vermekte zorlanıyorsanız, şansınıza bırakın ve çarkı çevirin',
      icon: Icons.casino,
      gradient: const LinearGradient(
        colors: [Color(0xFFFFB157), Color(0xFFFF6B78)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      route: '/decision',
    ),
    CardItem(
      title: 'Yeni Çark',
      description: 'Özel seçeneklerle kendi karar çarkınızı tasarlayın ve kullanın',
      icon: Icons.add_circle,
      gradient: const LinearGradient(
        colors: [Color(0xFF42E695), Color(0xFF3BB2B8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      route: '/create_decision',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: 0,
    );
    _pageController.addListener(_onPageChanged);
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  void _onPageChanged() {
    setState(() {
      _currentPage = _pageController.page!;
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7F00FF), Color(0xFF9500ff), Color(0xFFE100FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Uygulama başlığı
              FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
                  ),
                ),
                child: const Text(
                  'Anket & Karar Uygulaması',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Alt başlık
              FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
                  ),
                ),
                child: const Text(
                  'Ne yapmak istersiniz?',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ),
              
              const SizedBox(height: 50),
              
              // Ana kartlar bölümü
              Expanded(
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.4, 1.0, curve: Curves.easeOutQuint),
                    ),
                  ),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final scale = 1.0 - (_currentPage - index).abs() * 0.15;
                      final rotate = (_currentPage - index) * 0.05;
                      
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(context, _items[index].route),
                        child: TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0.9, end: 1.0),
                          duration: const Duration(milliseconds: 300),
                          builder: (context, value, child) {
                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(rotate)
                                ..scale(scale * value),
                              child: _buildCard(_items[index]),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Sayfa göstergesi
              _buildPageIndicator(),
              
              const SizedBox(height: 20),
              
              // Alt animasyon
              SizedBox(
                height: 100,
                child: Lottie.asset(
                  'assets/animations/party.json',
                  repeat: true,
                  animate: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(CardItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              gradient: item.gradient,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            ),
            child: Stack(
              children: [
                // Dekoratif baloncuklar
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Positioned(
                  left: -30,
                  top: -30,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                
                // İçerik
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // İkon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          item.icon,
                          size: 42,
                          color: Colors.white,
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Başlık
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Açıklama
                      Text(
                        item.description,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Başla düğmesi
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Başla',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: item.gradient.colors.first,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: item.gradient.colors.first,
                                ),
                              ],
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
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_items.length, (index) {
        return Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage.round() == index
                ? Colors.white
                : Colors.white.withOpacity(0.3),
          ),
        );
      }),
    );
  }
}

class CardItem {
  final String title;
  final String description;
  final IconData icon;
  final LinearGradient gradient;
  final String route;

  CardItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.route,
  });
}
