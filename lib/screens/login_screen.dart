import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/cities.dart';
import 'login_sections.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoggedIn = false;
  String _phoneNumber = '';
  double _budget = 2.0;
  String _selectedCity = 'All cities';
  String _selectedPropertyType = 'Any BHK';
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _mobileNavIndex = 0;
  final Set<String> _savedProperties = {};

  void _showSavedPropertiesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Saved Properties', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SizedBox(
                width: 400,
                child: _savedProperties.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No saved properties yet.', style: TextStyle(color: Colors.black54)),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _savedProperties.length,
                        itemBuilder: (context, index) {
                          final title = _savedProperties.elementAt(index);
                          return ListTile(
                            title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
                            trailing: IconButton(
                              icon: const Icon(Icons.favorite, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _savedProperties.remove(title);
                                });
                                setDialogState(() {});
                              },
                            ),
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    if (isMobile) {
      return _buildMobileApp(context);
    }

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildProfileDrawer(),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(flex: 1, child: Container(color: const Color(0xFFF9F8F4))),
              Expanded(
                flex: 1,
                child: Image.asset(
                  'assets/images/living_room.jpg',
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
            ],
          ),
          Column(
            children: [
              _buildTopNav(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildNewHeroSection(),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              margin: const EdgeInsets.only(top: 100),
                              color: Colors.white,
                              width: double.infinity,
                              padding: const EdgeInsets.only(top: 120, bottom: 60),
                              child: Column(
                                children: [
                                  const HotspotsNearbySection(),
                                  const SizedBox(height: 60),
                                  buildTopPicks(
                                    isLoggedIn: _isLoggedIn,
                                    savedProperties: _savedProperties,
                                    onSaveToggle: (String title) {
                                      setState(() {
                                        if (_savedProperties.contains(title)) {
                                          _savedProperties.remove(title);
                                        } else {
                                          _savedProperties.add(title);
                                        }
                                      });
                                    },
                                    onLoginRequested: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => LoginDialog(
                                          onLoginSuccess: (phone) {
                                            setState(() {
                                              _isLoggedIn = true;
                                              _phoneNumber = phone;
                                            });
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 60),
                                  const ToolsSection(),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 140,
                            right: 140,
                            child: _buildNewSearchSection(),
                          ),
                        ],
                      ),
                      const HousingIndexSection(),
                      const FooterSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 40,
            right: 40,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 15, offset: const Offset(0, 5)),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Center(child: Icon(Icons.chat_bubble, color: Colors.black, size: 28)),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                      child: const Icon(Icons.close, color: Colors.white, size: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Mobile App Layout ─────────────────────────────────────────────────────

  Widget _buildMobileApp(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF7F7F7),
      endDrawer: _buildProfileDrawer(),
      bottomNavigationBar: _buildMobileBottomNav(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMobileHero(context),
            _buildMobileSearchBar(),
            _buildMobileFilterChips(),
            _buildHandpickedHomesTitle(),
            _buildMobilePropertyCards(context),
            _buildMobileSectionTitle('Hotspots Nearby'),
            _buildMobileHotspotsRow(),
            _buildMobileToolsSection(context),
            const SizedBox(height: 24),
            _buildMobileNewsSection(),
            const SizedBox(height: 24),
            _buildMobileFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileHero(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 480,
          width: double.infinity,
          child: Image.asset(
            'assets/images/living_room.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: 480,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.2),
                Colors.black.withOpacity(0.78),
              ],
            ),
          ),
        ),
        // Top Nav
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(color: Color(0xFFE23A44), shape: BoxShape.circle),
                      child: const Center(
                        child: Text('h', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('housing.com', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: -0.3)),
                  ],
                ),
                Row(
                  children: [
                    _heroNavBtn(Icons.favorite_border, () {}),
                    const SizedBox(width: 10),
                    _heroNavBtn(Icons.person_outline, () {
                      if (_isLoggedIn) {
                        _scaffoldKey.currentState?.openEndDrawer();
                      } else {
                        showDialog(
                          context: context,
                          builder: (_) => LoginDialog(
                            onLoginSuccess: (phone) {
                              setState(() { _isLoggedIn = true; _phoneNumber = phone; });
                            },
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Hero Text
        Positioned(
          bottom: 40,
          left: 24,
          right: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.location_on, color: Color(0xFFE23A44), size: 14),
                  SizedBox(width: 4),
                  Text('Mumbai, India', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Find Your\nDream Home',
                style: TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -1.0),
              ),
              const SizedBox(height: 10),
              const Text(
                'Explore verified properties carefully\nselected for your lifestyle and budget.',
                style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  child: const Text('Get Started', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _heroNavBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildMobileSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.black45, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search city or property...',
                hintStyle: TextStyle(color: Colors.black38, fontSize: 15),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.tune, color: Colors.black54, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFilterChips() {
    final filters = ['All', 'Rent', 'Buy', 'For Sale', 'New'];
    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: filters.length,
        itemBuilder: (context, i) {
          final filter = filters[i];
          final isSelected = filter == _selectedFilter;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1C1C1E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
                boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8)] : [],
              ),
              child: Text(
                filter,
                style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 13),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHandpickedHomesTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('HANDPICKED HOMES', style: TextStyle(color: Colors.black54, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.bold)),
              SizedBox(width: 4),
              Text('·', style: TextStyle(color: Colors.black26, fontSize: 10, fontWeight: FontWeight.bold)),
              SizedBox(width: 4),
              Text('RENT', style: TextStyle(color: Colors.black54, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Homes worth', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400, color: Color(0xFF1C1C1E), height: 1.1)),
          const Text('coming home to.', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic, color: Color(0xFF1C1C1E), height: 1.1, letterSpacing: -0.5)),
        ],
      ),
    );
  }

  Widget _buildMobileSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1C1C1E))),
          const Text('See all ›', style: TextStyle(fontSize: 13, color: Color(0xFFE23A44), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildMobilePropertyCards(BuildContext context) {
    final allProperties = [
      {'name': 'Sattva Anjanapura', 'price': '₹94 L', 'location': 'JP Nagar, Bengaluru', 'beds': '2', 'baths': '2', 'garage': '1', 'isNew': true, 'has3D': true, 'image': 'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=800&q=80', 'type': 'Buy'},
      {'name': 'The Grove Residences', 'price': '₹45K/mo', 'location': 'Whitefield, Bengaluru', 'beds': '3', 'baths': '3', 'garage': '2', 'isNew': false, 'has3D': true, 'image': 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800&q=80', 'type': 'Rent'},
      {'name': 'M3M Crown', 'price': '₹2.38 Cr', 'location': 'Sector 111, Gurugram', 'beds': '4', 'baths': '4', 'garage': '2', 'isNew': false, 'has3D': true, 'image': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800&q=80', 'type': 'For Sale'},
      {'name': 'Lodha Park', 'price': '₹4.5 Cr', 'location': 'Worli, Mumbai', 'beds': '3', 'baths': '3', 'garage': '1', 'isNew': true, 'has3D': false, 'image': 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800&q=80', 'type': 'New'},
      {'name': 'Godrej Nature Plus', 'price': '₹1.2 Cr', 'location': 'Sohna Road, Gurugram', 'beds': '2', 'baths': '2', 'garage': '1', 'isNew': true, 'has3D': true, 'image': 'https://images.unsplash.com/photo-1583608205776-bfd35f0d9f83?w=800&q=80', 'type': 'Buy'},
      {'name': 'Prestige Jindal City', 'price': '₹35K/mo', 'location': 'Tumkur Road, Bengaluru', 'beds': '2', 'baths': '2', 'garage': '1', 'isNew': false, 'has3D': false, 'image': 'https://images.unsplash.com/photo-1510627489930-0c1b0bfb6785?w=800&q=80', 'type': 'Rent'},
    ];

    final properties = allProperties.where((p) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'New' && p['isNew'] == true) return true;
      return p['type'] == _selectedFilter;
    }).toList();

    if (properties.isEmpty) {
      return const SizedBox(
        height: 298,
        child: Center(child: Text('No properties found for this filter.', style: TextStyle(color: Colors.black54))),
      );
    }

    return SizedBox(
      height: 298,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: properties.length,
        itemBuilder: (context, i) {
          final p = properties[i];
          final isSaved = _savedProperties.contains(p['name']);
          final propertyName = p['name'] as String;
          return Align(
            alignment: Alignment.topCenter,
            child: Container(
            width: 238,
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                      child: Image.network(
                        p['image'] as String,
                        height: 165,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(height: 165, color: Colors.grey.shade200),
                      ),
                    ),
                    if (p['isNew'] == true)
                      Positioned(
                        top: 12, left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(6)),
                          child: const Text('New', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    // ── Heart / Save button ──────────────────────────────────
                    Positioned(
                      top: 10, right: 10,
                      child: GestureDetector(
                        onTap: () {
                          if (!_isLoggedIn) {
                            // Show login first, then save after successful login
                            showDialog(
                              context: context,
                              builder: (_) => LoginDialog(
                                onLoginSuccess: (ph) {
                                  setState(() {
                                    _isLoggedIn = true;
                                    _phoneNumber = ph;
                                    // Auto-save after login
                                    _savedProperties.add(propertyName);
                                  });
                                },
                              ),
                            );
                          } else {
                            setState(() {
                              if (isSaved) {
                                _savedProperties.remove(propertyName);
                              } else {
                                _savedProperties.add(propertyName);
                              }
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: Icon(
                            isSaved ? Icons.favorite : Icons.favorite_border,
                            size: 16,
                            color: isSaved ? const Color(0xFFE23A44) : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    // ── 3D Tour button ───────────────────────────────────────
                    if (p['has3D'] == true)
                      Positioned(
                        bottom: 10, left: 10,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => VirtualTourDialog(propertyName: propertyName),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.65),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.view_in_ar_rounded, color: Colors.white, size: 13),
                                SizedBox(width: 4),
                                Text('3D Tour', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(propertyName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)),
                          Text(p['price'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1C1C1E))),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 12, color: Colors.black38),
                          const SizedBox(width: 2),
                          Expanded(child: Text(p['location'] as String, style: const TextStyle(color: Colors.black38, fontSize: 11), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _mobileSpec(Icons.bed_outlined, '${p['beds']} Beds'),
                            const SizedBox(width: 10),
                            _mobileSpec(Icons.bathtub_outlined, '${p['baths']} Baths'),
                            const SizedBox(width: 10),
                            _mobileSpec(Icons.garage_outlined, '${p['garage']} Gar.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // ── RERA verified row ──────────────────────────────────
                      Row(
                        children: const [
                          Icon(Icons.verified_user_outlined, color: Colors.green, size: 11),
                          SizedBox(width: 4),
                          Text('RERA verified', style: TextStyle(color: Colors.green, fontSize: 10)),
                        ],
                      ),
                    ], // closes Column children
                  ),   // closes Column
                ),     // closes Padding
              ],       // closes outer Column children
            ),         // closes outer Column
          ),           // closes Container
          );           // closes Align
        },
      ),
    );
  }

  Widget _mobileSpec(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.black38),
        const SizedBox(width: 3),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.black45)),
      ],
    );
  }

  Widget _buildMobileHotspotsRow() {
    final spots = [
      {'name': 'Whitefield, Bengaluru',    'growth': '+22.3%', 'price': '₹8.4K/sqft',  'city': 'BLR', 'color': 0xFF4CAF50},
      {'name': 'Powai, Mumbai',             'growth': '+18.7%', 'price': '₹24.1K/sqft', 'city': 'MUM', 'color': 0xFF2196F3},
      {'name': 'Sector 150, Noida',         'growth': '+31.2%', 'price': '₹6.2K/sqft',  'city': 'NCR', 'color': 0xFFFF9800},
      {'name': 'Gachibowli, Hyderabad',     'growth': '+27.4%', 'price': '₹7.8K/sqft',  'city': 'HYD', 'color': 0xFF9C27B0},
      {'name': 'Hinjewadi, Pune',           'growth': '+19.5%', 'price': '₹9.1K/sqft',  'city': 'PNQ', 'color': 0xFFE91E63},
      {'name': 'Perambur, Chennai',         'growth': '+24.8%', 'price': '₹7.3K/sqft',  'city': 'CHN', 'color': 0xFF00BCD4},
      {'name': 'Dwarka Expressway, Gurugram', 'growth': '+36.5%', 'price': '₹11.2K/sqft','city': 'GGN', 'color': 0xFFFF5722},
      {'name': 'Thane West, Mumbai',        'growth': '+15.9%', 'price': '₹18.6K/sqft', 'city': 'MUM', 'color': 0xFF607D8B},
      {'name': 'Electronic City, Bengaluru','growth': '+20.1%', 'price': '₹5.9K/sqft',  'city': 'BLR', 'color': 0xFF009688},
      {'name': 'New Chandigarh',            'growth': '+28.6%', 'price': '₹5.4K/sqft',  'city': 'CHD', 'color': 0xFF795548},
    ];

    return SizedBox(
      height: 125,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: spots.length,
        itemBuilder: (context, i) {
          final spot = spots[i];
          final trendColor = Color(spot['color'] as int);
          return Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 162,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // City badge + name
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: trendColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(spot['city'] as String, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: trendColor)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    spot['name'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF1C1C1E)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(spot['price'] as String, style: const TextStyle(fontSize: 10, color: Colors.black54)),
                      Row(
                        children: [
                          Icon(Icons.trending_up, color: trendColor, size: 11),
                          const SizedBox(width: 2),
                          Text(spot['growth'] as String, style: TextStyle(color: trendColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileToolsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F4EE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('SMARTER DECISIONS', style: TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 12),
          const Text('Tools for the', style: TextStyle(color: Color(0xFF1C1C1E), fontSize: 32, fontWeight: FontWeight.w400, height: 1.1)),
          const Text('next chapter.', style: TextStyle(color: Color(0xFF1C1C1E), fontSize: 34, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, height: 1.1, letterSpacing: -0.5)),
          const SizedBox(height: 12),
          const Text('Numbers matter when you’re making a\nplace your own. We make them simple.', style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.4)),
          const SizedBox(height: 24),
          _buildMobileToolTile(
            icon: Icons.calculate_outlined,
            color: const Color(0xFFFDE9EA),
            iconColor: const Color(0xFFE23A44),
            title: 'EMI calculator',
            sub: 'Know your monthly\ncomfort zone',
            onTap: () => showDialog(context: context, builder: (_) => const EmiCalculatorDialog()),
          ),
          const SizedBox(height: 12),
          _buildMobileToolTile(
            icon: Icons.bar_chart_outlined,
            color: const Color(0xFFE4F1EC),
            iconColor: const Color(0xFF2C8465),
            title: 'Property valuation',
            sub: 'See where prices are\nheaded',
            onTap: () => showDialog(context: context, builder: (_) => const PropertyValuationDialog()),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileNewsSection() {
    final List<Map<String, String>> allNews = [
      {
        'title': 'Mumbai residential sales jump 5% in Q3 2026, driven by new launches.',
        'city': 'Mumbai',
        'time': '2 hours ago',
        'image': 'https://images.unsplash.com/photo-1567157577867-05ccb1388e66?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'tag': 'Hot',
        'url': 'https://housing.com/news/mumbai-real-estate-market-report/'
      },
      {
        'title': 'Bengaluru real estate hits peak momentum with 12% annual growth.',
        'city': 'Bengaluru',
        'time': '5 hours ago',
        'image': 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'tag': 'Fresh',
        'url': 'https://housing.com/news/bengaluru-property-trends/'
      },
      {
        'title': 'Pune housing market stabilizes as buyers seek ready-to-move homes.',
        'city': 'Pune',
        'time': '1 day ago',
        'image': 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'tag': 'Trending',
        'url': 'https://housing.com/news/pune-residential-market-update/'
      },
      {
        'title': 'Chennai sees shift towards premium residential segments in 2026.',
        'city': 'Chennai',
        'time': '2 days ago',
        'image': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'tag': 'New',
        'url': 'https://housing.com/news/chennai-real-estate-premium/'
      },
      {
        'title': 'Kolkata real estate sees steady growth amidst infrastructure push.',
        'city': 'Kolkata',
        'time': '3 days ago',
        'image': 'https://images.unsplash.com/photo-1555636222-cae831e670b3?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'tag': 'Trending',
        'url': 'https://housing.com/news/kolkata-property-market-growth/'
      },
      {
        'title': 'Ahmedabad emerges as a new hotspot for affordable luxury housing.',
        'city': 'Ahmedabad',
        'time': '4 days ago',
        'image': 'https://images.unsplash.com/photo-1574362848149-11496d93a7c7?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'tag': 'Hot',
        'url': 'https://housing.com/news/ahmedabad-affordable-luxury/'
      },
      {
        'title': 'Jaipur property prices remain stable, attracting NRI investors.',
        'city': 'Jaipur',
        'time': '5 days ago',
        'image': 'https://images.unsplash.com/photo-1479839672679-a46483c0e7c8?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'tag': 'Fresh',
        'url': 'https://housing.com/news/jaipur-nri-investment-hub/'
      },
      {
        'title': 'Hyderabad office leasing sets new record in Q3 2026.',
        'city': 'Hyderabad',
        'time': '1 week ago',
        'image': 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'tag': 'Trending',
        'url': 'https://housing.com/news/hyderabad-commercial-real-estate/'
      },
    ];

    final filteredNews = allNews.where((news) {
      final query = _searchQuery.toLowerCase();
      return query.isEmpty ||
             news['title']!.toLowerCase().contains(query) ||
             news['city']!.toLowerCase().contains(query);
    }).toList();

    if (filteredNews.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Property News', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: -0.5)),
              Text('See all', style: TextStyle(fontSize: 13, color: Colors.blue.shade700, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredNews.length,
            itemBuilder: (context, i) {
              final item = filteredNews[i];
              return GestureDetector(
                onTap: () async {
                  final url = Uri.parse(item['url']!);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                child: Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(item['image']!, height: 140, width: double.infinity, fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: item['tag'] == 'Hot' ? Colors.red : (item['tag'] == 'Fresh' ? Colors.green : Colors.blue),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(item['tag']!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item['title']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item['city']!, style: const TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w500)),
                                  Text(item['time']!, style: const TextStyle(fontSize: 11, color: Colors.black38)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMobileToolTile({required IconData icon, required Color color, required Color iconColor, required String title, required String sub, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(sub, style: const TextStyle(color: Colors.black54, fontSize: 12, height: 1.4)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black87, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 380,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/footer_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.95), Colors.black.withOpacity(0.2)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'Your journey home\nstarts here.',
              style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, height: 1.2),
            ),
            const SizedBox(height: 12),
            const Text(
              'Join thousands of happy homeowners who found their dream property with us.',
              style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 32),
            Row(
              children: const [
                Icon(Icons.home, color: Colors.white, size: 24),
                SizedBox(width: 8),
                Text('Housing.com', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _bottomNavItem(Icons.home_filled, 'Home', _mobileNavIndex == 0, () {
                setState(() => _mobileNavIndex = 0);
              }),
              _bottomNavItem(Icons.search, 'Search', _mobileNavIndex == 1, () {
                setState(() => _mobileNavIndex = 1);
              }),
              _bottomNavItem(
                _savedProperties.isNotEmpty ? Icons.bookmark : Icons.bookmark_border,
                'Saved',
                _mobileNavIndex == 2,
                () {
                  setState(() => _mobileNavIndex = 2);
                  _showMobileSavedSheet(context);
                },
              ),
              _bottomNavItem(Icons.person_outline, 'Profile', _mobileNavIndex == 3, () {
                setState(() => _mobileNavIndex = 3);
                if (_isLoggedIn) {
                  _scaffoldKey.currentState?.openEndDrawer();
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => LoginDialog(
                      onLoginSuccess: (phone) {
                        setState(() { _isLoggedIn = true; _phoneNumber = phone; });
                      },
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showMobileSavedSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              height: MediaQuery.of(ctx).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40, height: 4,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                  ),
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Saved Properties', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1C1C1E))),
                        if (_savedProperties.isNotEmpty)
                          Text('${_savedProperties.length} saved', style: const TextStyle(fontSize: 13, color: Color(0xFFE23A44), fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Content
                  Expanded(
                    child: !_isLoggedIn
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.lock_outline, size: 48, color: Colors.black26),
                                const SizedBox(height: 16),
                                const Text('Login to view saved properties', style: TextStyle(color: Colors.black45, fontSize: 15)),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    showDialog(
                                      context: context,
                                      builder: (_) => LoginDialog(
                                        onLoginSuccess: (ph) {
                                          setState(() { _isLoggedIn = true; _phoneNumber = ph; });
                                          setSheetState(() {});
                                        },
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE23A44),
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text('Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                                ),
                              ],
                            ),
                          )
                        : _savedProperties.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.bookmark_border, size: 56, color: Colors.black12),
                                    const SizedBox(height: 16),
                                    const Text('No saved properties yet', style: TextStyle(color: Colors.black45, fontSize: 15)),
                                    const SizedBox(height: 6),
                                    const Text('Tap the ♡ on any property to save it', style: TextStyle(color: Colors.black26, fontSize: 13)),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: _savedProperties.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                                itemBuilder: (_, index) {
                                  final name = _savedProperties.elementAt(index);
                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF9F9F9),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: Colors.grey.shade200),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 48, height: 48,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFDE9EA),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: const Icon(Icons.home_outlined, color: Color(0xFFE23A44), size: 24),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1C1C1E))),
                                              const SizedBox(height: 3),
                                              const Text('Featured Property', style: TextStyle(color: Colors.black38, fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() => _savedProperties.remove(name));
                                            setSheetState(() {});
                                          },
                                          child: const Icon(Icons.favorite, color: Color(0xFFE23A44), size: 22),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _bottomNavItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? const Color(0xFFE23A44) : Colors.black38, size: 24),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: isActive ? const Color(0xFFE23A44) : Colors.black38, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildTopNav(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40, vertical: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(color: Color(0xFFE23A44), shape: BoxShape.circle),
                    child: const Center(
                      child: Text('h', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (!isMobile) const Text('housing', style: TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                  if (!isMobile) const Text('.com', style: TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                ],
              ),
              // Right Links
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (_isLoggedIn) {
                        _showSavedPropertiesDialog(context);
                      } else {
                        showDialog(
                          context: context,
                          builder: (_) => LoginDialog(
                            onLoginSuccess: (phone) {
                              setState(() {
                                _isLoggedIn = true;
                                _phoneNumber = phone;
                              });
                            },
                          ),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          _savedProperties.isNotEmpty ? Icons.favorite : Icons.favorite_border,
                          color: _savedProperties.isNotEmpty ? Colors.red : Colors.black87,
                          size: 20
                        ),
                        const SizedBox(width: 6),
                        if (!isMobile) const Text('Saved', style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
              if (!isMobile) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Post property', style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(width: 24),
              ],
              if (_isLoggedIn)
                InkWell(
                  onTap: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                  },
                  child: const CircleAvatar(
                    backgroundColor: Color(0xFF6C2BD9),
                    radius: 20,
                    child: Text('E', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => LoginDialog(
                        onLoginSuccess: (phone) {
                          setState(() {
                            _isLoggedIn = true;
                            _phoneNumber = phone;
                          });
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 16, vertical: isMobile ? 8 : 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    side: const BorderSide(color: Colors.black26),
                  ),
                  child: Row(
                    children: [
                      if (!isMobile) const Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
                      if (!isMobile) const SizedBox(width: 8),
                      const Icon(Icons.menu, size: 16),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
          // Middle Links
          if (!isMobile)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  // buy tapped
                },
                child: const Text('Buy', style: TextStyle(color: Color(0xFFE23A44), fontSize: 15, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 32),
              InkWell(
                onTap: () {
                  // rent tapped
                },
                child: const Text('Rent', style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(width: 32),
              InkWell(
                onTap: () {
                  // invest tapped
                },
                child: const Text('Invest', style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navLink(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Text(text, style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 14),
        ],
      ),
    );
  }

  Widget _buildNewHeroSection() {
    return Builder(
      builder: (context) {
        final bool isMobile = MediaQuery.of(context).size.width < 800;
        final content = Padding(
          padding: EdgeInsets.only(
            left: isMobile ? 24 : 100, 
            right: isMobile ? 24 : 40, 
            top: isMobile ? 16 : 100, 
            bottom: isMobile ? 80 : 0
          ),
          child: Column(
            crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.black, size: 16),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "INDIA'S MOST TRUSTED PROPERTY PLATFORM",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, letterSpacing: 1.5, fontSize: isMobile ? 10 : 11),
                      textAlign: isMobile ? TextAlign.center : TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 24 : 32),
              RichText(
                textAlign: isMobile ? TextAlign.center : TextAlign.left,
                text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: isMobile ? 40 : 80, fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -1.0),
                  children: const [
                    TextSpan(text: 'Find a place\n'),
                    TextSpan(
                      text: "you'll love",
                      style: TextStyle(fontFamily: 'Georgia', fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),
                    ),
                    TextSpan(text: ' to\nlive.'),
                  ],
                ),
              ),
              SizedBox(height: isMobile ? 16 : 32),
              Text(
                'Explore verified homes, compare what\nmatters, and move with confidence.',
                textAlign: isMobile ? TextAlign.center : TextAlign.left,
                style: TextStyle(color: Colors.black, fontSize: isMobile ? 14 : 20, height: 1.5, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        );

        return SizedBox(
          height: isMobile ? null : 600,
          child: isMobile 
            ? content
            : Row(
                children: [
                  Expanded(flex: 1, child: content),
                  Expanded(
                    flex: 1, 
                    child: Stack(
                      children: [],
                    ),
                  ),
                ],
              ),
        );
      }
    );
  }

  Widget _buildNewSearchSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 15),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                _newSearchTab('Buy', true),
                const SizedBox(width: 24),
                _newSearchTab('Rent', false),
                const SizedBox(width: 24),
                _newSearchTab('Invest', false),
              ],
            ),
          ),
          const Divider(height: 1),
          const Divider(height: 1),
          Builder(
            builder: (context) {
              final bool isMobile = MediaQuery.of(context).size.width < 800;
              final locationItem = PopupMenuButton<String>(
                offset: const Offset(0, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                color: const Color(0xFF4A4A4A),
                onSelected: (String result) {
                  setState(() {
                    _selectedCity = result;
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  _buildCityMenuItem('All cities'),
                  _buildCityMenuItem('Mumbai'),
                  _buildCityMenuItem('Bengaluru'),
                  _buildCityMenuItem('Gurugram'),
                ],
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.black87),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Location', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(_selectedCity, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  ],
                ),
              );

              final propertyItem = PopupMenuButton<String>(
                offset: const Offset(0, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                color: const Color(0xFF4A4A4A),
                onSelected: (String result) {
                  setState(() {
                    _selectedPropertyType = result;
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  _buildPropertyTypeMenuItem('Any BHK'),
                  _buildPropertyTypeMenuItem('1 BHK'),
                  _buildPropertyTypeMenuItem('2 BHK'),
                  _buildPropertyTypeMenuItem('3 BHK'),
                  _buildPropertyTypeMenuItem('4 BHK'),
                ],
                child: Row(
                  children: [
                    const Icon(Icons.bed_outlined, color: Colors.black87),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Property type', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(_selectedPropertyType, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  ],
                ),
              );

              final budgetItem = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Budget up to', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        _budget >= 5.0 ? '₹5+ Cr' : '₹${_budget.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')} Cr',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                          ),
                          child: Slider(
                            value: _budget,
                            min: 0,
                            max: 5,
                            activeColor: Colors.redAccent,
                            inactiveColor: Colors.redAccent.withOpacity(0.3),
                            onChanged: (val) {
                              setState(() {
                                _budget = val;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );

              final searchBtn = ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.search, color: Colors.white, size: 20),
                label: const Text('Search', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE23A44),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  elevation: 0,
                ),
              );

              return Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 8),
                child: isMobile 
                  ? Column(
                      children: [
                        locationItem,
                        const Divider(height: 24),
                        propertyItem,
                        const Divider(height: 24),
                        budgetItem,
                        const SizedBox(height: 16),
                        SizedBox(width: double.infinity, child: searchBtn),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: locationItem),
                        Container(height: 40, width: 1, color: Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 24)),
                        Expanded(child: propertyItem),
                        Container(height: 40, width: 1, color: Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 24)),
                        Expanded(child: budgetItem),
                        const SizedBox(width: 24),
                        searchBtn,
                      ],
                    ),
              );
            }
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24, bottom: 12),
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const AllFiltersDialog(),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.tune, color: Colors.black87, size: 16),
                  const SizedBox(width: 4),
                  const Text('All filters', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('50+', style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _newSearchTab(String title, bool isSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFFE23A44) : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        if (isSelected) ...[
          const SizedBox(height: 8),
          Container(height: 2, width: 30, color: const Color(0xFFE23A44)),
        ]
      ],
    );
  }

  PopupMenuItem<String> _buildCityMenuItem(String city) {
    bool isSelected = _selectedCity == city;
    return PopupMenuItem<String>(
      value: city,
      padding: EdgeInsets.zero,
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: isSelected 
            ? BoxDecoration(color: const Color(0xFF4A89F3), borderRadius: BorderRadius.circular(4))
            : null,
        child: Row(
          children: [
            if (isSelected) const Icon(Icons.check, color: Colors.white, size: 16) else const SizedBox(width: 16),
            const SizedBox(width: 8),
            Text(city, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPropertyTypeMenuItem(String type) {
    bool isSelected = _selectedPropertyType == type;
    return PopupMenuItem<String>(
      value: type,
      padding: EdgeInsets.zero,
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            if (isSelected) const Icon(Icons.check, color: Colors.white, size: 16) else const SizedBox(width: 16),
            const SizedBox(width: 8),
            Text(type, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDrawer() {
    return Drawer(
      width: 350,
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF6C2BD9),
                  radius: 24,
                  child: Text('E', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hello Edita!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 2),
                      const Text('nivedita10012006@gmail.com', style: TextStyle(color: Colors.grey, fontSize: 12), overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text('+91-$_phoneNumber', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                TextButton(onPressed: (){}, child: const Text('Edit', style: TextStyle(color: Colors.black))),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _activityBox('Contacted\nProperties', '00'),
                _activityBox('Seen\nProperties', '00', isSelected: true),
                _activityBox('Saved\nProperties', '00'),
                _activityBox('Recent\nSearches', '00'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE5E0F5),
                foregroundColor: const Color(0xFF6C2BD9),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Start new search', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.diamond_outlined),
                  title: const Text('Zero Brokerage Properties'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: const Text('My Transactions'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log Out'),
                  onTap: () {
                    setState(() {
                      _isLoggedIn = false;
                      _phoneNumber = '';
                    });
                    Navigator.pop(context); // close drawer
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _activityBox(String title, String count, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? const Color(0xFF6C2BD9) : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: isSelected ? const Color(0xFF6C2BD9).withOpacity(0.05) : Colors.transparent,
      ),
      child: Column(
        children: [
          Icon(Icons.home_outlined, color: isSelected ? const Color(0xFF6C2BD9) : Colors.grey, size: 20),
          const SizedBox(height: 4),
          Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: isSelected ? const Color(0xFF6C2BD9) : Colors.grey)),
          const SizedBox(height: 4),
          Text(count, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}

class CityDropdown extends StatefulWidget {
  const CityDropdown({Key? key}) : super(key: key);
  @override
  _CityDropdownState createState() => _CityDropdownState();
}

class _CityDropdownState extends State<CityDropdown> {
  bool _isHovering = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  String _selectedCity = 'Bengaluru';

  void _showDropdown() {
    if (_overlayEntry != null) return;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: 600, // Widened for better grid layout
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(-20, 24),
          showWhenUnlinked: false,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovering = true),
            onExit: (_) {
              setState(() => _isHovering = false);
              _hideDropdown();
            },
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              child: CityDropdownMenu(
                selectedCity: _selectedCity,
                onCitySelected: (city) {
                  setState(() {
                    _selectedCity = city;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _isHovering = true);
          _showDropdown();
        },
        onExit: (_) {
          setState(() => _isHovering = false);
          Future.delayed(const Duration(milliseconds: 100), () {
            if (!_isHovering) {
              _hideDropdown();
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Text(_selectedCity, style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500)),
              const Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class CityDropdownMenu extends StatefulWidget {
  final String selectedCity;
  final ValueChanged<String> onCitySelected;

  const CityDropdownMenu({
    Key? key,
    required this.selectedCity,
    required this.onCitySelected,
  }) : super(key: key);

  @override
  _CityDropdownMenuState createState() => _CityDropdownMenuState();
}

class _CityDropdownMenuState extends State<CityDropdownMenu> {
  bool _showAllCities = false;
  late String _localSelectedCity;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _localSelectedCity = widget.selectedCity;
  }

  Widget _cityItem(String name, IconData icon) {
    bool isSelected = _localSelectedCity == name;
    return InkWell(
      onTap: () {
        setState(() {
          _localSelectedCity = name;
        });
        widget.onCitySelected(name);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? const Color(0xFF6C2BD9) : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? const Color(0xFF6C2BD9) : Colors.grey),
            const SizedBox(width: 6),
            Expanded(child: Text(name, style: const TextStyle(fontSize: 11), overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.search, color: Colors.grey, size: 20),
                hintText: 'Search for city',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_searchQuery.isNotEmpty) ...[
            const Text('Choose a city', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: CityData.cities
                      .where((city) => city['name']!.toLowerCase().contains(_searchQuery.toLowerCase()))
                      .map((city) {
                    bool isSelected = _localSelectedCity == city['name'];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _localSelectedCity = city['name']!;
                        });
                        widget.onCitySelected(city['name']!);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Text(
                          city['name']!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ] else if (!_showAllCities) ...[
            const Text('Popular cities', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 12),
            // Grid
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _cityItem('Bengaluru', Icons.business),
                _cityItem('Mumbai', Icons.location_city),
                _cityItem('Pune', Icons.apartment),
                _cityItem('Chennai', Icons.account_balance),
                _cityItem('Kolkata', Icons.house),
                _cityItem('Ahmedabad', Icons.store),
                _cityItem('Delhi', Icons.business_center),
                _cityItem('Noida', Icons.corporate_fare),
                _cityItem('Gurgaon', Icons.domain),
                _cityItem('Hyderabad', Icons.factory),
                _cityItem('Thane', Icons.location_city),
                _cityItem('Navi Mumbai', Icons.business),
              ],
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('All cities', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                InkWell(
                  onTap: () => setState(() => _showAllCities = false),
                  child: const Text('Back to popular >', style: TextStyle(fontSize: 12, color: Colors.blue)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: CityData.cities.map((city) {
                    bool isSelected = _localSelectedCity == city['name'];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _localSelectedCity = city['name']!;
                        });
                        widget.onCitySelected(city['name']!);
                      },
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        width: 130,
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF6C2BD9).withOpacity(0.1) : Colors.transparent,
                          border: Border.all(color: isSelected ? const Color(0xFF6C2BD9) : Colors.transparent),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(city['name']!, style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? const Color(0xFF6C2BD9) : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        )),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('All India', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(width: 8),
              Container(width: 1, height: 12, color: Colors.grey.shade300),
              const SizedBox(width: 8),
              const Text('International', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const Spacer(),
              if (!_showAllCities)
                InkWell(
                  onTap: () {
                    setState(() {
                      _showAllCities = true;
                    });
                  },
                  child: const Text('View all cities >', style: TextStyle(fontSize: 12, color: Colors.blue)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class LoginDialog extends StatefulWidget {
  final Function(String phone)? onLoginSuccess;
  const LoginDialog({Key? key, this.onLoginSuccess}) : super(key: key);

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  bool _showOtp = false;
  final TextEditingController _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());
  
  bool get _isOtpFilled => _otpControllers.every((c) => c.text.isNotEmpty);

  @override
  void initState() {
    super.initState();
    for (var controller in _otpControllers) {
      controller.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() {
    if (!_isOtpFilled) return;
    String otp = _otpControllers.map((c) => c.text).join();
    if (otp == '1234' || otp == '5678' || otp == '1245') {
       Navigator.pop(context); // close dialog
       if (widget.onLoginSuccess != null) {
         widget.onLoginSuccess!(_phoneController.text);
       }
    } else {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
         content: Text('Invalid OTP. Try 1234, 5678, or 1245.'),
         backgroundColor: Colors.red,
       ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             // Header with close button
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 const SizedBox(width: 40), // spacer to center the logo
                 Container(
                   padding: const EdgeInsets.all(8),
                   decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(8)),
                   child: const Icon(Icons.keyboard_arrow_up, color: Colors.indigo),
                 ),
                 IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
               ],
             ),
             const SizedBox(height: 16),
             if (!_showOtp) ...[
                const Text('Log in or sign up to Housing', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Buy • Rent • Sell', style: TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 24),
                // Phone input
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('+91', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(width: 1, height: 24, color: Colors.grey.shade400),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: 'Phone number',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                          onChanged: (value) => setState((){}),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _phoneController.text.isNotEmpty ? () {
                      setState(() => _showOtp = true);
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C2BD9),
                      disabledBackgroundColor: Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
             ] else ...[
                const Text('Enter OTP to verify details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('OTP sent to +91 ${_phoneController.text}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () => setState(() => _showOtp = false),
                      child: const Icon(Icons.edit, size: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return SizedBox(
                      width: 50,
                      child: TextField(
                        controller: _otpControllers[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 3) {
                             FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty && index > 0) {
                             FocusScope.of(context).previousFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Resend OTP in 28 seconds', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isOtpFilled ? _verifyOtp : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C2BD9),
                      disabledBackgroundColor: Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Verify OTP', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
             ]
          ],
        ),
      ),
    );
  }
}

class AllFiltersDialog extends StatefulWidget {
  const AllFiltersDialog({super.key});

  @override
  State<AllFiltersDialog> createState() => _AllFiltersDialogState();
}

class _AllFiltersDialogState extends State<AllFiltersDialog> {
  final List<String> _filters = [
    'Ready to move',
    'RERA verified',
    'Parking',
    'Swimming pool',
    'Near metro',
    'New construction',
  ];

  final Set<String> _selectedFilters = {};

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      backgroundColor: Colors.transparent,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('REFINE YOUR SEARCH', style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: Colors.black87, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('All filters', style: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Find exactly what feels right for you.', style: TextStyle(color: Colors.black54, fontSize: 14)),
            const SizedBox(height: 32),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _filters.map((filter) {
                final isSelected = _selectedFilters.contains(filter);
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedFilters.remove(filter);
                      } else {
                        _selectedFilters.add(filter);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.red.shade50 : Colors.white,
                      border: Border.all(color: isSelected ? Colors.redAccent : Colors.black12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.redAccent : Colors.black87,
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE23A44),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  elevation: 0,
                ),
                child: const Text('Apply filters', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
