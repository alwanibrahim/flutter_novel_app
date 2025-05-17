import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_novel_app/data/model/novel_model.dart';
import 'package:flutter_novel_app/data/provider/comment_provider.dart';
import 'package:flutter_novel_app/data/provider/novel_provider.dart';
import 'package:flutter_novel_app/data/provider/review_provider.dart';
import 'package:flutter_novel_app/data/provider/favorite_provider.dart';
import 'package:flutter_novel_app/screens/read_novel_screen.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/shimmer_widgets.dart';

class DetailNovelScreen extends StatefulWidget {
  final int novelId;

  const DetailNovelScreen({
    Key? key,
    required this.novelId,
  }) : super(key: key);

  @override
  State<DetailNovelScreen> createState() => _DetailNovelScreenState();
}

class _DetailNovelScreenState extends State<DetailNovelScreen> {
  late Box<List> favoriteBox;
  List<int> favoriteIds = [];
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final novelProvider = Provider.of<NovelProvider>(context, listen: false);
      novelProvider.getNovelDetail(widget.novelId);
      final reviewProvider =
          Provider.of<ReviewProvider>(context, listen: false);
      reviewProvider.fetchReviews(widget.novelId);

      Provider.of<FavoriteProvider>(context, listen: false)
          .checkFavorite(widget.novelId);
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
          content: Text(favoriteProvider.error ?? 'Status favorit diperbarui')),
    );
  }

  void goToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      // Sudah login, lanjut ke ReadNovelScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReadNovelScreen(novelId: widget.novelId),
        ),
      );
    } else {
      // Belum login, arahkan ke halaman register
      Navigator.pushNamed(context, '/register'); // atau ganti sesuai rute kamu
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
                    const SnackBar(content: Text('Link berhasil disalin')),
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
    final TextEditingController _contentController = TextEditingController();
    int _rating = 0;
    bool _isSpoiler = false;
    bool _isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
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
                              _rating = index + 1;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              index < _rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 20,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 12),

                    // Input komen - lebih compact
                    TextField(
                      controller: _contentController,
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
                          value: _isSpoiler,
                          onChanged: (val) {
                            setState(() {
                              _isSpoiler = val ?? false;
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
                        onPressed: _isLoading
                            ? null
                            : () async {
                                final content = _contentController.text.trim();
                                if (content.isEmpty || _rating == 0) {
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
                                  _isLoading = true;
                                });

                                await Provider.of<ReviewProvider>(context,
                                        listen: false)
                                    .submitReview(
                                        novelId, content, _rating, _isSpoiler);

                                setState(() {
                                  _isLoading = false;
                                });

                                Navigator.pop(context);
                              },
                        child: _isLoading
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
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  isLoading
                      ? ShimmerWidgets.coverImageShimmer()
                      : Image.network(
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
                  // Gradient overlay for better text visibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.7, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              iconsimpan.loading?SizedBox.shrink():
             iconsimpan.isFavorite
                      ? SizedBox.shrink() // Tidak tampilkan tombol sama sekali
                      : IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: _toggleFavorite,
                        ),

              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  showShareOptions(context,
                      'https://www.mamamnovel.suarafakta.my.id/api/novels/${widget.novelId}');
                },
              ),
            ],
          ),

          // Novel Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'oleh ${novelProvider.novelDetail!.author.name}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.grey[700],
                                  ),
                            ),
                          ],
                        ),

                  const SizedBox(height: 16),

                  // Rating and Stats
                  isLoading
                      ? ShimmerWidgets.statsShimmer()
                      : Row(
                          children: [
                            // Rating
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  novelProvider.novelDetail!.averageRating
                                      .toString(),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            // Views
                            Row(
                              children: [
                                const Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  novelProvider.novelDetail!.viewCount
                                      .toString(),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            // Category
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                novelProvider.novelDetail!.category.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                            ),
                          ],
                        ),

                  const SizedBox(height: 24),

                  // Read Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : goToNextScreen,
                      child: const Text('Baca Novel'),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'Deskripsi',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  isLoading
                      ? ShimmerWidgets.descriptionShimmer()
                      : Text(
                          novelProvider.novelDetail!.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),

                  const SizedBox(height: 24),

                  // Reviews
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ulasan',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  isLoading ? ShimmerWidgets.reviewsShimmer() : _buildReviews(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews() {
    final reviewProvider = Provider.of<ReviewProvider>(context);
    final novelId = widget.novelId; // Sesuaikan ambil ID dari novel

    if (reviewProvider.isLoading) {
      return ShimmerWidgets.reviewsShimmer();
    }

    if (reviewProvider.reviews.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
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
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.rate_review, size: 48, color: Colors.grey),
              const SizedBox(height: 8),
              Text(
                'Belum ada review',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Jadilah reviewer pertama!',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _showAddReviewDialog(novelId); // Modal form review
                },
                child: const Text('Tulis Review'),
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
      ],
    );
  }

  Widget _buildReviewItem(Review review) {
    final commentProvider =
        Provider.of<CommentProvider>(context, listen: false);
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

    return FutureBuilder(
      future: commentProvider.loadComments(review.id),
      builder: (context, snapshot) {
        final comments = commentProvider.comments;

        return ValueListenableBuilder(
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
                  /// Header
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              DateFormat('dd MMM yyyy')
                                  .format(review.createdAt),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
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

                  /// Review Text
                  Text(
                    review.comment,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 12),

                  /// Like Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            // Like functionality
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.thumb_up,
                                  size: 16,
                                  color: Colors.blue[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${review.likesCount ?? 0}',
                                  style: TextStyle(
                                    color: Colors.blue[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// Toggle Komentar
                  const Divider(),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        isExpanded.value = !isExpanded.value;
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
                              expanded
                                  ? 'Sembunyikan Komentar'
                                  : 'Lihat Komentar',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[700],
                              ),
                            ),
                            const SizedBox(width: 4),
                            if (!expanded && comments.isNotEmpty)
                              Container(
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
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// Komentar-komentar
                  AnimatedCrossFade(
                    firstChild: const SizedBox(height: 0),
                    secondChild: Column(
                      children: [
                        const SizedBox(height: 12),
                        commentProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : comments.isEmpty
                                ? Container(
                                    padding: const EdgeInsets.all(16),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Belum ada komentar.',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  )
                                : ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                    DateFormat(
                                                            'dd MMM yyyy HH:mm')
                                                        .format(
                                                            comment.createdAt),
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                                      // Tampilkan indicator loading
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );

                                      try {
                                        await commentProvider.addComment(
                                            review.id, newComment);
                                        await commentProvider
                                            .loadComments(review.id);
                                        commentController.clear();

                                        // Tutup dialog loading
                                        Navigator.of(context).pop();

                                        // Tampilkan snackbar sukses
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Komentar berhasil ditambahkan'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      } catch (e) {
                                        // Tutup dialog loading
                                        Navigator.of(context).pop();

                                        // Tampilkan error
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Gagal menambahkan komentar: ${e.toString()}'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  icon: const Icon(Icons.send, size: 16),
                                  label: const Text('Kirim'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[700],
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    elevation: 0,
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
                    ),
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
      },
    );
  }
}
