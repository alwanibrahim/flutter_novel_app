import 'package:flutter/material.dart';
import '../models/novel_model.dart';
import '../models/favorite_model.dart';
import 'detail_novel_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGridView = true;

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

    final favoriteIds = Favorite.getFavoriteNovelIds(1);
    final favoriteNovels = Novel.novels.where((novel) => favoriteIds.contains(novel.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tersimpan'),
        centerTitle: false,
        actions: [

          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Novel'),
            Tab(text: 'Riwayat'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [

          favoriteNovels.isEmpty
              ? _buildEmptyFavorites()
              : _isGridView
                  ? _buildGridView(favoriteNovels)
                  : _buildListView(favoriteNovels),


          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.history,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'Riwayat Bacaan',
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
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFavorites() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.bookmark_border,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada novel tersimpan',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Novel yang Anda simpan akan muncul di sini',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExploreScreen(),
                ),
              );
            },
            child: const Text('Jelajahi Novel'),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<Novel> novels) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: novels.length,
      itemBuilder: (context, index) {
        final novel = novels[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailNovelScreen(novel: novel),
              ),
            ).then((_) => setState(() {}));
          },
          child: Stack(
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        novel.coverImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported, size: 40),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    novel.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Text(
                    novel.author.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),


              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.bookmark, color: Colors.amber),
                    onPressed: () {

                      setState(() {
                        Favorite.favorites.removeWhere(
                          (favorite) => favorite.userId == 1 && favorite.novelId == novel.id,
                        );
                      });
                    },
                    iconSize: 20,
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListView(List<Novel> novels) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: novels.length,
      itemBuilder: (context, index) {
        final novel = novels[index];
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
              ).then((_) => setState(() {}));
            },
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [

                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  child: Image.asset(
                    novel.coverImage,
                    height: 120,
                    width: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        width: 80,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 24),
                        ),
                      );
                    },
                  ),
                ),

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
                          novel.author.name,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          novel.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.bookmark, color: Colors.amber),
                  onPressed: () {

                    setState(() {
                      Favorite.favorites.removeWhere(
                        (favorite) => favorite.userId == 1 && favorite.novelId == novel.id,
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
