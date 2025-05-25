import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_novel_app/data/model/novel_model.dart';
import 'package:flutter_novel_app/data/provider/chapter_provider.dart';
import 'package:flutter_novel_app/data/provider/comment_provider.dart';
import 'package:flutter_novel_app/data/provider/favorite_provider.dart';
import 'package:flutter_novel_app/data/provider/novel_provider.dart';
import 'package:flutter_novel_app/data/provider/review_provider.dart';
import 'package:flutter_novel_app/screens/read_novel_screen.dart';
import 'package:flutter_novel_app/utils/dialog_for_no_user.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../components/shimmer_widgets.dart';

class DetailNovelScreen extends StatefulWidget {
  final int novelId;

  const DetailNovelScreen({
    super.key,
    required this.novelId,
  });

  @override
  State<DetailNovelScreen> createState() => _DetailNovelScreenState();
}

class _DetailNovelScreenState extends State<DetailNovelScreen>
    with SingleTickerProviderStateMixin {
  Set<int> likedCommentIds =
      {}; // simpan id komentar yg sudah di-like user saat ini
  late Box<List> favoriteBox;
  List<int> favoriteIds = [];
  bool _isFavorite = false;
  bool _isDescriptionExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int? currentUserId;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    loadUserId();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final novelProvider = Provider.of<NovelProvider>(context, listen: false);
      novelProvider.getNovelDetail(widget.novelId);
      final reviewProvider =
          Provider.of<ReviewProvider>(context, listen: false);
      reviewProvider.fetchReviews(widget.novelId);

      Provider.of<FavoriteProvider>(context, listen: false)
          .checkFavorite(widget.novelId);

      final commentProvider =
          Provider.of<CommentProvider>(context, listen: false);
      commentProvider.loadComments(widget.novelId);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void loadUserId() async {
    final provider = Provider.of<CommentProvider>(context, listen: false);

    final id = await provider.getCurrentUserId();
    setState(() {
      currentUserId = id;
    });
  }

  void _toggleDescription() {
    setState(() {
      _isDescriptionExpanded = !_isDescriptionExpanded;
      if (_isDescriptionExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _toggleFavorite() async {
    final favoriteProvider = Provider.of<NovelProvider>(context, listen: false);

    setState(() {
      _isFavorite = !_isFavorite; // Toggle icon favorit di UI
    });

    await favoriteProvider.toggleFavorite(
      novelId: widget.novelId,
      isCurrentlyFavorite: !_isFavorite, // karena sudah di-toggle sebelumnya
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(favoriteProvider.error ?? 'Novel Telah Ditambah kan ke daftar favorite'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          left: 20,
          right: 20,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void goToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      final readingProvider =
          Provider.of<ChapterProvider>(context, listen: false);

      await readingProvider.postReadingHistory(
        id: widget.novelId,
        chapterNumber: 1,
        lastPageRead: 1,
        progressPercentage: 0.0,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReadNovelScreen(novelId: widget.novelId),
        ),
      );
    } else {
      showLoginRegisterDialog(context);
    }
  }

  void showShareOptions(BuildContext context, String urlToShare) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copy Link'),
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: urlToShare));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Link berhasil disalin'),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height - 100,
                        left: 20,
                        right: 20,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddReviewDialog(int novelId) {
    final TextEditingController contentController = TextEditingController();
    int rating = 0;
    bool isSpoiler = false;
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 300),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        const Icon(Icons.rate_review,
                            color: Colors.blue, size: 18),
                        const SizedBox(width: 6),
                        const Text(
                          'Tulis Review',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        // Close button
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(height: 16),

                    // Rating stars - compact horizontal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              rating = index + 1;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              index < rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 24,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 12),

                    // Input komen - lebih compact
                    TextField(
                      controller: contentController,
                      maxLines: 3,
                      maxLength: 200,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Tulis komentarmu...',
                        hintStyle: const TextStyle(fontSize: 13),
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        counterText: '',
                      ),
                    ),

                    // Spoiler checkbox - lebih compact
                    Row(
                      children: [
                        Checkbox(
                          value: isSpoiler,
                          onChanged: (val) {
                            setState(() {
                              isSpoiler = val ?? false;
                            });
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        const Text('Mengandung spoiler?',
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Button lebih compact
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: isLoading
                            ? null
                            : () async {
                                final content = contentController.text.trim();
                                if (content.isEmpty || rating == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Harap isi komentar dan rating'),
                                      duration: Duration(seconds: 1),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  isLoading = true;
                                });

                                await Provider.of<ReviewProvider>(context,
                                        listen: false)
                                    .submitReview(
                                        novelId, content, rating, isSpoiler);

                                setState(() {
                                  isLoading = false;
                                });

                                Navigator.pop(context);
                              },
                        child: isLoading
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Kirim Review',
                                style: TextStyle(fontSize: 13)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final novelProvider = Provider.of<NovelProvider>(context);
    final iconsimpan = Provider.of<FavoriteProvider>(context);
    final novel = novelProvider.novelDetail;
    final isLoading = novel == null;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            elevation: 0,
            stretch: true,
            backgroundColor: Colors.grey,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  isLoading
                      ? ShimmerWidgets.coverImageShimmer()
                      : Hero(
                          tag: 'novel-cover-${widget.novelId}',
                          child: Image.network(
                            'https://www.mamamnovel.suarafakta.my.id/storage/${novelProvider.novelDetail!.coverImage}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child:
                                      Icon(Icons.image_not_supported, size: 64),
                                ),
                              );
                            },
                          ),
                        ),
                  // Enhanced gradient overlay for better text visibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.4, 0.75, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              iconsimpan.loading
                  ? const SizedBox.shrink()
                  : iconsimpan.isFavorite
                      ? const SizedBox
                          .shrink() // Tidak tampilkan tombol sama sekali
                      : IconButton(
                          icon: const Icon(
                            Icons.bookmark_add_outlined,
                            color: Colors.white,
                            size: 26,
                          ),
                          onPressed: _toggleFavorite,
                        ),
              // IconButton(
              //   icon: const Icon(Icons.share, color: Colors.white, size: 24),
              //   onPressed: () {
              //     showShareOptions(context,
              //         'https://www.mamamnovel.suarafakta.my.id/api/novels/${widget.novelId}');
              //   },
              // ),
            ],
          ),

          // Novel Details
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, -5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Author
                    isLoading
                        ? ShimmerWidgets.titleAuthorShimmer()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                novelProvider.novelDetail!.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.person,
                                      size: 18, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    'oleh ${novelProvider.novelDetail!.author.name}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                    const SizedBox(height: 20),

                    // Rating and Stats in a stylish card
                    isLoading
                        ? ShimmerWidgets.statsShimmer()
                        : Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFF5F4ED), Color(0xFFF5F4ED)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // Rating
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          (novel.reviews?.isNotEmpty ?? false)
                                              ? novel.reviews![0].rating
                                                  .toString()
                                              : '0',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                color: Color(0xFF2F7570),
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rating',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Color(0xFF2F7570),
                                          ),
                                    ),
                                  ],
                                ),

                                // Vertical divider
                                Container(
                                  height: 40,
                                  width: 1,
                                  color: Colors.white.withOpacity(0.3),
                                ),

                                // Views
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.remove_red_eye,
                                          color: Color(0xFF2F7570),
                                          size: 24,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          novelProvider.novelDetail!.viewCount
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                color: Color(0xFF2F7570),
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Dilihat',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Color(0xFF2F7570),
                                          ),
                                    ),
                                  ],
                                ),

                                // Vertical divider
                                Container(
                                  height: 40,
                                  width: 1,
                                  color: Colors.white.withOpacity(0.3),
                                ),

                                // Category
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Color(0xFF2F7570),
                                        ),
                                      ),
                                      child: Text(
                                        novelProvider
                                            .novelDetail!.category.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Color(0xFF2F7570),
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Kategori',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Color(0xFF2F7570),
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                    const SizedBox(height: 24),

                    // Read Button - Enhanced with gradient
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : goToNextScreen,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Color(0xFFF5F4ED),
                          elevation: 5,
                          shadowColor:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                        ),
                        child: const Text(
                          'Baca Novel',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2F7570)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Description Header
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.description, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Deskripsi',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),

                    // Stylized Description Section
                    isLoading
                        ? ShimmerWidgets.descriptionShimmer()
                        : Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedBuilder(
                                  animation: _animation,
                                  builder: (context, child) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          novelProvider
                                              .novelDetail!.description,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                height: 1.5,
                                                color: Colors.grey[800],
                                              ),
                                          maxLines:
                                              _isDescriptionExpanded ? null : 3,
                                          overflow: _isDescriptionExpanded
                                              ? TextOverflow.visible
                                              : TextOverflow.ellipsis,
                                        ),
                                      ],
                                    );
                                  },
                                ),

                                const SizedBox(height: 8),

                                // Expand/Collapse Button
                                Align(
                                  alignment: Alignment.center,
                                  child: TextButton.icon(
                                    onPressed: _toggleDescription,
                                    icon: AnimatedRotation(
                                      turns: _isDescriptionExpanded ? 0.5 : 0,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child:
                                          const Icon(Icons.keyboard_arrow_down),
                                    ),
                                    label: Text(
                                      _isDescriptionExpanded
                                          ? 'Ciutkan'
                                          : 'Baca Selengkapnya',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2F7570),
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                    const SizedBox(height: 24),

                    // Reviews Header
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.reviews, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Review',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          // Add Review Button
                        ],
                      ),
                    ),

                    isLoading
                        ? ShimmerWidgets.reviewsShimmer()
                        : _buildReviews(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews() {
    final reviewProvider = Provider.of<ReviewProvider>(context);
    final novelId = widget.novelId;

    if (reviewProvider.isLoading) {
      return ShimmerWidgets.reviewsShimmer();
    }

    if (reviewProvider.reviews.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
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
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.rate_review,
                size: 56,
                color: Theme.of(context).primaryColor.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'Belum ada review',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Jadilah reviewer pertama!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  _showAddReviewDialog(novelId);
                },
                icon: const Icon(Icons.create),
                label: const Text('Tulis Review'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 0, 147, 140),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final displayedReviews = reviewProvider.reviews.take(3).toList();

    return Column(
      children: [
        ...displayedReviews.map((review) => _buildReviewItem(review)),
        if (reviewProvider.reviews.length > 3)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                // Implement viewing all reviews logic here
              },
              child: Text(
                'Lihat Semua Review (${reviewProvider.reviews.length})',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReviewItem(Review review) {
    final TextEditingController commentController = TextEditingController();
    final ValueNotifier<bool> isExpanded = ValueNotifier<bool>(false);

    ImageProvider avatarImage;
    if (review.user.profilePicture != null &&
        review.user.profilePicture != '') {
      avatarImage = NetworkImage(
        'https://www.mamamnovel.suarafakta.my.id/storage/${review.user.profilePicture}',
      );
    } else {
      avatarImage = NetworkImage(
        'https://ui-avatars.com/api/?name=${Uri.encodeComponent(review.user.name)}&background=random',
      );
    }

    return ValueListenableBuilder<bool>(
      valueListenable: isExpanded,
      builder: (context, expanded, _) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header dan review seperti sebelumnya...
              Row(
                children: [
                  Hero(
                    tag: 'avatar-${review.user.id}',
                    child: CircleAvatar(
                      backgroundImage: avatarImage,
                      radius: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.user.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          DateFormat('dd MMM yyyy').format(review.createdAt),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < review.rating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                review.comment,
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 12),

              /// Like button dsb...

              const Divider(),

              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    isExpanded.value = !isExpanded.value;

                    if (!isExpanded.value) return;

                    // Saat komentar dibuka, load komentar
                    final commentProvider =
                        Provider.of<CommentProvider>(context, listen: false);
                    commentProvider.loadComments(review.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        AnimatedRotation(
                          turns: expanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            size: 20,
                            color: Colors.blue[700],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          expanded ? 'Sembunyikan Komentar' : 'Lihat Komentar',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[700],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Consumer<CommentProvider>(
                          builder: (context, commentProvider, _) {
                            final comments = commentProvider.comments;
                            if (!expanded || comments.isEmpty)
                              return const SizedBox();
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${comments.length}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// Komentar-komentar pakai Consumer
              AnimatedCrossFade(
                firstChild: const SizedBox(height: 0),
                secondChild: Consumer<CommentProvider>(
                  builder: (context, commentProvider, _) {
                    final comments = commentProvider.comments;
                    if (commentProvider.isLoading) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            width: double.infinity,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      );
                    }
                    if (comments.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              'Belum ada komentar.',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextField(
                              controller: commentController,
                              decoration: InputDecoration(
                                hintText: 'Tulis komentar...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.blue[400]!),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              maxLines: null,
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final newComment =
                                      commentController.text.trim();
                                  if (newComment.isNotEmpty) {
                                    try {
                                      await Provider.of<CommentProvider>(
                                              context,
                                              listen: false)
                                          .addComment(review.id, newComment);
                                      await Provider.of<CommentProvider>(
                                              context,
                                              listen: false)
                                          .loadComments(review.id);
                                      commentController.clear();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Komentar berhasil ditambahkan'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    } catch (e) {
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Gagal menambahkan komentar: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                icon: const Icon(Icons.send),
                                label: const Text('Kirim'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Column(
                      children: [
                        const SizedBox(height: 12),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: comments.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            ImageProvider image;
                            if (comment.user.profilePicture != null &&
                                comment.user.profilePicture != '') {
                              image = NetworkImage(
                                'https://www.mamamnovel.suarafakta.my.id/storage/${comment.user.profilePicture}',
                              );
                            } else {
                              image = NetworkImage(
                                'https://ui-avatars.com/api/?name=${Uri.encodeComponent(comment.user.name)}&background=random',
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: image,
                                    radius: 18,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comment.user.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          comment.content,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          DateFormat('dd MMM yyyy HH:mm')
                                              .format(comment.createdAt),
                                          style: const TextStyle(
                                              fontSize: 10, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),

                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.thumb_up,
                                                size: 20,
                                                color:
                                                    Colors.blue, // selalu biru
                                              ),
                                              onPressed: () async {
                                                if (likedCommentIds
                                                    .contains(comment.id)) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Anda sudah like komentar ini')),
                                                  );
                                                  return;
                                                }

                                                try {
                                                  await Provider.of<
                                                              CommentProvider>(
                                                          context,
                                                          listen: false)
                                                      .likeComment(review.id,
                                                          comment.id);

                                                  setState(() {
                                                    likedCommentIds
                                                        .add(comment.id);
                                                    comment.likesCount += 1;
                                                  });
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Gagal like komentar')),
                                                  );
                                                }
                                              },
                                            ),
                                            Text(
                                              comment.likesCount
                                                  .toString(), // ganti dengan jumlah like asli
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                        if (comment.userId == currentUserId)
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              size: 20, color: Colors.red),
                                          onPressed: () async {
                                            await Provider.of<CommentProvider>(
                                              context,
                                              listen: false,
                                            ).deleteComment(
                                                comment.id, review.id);
                                          },
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        /// Form tambah komentar
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              TextField(
                                controller: commentController,
                                decoration: InputDecoration(
                                  hintText: 'Tulis komentar...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: Colors.grey[300]!),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: Colors.grey[300]!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: Colors.blue[400]!),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                maxLines: null,
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final newComment =
                                        commentController.text.trim();
                                    if (newComment.isNotEmpty) {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => const Center(
                                            child: CircularProgressIndicator()),
                                      );

                                      try {
                                        await Provider.of<CommentProvider>(
                                                context,
                                                listen: false)
                                            .addComment(review.id, newComment);
                                        await Provider.of<CommentProvider>(
                                                context,
                                                listen: false)
                                            .loadComments(review.id);
                                        commentController.clear();
                                        Navigator.of(context).pop();

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Komentar berhasil ditambahkan'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      } catch (e) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Gagal menambahkan komentar: $e'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  icon: const Icon(Icons.send),
                                  label: const Text('Kirim'),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                firstCurve: Curves.easeOut,
                secondCurve: Curves.easeIn,
                crossFadeState: expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        );
      },
    );
  }
}
