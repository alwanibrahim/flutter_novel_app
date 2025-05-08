import 'package:flutter/material.dart';
import '../models/novel_model.dart';
import '../models/review_model.dart';
import '../models/favorite_model.dart';
import 'read_novel_screen.dart';
import 'review_screen.dart';

class DetailNovelScreen extends StatefulWidget {
  final Novel novel;

  const DetailNovelScreen({
    Key? key,
    required this.novel,
  }) : super(key: key);

  @override
  State<DetailNovelScreen> createState() => _DetailNovelScreenState();
}

class _DetailNovelScreenState extends State<DetailNovelScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Check if novel is in favorites
    _isFavorite = Favorite.isNovelFavorited(1, widget.novel.id); // Assuming current user id is 1
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    // In a real app, you would update the database here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Novel Cover
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Novel Cover
                  Image.asset(
                    widget.novel.coverImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 64),
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
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.bookmark : Icons.bookmark_border,
                  color: _isFavorite ? Colors.amber : Colors.white,
                ),
                onPressed: _toggleFavorite,
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  // Share functionality
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
                  Text(
                    widget.novel.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'oleh ${widget.novel.author.name}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Rating and Stats
                  Row(
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
                            widget.novel.averageRating.toString(),
                            style: Theme.of(context).textTheme.titleMedium,
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
                            '${widget.novel.viewCount}',
                            style: Theme.of(context).textTheme.titleMedium,
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
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          widget.novel.category.name,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReadNovelScreen(novel: widget.novel),
                          ),
                        );
                      },
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
                  Text(
                    widget.novel.description,
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
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewScreen(novel: widget.novel),
                            ),
                          );
                        },
                        child: const Text('Lihat Semua'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildReviews(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews() {
    final reviews = Review.getReviewsByNovel(widget.novel.id);
    
    if (reviews.isEmpty) {
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
              const Icon(
                Icons.rate_review,
                size: 48,
                color: Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                'Belum ada ulasan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Navigate to add review screen
                },
                child: const Text('Tulis Ulasan'),
              ),
            ],
          ),
        ),
      );
    }

    // Show only first 3 reviews
    final displayedReviews = reviews.take(3).toList();
    
    return Column(
      children: displayedReviews.map((review) => _buildReviewItem(review)).toList(),
    );
  }

  Widget _buildReviewItem(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info and rating
          Row(
            children: [
              // User avatar
              CircleAvatar(
                backgroundImage: AssetImage(review.userProfilePicture),
                radius: 20,
                onBackgroundImageError: (exception, stackTrace) {
                  // Handle error
                },
              ),
              const SizedBox(width: 12),
              // Username and date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.username,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      review.createdAt,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Rating
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Review comment
          Text(
            review.comment,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          // Like button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.thumb_up, size: 16),
                label: Text('${review.likesCount}'),
                onPressed: () {
                  // Like functionality
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
