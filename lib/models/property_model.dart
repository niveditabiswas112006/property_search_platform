class Property {
  final String id;
  final String title;
  final String location;
  final double price;
  final String priceFormatted;
  final int bhk;
  final String furnishing;
  final double carpetArea;
  final double superArea;
  final int propertyAge;
  final String possessionDate;
  final String possessionStatus;
  final String reraNumber;
  final bool isReraVerified;
  final bool isFeatured;
  final bool isBuilderListing;
  final String builderName;
  final String imageUrl;
  final List<String> floorPlans;
  final Map<String, List<String>> nearbyAmenities; // e.g. {'Schools': ['DPS'], 'Metro': ['Blue Line']}
  
  Property({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.priceFormatted,
    required this.bhk,
    required this.furnishing,
    required this.carpetArea,
    required this.superArea,
    required this.propertyAge,
    required this.possessionDate,
    required this.possessionStatus,
    required this.reraNumber,
    required this.isReraVerified,
    this.isFeatured = false,
    this.isBuilderListing = false,
    required this.builderName,
    required this.imageUrl,
    required this.floorPlans,
    required this.nearbyAmenities,
  });
}

final List<Property> dummyProperties = [
  Property(
    id: '1',
    title: 'Luxury 3BHK Apartment',
    location: 'Sector 50, Gurgaon',
    price: 15000000,
    priceFormatted: '₹1.50 Cr',
    bhk: 3,
    furnishing: 'Semi-Furnished',
    carpetArea: 1200,
    superArea: 1500,
    propertyAge: 2,
    possessionDate: 'Ready to Move',
    possessionStatus: 'Ready',
    reraNumber: 'RERA-GRG-1234',
    isReraVerified: true,
    isFeatured: true,
    isBuilderListing: true,
    builderName: 'DLF Group',
    imageUrl: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80',
    floorPlans: ['Floor Plan A'],
    nearbyAmenities: {
      'Schools': ['DPS Gurgaon (2km)'],
      'Hospitals': ['Fortis (3km)'],
      'Metro': ['Sector 50 Metro (1km)'],
    },
  ),
  Property(
    id: '2',
    title: 'Modern 2BHK Flat',
    location: 'Whitefield, Bangalore',
    price: 8500000,
    priceFormatted: '₹85 L',
    bhk: 2,
    furnishing: 'Fully Furnished',
    carpetArea: 900,
    superArea: 1100,
    propertyAge: 0,
    possessionDate: 'Dec 2026',
    possessionStatus: 'Under Construction',
    reraNumber: 'PRM/KA/RERA/5678',
    isReraVerified: true,
    isFeatured: false,
    isBuilderListing: false,
    builderName: 'Prestige Group',
    imageUrl: 'https://images.unsplash.com/photo-1493809842364-78817add7ffb?auto=format&fit=crop&w=800&q=80',
    floorPlans: ['Floor Plan B'],
    nearbyAmenities: {
      'Schools': ['TISB (4km)'],
      'Hospitals': ['Manipal Hospital (2km)'],
      'Metro': ['Whitefield Metro (0.5km)'],
    },
  ),
];
