import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'countries.dart';

class SearchableDropdown extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final String? value;
  final String labelText;
  final Function(String?) onChanged;

  const SearchableDropdown({
    Key? key,
    required this.items,
    this.value,
    required this.labelText,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SearchableDropdownState createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredItems = [];
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = widget.items
          .where((item) =>
          item['name'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isDropdownOpen = !_isDropdownOpen;
              _searchController.clear();
              _filteredItems = widget.items;
            });
          },
          child: AbsorbPointer(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: widget.labelText,
                suffixIcon: Icon(Icons.arrow_drop_down),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Color(0xFFd6dedf),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              controller: TextEditingController(
                  text: widget.value ?? 'choose_country'.tr
              ),
            ),
          ),
        ),
        if (_isDropdownOpen)
          Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: _filterItems,
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 250, // Adjust as needed
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return ListTile(
                        title: Text(item['name']),
                        onTap: () {
                          widget.onChanged(item['name']);
                          setState(() {
                            _isDropdownOpen = false;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
