import 'package:flutter/material.dart';
import '../models/novel_model.dart';
import '../models/review_model.dart';

class ReviewScreen extends StatefulWidget {
  final Novel novel;

  const ReviewScreen({
    Key? key,
    required this.novel,
  }) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isSpoiler = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reviews = Review.getReviewsByNovel(widget.novel.id);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ulasan'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Novel info
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                // Novel cover
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.novel.coverImage,
                    height: 80,
                    width: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 80,
                        width: 60,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 24),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Novel title and rating
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.novel.title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.novel.author.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.novel.averageRating} (${reviews.length} ulasan)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Write review button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: ElevatedButton(
              onPressed: () {
                _showAddReviewBottomSheet();
              },
              child: const Text('Tulis Ulasan'),
            ),
          ),
          
          // Reviews list
          Expanded(
            child: reviews.isEmpty
                ? _buildEmptyReviews()
                : ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      return _buildReviewItem(reviews[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyReviews() {
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
            'Jadilah yang pertama memberikan ulasan',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Review review) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          // Like button and spoiler tag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Spoiler tag if applicable
              if (review.isSpoiler)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Spoiler',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.red[800],
                    ),
                  ),
                ),
              // Like button
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

  void _showAddReviewBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Tulis Ulasan',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  // Rating selection
                  Text(
                    'Rating',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _selectedRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedRating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  
                  // Review text field
                  Text(
                    'Ulasan',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _reviewController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Bagikan pendapat Anda tentang novel ini...',
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Spoiler checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _isSpoiler,
                        onChanged: (value) {
                          setState(() {
                            _isSpoiler = value ?? false;
                          });
                        },
                      ),
                      const Text('Ulasan ini mengandung spoiler'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedRating > 0 && _reviewController.text.isNotEmpty
                          ? () {
                              // Submit review
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Ulasan berhasil dikirim'),
                                ),
                              );
                            }
                          : null,
                      child: const Text('Kirim Ulasan'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
