import 'package:flutter/material.dart';
import 'package:flutter_novel_app/data/provider/auth_provider.dart';
import 'package:flutter_novel_app/data/provider/chapter_provider.dart';
import 'package:flutter_novel_app/data/provider/reading_provider.dart';
import 'package:flutter_novel_app/data/provider/review_provider.dart';
import 'package:flutter_novel_app/data/provider/user_provider.dart';
import 'package:flutter_novel_app/screens/detail_novel_screen.dart';
import 'package:flutter_novel_app/screens/read_novel_screen.dart';
import 'package:flutter_novel_app/utils/dialog_for_no_user.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../models/user_model.dart';
import '../models/novel_model.dart';
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
  bool _isLoading= true;


  @override
  void initState(){


    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(()async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchUser();
      final novelHistoryProvider =
          Provider.of<ReadingHistoryProvider>(context, listen: false);
      novelHistoryProvider.fetchReadingHistory();

      final reviewProvider =
          Provider.of<ReviewProvider>(context, listen: false);
      reviewProvider.loadMyReviews();
      //cek udah login blom??
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
       if (userProvider.user == null && token == null) {
        showLoginRegisterDialog(context);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<UserProvider>(context, listen: false)
        .fetchUser();
        final novelHistoryProvider =
        Provider.of<ReadingHistoryProvider>(context, listen: false);
    novelHistoryProvider.fetchReadingHistory();

    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    reviewProvider.loadMyReviews();

    setState(() {
      _isLoading = false;
    });
  }




  void goToNextScreen(int novelId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      final readingProvider =
          Provider.of<ChapterProvider>(context, listen: false);
      final novelHistoryProvider =
          Provider.of<ReadingHistoryProvider>(context, listen: false);
      novelHistoryProvider.fetchReadingHistory();

      final existingHistory =
          await readingProvider.fetchReadingHistory(novelId);

      if (existingHistory != null) {
        await readingProvider.editReadingHistory(
          id: novelId,
          chapterNumber: 1,
          lastPageRead: 1,
          progressPercentage: 0.0,
        );
      } else {
        await readingProvider.postReadingHistory(
          id: novelId,
          chapterNumber: 1,
          lastPageRead: 1,
          progressPercentage: 0.0,
        );
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReadNovelScreen(novelId: novelId),
        ),
      );
    } else {
      Navigator.pushNamed(context, '/register');
    }
  }

  @override
  Widget build(BuildContext context) {
      final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    final userProvider = Provider.of<UserProvider>(context);
    final totalCompleted =
        Provider.of<ReadingHistoryProvider>(context).totalCompletedNovels;
    final readingHours = Provider.of<ReadingHistoryProvider>(context)
        .estimatedReadingTimeRounded;
    final historyProvider =
        Provider.of<ReadingHistoryProvider>(context, listen: false);

    return Scaffold(
       key: _scaffoldKey,
     floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Konfirmasi'),
              content: const Text('Yakin ingin menghapus semua riwayat baca?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Batal'),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context, true),
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('Hapus'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );

          if (confirm == true) {
            await historyProvider.removeAllHistory();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Semua riwayat berhasil dihapus')),
            );
          }
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.delete_outline,size: 15,),
        label: const Text(
          'Hapus\nRiwayat',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      backgroundColor: const Color(0xFFF8F5F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        title: const Text(
          'Profil Pembaca',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF015754),
          ),
        ),
        centerTitle: true,
        actions: [
         IconButton(
            icon: const Icon(Icons.settings_outlined,
                color: Color(0xFF015754), size: 18),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),

           IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: _loadData,
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF015754)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar/logo aplikasi
                  ClipRRect(
                    borderRadius:  BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/book_splash.png', // sesuaikan dengan asset kamu
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Ucapan selamat datang
                  const Text(
                    'Selamat datang!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Deskripsi singkat aplikasi
                  const Text(
                    'Nikmati ribuan novel menarik hanya dalam genggamanmu.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditProfileScreen(userId: userProvider.user!.id ),
                  ),
                ).then((_) => setState(() {}));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
             onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Konfirmasi Logout'),
                    content: const Text('Apakah kamu yakin ingin logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Batal'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  context.read<AuthProvider>().logout(context);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login');
              },
            ),
            ListTile(
              leading: const Icon(Icons.app_registration),
              title: const Text('Register'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/register');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Profile Card
          _buildProfileCard(userProvider),

          // Stats Row
          _buildStatsRow(totalCompleted, readingHours),

          // Tab Bar
          Container(
            margin: const EdgeInsets.fromLTRB(16, 10, 16, 5),
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE6D7C3).withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF015754),

              ),
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF015754),
              labelStyle: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(
                  icon: Icon(Icons.menu_book, size: 14),
                  text: 'Riwayat',
                ),
                Tab(
                  icon: Icon(Icons.rate_review, size: 14),
                  text: 'Ulasan',
                ),
              ],
            ),
          ),

          // Tab View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildReadingHistoryTab(),
                _buildReviewsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(UserProvider userProvider) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
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
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile image
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6D7C3),
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                    color: const Color(0xFFD4C1A9),
                    width: 2,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        userProvider.user?.profilePicture != null &&
                                userProvider.user!.profilePicture!.isNotEmpty
                            ? 'https://www.mamamnovel.suarafakta.my.id/storage/${userProvider.user!.profilePicture}'
                            : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(userProvider.user?.name ?? 'User')}&background=random',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 14),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userProvider.user?.name ?? 'Loading..',
                  style: const TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF015754),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 2),

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EEE8),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFDCD3C5),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    '@${userProvider.user?.name ?? 'username'}',
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 11,
                      color: Color(0xFF015754),
                    ),
                  ),
                ),

                if (userProvider.user?.bio != null &&
                    userProvider.user!.bio!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      userProvider.user!.bio!,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF707070),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                const SizedBox(height: 5),

                // Action buttons
                Row(
                  children: [
                    _buildActionButton(
                      icon: Icons.edit_outlined,
                      label: 'Edit',
                      color: const Color(0xFF015754),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(
                                userId: userProvider.user?.id ?? 0),
                          ),
                        ).then((_) => setState(() {}));
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      icon: Icons.logout,
                      label: 'Logout',
                      color: Colors.red[700]!,
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Konfirmasi Logout'),
                            content:
                                const Text('Apakah kamu yakin ingin logout?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Batal'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          context.read<AuthProvider>().logout(context);
                        }
                      },
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(int totalCompleted, int readingHours) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('$totalCompleted', 'Buku'),
          _buildVerticalDivider(),
          _buildStatItem('$readingHours', 'Jam'),
          _buildVerticalDivider(),
          _buildStatItem(
            '${Provider.of<ReviewProvider>(context).totalMyReviews}',
            'Ulasan',
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 25,
      width: 1,
      color: const Color(0xFFEEEEEE),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF015754),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Lato',
            fontSize: 10,
            color: Color(0xFF707070),
          ),
        ),
      ],
    );
  }

  Widget _buildReadingHistoryTab() {
    final readingProvider = Provider.of<ReadingHistoryProvider>(context);
    final readingHistory = readingProvider.readingHistory;

    if (readingProvider.isLoading) {
      return _buildShimmerLoading();
    }

    if (readingProvider.error != null) {
      return Center(
          child: Text(
        'Gagal memuat data',
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ));
    }

    if (readingHistory.isEmpty) {
      return _buildEmptyState(
        icon: Icons.menu_book,
        title: 'Belum ada riwayat',
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

        if (novel.id == 0) return const SizedBox();

        return _buildHistoryCard(history, novel);
      },
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 5, // Show 5 shimmer items
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0.8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                // Shimmer cover image placeholder
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 45,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Shimmer book info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 14,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 10,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Shimmer progress bar
                      Row(
                        children: [
                          Expanded(
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 10,
                              width: 25,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(3),
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
      },
    );
  }

  Widget _buildHistoryCard(dynamic history, Novel novel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0.8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () => goToNextScreen(novel.id),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // Cover image
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  'https://www.mamamnovel.suarafakta.my.id/storage/${history.novel.coverImage}',
                  width: 45,
                  height: 65,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 45,
                    height: 65,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 16),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Book info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      history.novel.title,
                      style: const TextStyle(
                        fontFamily: 'Playfair Display',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3E2723),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 2),

                    Text(
                      '${DateFormat('d MMM y', 'id_ID').format(history.lastReadAt)}',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Progress
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: history.progressPercentage / 100,
                              minHeight: 5,
                              backgroundColor: const Color(0xFFE6D7C3),
                              valueColor: const AlwaysStoppedAnimation(
                                Color(0xFF015754),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(history.progressPercentage * 1).toInt()}%',
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF015754),
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
    );
  }
  // Inside your _ProfileScreenState class

 Widget _buildReviewsTab() {
    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, _) {
        // Check if reviews are still loading
        if (reviewProvider.isLoading) {
          return _buildReviewShimmerLoading();
        }

        // Handle errors
        if (reviewProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Gagal memuat data ulasan: ${reviewProvider.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => reviewProvider.loadMyReviews(),
                  child: const Text('Coba lagi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF015754),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        // Check if reviews list is empty
        final reviews = reviewProvider.reviewsUlasan;
        if (reviews.isEmpty) {
          return _buildEmptyState(
            icon: Icons.rate_review,
            title: 'Belum ada ulasan',
            subtitle: 'Ulasan yang Anda tulis akan muncul di sini',
          );
        }

        // Display the reviews list
        return RefreshIndicator(
          onRefresh: () async {
            await reviewProvider.loadMyReviews();
          },
          color: const Color(0xFF015754),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];

              // Safety check to prevent null reviews
              if (review == null) return const SizedBox();

              return _buildReviewCard(review);
            },
          ),
        );
      },
    );
  }

// Add this new method for shimmer loading in the reviews tab
  Widget _buildReviewShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 5, // Show 5 shimmer items
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0.8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with book info
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    // Shimmer cover image placeholder
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 35,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Shimmer book info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 12,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),

                          const SizedBox(height: 4),

                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 10,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),

                          const SizedBox(height: 3),

                          // Shimmer rating stars
                          Row(
                            children: List.generate(5, (_) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  margin: const EdgeInsets.only(right: 2),
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              const Divider(height: 1),

              // Shimmer review content
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shimmer text lines
                    for (int i = 0; i < 3; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 10,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 4),

                    // Shimmer date
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 9,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewCard(dynamic review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0.8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailNovelScreen(
                novelId: review.novel?.id ?? 0,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  // Cover
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      'https://www.mamamnovel.suarafakta.my.id/storage/${review.novel?.coverImage}',
                      width: 35,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 35,
                        height: 50,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 14),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.novel?.title ?? '-',
                          style: const TextStyle(
                            fontFamily: 'Playfair Display',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E2723),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          review.novel?.author.name ?? '-',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < review.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 12,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            const Divider(height: 1),

            // Review content
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.comment,
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF555555),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Date
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      DateFormat('dd MMM yyyy')
                          .format(review.createdAt), // ubah DateTime ke String
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 9,
                        color: Colors.grey[500],
                      ),
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

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF3EEE8),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              icon,
              size: 30,
              color: const Color(0xFFBCAAA4),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF015754),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 12,
              color: Color(0xFF707070),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to book discovery
              Navigator.pushNamed(context, '/explore');
            },
            icon: const Icon(Icons.explore, size: 14),
            label: const Text('Jelajahi', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF015754),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
