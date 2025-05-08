import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/novel_model.dart';

class ReadNovelScreen extends StatefulWidget {
  final Novel novel;
  final int initialChapterIndex;

  const ReadNovelScreen({
    Key? key,
    required this.novel,
    this.initialChapterIndex = 0,
  }) : super(key: key);

  @override
  State<ReadNovelScreen> createState() => _ReadNovelScreenState();
}

class _ReadNovelScreenState extends State<ReadNovelScreen> {
  late int _currentChapterIndex;
  late ScrollController _scrollController;
  bool _showAppBar = true;

  @override
  void initState() {
    super.initState();
    _currentChapterIndex = widget.initialChapterIndex;
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Hide/show app bar based on scroll direction
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_showAppBar) {
        setState(() {
          _showAppBar = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_showAppBar) {
        setState(() {
          _showAppBar = true;
        });
      }
    }
  }


  void _nextChapter() {
    if (_currentChapterIndex < widget.novel.chapters.length - 1) {
      setState(() {
        _currentChapterIndex++;
        _scrollController.jumpTo(0);
      });
    }
  }

  void _previousChapter() {
    if (_currentChapterIndex > 0) {
      setState(() {
        _currentChapterIndex--;
        _scrollController.jumpTo(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chapter = widget.novel.chapters[_currentChapterIndex];

    return Scaffold(
      appBar: _showAppBar ? AppBar(
        title: Text(widget.novel.title),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: () {
              // Show text settings dialog
              _showTextSettingsDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // Bookmark functionality
            },
          ),
        ],
      ) : null,
      body: Column(
        children: [
          // Chapter progress indicator
          LinearProgressIndicator(
            value: (_currentChapterIndex + 1) / widget.novel.chapters.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            minHeight: 2,
          ),

          // Chapter content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chapter title
                  Text(
                    chapter.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),

                  // Chapter content
                  Text(
                    chapter.content,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Chapter navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Previous chapter button
                      ElevatedButton.icon(
                        onPressed: _currentChapterIndex > 0 ? _previousChapter : null,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Sebelumnya'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.black,
                          disabledBackgroundColor: Colors.grey[100],
                          disabledForegroundColor: Colors.grey,
                        ),
                      ),

                      // Next chapter button
                      ElevatedButton.icon(
                        onPressed: _currentChapterIndex < widget.novel.chapters.length - 1 ? _nextChapter : null,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Selanjutnya'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[100],
                          disabledForegroundColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _showAppBar ? BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Chapter indicator
              Text(
                'Bab ${_currentChapterIndex + 1}/${widget.novel.chapters.length}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              // Chapter dropdown
              DropdownButton<int>(
                value: _currentChapterIndex,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _currentChapterIndex = value;
                      _scrollController.jumpTo(0);
                    });
                  }
                },
                items: List.generate(
                  widget.novel.chapters.length,
                  (index) => DropdownMenuItem(
                    value: index,
                    child: Text('Bab ${index + 1}'),
                  ),
                ),
                underline: Container(),
              ),
            ],
          ),
        ),
      ) : null,
    );
  }

  void _showTextSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pengaturan Teks'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Font size slider
            const Text('Ukuran Teks'),
            Slider(
              value: 16,
              min: 12,
              max: 24,
              divisions: 6,
              label: '16',
              onChanged: (value) {
                // Change font size
              },
            ),

            const SizedBox(height: 16),

            // Theme selection
            const Text('Tema'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildThemeOption('Terang', Colors.white, Colors.black),
                _buildThemeOption('Gelap', Colors.black, Colors.white),
                _buildThemeOption('Sepia', const Color(0xFFF5F2E9), Colors.brown[800]!),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(String label, Color bgColor, Color textColor) {
    return InkWell(
      onTap: () {
        // Change theme
      },
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'A',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
