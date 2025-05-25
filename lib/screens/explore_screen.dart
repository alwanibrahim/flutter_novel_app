import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_novel_app/data/model/novel_model.dart';
import 'package:flutter_novel_app/data/provider/category_provider.dart';
import 'package:flutter_novel_app/data/provider/novel_provider.dart';
import 'package:flutter_novel_app/screens/detail_novel_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isInitialized = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Jalankan setelah frame dan dalam microtask
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() => _initializeData());
    });

    // Search listener
    _searchController.addListener(_handleSearchChange);
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      final novelProvider = Provider.of<NovelProvider>(context, listen: false);

      // Fetch categories and novels concurrently
      await Future.wait([
        categoryProvider.getCategory(),
        novelProvider.getNovel(),
      ]);

      // Ensure we have at least one tab (All)
      final totalTabs = categoryProvider.dataList.isEmpty
          ? 1
          : categoryProvider.dataList.length + 1;

      // Update tab controller after categories are loaded
      if (mounted) {
        setState(() {
          _tabController = TabController(
            length: totalTabs,
            vsync: this,
            initialIndex: 0,
          );
          _isInitialized = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Handle any errors during initialization
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleSearchChange() {
    final query = _searchController.text.trim();
    final novelProvider = Provider.of<NovelProvider>(context, listen: false);
    novelProvider.getNovel();

    setState(() {
      _isSearching = query.isNotEmpty;
    });

    if (query.isNotEmpty) {
      novelProvider.searchNovels(query);
    } else {
      novelProvider.clearSearch();
    }
  }

  void _clearSearch() {
    _searchController.clear();
    FocusScope.of(context).unfocus();
  }

  Future<void> _refreshData() async {
    await _initializeData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final novelProvider = Provider.of<NovelProvider>(context);
    novelProvider.getNovel();

    // Show loading indicator while categories are being fetched
    if (categoryProvider.isLoading || !_isInitialized) {
      return _buildLoadingScaffold();
    }

    // Ensure tab controller is created
    if (_tabController == null) {
      return _buildLoadingScaffold();
    }

    // Prepare tabs and tab views
    final tabs = [
      const Tab(text: 'Semua'),
      ...categoryProvider.dataList.map((category) => Tab(text: category.name)),
    ];

    final tabViews = [
      // All Novels Tab
      _isLoading
          ? _buildShimmerGrid()
          : _buildNovelGrid(novelProvider.dataList),

      // Category Tabs
      ...categoryProvider.dataList.map(
        (category) => _buildCategoryTab(category.id),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore', style: TextStyle(fontSize: 16)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: _refreshData,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari novel, penulis, genre...',
                    hintStyle: const TextStyle(fontSize: 12),
                    prefixIcon: const Icon(Icons.search, size: 18),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: _clearSearch,
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: const TextStyle(fontSize: 12),
                ),
              ),

              // Tab Bar
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Theme.of(context).primaryColor,
                labelStyle:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(fontSize: 12),
                indicatorWeight: 2,
                tabs: tabs,
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _isSearching
            ? _buildSearchResults()
            : TabBarView(
                controller: _tabController,
                children: tabViews,
              ),
      ),
    );
  }

  Widget _buildLoadingScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore', style: TextStyle(fontSize: 16)),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Column(
            children: [
              // Shimmer Search Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),

              // Shimmer Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Row(
                    children: List.generate(
                        4,
                        (index) => Container(
                              width: 60,
                              height: 30,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            )),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: _buildShimmerGrid(),
    );
  }

  Widget _buildShimmerGrid() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.55,
          crossAxisSpacing: 8,
          mainAxisSpacing: 10,
        ),
        itemCount: 12,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover Image Shimmer
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // Title Shimmer
              Container(
                width: double.infinity,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 4),
              // Author Shimmer
              Container(
                width: 60,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryTab(int categoryId) {
    final novelProvider = Provider.of<NovelProvider>(context);

    return FutureBuilder<List<NovelModel>>(
      future: novelProvider.getFetchedNovels(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerGrid();
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 40),
                const SizedBox(height: 12),
                Text(
                  'Error loading novels',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  '${snapshot.error}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.book_outlined, color: Colors.grey, size: 40),
                SizedBox(height: 12),
                Text(
                  'Tidak ada novel dalam kategori ini',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          );
        }

        // Filter novels berdasarkan kategori
        final novelsInCategory = snapshot.data!.where((novel) {
          return novel.categoryId == categoryId;
        }).toList();

        // Jika tidak ada novel dalam kategori, tampilkan pesan
        if (novelsInCategory.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.book_outlined, color: Colors.grey, size: 40),
                SizedBox(height: 12),
                Text(
                  'Tidak ada novel dalam kategori ini',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          );
        }

        // Show novels by category
        return _buildNovelGrid(novelsInCategory);
      },
    );
  }

  Widget _buildSearchResults() {
    final novelProvider = Provider.of<NovelProvider>(context);

    if (novelProvider.searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 40,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            Text(
              'Tidak ada hasil yang ditemukan',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
            ),
          ],
        ),
      );
    }

    return _buildNovelGrid(novelProvider.searchResults);
  }

  Widget _buildNovelGrid(List<NovelModel> novels) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.55,
        crossAxisSpacing: 8,
        mainAxisSpacing: 10,
      ),
      itemCount: novels.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final novel = novels[index];
        return _buildNovelGridItem(novel);
      },
    );
  }

  Widget _buildNovelGridItem(NovelModel novel) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailNovelScreen(novelId: novel.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
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
                  borderRadius: BorderRadius.circular(6),
                  child: _buildNovelCoverImage(novel),
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Novel Details
            _buildNovelDetails(novel),
          ],
        ),
      ),
    );
  }

  Widget _buildNovelCoverImage(NovelModel novel) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          'https://www.mamamnovel.suarafakta.my.id/storage/${novel.coverImage}',
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 18,
                  color: Colors.grey,
                ),
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
            height: 30,
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
      ],
    );
  }

  Widget _buildNovelDetails(NovelModel novel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Novel Title
          Text(
            novel.title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // Author Name
          Text(
            novel.author.name,
            style: TextStyle(
              fontSize: 8,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
