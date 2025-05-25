import 'package:flutter/material.dart';

class EnhancedDrawer extends StatelessWidget {
  final String username;
  final String email;
  final NetworkImage? profileImageUrl;

  const EnhancedDrawer({
    Key? key,
    this.username = "Pengguna Novel",
    this.email = "pengguna@email.com",
    this.profileImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Expanded section containing the main drawer items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Enhanced drawer header
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF015754), Color(0xFF017374)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.book,
                                  color: Colors.white, size: 30),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'NovelApp',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Selamat datang!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Temukan dan baca novel favoritmu.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Menu items with enhanced styling
                  _buildMenuItem(
                    context,
                    icon: Icons.home_rounded,
                    title: 'Beranda',
                    route: '/main',
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.explore,
                    title: 'Eksplor Novel',
                    route: '/explore',
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.bookmark,
                    title: 'Novel Tersimpan',
                    route: '/saved',
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.trending_up,
                    title: 'Novel Unggulan',
                    route: '/main',
                  ),

                  const Divider(),

                  _buildMenuItem(
                    context,
                    icon: Icons.category,
                    title: 'Kategori',
                    route: '/explore',
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.history,
                    title: 'Riwayat Bacaan',
                    route: '/profile',
                  ),

                  const Divider(),

                  // _buildMenuItem(
                  //   context,
                  //   icon: Icons.settings,
                  //   title: 'Pengaturan',
                  //   route: '/settings',
                  // ),

                  // _buildMenuItem(
                  //   context,
                  //   icon: Icons.help_outline,
                  //   title: 'Bantuan',
                  //   route: '/help',
                  // ),
                ],
              ),
            ),

            // Profile section at the bottom of the drawer
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Profile picture
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFF015754),
                      backgroundImage: profileImageUrl ??
                          AssetImage('assets/images/photo.jpeg'),

                      child: profileImageUrl == null
                          ? const Text(
                              'P',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    // User info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            email,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Profile icon
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build menu items
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF015754),
          size: 24,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
        hoverColor: const Color(0xFF015754).withOpacity(0.1),
        dense: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -1),
      ),
    );
  }
}
