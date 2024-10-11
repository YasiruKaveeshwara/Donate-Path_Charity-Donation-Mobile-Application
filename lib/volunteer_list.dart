import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main_layout.dart';

class VolunteerListPage extends StatefulWidget {
  const VolunteerListPage({Key? key}) : super(key: key);

  @override
  _VolunteerListPageState createState() => _VolunteerListPageState();
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color.fromARGB(255, 198, 255, 214),
      margin: const EdgeInsets.only(top: 30.0),
      child: child,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _VolunteerListPageState extends State<VolunteerListPage> {
  final ValueNotifier<String> _searchText =
      ValueNotifier<String>(''); // ValueNotifier for search text
  String _filterOption = 'Name'; // Default filter option
  List<Map<String, dynamic>> _volunteers = [];

  @override
  void initState() {
    super.initState();
    _fetchVolunteers();
  }

  @override
  void dispose() {
    _searchText.dispose(); // Dispose the ValueNotifier
    super.dispose();
  }

  Future<void> _fetchVolunteers() async {
    // Fetch volunteers from Firestore
    QuerySnapshot volunteerSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userType', isEqualTo: 'volunteer')
        .get();

    setState(() {
      _volunteers = volunteerSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      _sortVolunteers();
    });
  }

  void _sortVolunteers() {
    if (_filterOption == 'Name') {
      _volunteers.sort((a, b) => (a['name'] ?? '').compareTo(b['name'] ?? ''));
    } else if (_filterOption == 'Rating') {
      _volunteers
          .sort((a, b) => (b['rating'] ?? 0).compareTo(a['rating'] ?? 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      headerText: 'Top Volunteers',
      profileImage: '',
      selectedIndex: 0,
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 150.0,
              maxHeight: 150.0,
              child: Column(
                children: [
                  _buildSearchBar(),
                  _buildFilterOptions(),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ValueListenableBuilder<String>(
              valueListenable: _searchText,
              builder: (context, value, child) {
                return _buildVolunteerList(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        onChanged: (value) {
          _searchText.value =
              value.toLowerCase(); // Update only the ValueNotifier
        },
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Top Volunteers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          DropdownButton<String>(
            value: _filterOption,
            onChanged: (String? newValue) {
              setState(() {
                _filterOption = newValue!;
                _sortVolunteers();
              });
            },
            items: <String>['Name', 'Rating']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildVolunteerList(String searchText) {
    List<Map<String, dynamic>> filteredVolunteers = _volunteers
        .where((volunteer) =>
            (volunteer['name'] ?? '').toLowerCase().contains(searchText))
        .toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), // Prevent scroll conflict
      itemCount: filteredVolunteers.length,
      padding: const EdgeInsets.only(top: 10.0),
      itemBuilder: (context, index) {
        final volunteer = filteredVolunteers[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(volunteer['profileImage'] ??
                  'https://via.placeholder.com/150'),
            ),
            title: Text(
              volunteer['name'] ?? 'Unknown',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  volunteer['district'] ?? 'Not available',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, size: 20, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '${volunteer['rating']?.toStringAsFixed(1) ?? '0.0'}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            onTap: () {
              // Optional: Implement volunteer detail page navigation if needed
            },
          ),
        );
      },
    );
  }
}
