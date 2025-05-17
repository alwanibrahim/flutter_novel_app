import 'package:flutter/material.dart';
import 'package:flutter_novel_app/data/provider/auth_provider.dart';
import 'package:flutter_novel_app/data/provider/novel_provider.dart';
import 'package:flutter_novel_app/data/provider/reading_provider.dart';
import 'package:flutter_novel_app/data/provider/review_provider.dart';
import 'package:flutter_novel_app/data/provider/user_provider.dart';
import 'package:flutter_novel_app/screens/detail_novel_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../models/novel_model.dart';
import '../models/review_model.dart';
import 'edit_profile_screen.dart';
import 'dart:ui';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final user = User.currentUser;
  final _bookmarkBorderRadius = 15.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchUser();
      final novelHistoryProvider =
          Provider.of<ReadingHistoryProvider>(context, listen: false);
      novelHistoryProvider.fetchReadingHistory();

      final reviewProvider =
          Provider.of<ReviewProvider>(context, listen: false);
      reviewProvider.loadMyReviews();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor:
          const Color(0xFFF8F5F1), // Warm off-white like a book page
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF015754)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profil Pembaca',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF015754),
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF015754)),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Profile header with book-like styling
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Profile picture with a book-themed frame
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Decorative book elements
                          Container(
                            width: 105,
                            height: 105,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6D7C3),
                              borderRadius: BorderRadius.circular(55),
                              border: Border.all(
                                color: const Color(0xFFD4C1A9),
                                width: 3,
                              ),
                            ),
                          ),

                          // Profile picture
                          ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: (userProvider.user?.profilePicture !=
                                              null &&
                                          userProvider
                                              .user!.profilePicture!.isNotEmpty)
                                      ? NetworkImage(
                                          'https://www.mamamnovel.suarafakta.my.id/storage/${userProvider.user!.profilePicture}')
                                      : NetworkImage(
                                          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(userProvider.user?.name ?? 'User')}&background=random',
                                        ),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                                child: Container(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ),

                          // Bookmark-like decoration
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 30,
                              height: 15,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // User name with elegant typography
                      Text(
                        userProvider.user?.name ?? 'Loading..',
                        style: const TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF015754),
                          letterSpacing: 0.5,
                        ),
                      ),

                      // Username with book-like styling

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3EEE8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFDCD3C5),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          '@${userProvider.user?.name ?? 'Loading..'}',
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 13,
                            color: Color(0xFF015754),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
// Bio with a book page style
                      if (userProvider.user?.bio != null &&
                          userProvider.user!.bio!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDFBF7),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFECE6DA),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            userProvider.user!.bio!,
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF015754),
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      const SizedBox(height: 14),

                      // Profile actions with book-themed buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfileScreen(),
                                ),
                              ).then(
                                  (_) => setState(() {})); // Refresh on return
                            },
                            icon: const Icon(Icons.edit, size: 16),
                            label: const Text('Edit Profil',
                                style: TextStyle(fontSize: 13)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF015754),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton.icon(
                            onPressed: () {
                              context.read<AuthProvider>().logout(context);
                            },
                            icon: const Icon(Icons.logout, size: 16),
                            label: const Text('Logout',
                                style: TextStyle(fontSize: 13)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red[700],
                              side: BorderSide(color: Colors.red[700]!),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Reading stats with book-like styling
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(context, '32', 'Buku Dibaca'),
                      _buildVerticalDivider(),
                      _buildStatItem(context, '128', 'Jam Membaca'),
                      _buildVerticalDivider(),
                      _buildStatItem(context, '15', 'Ulasan'),
                    ],
                  ),
                ),

                // Custom tab bar with book-like styling
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6D7C3).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xFF015754),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: const Color(0xFF015754),
                    labelStyle: const TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.menu_book, size: 16),
                        text: 'Riwayat Bacaan',
                      ),
                      Tab(
                        icon: Icon(Icons.rate_review, size: 16),
                        text: 'Ulasan Saya',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),

          // Tab content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Reading history tab
                _buildReadingHistoryTab(),
                // Reviews tab
                _buildReviewsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: const Color(0xFFE0E0E0),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF015754),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Lato',
            fontSize: 11,
            color: Color(0xFF015754),
          ),
        ),
      ],
    );
  }

  Widget _buildReadingHistoryTab() {
    final readingProvider = Provider.of<ReadingHistoryProvider>(context);
    final readingHistory = readingProvider.readingHistory;

    if (readingProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (readingProvider.error != null) {
      return Center(child: Text('Gagal memuat data: ${readingProvider.error}'));
    }

    if (readingHistory.isEmpty) {
      return _buildEmptyState(
        icon: Icons.menu_book,
        title: 'Belum ada riwayat bacaan',
        subtitle: 'Novel yang Anda baca akan muncul di sini',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: readingHistory.length,
      itemBuilder: (context, index) {
        final history = readingHistory[index];
        final novel = Novel.novels.firstWhere(
          (n) => n.id == history.novelId,
          orElse: () => Novel(
            id: 0,
            title: 'Unknown',
            description: '',
            coverImage: '',
            categoryId: 0,
            authorId: 0,
            publicationDate: '',
          ),
        );

        if (novel.id == 0) return const SizedBox(); // skip unknown novel

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailNovelScreen(
                    novelId: history.novel.id,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                // Cover image
                Container(
                  margin: const EdgeInsets.all(12),
                  width: 60,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://www.mamamnovel.suarafakta.my.id/storage/${history.novel.coverImage}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child:
                              const Icon(Icons.image_not_supported, size: 20),
                        );
                      },
                    ),
                  ),
                ),

                // Info
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          history.novel.title,
                          style: const TextStyle(
                            fontFamily: 'Playfair Display',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E2723),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.history,
                                size: 12, color: Color(0xFF015754)),
                            const SizedBox(width: 4),
                            Text(
                              'Terakhir dibaca: ${DateFormat('d MMMM y, HH:mm', 'id_ID').format(history.lastReadAt)}',
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 11,
                                color: Color(0xFF015754),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: history.progressPercentage / 100,
                            minHeight: 8,
                            backgroundColor: const Color(0xFFE6D7C3),
                            valueColor:
                                const AlwaysStoppedAnimation(Color(0xFF015754)),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(history.progressPercentage * 1).toInt()}% selesai',
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF015754),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab() {
    final reviewProvider = Provider.of<ReviewProvider>(context);
    final reviews = reviewProvider.reviewsUlasan;
    // Get reviews by current user
    final review = Review.getReviewsByUser(user.id);

    if (reviews.isEmpty) {
      return _buildEmptyState(
        icon: Icons.rate_review,
        title: 'Belum ada ulasan',
        subtitle: 'Ulasan yang Anda tulis akan muncul di sini',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        final novel = Novel.novels.firstWhere(
          (novel) => novel.id == review.novelId,
          orElse: () => Novel(
            id: 0,
            title: 'Unknown',
            description: '',
            coverImage: '',
            categoryId: 0,
            authorId: 0,
            publicationDate: '',
          ),
        );
        
        if (novel.id == 0) return const SizedBox(); // Skip if novel not found

        return GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailNovelScreen(
                  novelId: review.novel?.id ?? 0,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: const Color(0xFFECE6DA),
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Review header with book info
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Book cover with page effect
                      Container(
                        width: 45,
                        height: 65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            'https://www.mamamnovel.suarafakta.my.id/storage/${review.novel?.coverImage}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported,
                                    size: 16),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Book info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.novel?.title ?? '-',
                              style: const TextStyle(
                                fontFamily: 'Playfair Display',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3E2723),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              review.novel?.author.name ??'-',
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 12,
                                color: Color(0xFF015754),
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Rating with book page styling
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3EEE8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < review.rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 14,
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider with book page styling
                Container(
                  height: 1,
                  color: const Color(0xFFECE6DA),
                ),

                // Review content with book page styling
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFDFBF7),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Review text with quotation marks
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '"',
                            style: TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 24,
                              color: Color(0xFFBDBDBD),
                              height: 0.8,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                review.comment,
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xFF015754),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            '"',
                            style: TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 24,
                              color: Color(0xFFBDBDBD),
                              height: 0.8,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Review date with book page styling
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.event_note,
                            size: 12,
                            color: Color(0xFF9E9E9E),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Ditulis pada ${review.createdAt}',
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 11,
                              color: Color(0xFF9E9E9E),
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
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Empty state icon with book-like styling
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF3EEE8),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              icon,
              size: 40,
              color: const Color(0xFFBCAAA4),
            ),
          ),
          const SizedBox(height: 16),

          // Empty state title
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF015754),
            ),
          ),

          const SizedBox(height: 8),

          // Empty state subtitle
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 13,
              color: Color(0xFF015754),
            ),
          ),

          const SizedBox(height: 16),

          // Action button with book-like styling
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to book discovery
            },
            icon: const Icon(Icons.explore, size: 16),
            label:
                const Text('Jelajahi Koleksi', style: TextStyle(fontSize: 13)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF015754),
              foregroundColor: Colors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
