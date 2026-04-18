import 'package:ecommerce_app/home_page.dart';
import 'package:flutter/material.dart';

class FilterList extends StatefulWidget {
  const FilterList({super.key});

  @override
  State<FilterList> createState() => _FilterListState();
}

class _FilterListState extends State<FilterList> {
  final List<String> filters = const [
    "All",
    "Running",
    "Training",
    "Basketball",
    "Lifestyle",
  ];
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = filters[0];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        itemCount: filters.length,
        scrollDirection: Axis.horizontal,

        itemBuilder: (BuildContext context, int index) {
          String filter = filters[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selected = filter;
                });
              },
              child: Chip(
                backgroundColor: selected == filter
                    ? Theme.of(context).primaryColor
                    : const Color.fromARGB(255, 215, 230, 245),
                labelStyle: TextStyle(fontSize: 16),
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                side: BorderSide(
                  color: const Color.fromARGB(
                    255,
                    215,
                    230,
                    245,
                  ),
                ),
                label: Text(filter),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
