import 'package:flutter/material.dart';
import 'package:flutter_novel_app/components/drawer_home.dart';
import 'package:flutter_novel_app/components/novel_placeholder_list.dart';
import 'package:flutter_novel_app/components/nover_terbaru.dart';
import 'package:flutter_novel_app/data/provider/novel_featured_provider.dart';
import 'package:flutter_novel_app/data/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/category_model.dart';
import 'detail_novel_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

    final RefreshController _refreshController = RefreshController();
     @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

   Future<void> _onRefresh() async {
    await Provider.of<NovelFeaturedProvider>(context, listen: false).refresh(null);
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final novelProvider =
          Provider.of<NovelFeaturedProvider>(context, listen: false);
      if (!novelProvider.isFetched) {
        novelProvider.getNovelFeatured();
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.fetchUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('NovelApp'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu), // ikon garis tiga
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer(); // membuka drawer kiri
            },
          )
        ],
      ),
      drawer: EnhancedDrawer(
        email: userProvider.user?.email ?? 'Email Belum Ada',
        profileImageUrl: NetworkImage(
          userProvider.user?.profilePicture != null &&
                  userProvider.user!.profilePicture!.isNotEmpty
              ? 'https://www.mamamnovel.suarafakta.my.id/storage/${userProvider.user!.profilePicture}'
              : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(userProvider.user?.name ?? 'User')}&background=random',
        ),
        username: userProvider.user?.name ?? 'Nama Belum Ada',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section
              _buildHeroSection(context),

              const SizedBox(height: 24),

              // Featured Novels
              Text(
                'Novel Unggulan',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              _buildFeaturedNovels(context),

              // Latest Novels
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Novel Terbaru',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 16),
              _buildLatestNovels(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    // Get screen height to calculate half screen
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Main Hero Container - Set to approximately half screen height
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 10.0),
          child: Center(
            child: Container(
              height: 100, // Approximately half screen height
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/images/hero.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: const [0.2, 0.7, 0.9],
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat datang\ndi dunia novel!',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 4.0,
                            color: Colors.black.withOpacity(0.6),
                            offset: const Offset(2, 3),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Enhanced 3D Floating Book in Top Right Corner
        Positioned(
          top: 15,
          right: 20,
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateY(-0.2)
              ..rotateZ(-0.3),
            alignment: Alignment.center,
            child: Container(
              height: 120,
              width: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  // Book cover with bamboo binding effect
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF355E3B), // Dark green color
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/book.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Overlay gradient for depth
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.transparent,
                          Colors.black.withOpacity(0.2),
                        ],
                        stops: const [0.0, 0.5, 0.9],
                      ),
                    ),
                  ),

                  // Bamboo binding on left side with enhanced 3D effect
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 15,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6DFC8), // Light beige color
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 2,
                            offset: const Offset(1, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          7,
                          (index) => Container(
                            height: 7,
                            width: 12,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD2B48C), // Tan color
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Edge highlight for 3D effect
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    width: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Horizontal lines resembling text with better visibility
                  Positioned(
                    left: 24,
                    right: 10,
                    top: 15,
                    bottom: 15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        5,
                        (index) => Container(
                          height: 3,
                          width: index % 2 == 0 ? 50 : 35,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 1,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Chinese/Japanese characters with enhanced styling
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Transform.rotate(
                      angle: 0.1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 2,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                        child: const Text(
                          '小説',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            shadows: [
                              Shadow(
                                blurRadius: 2.0,
                                color: Colors.black54,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Subtle page edge effect
                  Positioned(
                    left: 15,
                    top: 0,
                    bottom: 0,
                    width: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedNovels(BuildContext context) {
    final novelProvider = Provider.of<NovelFeaturedProvider>(context);
    novelProvider.getNovelFeatured();
    if (novelProvider.isLoading) {
      return const NovelPlaceholderList();
    }

    if (novelProvider.error != null) {
      return SizedBox(
        height: 180,
        child: Center(child: Text('Terjadi error: ${novelProvider.error}')),
      );
    }

    if (novelProvider.dataListfeature.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text('Data kosong')),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: novelProvider.dataListfeature.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final novel = novelProvider.dataListfeature[index];

          return GestureDetector(
            onTap: () {
              print("Navigating to detail screen with novelId: ${novel.id}");

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailNovelScreen(
                    novelId: novel.id,
                  ),
                ),
              );
            },
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(right: 16, top: 4, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 100,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Hero(
                            tag: 'featured_${novel.id}',
                            child: Image.network(
                              'https://www.mamamnovel.suarafakta.my.id/storage/${novel.coverImage}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: Icon(Icons.image_not_supported,
                                        size: 20, color: Colors.grey),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 8),
                              const SizedBox(width: 2),
                              Text(
                                (novel.reviews?.isNotEmpty ?? false)
                                    ? novel.reviews![0].rating.toString()
                                    : '0',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 7,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    novel.title,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    novel.author.name,
                    style: TextStyle(fontSize: 9, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

// Helper function to determine status color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'ongoing':
        return Colors.blue;
      case 'hiatus':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

// Helper function to get status label
  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'TAMAT';
      case 'ongoing':
        return 'LANJUT';
      case 'hiatus':
        return 'JEDA';
      default:
        return status.toUpperCase();
    }
  }

  Widget _buildCategories(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: Category.categories.length,
        itemBuilder: (context, index) {
          final category = Category.categories[index];
          return GestureDetector(
            onTap: () {
              // Navigate to category screen
            },
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLatestNovels(BuildContext context) {
    final novelProvider = Provider.of<NovelFeaturedProvider>(context);

    if (novelProvider.isLoading) {
      return const NovelListLoadingPlaceholder();
    }

    if (novelProvider.error != null) {
      return SizedBox(
        height: 150,
        child: Center(
          child: Text(
            'Terjadi error: ${novelProvider.error}',
            style: TextStyle(color: Colors.red[700]),
          ),
        ),
      );
    }

    if (novelProvider.dataListfeature.isEmpty) {
      return const SizedBox(
        height: 150,
        child: Center(child: Text('Data kosong')),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header with accent

          // Compact novel list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5, // Show only 5 latest novels
            itemBuilder: (context, index) {
              final novel = novelProvider.dataListfeature[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailNovelScreen(
                          novelId: novel.id,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Left side with cover and labels
                        SizedBox(
                          width: 80,
                          child: Stack(
                            children: [
                              // Novel Cover with gradient overlay for depth
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(2, 0),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    'https://www.mamamnovel.suarafakta.my.id/storage/${novel.coverImage}',
                                    height: 100,
                                    width: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 100,
                                        width: 80,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                            Icons.image_not_supported,
                                            size: 24),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              // Rating chip at top
                              Positioned(
                                top: 8,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.9),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        (novel.reviews?.isNotEmpty ?? false)
                                            ? novel.reviews![0].rating
                                                .toString()
                                            : '0',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // View count chip at bottom
                              Positioned(
                                bottom: 8,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.visibility,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        _formatViewCount(novel.viewCount),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right side with novel info
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Title with ellipsis
                                Text(
                                  novel.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                // Author name with icon
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 12,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      novel.author.name,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),

                                // Description preview
                                Text(
                                  novel.description,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    height: 1.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                // Bottom row with tags/buttons
                                Row(
                                  children: [
                                    _buildTag(novel.category.name, Colors.pink),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

// Helper widgets and methods
  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

// Format view count (e.g., 1000 -> 1K)
  String _formatViewCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return count.toString();
    }
  }
}
