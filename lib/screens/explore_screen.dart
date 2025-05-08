import 'package:flutter/material.dart';
import '../models/novel_model.dart';
import '../models/category_model.dart';
import 'detail_novel_screen.dart';

class ExploreScren extends StatefulWidget {
  const ExploreScren({Key? key}) : super(key: key);

  @override
  State<ExploreScren> createState() => _ExploreScrenState();
}

class _ExploreScrenState extends State<ExploreScren>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<Novel> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: Category.categories.length + 1, // +1 for "Semua" tab
      vsync: this,
    );
    _searchController.addListener(() {
      setState(() {}); // To update the clear button visibility
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = Novel.searchNovels(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari novel, penulis, atau genre...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _performSearch('');
                              FocusScope.of(context).unfocus();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: _performSearch,
                ),
              ),

              // Tab Bar
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: [
                  const Tab(text: 'Semua'),
                  ...Category.categories
                      .map((category) => Tab(text: category.name)),
                ],
              ),
            ],
          ),
        ),
      ),
      body: _isSearching
          ? _buildSearchResults()
          : TabBarView(
              controller: _tabController,
              children: [
                // All Novels Tab
                _buildNovelGrid(Novel.novels),
                // Category Tabs
                ...Category.categories.map(
                  (category) => _buildNovelGrid(
                    Novel.getNovelsByCategory(category.id),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada hasil yang ditemukan',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      );
    }

    return _buildNovelGrid(_searchResults);
  }

  Widget _buildNovelGrid(List<Novel> novels) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.55,
        crossAxisSpacing: 10,
        mainAxisSpacing: 14,
      ),
      itemCount: novels.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final novel = novels[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailNovelScreen(novel: novel),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
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
                // Novel Cover
                Expanded(
                  child: Hero(
                    tag: 'novel_${novel.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            novel.coverImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(Icons.image_not_supported,
                                      size: 24, color: Colors.grey),
                                ),
                              );
                            },
                          ),
                          // Gradient overlay for better text visibility
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Status badge (optional)

                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                // Novel Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    novel.title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 2),
                // Author Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    novel.author.name,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 3),
                // Rating
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        novel.averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      
                        Text(
                          '${novel.pageCount} Ch',
                          style: TextStyle(
                            fontSize: 9,
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
