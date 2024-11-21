import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_task/services.dart';
import 'package:wallpaper_task/json.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    // Initial fetch when page loads
    context.read<WallpaperProvider>().fetchWallpapers();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_isLoading) {
        _loadMoreWallpapers();
      }
    }
  }

  void _loadMoreWallpapers() {
    setState(() {
      _isLoading = true;
    });
    context.read<WallpaperProvider>().fetchWallpapers().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _downloadImage(String url) {
    // Implement your download logic here
    print('Downloading image from $url');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
          actions: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {},
                  child: const CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 20,
                    child: Text(
                      'Follow',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: SafeArea(
            // Wrap the body with SafeArea
            child: Column(children: [
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: Column(
                    children: [
                      const Text(
                        'Activity',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Community',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Shop',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              // Use Expanded to allow the list to take the available space
              child: Container(
                  color: Colors.black,
                  child: Stack(children: [
                    Positioned.fill(
                        child: Container(
                      decoration: BoxDecoration(
                        color: Colors
                            .white, // You can change the background color if needed
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(
                              20), // Curved border at the bottom left
                          topRight: Radius.circular(
                              20), // Curved border at the bottom right
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(
                                0, 4), // Shadow effect for a nice look
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Main content (GridView of wallpapers)
                          Consumer<WallpaperProvider>(
                            builder: (context, provider, child) {
                              if (provider.wallpapers.isEmpty) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              return SingleChildScrollView(
                                controller: _scrollController,
                                child: Column(
                                  children: [
                                    GridView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            2, // Number of columns in the grid
                                        crossAxisSpacing:
                                            10.0, // Space between columns
                                        mainAxisSpacing:
                                            10.0, // Space between rows
                                        childAspectRatio:
                                            0.8, // Adjust the aspect ratio to fit the content
                                      ),
                                      itemCount: provider.wallpapers.length + 1,
                                      itemBuilder: (context, index) {
                                        if (index ==
                                            provider.wallpapers.length) {
                                          if (_isLoading) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                          return Container();
                                        }

                                        Wallpaper wallpaperData =
                                            provider.wallpapers[index];
                                        return GestureDetector(
                                          onTap: () => _downloadImage(
                                              wallpaperData.urls?.full ?? ''),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Stack(
                                                    children: [
                                                      // The wallpaper image
                                                      Image.network(
                                                        wallpaperData.urls
                                                                ?.regular ??
                                                            '',
                                                        fit: BoxFit.cover,
                                                        height: double.infinity,
                                                        width: double.infinity,
                                                        errorBuilder: (context,
                                                                error,
                                                                stackTrace) =>
                                                            const Icon(
                                                                Icons.error),
                                                        loadingBuilder: (context,
                                                            child,
                                                            loadingProgress) {
                                                          if (loadingProgress ==
                                                              null)
                                                            return child;
                                                          return const CircularProgressIndicator();
                                                        },
                                                      ),
                                                      // Displaying the price or rating in the top-left corner
                                                      Positioned(
                                                        top: 8,
                                                        left: 8,
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              Colors.black
                                                                  .withOpacity(
                                                                      0.5),
                                                          radius: 20,
                                                          child: Text(
                                                            '\$${(index + 1) * 10}', // Price or Rating
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Product $index', // Use dynamic data here
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 4),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    // Show loading indicator at the bottom of the page
                                    if (_isLoading)
                                      const Center(
                                          child: CircularProgressIndicator()),
                                  ],
                                ),
                              );
                            },
                          ),

                          // Positioned Bottom Navigation Bar
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 30,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: BottomNavigationBar(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                currentIndex: _selectedIndex,
                                onTap: _onItemTapped,
                                items: [
                                  BottomNavigationBarItem(
                                    icon: _selectedIndex == 0
                                        ? Image.asset('assets/download.jpeg',
                                            width: 24, height: 24)
                                        : Image.asset(
                                            'assets/download.jpeg',
                                            width: 24,
                                            height: 24,
                                          ),
                                    label: 'Home',
                                  ),
                                  BottomNavigationBarItem(
                                    icon: _selectedIndex == 1
                                        ? const Icon(Icons.search,
                                            color: Colors.blue)
                                        : const Icon(Icons.search,
                                            color: Colors.grey),
                                    label: 'Search',
                                  ),
                                  BottomNavigationBarItem(
                                    icon: _selectedIndex == 3
                                        ? const Icon(Icons.notifications,
                                            color: Colors.blue)
                                        : const Icon(Icons.notifications,
                                            color: Colors.grey),
                                    label: 'Notifications',
                                  ),
                                  BottomNavigationBarItem(
                                    icon: _selectedIndex == 2
                                        ? const Icon(Icons.account_circle,
                                            color: Colors.blue)
                                        : const Icon(Icons.account_circle,
                                            color: Colors.grey),
                                    label: 'Profile',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                  ])))
        ])));
  }
}
