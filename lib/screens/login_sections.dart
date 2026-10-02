import 'package:flutter/material.dart';
import 'dart:math';
import 'package:panorama_viewer/panorama_viewer.dart';

class HotspotsNearbySection extends StatefulWidget {
  const HotspotsNearbySection({Key? key}) : super(key: key);

  @override
  State<HotspotsNearbySection> createState() => _HotspotsNearbySectionState();
}

class _HotspotsNearbySectionState extends State<HotspotsNearbySection> {
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> hotspots = [
    {'name': 'Palm Beach Road-Vashi', 'properties': '369 properties', 'price': '₹20.6K/sq.ft.', 'growth': '14.61%'},
    {'name': 'Sion Panvel Highway-CBD Bela...', 'properties': '318 properties', 'price': '₹14.4K/sq.ft.', 'growth': '49.02%'},
    {'name': 'Thane Belapur Road-Kopar Kh...', 'properties': '188 properties', 'price': '₹15K/sq.ft.', 'growth': '36.58%'},
    {'name': 'Palm Beach Road - Seawoods', 'properties': '180 properties', 'price': '₹23K/sq.ft.', 'growth': '14.67%'},
    {'name': 'Palm Beach Road - Sanpada', 'properties': '146 properties', 'price': '₹24.7K/sq.ft.', 'growth': '34.34%'},
  ];

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 300,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 300,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 1000),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 0 : 20),
      ),
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hotspots nearby', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 8),
          const Text('New projects. Trusted builders. All in one place.', style: TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: hotspots.map((spot) => _buildHotspotCard(spot)).toList(),
                ),
              ),
              Positioned(
                left: 0,
                child: InkWell(
                  onTap: _scrollLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.chevron_left, size: 24, color: Colors.black87),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: InkWell(
                  onTap: _scrollRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.chevron_right, size: 24, color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildHotspotCard(Map<String, String> spot) {
  return Container(
    width: 250,
    margin: const EdgeInsets.only(right: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade200),
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(spot['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 4),
        Text(spot['properties']!, style: const TextStyle(color: Colors.black54, fontSize: 12)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(spot['price']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
            Row(
              children: [
                const Icon(Icons.arrow_drop_up, color: Colors.green, size: 18),
                Text('${spot['growth']} (3yrs)', style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        )
      ],
    ),
  );
}

Widget buildTopPicks({
  required bool isLoggedIn,
  required Set<String> savedProperties,
  required Function(String) onSaveToggle,
  required VoidCallback onLoginRequested,
}) {
  return Builder(
    builder: (context) {
      final bool isMobile = MediaQuery.of(context).size.width < 800;
      
      final header = isMobile 
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('HANDPICKED HOMES · RENT', style: TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    const SizedBox(height: 12),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(color: const Color(0xFF1C1C1C), fontSize: isMobile ? 28 : 40, height: 1.1),
                        children: const [
                          TextSpan(text: 'Homes worth\n', style: TextStyle(fontWeight: FontWeight.w400)),
                          TextSpan(
                            text: 'coming home to.',
                            style: TextStyle(fontFamily: 'Georgia', fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, letterSpacing: -1.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('3 properties', style: TextStyle(color: Colors.black54, fontSize: 14)),
                    Text('Sort: Recommended >', style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('HANDPICKED HOMES · RENT', style: TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    const SizedBox(height: 12),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Color(0xFF1C1C1C), fontSize: 40, height: 1.1),
                        children: [
                          TextSpan(text: 'Homes worth\n', style: TextStyle(fontWeight: FontWeight.w400)),
                          TextSpan(
                            text: 'coming home to.',
                            style: TextStyle(fontFamily: 'Georgia', fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: 44, letterSpacing: -1.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Text('3 properties', style: TextStyle(color: Colors.black54, fontSize: 14)),
                    SizedBox(width: 16),
                    Text('Sort: Recommended >', style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            );

      final cards = [
        _buildHandpickedCard('Sattva Anjanapura', '₹94 L', 'JP Nagar, Bengaluru', '2 BHK', '890', '5', 'Ready to move', true, 'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=800&q=80', isLoggedIn, savedProperties, onSaveToggle, onLoginRequested),
        _buildHandpickedCard('The Grove Residences', '₹1.62 Cr', 'Whitefield, Bengaluru', '3 BHK', '1,280', '9', 'Dec 2026', false, 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800&q=80', isLoggedIn, savedProperties, onSaveToggle, onLoginRequested),
        _buildHandpickedCard('M3M Crown', '₹2.38 Cr', 'Sector 111, Gurugram', '4 BHK', '1,780', '22', 'Jun 2027', false, 'assets/images/hero_bg.png', isLoggedIn, savedProperties, onSaveToggle, onLoginRequested),
      ];

      return Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1000),
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            const SizedBox(height: 32),
            if (isMobile)
              Column(
                children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 24), child: c)).toList(),
              )
            else
              Row(
                children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 24), child: c))).toList(),
              ),
          ],
        ),
      );
    }
  );
}

Widget _buildHandpickedCard(
  String title,
  String price,
  String subtitle,
  String bhk,
  String sqft,
  String floor,
  String status,
  bool isFeatured,
  String imageUrl,
  bool isLoggedIn,
  Set<String> savedProperties,
  Function(String) onSaveToggle,
  VoidCallback onLoginRequested,
) {
  bool isSaved = savedProperties.contains(title);
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            imageUrl.startsWith('assets/')
                ? Image.asset(
                    imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            if (isFeatured)
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFE23A44), borderRadius: BorderRadius.circular(2)),
                  child: Row(
                    children: const [
                      Icon(Icons.auto_awesome, color: Colors.white, size: 12),
                      SizedBox(width: 4),
                      Text('Featured', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            Positioned(
              top: 16,
              right: 16,
              child: InkWell(
                onTap: () {
                  if (!isLoggedIn) {
                    onLoginRequested();
                  } else {
                    onSaveToggle(title);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: Icon(
                    isSaved ? Icons.favorite : Icons.favorite_border,
                    size: 16,
                    color: isSaved ? Colors.red : Colors.black87,
                  ),
                ),
              ),
            ),
            if (title == 'Sattva Anjanapura' || title == 'The Grove Residences' || title == 'M3M Crown')
              Positioned(
                bottom: 16,
                left: 16,
                child: Builder(
                  builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => VirtualTourDialog(propertyName: title),
                        );
                      },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: Colors.black.withOpacity(0.6),
                      child: const Text('3D Tour', style: TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                  ),
                );
                }),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(bhk.split(' ')[0], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                  const Text(' BHK', style: TextStyle(color: Colors.black54, fontSize: 10)),
                  const SizedBox(width: 12),
                  Text(sqft, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                  const Text(' sq.ft carpet', style: TextStyle(color: Colors.black54, fontSize: 10)),
                  const SizedBox(width: 12),
                  const Text('Floor ', style: TextStyle(color: Colors.black54, fontSize: 10)),
                  Text(floor, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.verified_user_outlined, color: Colors.green, size: 12),
                      SizedBox(width: 4),
                      Text('RERA verified', style: TextStyle(color: Colors.green, fontSize: 10)),
                    ],
                  ),
                  Text(status, style: const TextStyle(color: Colors.black54, fontSize: 10)),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class ToolsSection extends StatelessWidget {
  const ToolsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final bool isMobile = MediaQuery.of(context).size.width < 800;
        
        final textSide = Column(
          crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            const Text('SMARTER DECISIONS', style: TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            const SizedBox(height: 12),
            RichText(
              textAlign: isMobile ? TextAlign.center : TextAlign.left,
              text: TextSpan(
                style: TextStyle(color: const Color(0xFF1C1C1C), fontSize: isMobile ? 28 : 32, height: 1.1),
                children: const [
                  TextSpan(text: 'Tools for the\n', style: TextStyle(fontWeight: FontWeight.w400)),
                  TextSpan(
                    text: 'next chapter.',
                    style: TextStyle(fontFamily: 'Georgia', fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, letterSpacing: -1.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Numbers matter when you're making a\nplace your own. We make them simple.", 
              textAlign: isMobile ? TextAlign.center : TextAlign.left,
              style: const TextStyle(color: Colors.black54, fontSize: 14, height: 1.5)
            ),
          ],
        );

        final toolsSide = isMobile
            ? Column(
                children: [
                  _buildToolCard(
                    icon: Icons.calculate_outlined,
                    iconBgColor: const Color(0xFFFDE9EA),
                    iconColor: const Color(0xFFE23A44),
                    title: 'EMI calculator',
                    subtitle: 'Know your monthly comfort zone',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const EmiCalculatorDialog(),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildToolCard(
                    icon: Icons.bar_chart_outlined,
                    iconBgColor: const Color(0xFFE4F1EC),
                    iconColor: const Color(0xFF2C8465),
                    title: 'Property valuation',
                    subtitle: 'See where prices are headed',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const PropertyValuationDialog(),
                      );
                    },
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: _buildToolCard(
                      icon: Icons.calculate_outlined,
                      iconBgColor: const Color(0xFFFDE9EA),
                      iconColor: const Color(0xFFE23A44),
                      title: 'EMI calculator',
                      subtitle: 'Know your monthly comfort zone',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const EmiCalculatorDialog(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildToolCard(
                      icon: Icons.bar_chart_outlined,
                      iconBgColor: const Color(0xFFE4F1EC),
                      iconColor: const Color(0xFF2C8465),
                      title: 'Property valuation',
                      subtitle: 'See where prices are headed',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const PropertyValuationDialog(),
                        );
                      },
                    ),
                  ),
                ],
              );

        return Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 1000),
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textSide,
                    const SizedBox(height: 32),
                    toolsSide,
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 4, child: textSide),
                    const SizedBox(width: 48),
                    Expanded(flex: 6, child: toolsSide),
                  ],
                ),
        );
      }
    );
  }

  Widget _buildToolCard({required IconData icon, required Color iconBgColor, required Color iconColor, required String title, required String subtitle, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black87),
          ],
        ),
      ),
    );
  }
}

class EmiCalculatorDialog extends StatefulWidget {
  const EmiCalculatorDialog({Key? key}) : super(key: key);

  @override
  State<EmiCalculatorDialog> createState() => _EmiCalculatorDialogState();
}

class _EmiCalculatorDialogState extends State<EmiCalculatorDialog> {
  double propertyPriceCr = 120;
  double downPaymentL = 20;
  double tenureYears = 20;

  @override
  Widget build(BuildContext context) {
    double interestRate = 8.5;
    
    double loanAmount = (propertyPriceCr * 10000000) - (downPaymentL * 100000);
    double r = interestRate / (12 * 100);
    int n = (tenureYears * 12).toInt();
    
    double emi = 0;
    double totalInterest = 0;
    if (loanAmount > 0 && r > 0 && n > 0) {
      emi = (loanAmount * r * pow((1 + r), n)) / (pow((1 + r), n) - 1);
      totalInterest = (emi * n) - loanAmount;
    }
    
    return Dialog(
      backgroundColor: const Color(0xFFFBF9F6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('PLAN WITH CLARITY', style: TextStyle(color: Colors.black45, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('EMI calculator', style: TextStyle(fontSize: 32, color: Colors.black87, fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            const Text('A comfortable monthly payment starts with a clear picture.', style: TextStyle(color: Colors.black54, fontSize: 14)),
            const SizedBox(height: 32),
            
            _buildSliderRow(
              label: 'Property price',
              valueStr: '₹${propertyPriceCr.toInt()} Cr',
              value: propertyPriceCr,
              min: 1,
              max: 200,
              onChanged: (val) {
                setState(() {
                  propertyPriceCr = val;
                });
              },
            ),
            const SizedBox(height: 24),
            
            _buildSliderRow(
              label: 'Down payment',
              valueStr: '₹${downPaymentL.toInt()} L',
              value: downPaymentL,
              min: 0,
              max: 1000,
              onChanged: (val) {
                setState(() {
                  downPaymentL = val;
                });
              },
            ),
            const SizedBox(height: 24),
            
            _buildSliderRow(
              label: 'Loan tenure',
              valueStr: '${tenureYears.toInt()} years',
              value: tenureYears,
              min: 1,
              max: 30,
              onChanged: (val) {
                setState(() {
                  tenureYears = val;
                });
              },
            ),
            const SizedBox(height: 32),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: const Color(0xFF262626),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Estimated monthly EMI', style: TextStyle(color: Colors.white54, fontSize: 11)),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('₹', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: FittedBox(
                                    alignment: Alignment.centerLeft,
                                    fit: BoxFit.scaleDown,
                                    child: Text(_formatCurrency(emi.toInt()), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Interest', style: TextStyle(color: Colors.white54, fontSize: 11)),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('₹', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: FittedBox(
                                    alignment: Alignment.centerLeft,
                                    fit: BoxFit.scaleDown,
                                    child: Text(_formatCurrency(totalInterest.toInt()), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('at 8.5% interest · Loan amount ₹${(loanAmount / 100000).toInt()} L', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderRow({required String label, required String valueStr, required double value, required double min, required double max, required ValueChanged<double> onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
            Text(valueStr, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: const Color(0xFFE23A44),
            inactiveTrackColor: Colors.grey.shade300,
            thumbColor: const Color(0xFFE23A44),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
  
  String _formatCurrency(int amount) {
    String result = amount.toString();
    if (result.length > 3) {
      String lastThree = result.substring(result.length - 3);
      String other = result.substring(0, result.length - 3);
      other = other.replaceAllMapped(RegExp(r".{1,2}(?=(.{2})+(?!.))"), (Match m) => "${m[0]},");
      result = other + "," + lastThree;
    }
    return result;
  }
}

class TopHighlightedProjectsSection extends StatelessWidget {
  const TopHighlightedProjectsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 1000),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top highlighted projects', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 8),
          const Text('Noteworthy projects to watch', style: TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildHighlightedCard(
                  name: 'Shubham Jijai Tulsi',
                  builder: 'by Shubham Group',
                  price: '₹33.7 L - 37.8 L',
                  details: '1 BHK Apartment\nTaloja, Navi Mumbai',
                  imageUrl: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800&q=80',
                ),
                const SizedBox(width: 16),
                _buildHighlightedCard(
                  name: 'Unimont Imperia',
                  builder: 'by Unimont Realty',
                  price: '₹24.75 L - 48.93 L',
                  details: '1, 2 BHK Apartments\nKhopoli, Navi Mumbai',
                  imageUrl: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800&q=80',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedCard({required String name, required String builder, required String price, required String details, required String imageUrl}) {
    return Container(
      width: 320,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.9), Colors.transparent],
            stops: const [0.0, 0.6],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(builder, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                Text(price, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 12),
            Text(details, style: const TextStyle(color: Colors.white70, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class FeaturedDevelopersSection extends StatelessWidget {
  const FeaturedDevelopersSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 1000),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Featured Developers', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 8),
          const Text('Prominent real-estate builders', style: TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDevCard(
                  name: 'Riyasat Infra Develop...',
                  estd: '2020',
                  projects: '4',
                  desc: 'Riyasat Group is best real estate developer in Navi Mumbai & Jaipur, established in 2021. We are dedicated t...',
                  tabs: ['The Riyasat ...', 'Riyasat Bliss'],
                  projectName: 'The Riyasat Sankalp',
                  projectLoc: 'Panvel, Navi Mumbai',
                  projectPrice: '₹80.0 L - 4.78 Cr',
                  imageUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800&q=80',
                ),
                const SizedBox(width: 16),
                _buildDevCard(
                  name: 'Riu Homes Private Li...',
                  estd: '2020',
                  projects: '5',
                  desc: 'RIU HOMES PRIVATE LIMITED is a Private Company, Which CIN Number is U70109MH2020PTC352240 , was...',
                  tabs: ['Riu Siddhivi...'],
                  projectName: 'Riu Siddhivinayak Aarambh',
                  projectLoc: 'Pushpak Nagar, Navi Mumbai',
                  projectPrice: '₹55.0 L - 1.04 Cr',
                  imageUrl: 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=800&q=80',
                ),
                const SizedBox(width: 16),
                _buildDevCard(
                  name: 'S M Developers',
                  estd: '2002',
                  projects: '18',
                  desc: 'SM Developers is one of the top level Real Estate development organizations operating in Mumbai for the past so...',
                  tabs: ['SM Tulip'],
                  projectName: 'SM Tulip',
                  projectLoc: 'Ulwe, Navi Mumbai',
                  projectPrice: '₹67.0 L',
                  imageUrl: 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800&q=80',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevCard({
    required String name,
    required String estd,
    required String projects,
    required String desc,
    required List<String> tabs,
    required String projectName,
    required String projectLoc,
    required String projectPrice,
    required String imageUrl,
  }) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top purple line
          Container(height: 4, decoration: const BoxDecoration(color: Color(0xFF6C2BD9), borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)))),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(4)),
                      child: Center(child: Text(name.substring(0, 2).toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(estd, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  const Text('Year estd.', style: TextStyle(color: Colors.black54, fontSize: 10)),
                                ],
                              ),
                              const SizedBox(width: 24),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(projects, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  const Text('Projects', style: TextStyle(color: Colors.black54, fontSize: 10)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(desc, style: const TextStyle(color: Colors.black54, fontSize: 11, height: 1.4), maxLines: 3, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 16),
                Row(
                  children: tabs.map((tab) {
                    bool isFirst = tab == tabs.first;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tab, style: TextStyle(fontSize: 12, fontWeight: isFirst ? FontWeight.bold : FontWeight.normal, color: isFirst ? const Color(0xFF6C2BD9) : Colors.black54)),
                          if (isFirst)
                            Container(margin: const EdgeInsets.only(top: 4), height: 2, width: 40, color: const Color(0xFF6C2BD9))
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(projectName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        Text(projectLoc, style: const TextStyle(color: Colors.white70, fontSize: 10)),
                        const SizedBox(height: 4),
                        Text(projectPrice, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HighDemandProjectsSection extends StatefulWidget {
  const HighDemandProjectsSection({Key? key}) : super(key: key);

  @override
  State<HighDemandProjectsSection> createState() => _HighDemandProjectsSectionState();
}

class _HighDemandProjectsSectionState extends State<HighDemandProjectsSection> {
  final ScrollController _scrollController = ScrollController();

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 400,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 400,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 1000),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('High-demand projects to invest now', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 8),
          const Text('Leading projects in high demand', style: TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        _buildHighDemandCard(
                          name: 'SM Ganesha',
                          developer: 'by S M Developers',
                          type: '1 BHK Apartment',
                          location: 'Ulwe, Navi Mumbai',
                          price: '₹66.0 L',
                          imageUrl: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800&q=80',
                        ),
                        const SizedBox(height: 16),
                        _buildHighDemandCard(
                          name: 'Phoenix Vision',
                          developer: 'by Phoenix Vision Developers',
                          type: '1 BHK Apartment',
                          location: 'Ulwe, Navi Mumbai',
                          price: '₹52.0 L',
                          imageUrl: 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=800&q=80',
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        _buildHighDemandCard(
                          name: 'Shreesha Heights',
                          developer: 'by Shreesha Group',
                          type: '1, 2 BHK Apartments',
                          location: 'Pushpak Nagar, Navi Mumbai',
                          price: '₹44.0 L - 65.0 L',
                          imageUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800&q=80',
                        ),
                        const SizedBox(height: 16),
                        _buildHighDemandCard(
                          name: 'Vastu Park',
                          developer: 'by Vastu Nirvana LLP',
                          type: '1, 2 BHK Apartments',
                          location: 'Kharghar, Navi Mumbai',
                          price: '₹67.0 L - 97.0 L',
                          imageUrl: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800&q=80',
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        _buildHighDemandCard(
                          name: 'Dani Sky',
                          developer: 'by Dani Enterprises',
                          type: '1, 2 BHK Apartments',
                          location: 'Pushpak Nagar, Navi Mumbai',
                          price: '₹52.68 L - 79.62 L',
                          imageUrl: 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800&q=80',
                        ),
                        const SizedBox(height: 16),
                        _buildHighDemandCard(
                          name: 'Vishwanath Vaastu',
                          developer: 'by Vaastu Builders & Develop...',
                          type: '1 BHK Apartment',
                          location: 'Panvel, Navi Mumbai',
                          price: '₹28.32 L - 40.98 L',
                          imageUrl: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800&q=80',
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        _buildHighDemandCard(
                          name: 'SM Tulip',
                          developer: 'by S M Developers',
                          type: '1 BHK Apartment',
                          location: 'Ulwe, Navi Mumbai',
                          price: '₹67.0 L',
                          imageUrl: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800&q=80',
                        ),
                        const SizedBox(height: 16),
                        _buildHighDemandCard(
                          name: 'Haware Grande',
                          developer: 'by Haware Legaccy',
                          type: '1, 2, 2.5, 3 BHK Apartments',
                          location: 'Pen, Raigad',
                          price: '₹35.0 L - 75.01 L',
                          imageUrl: 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=800&q=80',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                child: InkWell(
                  onTap: _scrollLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.arrow_back, size: 24, color: Colors.black87),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: InkWell(
                  onTap: _scrollRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.arrow_forward, size: 24, color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHighDemandCard({
    required String name,
    required String developer,
    required String type,
    required String location,
    required String price,
    required String imageUrl,
  }) {
    return Container(
      width: 320,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(developer, style: const TextStyle(color: Colors.black54, fontSize: 10)),
                  const SizedBox(height: 12),
                  Text(type, style: const TextStyle(color: Colors.black87, fontSize: 11)),
                  Text(location, style: const TextStyle(color: Colors.black54, fontSize: 11)),
                  const SizedBox(height: 8),
                  Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecommendedSellersSection extends StatefulWidget {
  const RecommendedSellersSection({Key? key}) : super(key: key);

  @override
  State<RecommendedSellersSection> createState() => _RecommendedSellersSectionState();
}

class _RecommendedSellersSectionState extends State<RecommendedSellersSection> {
  final ScrollController _scrollController = ScrollController();

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 400,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 400,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 1000),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recommended sellers', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 8),
          const Text('Sellers with complete knowledge about locality', style: TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        _buildSellerCard(
                          name: 'Griha Realty',
                          color: const Color(0xFFF1C40F),
                          textColor: Colors.black87,
                          experience: '16',
                          listings: '245',
                          locations: ['Ulwe', 'Kopar Khairane'],
                        ),
                        const SizedBox(height: 16),
                        _buildSellerCard(
                          name: 'Newbricks Real Es...',
                          color: Colors.white,
                          textColor: Colors.black87,
                          experience: '16',
                          listings: '50',
                          locations: ['Kharghar', 'Taloja'],
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        _buildSellerCard(
                          name: 'UNNATI REALTORS',
                          color: const Color(0xFF5D535E),
                          textColor: Colors.white,
                          experience: '15',
                          listings: '6',
                          locations: ['Ghansoli', 'Kopar Khairane'],
                        ),
                        const SizedBox(height: 16),
                        _buildSellerCard(
                          name: 'RTC Properties',
                          color: Colors.white,
                          textColor: Colors.black87,
                          experience: '2',
                          listings: '81',
                          locations: ['Kharghar', 'Taloja'],
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        _buildSellerCard(
                          name: 'SANTOSH NARAYA...',
                          color: const Color(0xFF4A4E45),
                          textColor: Colors.white,
                          experience: '23',
                          listings: '11',
                          locations: ['Sanpada', 'Juinagar'],
                        ),
                        const SizedBox(height: 16),
                        _buildSellerCard(
                          name: 'Ankit Mittal',
                          color: Colors.white,
                          textColor: Colors.black87,
                          experience: '9',
                          listings: '27',
                          locations: ['Kharghar', 'Sanpada'],
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        _buildSellerCard(
                          name: 'Pradeshi Property',
                          color: const Color(0xFFD3C5A3),
                          textColor: Colors.black87,
                          experience: '16',
                          listings: '361',
                          locations: ['Kharghar', 'Taloja'],
                        ),
                        const SizedBox(height: 16),
                        _buildSellerCard(
                          name: 'Lotus Realty',
                          color: Colors.white,
                          textColor: Colors.black87,
                          experience: '0.5',
                          listings: '75',
                          locations: ['Ulwe', 'Sonkhar'],
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        _buildSellerCard(
                          name: 'Shalini Singh',
                          color: const Color(0xFFC7BBA5),
                          textColor: Colors.black87,
                          experience: '0',
                          listings: '130',
                          locations: ['Kamothe', 'Panvel'],
                        ),
                        const SizedBox(height: 16),
                        _buildSellerCard(
                          name: 'Novira lands',
                          color: Colors.white,
                          textColor: Colors.black87,
                          experience: '0.5',
                          listings: '9',
                          locations: ['jui', 'Koproli, Uran Taluka'],
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        _buildSellerCard(
                          name: 'Estate Harbor',
                          color: const Color(0xFFF79F9F),
                          textColor: Colors.black87,
                          experience: '3',
                          listings: '97',
                          locations: ['Kalyan West', 'Dombivli East'],
                        ),
                        const SizedBox(height: 16),
                        _buildSellerCard(
                          name: 'PROFITWALA REAL...',
                          color: Colors.white,
                          textColor: Colors.black87,
                          experience: '0.5',
                          listings: '65',
                          locations: ['Ulwe'],
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        _buildSellerCard(
                          name: 'Shree Trimurti Est...',
                          color: const Color(0xFFCE0A0A),
                          textColor: Colors.white,
                          experience: '18',
                          listings: '19',
                          locations: ['Ulwe'],
                        ),
                        const SizedBox(height: 16),
                        _buildSellerCard(
                          name: 'Santosh Property',
                          color: Colors.white,
                          textColor: Colors.black87,
                          experience: '0.5',
                          listings: '123',
                          locations: ['Kharghar', 'Kamothe'],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                child: InkWell(
                  onTap: _scrollLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.arrow_back, size: 24, color: Colors.black87),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: InkWell(
                  onTap: _scrollRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.arrow_forward, size: 24, color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSellerCard({
    required String name,
    required Color color,
    required Color textColor,
    required String experience,
    required String listings,
    required List<String> locations,
  }) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: textColor == Colors.white ? Colors.white24 : Colors.black12,
                  child: Icon(Icons.person, size: 16, color: textColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.chevron_right, color: textColor, size: 18),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: '$experience Yrs ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
                          const TextSpan(text: 'Experience', style: TextStyle(color: Colors.black54, fontSize: 10)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(height: 12, width: 1, color: Colors.grey.shade300),
                    const SizedBox(width: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: '$listings ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
                          const TextSpan(text: 'Total listings', style: TextStyle(color: Colors.black54, fontSize: 10)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: locations.map((loc) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
                      child: Text(loc, style: const TextStyle(fontSize: 10, color: Colors.black54)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.phone, size: 16, color: Color(0xFF6C2BD9)),
                    label: const Text('Show Contact', style: TextStyle(color: Color(0xFF6C2BD9), fontWeight: FontWeight.bold, fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF6C2BD9)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyToSellSection extends StatelessWidget {
  const PropertyToSellSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 1000),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Have a property to sell?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
              gradient: const LinearGradient(
                colors: [Color(0xFFEDEEFF), Color(0xFFFAF5FF), Color(0xFFFFF2FA)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left graphic placeholder
                Container(
                  width: 200,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(
                    'https://images.unsplash.com/photo-1560518883-ce09059eeffa?auto=format&fit=crop&w=200&h=120',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.vpn_key_rounded, size: 60, color: Color(0xFF6C2BD9))),
                  ),
                ),
                // Center content
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('List your property & connect with clients faster!', style: TextStyle(fontSize: 16, color: Colors.black87)),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF6C2BD9)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                          backgroundColor: Colors.white,
                        ),
                        child: const Text('Sell your property', style: TextStyle(color: Color(0xFF6C2BD9), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                // Right graphic placeholder
                Container(
                  width: 200,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(
                    'https://images.unsplash.com/photo-1573164713988-8665fc963095?auto=format&fit=crop&w=200&h=120',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.groups, size: 60, color: Color(0xFFFF2A85))),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewsAndArticlesSection extends StatefulWidget {
  const NewsAndArticlesSection({Key? key}) : super(key: key);

  @override
  State<NewsAndArticlesSection> createState() => _NewsAndArticlesSectionState();
}

class _NewsAndArticlesSectionState extends State<NewsAndArticlesSection> {
  final ScrollController _scrollController = ScrollController();

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 320,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 1000),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('News and Articles', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(height: 8),
                  Text("Read what's happening in Real Estate", style: TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF6C2BD9)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: const Text('See all news and articles >', style: TextStyle(color: Color(0xFF6C2BD9), fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNewsCard(
                      imageUrl: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=400&h=200',
                      title: 'Exploring Madh Island as a real estate destination in Mumbai',
                      description: 'Madh Island is among the emerging destinations for premium living in Mumbai. New infrastructural developments will push property prices in the comin...',
                      author: 'Harini Balasubramanian',
                      date: 'Sep 2026',
                    ),
                    const SizedBox(width: 24),
                    _buildNewsCard(
                      imageUrl: 'https://images.unsplash.com/photo-1503387762-592deb58ef4e?auto=format&fit=crop&w=400&h=200',
                      title: 'Do faster construction approvals make homes cheaper?',
                      description: 'Several states in the country have made efforts to streamline the process of obtaining approvals for construction. Let\'s understand how it results in...',
                      author: 'Harini Balasubramanian',
                      date: 'Sep 2026',
                    ),
                    const SizedBox(width: 24),
                    _buildNewsCard(
                      imageUrl: 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=400&h=200',
                      title: 'Do buyers still wait for the festive season to buy homes?',
                      description: 'Developers and financial institutions take advantage of the festive season to draw customers by offering discounts and freebies. This makes it a favourable...',
                      author: 'Harini Balasubramanian',
                      date: 'Aug 2026',
                    ),
                    const SizedBox(width: 24),
                    _buildNewsCard(
                      imageUrl: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=400&h=200',
                      title: 'Investing in commercial properties vs residential properties',
                      description: 'A comprehensive guide to understanding the key differences, returns on investment, and risks associated with commercial and residential real estate...',
                      author: 'Harini Balasubramanian',
                      date: 'Jul 2026',
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                child: InkWell(
                  onTap: _scrollRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.arrow_forward, size: 24, color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard({
    required String imageUrl,
    required String title,
    required String description,
    required String author,
    required String date,
  }) {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              height: 160,
              width: 300,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87, height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.5),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Colors.black12),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(author, style: const TextStyle(fontSize: 10, color: Colors.black45)),
              Text(date, style: const TextStyle(fontSize: 10, color: Colors.black45)),
            ],
          ),
        ],
      ),
    );
  }
}

final ValueNotifier<String> propertyValuationSelectedCityNotifier = ValueNotifier<String>('Mumbai');

final Map<String, Map<String, dynamic>> propertyValuationCityData = {
  'Mumbai': {
    'growth': '+28.6%',
    'bars': [120.0, 130.0, 145.0, 150.0, 165.0, 170.0],
    'prices': ['14.2K', '14.8K', '15.5K', '16.1K', '17.3K', '18.2K'],
  },
  'Bengaluru': {
    'growth': '+38.1%',
    'bars': [110.0, 125.0, 140.0, 160.0, 175.0, 185.0],
    'prices': ['6.5K', '7.1K', '7.8K', '8.6K', '9.4K', '10.1K'],
  },
  'Gurugram': {
    'growth': '+32.7%',
    'bars': [100.0, 115.0, 130.0, 145.0, 155.0, 175.0],
    'prices': ['8.2K', '8.9K', '9.7K', '10.5K', '11.2K', '12.5K'],
  },
  'Pune': {
    'growth': '+22.4%',
    'bars': [110.0, 120.0, 130.0, 135.0, 145.0, 155.0],
    'prices': ['5.8K', '6.1K', '6.4K', '6.7K', '7.2K', '7.8K'],
  },
  'Chennai': {
    'growth': '+18.5%',
    'bars': [120.0, 125.0, 135.0, 140.0, 145.0, 150.0],
    'prices': ['5.5K', '5.7K', '6.0K', '6.3K', '6.5K', '6.9K'],
  },
  'Kolkata': {
    'growth': '+12.3%',
    'bars': [60.0, 65.0, 72.0, 78.0, 85.0, 92.0],
    'prices': ['3.4K', '3.6K', '3.8K', '4.1K', '4.3K', '4.5K'],
  },
  'Ahmedabad': {
    'growth': '+14.1%',
    'bars': [55.0, 60.0, 68.0, 72.0, 80.0, 88.0],
    'prices': ['3.2K', '3.3K', '3.5K', '3.7K', '3.9K', '4.2K'],
  },
  'Jaipur': {
    'growth': '+9.8%',
    'bars': [45.0, 50.0, 55.0, 58.0, 62.0, 65.0],
    'prices': ['2.8K', '2.9K', '3.0K', '3.2K', '3.4K', '3.5K'],
  }
};

class HousingIndexSection extends StatelessWidget {
  const HousingIndexSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final bool isMobile = MediaQuery.of(context).size.width < 800;

        return Container(
          width: double.infinity,
          color: const Color(0xFF262626), // Dark background color
          padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 80),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left side text
                        Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('THE HOUSING INDEX', style: TextStyle(color: Color(0xFFE23A44), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    const SizedBox(height: 16),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(color: Colors.white, fontSize: isMobile ? 32 : 44, height: 1.1),
                        children: [
                          const TextSpan(text: 'What is your\n', style: TextStyle(fontWeight: FontWeight.w400)),
                          TextSpan(
                            text: 'home worth?',
                            style: TextStyle(fontFamily: 'Georgia', fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: isMobile ? 36 : 48, letterSpacing: -1.0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Track price movement across India's most-loved\nneighbourhoods.", 
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)
                    ),
                    const SizedBox(height: 32),
                    OutlinedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const PropertyValuationDialog(),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white38),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('Explore valuations', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
                          SizedBox(width: 8),
                          Icon(Icons.chevron_right, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                // Right side graph
                ValueListenableBuilder<String>(
                  valueListenable: propertyValuationSelectedCityNotifier,
                  builder: (context, selectedCity, _) {
                    final data = propertyValuationCityData[selectedCity]!;
                    final List<double> bars = data['bars'];
                    final String growth = data['growth'];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('$selectedCity · Avg. ₹/sq.ft', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                            Row(
                              children: [
                                Text(growth, style: const TextStyle(color: Color(0xFF33A974), fontWeight: FontWeight.bold, fontSize: 20)),
                                const SizedBox(width: 6),
                                const Text('in 6 months', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildGraphBar('Oct', bars[0]),
                            _buildGraphBar('Nov', bars[1]),
                            _buildGraphBar('Dec', bars[2]),
                            _buildGraphBar('Jan', bars[3]),
                            _buildGraphBar('Feb', bars[4]),
                            _buildGraphBar('Mar', bars[5]),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(height: 1, color: Colors.white24, width: double.infinity),
                      ],
                    );
                  }
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left side text
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('THE HOUSING INDEX', style: TextStyle(color: Color(0xFFE23A44), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                      const SizedBox(height: 16),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(color: Colors.white, fontSize: 44, height: 1.1),
                          children: [
                            TextSpan(text: 'What is your\n', style: TextStyle(fontWeight: FontWeight.w400)),
                            TextSpan(
                              text: 'home worth?',
                              style: TextStyle(fontFamily: 'Georgia', fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: 48, letterSpacing: -1.0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text("Track price movement across India's most-loved\nneighbourhoods.", style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)),
                      const SizedBox(height: 32),
                      OutlinedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const PropertyValuationDialog(),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white38),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('Explore valuations', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
                            SizedBox(width: 8),
                            Icon(Icons.chevron_right, color: Colors.white, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                // Right side graph
                Expanded(
                  flex: 6,
                  child: ValueListenableBuilder<String>(
                    valueListenable: propertyValuationSelectedCityNotifier,
                    builder: (context, selectedCity, _) {
                      final data = propertyValuationCityData[selectedCity]!;
                      final List<double> bars = data['bars'];
                      final String growth = data['growth'];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('$selectedCity · Avg. ₹/sq.ft', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                              Row(
                                children: [
                                  Text(growth, style: const TextStyle(color: Color(0xFF33A974), fontWeight: FontWeight.bold, fontSize: 20)),
                                  const SizedBox(width: 6),
                                  const Text('in 6 months', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildGraphBar('Oct', bars[0]),
                              _buildGraphBar('Nov', bars[1]),
                              _buildGraphBar('Dec', bars[2]),
                              _buildGraphBar('Jan', bars[3]),
                              _buildGraphBar('Feb', bars[4]),
                              _buildGraphBar('Mar', bars[5]),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(height: 1, color: Colors.white24, width: double.infinity),
                        ],
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildGraphBar(String label, double height) {
    return Column(
      children: [
        Container(
          width: 32,
          height: height,
          color: const Color(0xFFE23A44),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
      ],
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final bool isMobile = MediaQuery.of(context).size.width < 800;
        
        return Container(
          width: double.infinity,
          color: const Color(0xFFF9F8F4), // Light off-white
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: isMobile
                  ? Column(
                      children: [
                        // Logo
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(color: Color(0xFFE23A44), shape: BoxShape.circle),
                              child: const Center(child: Text('h', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 14))),
                            ),
                            const SizedBox(width: 8),
                            const Text('housing.com', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Text
                        Column(
                          children: const [
                            Text('Made for the way you find home.', style: TextStyle(color: Colors.black45, fontSize: 12), textAlign: TextAlign.center),
                            SizedBox(height: 8),
                            Text('© 2025 Housing.com', style: TextStyle(color: Colors.black45, fontSize: 12), textAlign: TextAlign.center),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(color: Color(0xFFE23A44), shape: BoxShape.circle),
                              child: const Center(child: Text('h', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 14))),
                            ),
                            const SizedBox(width: 8),
                            const Text('housing.com', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        // Text
                        Row(
                          children: const [
                            Text('Made for the way you find home.', style: TextStyle(color: Colors.black45, fontSize: 12)),
                            SizedBox(width: 32),
                            Text('© 2025 Housing.com', style: TextStyle(color: Colors.black45, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        );
      }
    );
  }
}

class PropertyValuationDialog extends StatelessWidget {
  const PropertyValuationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFFBF9F6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(32),
        child: ValueListenableBuilder<String>(
          valueListenable: propertyValuationSelectedCityNotifier,
          builder: (context, selectedCity, _) {
            final data = propertyValuationCityData[selectedCity]!;
            final List<double> bars = data['bars'];
            final List<String> prices = data['prices'] ?? List.filled(6, '');
            final String growth = data['growth'];

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('MARKET INTELLIGENCE', style: TextStyle(color: Colors.black45, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Property valuation', style: TextStyle(fontSize: 32, color: Colors.black87, fontWeight: FontWeight.w400)),
                const SizedBox(height: 8),
                const Text('See how your city has moved over the last six months.', style: TextStyle(color: Colors.black54, fontSize: 14)),
                const SizedBox(height: 32),
                
                // Tabs
                // Tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Mumbai', 'Bengaluru', 'Gurugram', 'Pune', 'Chennai', 'Kolkata', 'Ahmedabad', 'Jaipur'].map((city) {
                      bool isSelected = city == selectedCity;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: InkWell(
                          onTap: () {
                            propertyValuationSelectedCityNotifier.value = city;
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: isSelected ? const Color(0xFFE23A44) : Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Text(
                              city,
                              style: TextStyle(
                                color: isSelected ? const Color(0xFFE23A44) : Colors.black87,
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Graph Box
                Container(
                  width: double.infinity,
                  height: 280,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildGraphBar('Oct', bars[0], prices[0]),
                      _buildGraphBar('Nov', bars[1], prices[1]),
                      _buildGraphBar('Dec', bars[2], prices[2]),
                      _buildGraphBar('Jan', bars[3], prices[3]),
                      _buildGraphBar('Feb', bars[4], prices[4]),
                      _buildGraphBar('Mar', bars[5], prices[5]),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Bottom Growth Text
                Row(
                  children: [
                    Text(growth, style: const TextStyle(color: Color(0xFF2C8465), fontWeight: FontWeight.bold, fontSize: 24)),
                    const SizedBox(width: 12),
                    Text('Average price growth in $selectedCity', style: const TextStyle(color: Colors.black54, fontSize: 12)),
                  ],
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  Widget _buildGraphBar(String label, double height, String priceText) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(priceText, style: const TextStyle(color: Colors.black87, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          width: 32,
          height: height,
          color: const Color(0xFFE23A44),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.black54, fontSize: 10)),
      ],
    );
  }
}

class VirtualTourDialog extends StatefulWidget {
  final String propertyName;
  const VirtualTourDialog({Key? key, required this.propertyName}) : super(key: key);

  @override
  State<VirtualTourDialog> createState() => _VirtualTourDialogState();
}

class _VirtualTourDialogState extends State<VirtualTourDialog> {
  String currentRoom = 'Living room';

  String get currentImageUrl {
    bool isGrove = widget.propertyName == 'The Grove Residences';
    bool isM3M = widget.propertyName == 'M3M Crown';
    
    switch (currentRoom) {
      case 'Living room':
        if (isM3M) return 'assets/images/m3m_living_room.png';
        return isGrove ? 'assets/images/grove_living_room.jpg' : 'assets/images/living_room.jpg';
      case 'Master bedroom':
        if (isM3M) return 'assets/images/m3m_bedroom.jpg';
        return isGrove ? 'assets/images/grove_bedroom.jpg' : 'assets/images/bedroom.png';
      case 'Kitchen area':
        if (isM3M) return 'assets/images/m3m_kitchen.jpg';
        return isGrove ? 'assets/images/grove_kitchen.jpg' : 'assets/images/kitchen.png';
      case 'Restroom':
      case 'Bathroom':
        if (isM3M) return 'assets/images/m3m_bathroom.png';
        return isGrove ? 'assets/images/grove_bathroom.jpg' : 'assets/images/bathroom.jpg';
      default:
        if (isM3M) return 'assets/images/m3m_living_room.png';
        return isGrove ? 'assets/images/grove_living_room.jpg' : 'assets/images/living_room.jpg';
    }
  }

  String get currentDimensions {
    switch (currentRoom) {
      case 'Living room': return '22 × 15 ft';
      case 'Master bedroom': return '16 × 14 ft';
      case 'Kitchen area': return '12 × 10 ft';
      case 'Restroom':
      case 'Bathroom': return '8 × 8 ft';
      default: return '';
    }
  }

  Widget _buildTab(String label) {
    bool isSelected = currentRoom == label;
    return InkWell(
      onTap: () => setState(() => currentRoom = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE23A44) : Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: isMobile ? 24 : 40,
      ),
      child: Container(
        width: 900,
        height: isMobile ? screenWidth * 1.4 : 700,
        decoration: BoxDecoration(
          color: const Color(0xFFF6F4EE),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.only(
                top: isMobile ? 16 : 24,
                right: 16,
                left: isMobile ? 20 : 40,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: isMobile ? 8 : 16),
                      const Text('STEP INSIDE', style: TextStyle(color: Colors.black54, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Virtual tour', style: TextStyle(fontSize: isMobile ? 24 : 32, fontWeight: FontWeight.w400)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            SizedBox(height: isMobile ? 12 : 24),

            // ── Room image ───────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image.asset(currentImageUrl, fit: BoxFit.cover),
                      ),
                      Positioned(
                        bottom: isMobile ? 16 : 30,
                        left: isMobile ? 16 : 30,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('HD Image', style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1.0)),
                            const SizedBox(height: 4),
                            Text(currentRoom, style: TextStyle(color: Colors.white, fontSize: isMobile ? 18 : 24, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(currentDimensions, style: const TextStyle(color: Colors.white, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Room tabs row (scrollable to prevent overflow) ────────────
            Padding(
              padding: EdgeInsets.symmetric(vertical: isMobile ? 16 : 28, horizontal: isMobile ? 8 : 16),
              child: Row(
                children: [
                  // Left arrow
                  GestureDetector(
                    onTap: () {
                      final rooms = ['Living room', 'Master bedroom', 'Kitchen area', 'Restroom'];
                      final idx = rooms.indexOf(currentRoom);
                      if (idx > 0) setState(() => currentRoom = rooms[idx - 1]);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.chevron_left, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Scrollable tabs
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildTab('Living room'),
                          const SizedBox(width: 6),
                          _buildTab('Master bedroom'),
                          const SizedBox(width: 6),
                          _buildTab('Kitchen area'),
                          const SizedBox(width: 6),
                          _buildTab('Restroom'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),
                  // Right arrow
                  GestureDetector(
                    onTap: () {
                      final rooms = ['Living room', 'Master bedroom', 'Kitchen area', 'Restroom'];
                      final idx = rooms.indexOf(currentRoom);
                      if (idx < rooms.length - 1) setState(() => currentRoom = rooms[idx + 1]);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.chevron_right, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
