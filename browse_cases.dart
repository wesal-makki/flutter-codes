import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'donation.dart';

class BrowseCasesPage extends StatefulWidget {
  final int userId;

  const BrowseCasesPage({super.key, required this.userId});

  @override
  State<BrowseCasesPage> createState() => _BrowseCasesPageState();
}

class _BrowseCasesPageState extends State<BrowseCasesPage> {
  List<dynamic> cases = [];
  List<dynamic> filteredCases = [];
  TextEditingController searchController = TextEditingController();

  String? selectedCategory;
  String? selectedState;

  @override
  void initState() {
    super.initState();
    fetchCases();
  }

  Future<void> fetchCases() async {
    try {
      var url = Uri.parse("http://10.0.2.2/pwrs_backend/browse_cases.php");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          cases = data;
          filteredCases = data;
        });
      } else {
        throw Exception("Failed to load cases");
      }
    } catch (e) {
      print("Error fetching cases: $e");
    }
  }

  void filterCases(String query) {
    setState(() {
      filteredCases = cases.where((caseItem) {
        final title = caseItem['title'].toLowerCase();
        final state = caseItem['state'].toLowerCase();
        final category = caseItem['category'].toLowerCase();
        final search = query.toLowerCase();

        bool matchesSearch =
            title.contains(search) ||
            state.contains(search) ||
            category.contains(search);

        bool matchesCategory =
            selectedCategory == null ||
            caseItem['category'] == selectedCategory;
        bool matchesState =
            selectedState == null || caseItem['state'] == selectedState;

        return matchesSearch && matchesCategory && matchesState;
      }).toList();
    });
  }

  void _onFilterPressed() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Filter Cases",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(labelText: "Category"),
                    items: ['Health', 'Education', 'Reconstruction', 'Other']
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                    onChanged: (value) {
                      setModalState(() => selectedCategory = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedState,
                    decoration: const InputDecoration(labelText: "State"),
                    items: ['Khartoum', 'Omdurman', 'Bahri', 'Other']
                        .map(
                          (st) => DropdownMenuItem(value: st, child: Text(st)),
                        )
                        .toList(),
                    onChanged: (value) {
                      setModalState(() => selectedState = value);
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      filterCases(searchController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text("Apply Filters"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Requests'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search cases...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _onFilterPressed,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onChanged: filterCases,
            ),
          ),
          Expanded(
            child: filteredCases.isEmpty
                ? const Center(child: Text("No approved cases found"))
                : ListView.builder(
                    itemCount: filteredCases.length,
                    itemBuilder: (context, index) {
                      var caseItem = filteredCases[index];

                      double target = double.parse(caseItem['target']);
                      double collected =
                          double.tryParse(caseItem['collected'].toString()) ??
                          0;
                      double progress = (collected / target).clamp(0, 1);

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.blue.shade100,
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    caseItem['full_name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (caseItem['image'] != null &&
                                  caseItem['image'].isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    "http://10.0.2.2/pwrs_backend/${caseItem['image']}",
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              const SizedBox(height: 10),
                              Text(
                                caseItem['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                caseItem['description'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor: Colors.grey[300],
                                    color: Colors.green,
                                    minHeight: 8,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Collected: ${collected.toStringAsFixed(0)} / ${target.toStringAsFixed(0)} SDG",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => DonationPage(
                                          caseId: int.parse(
                                            caseItem['case_id'],
                                          ),
                                          userId: widget.userId,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  child: const Text(
                                    "Donate",
                                    style: TextStyle(color: Colors.white),
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
      ),
    );
  }
}
