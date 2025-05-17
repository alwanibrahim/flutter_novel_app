import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_novel_app/data/provider/chapter_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadNovelScreen extends StatefulWidget {
  final int novelId;
  final int initialChapterIndex;

  const ReadNovelScreen({
    Key? key,
    required this.novelId,
    this.initialChapterIndex = 0,
  }) : super(key: key);

  @override
  State<ReadNovelScreen> createState() => _ReadNovelScreenState();
}

class _ReadNovelScreenState extends State<ReadNovelScreen> {
  late int _currentChapterIndex;
  late ScrollController _scrollController;
  bool _showAppBar = true;

  // Text settings
  double _fontSize = 16.0;
  String _currentTheme = 'light';
  Color _backgroundColor = Colors.white;
  Color _textColor = Colors.black87;
  String _fontFamily = 'Roboto';
  double _lineHeight = 1.6;

  @override
  void initState() {
    super.initState();
    _currentChapterIndex = widget.initialChapterIndex;
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    // Load saved text settings
    _loadTextSettings();

    // Fetch chapters
 WidgetsBinding.instance.addPostFrameCallback((_) {
      final chapterProvider =
          Provider.of<ChapterProvider>(context, listen: false);
      if (!chapterProvider.isFetched) {
        chapterProvider.fetchChapters(widget.novelId);
      }
    });

  }

  Future<void> _loadTextSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _fontSize = prefs.getDouble('fontSize') ?? 16.0;
        _currentTheme = prefs.getString('theme') ?? 'light';
        _fontFamily = prefs.getString('fontFamily') ?? 'Roboto';
        _lineHeight = prefs.getDouble('lineHeight') ?? 1.6;

        // Set colors based on theme
        _updateThemeColors(_currentTheme);
      });
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  void _updateThemeColors(String theme) {
    switch (theme) {
      case 'dark':
        _backgroundColor = Colors.black;
        _textColor = Colors.white;
        break;
      case 'sepia':
        _backgroundColor = const Color(0xFFF5F2E9);
        _textColor = Colors.brown[800]!;
        break;
      case 'light':
      default:
        _backgroundColor = Colors.white;
        _textColor = Colors.black87;
        break;
    }
  }

  Future<void> _saveTextSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('fontSize', _fontSize);
      await prefs.setString('theme', _currentTheme);
      await prefs.setString('fontFamily', _fontFamily);
      await prefs.setDouble('lineHeight', _lineHeight);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Hide/show app bar based on scroll direction
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_showAppBar) {
        setState(() {
          _showAppBar = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_showAppBar) {
        setState(() {
          _showAppBar = true;
        });
      }
    }
  }

  void _nextChapter() {
    final chapterProvider = Provider.of<ChapterProvider>(context, listen: false);
    if (_currentChapterIndex < chapterProvider.chapters.length - 1) {
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

  void _changeTheme(String theme) {
    setState(() {
      _currentTheme = theme;
      _updateThemeColors(theme);
    });
    _saveTextSettings();
    Navigator.pop(context);
  }

  void _changeFontSize(double size) {
    setState(() {
      _fontSize = size;
    });
    _saveTextSettings();
  }

  void _changeFontFamily(String fontFamily) {
    setState(() {
      _fontFamily = fontFamily;
    });
    _saveTextSettings();
  }

  void _changeLineHeight(double height) {
    setState(() {
      _lineHeight = height;
    });
    _saveTextSettings();
  }

  @override
  Widget build(BuildContext context) {
    final chapterProvider = Provider.of<ChapterProvider>(context);
    final chapter = chapterProvider.chapters.isNotEmpty
        ? chapterProvider.chapters[_currentChapterIndex]
        : null;
    final totalChapter = chapterProvider.totalChapter;

    if (chapterProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (chapter == null || chapterProvider.chapters.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Novel Reader')),
        body: const Center(child: Text('Tidak ada chapter yang tersedia')),
      );
    }

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: _showAppBar
          ? AppBar(
              title: Text(chapter.title),
              centerTitle: false,
              backgroundColor: _backgroundColor,
              foregroundColor: _textColor,
              elevation: 1,
              actions: [
                IconButton(
                  icon: const Icon(Icons.text_fields),
                  onPressed: _showTextSettingsDialog,
                  tooltip: 'Pengaturan Teks',
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bookmark ditambahkan')),
                    );
                  },
                  tooltip: 'Tambah Bookmark',
                ),
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: _showChapterList,
                  tooltip: 'Daftar Bab',
                ),
              ],
            )
          : null,
      body: Column(
        children: [
          // Chapter progress indicator
          LinearProgressIndicator(
            value: (_currentChapterIndex + 1) / totalChapter,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
                _currentTheme == 'dark' ? Colors.blueAccent : Theme.of(context).primaryColor),
            minHeight: 2,
          ),

          // Chapter content
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showAppBar = !_showAppBar;
                });
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chapter title
                    Text(
                      chapter.title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: _textColor,
                            fontFamily: _fontFamily,
                          ),
                    ),
                    const SizedBox(height: 24),

                    // Chapter content
                    Text(
                      chapter.content,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: _lineHeight,
                            color: _textColor,
                            fontSize: _fontSize,
                            fontFamily: _fontFamily,
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
                            backgroundColor: _currentTheme == 'dark' ? Colors.grey[800] : Colors.grey[200],
                            foregroundColor: _textColor,
                            disabledBackgroundColor: _currentTheme == 'dark' ? Colors.grey[900] : Colors.grey[100],
                            disabledForegroundColor: Colors.grey,
                          ),
                        ),

                        // Next chapter button
                        ElevatedButton.icon(
                          onPressed: _currentChapterIndex < totalChapter - 1 ? _nextChapter : null,
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Selanjutnya'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: _currentTheme == 'dark' ? Colors.grey[900] : Colors.grey[100],
                            disabledForegroundColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _showAppBar
          ? BottomAppBar(
              color: _backgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Chapter indicator
                    Text(
                      'Bab ${_currentChapterIndex + 1}/$totalChapter',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: _textColor,
                          ),
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
                        totalChapter,
                        (index) => DropdownMenuItem(
                          value: index,
                          child: Text('Bab ${index + 1}'),
                        ),
                      ),
                      underline: Container(),
                      dropdownColor: _backgroundColor,
                      style: TextStyle(color: _textColor),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  void _showTextSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Pengaturan Teks'),
            backgroundColor: _backgroundColor,
            titleTextStyle: TextStyle(
              color: _textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            contentTextStyle: TextStyle(
              color: _textColor,
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Font size slider
                  Text(
                    'Ukuran Teks',
                    style: TextStyle(color: _textColor, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.text_decrease, size: 20),
                      Expanded(
                        child: Slider(
                          value: _fontSize,
                          min: 12,
                          max: 24,
                          divisions: 12,
                          label: _fontSize.toStringAsFixed(1),
                          onChanged: (value) {
                            setStateDialog(() {
                              _fontSize = value;
                            });
                            _changeFontSize(value);
                          },
                          activeColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      const Icon(Icons.text_increase, size: 24),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Line height
                  Text(
                    'Jarak Baris',
                    style: TextStyle(color: _textColor, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.format_line_spacing, size: 20),
                      Expanded(
                        child: Slider(
                          value: _lineHeight,
                          min: 1.0,
                          max: 2.5,
                          divisions: 15,
                          label: _lineHeight.toStringAsFixed(1),
                          onChanged: (value) {
                            setStateDialog(() {
                              _lineHeight = value;
                            });
                            _changeLineHeight(value);
                          },
                          activeColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      const Icon(Icons.format_line_spacing, size: 24),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Font family selection
                  Text(
                    'Jenis Font',
                    style: TextStyle(color: _textColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    children: [
                      _buildFontFamilyOption('Roboto', 'Roboto'),
                      _buildFontFamilyOption('Serif', 'Georgia'),
                      _buildFontFamilyOption('Sans', 'Arial'),
                      _buildFontFamilyOption('Mono', 'Courier'),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Theme selection
                  Text(
                    'Tema',
                    style: TextStyle(color: _textColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    children: [
                      _buildThemeOption('Terang', 'light', Colors.white, Colors.black87),
                      _buildThemeOption('Gelap', 'dark', Colors.black, Colors.white),
                      _buildThemeOption('Sepia', 'sepia', const Color(0xFFF5F2E9), Colors.brown[800]!),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Tutup',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFontFamilyOption(String label, String fontFamily) {
    final isSelected = _fontFamily == fontFamily;

    return InkWell(
      onTap: () {
        _changeFontFamily(fontFamily);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.2) : Colors.transparent,
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: fontFamily,
            color: _textColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption(String label, String themeKey, Color bgColor, Color textColor) {
    final isSelected = _currentTheme == themeKey;

    return InkWell(
      onTap: () {
        _changeTheme(themeKey);
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Aa',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: _textColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showChapterList() {
    final chapterProvider = Provider.of<ChapterProvider>(context, listen: false);
    final chapters = chapterProvider.chapters;

    showModalBottomSheet(
      context: context,
      backgroundColor: _backgroundColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Text(
                    'Daftar Bab',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: chapters.length,
                    itemBuilder: (context, index) {
                      final chapter = chapters[index];
                      final isCurrentChapter = index == _currentChapterIndex;

                      return ListTile(
                        title: Text(
                          chapter.title,
                          style: TextStyle(
                            color: _textColor,
                            fontWeight: isCurrentChapter ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          'Bab ${index + 1}',
                          style: TextStyle(
                            color: _textColor.withOpacity(0.7),
                          ),
                        ),
                        leading: isCurrentChapter
                            ? Icon(
                                Icons.bookmark,
                                color: Theme.of(context).primaryColor,
                              )
                            : const Icon(Icons.bookmark_border),
                        onTap: () {
                          setState(() {
                            _currentChapterIndex = index;
                            _scrollController.jumpTo(0);
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
