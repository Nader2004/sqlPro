import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:sqlpro/models/employee.dart';
import 'package:sqlpro/widgets/employee_card.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sqlpro/widgets/barchart.dart';

class ResultsPage extends StatefulWidget {
  final List<Employee> employess;
  final Map<String, dynamic> graphResults;
  const ResultsPage(
      {super.key, required this.employess, required this.graphResults});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pop(true),
        label: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Hit another request'),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_rounded, color: Colors.black),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      appBar: AppBar(
        elevation: 1.5,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        shadowColor: Colors.grey[300],
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Text(
          'Results',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: widget.graphResults.isNotEmpty
          ? Center(
              child: SimpleBarChart(results: widget.graphResults),
            )
          : widget.employess.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        color: Colors.grey[300],
                        size: 50,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No Results found',
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: AnimationLimiter(
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(
                        widget.employess.length,
                        (int index) {
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            columnCount: 2,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: EmployeeCard(
                                    employee: widget.employess[index]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
    );
  }
}
