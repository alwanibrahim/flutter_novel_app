import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/reading_history_model.dart';
import '../models/novel_model.dart';
import '../models/review_model.dart';
import 'edit_profile_screen.dart';
import 'detail_novel_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final user = User.currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Profile header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Profile picture
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(user.profilePicture),
                  onBackgroundImageError: (exception, stackTrace) {
                    // Handle error
                  },
                ),
                const SizedBox(height: 16),
                // User name
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                // Username
                Text(
                  '@${user.username}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                // Bio
                Text(
                  user.bio,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Edit profile button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        ).then((_) => setState(() {})); // Refresh on return
                      },
                      child: const Text('Edit Profil'),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: () {
                        // Logout functionality
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Riwayat Bacaan'),
              Tab(text: 'Ulasan Saya'),
            ],
          ),

          // Tab content
          Expanded(
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

  Widget _buildReadingHistoryTab() {
    // Get reading history for current user
    final readingHistory = ReadingHistory.getReadingHistoryByUser(user.id);

    if (readingHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.menu_book,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada riwayat bacaan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Novel yang Anda baca akan muncul di sini',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: readingHistory.length,
      itemBuilder: (context, index) {
        final history = readingHistory[index];
        final novel = Novel.novels.firstWhere(
          (novel) => novel.id == history.novelId,
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

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
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
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailNovelScreen(novel: novel),
                ),
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                // Novel Cover
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ClipRRect(
                    borderRadius:  BorderRadius.circular(10),
                    child: Image.asset(
                      novel.coverImage,
                      height: 100,
                      width: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 100,
                          width: 70,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.image_not_supported, size: 24),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Novel Info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          novel.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Terakhir dibaca: ${history.lastReadAt}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Progress bar
                        LinearProgressIndicator(
                          value: history.progressPercentage,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(history.progressPercentage * 100).toInt()}% selesai',
                          style: Theme.of(context).textTheme.bodySmall,
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
    // Get reviews by current user
    final reviews = Review.getReviewsByUser(user.id);

    if (reviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.rate_review,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada ulasan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ulasan yang Anda tulis akan muncul di sini',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
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

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
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
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailNovelScreen(novel: novel),
                ),
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Novel info
                ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      novel.coverImage,
                      width: 40,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 40,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported, size: 16),
                        );
                      },
                    ),
                  ),
                  title: Text(
                    novel.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    novel.author.name,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      return Icon(
                        index < review.rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      );
                    }),
                  ),
                ),
                // Divider
                const Divider(height: 1),
                // Review content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.comment,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ditulis pada ${review.createdAt}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
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
}
