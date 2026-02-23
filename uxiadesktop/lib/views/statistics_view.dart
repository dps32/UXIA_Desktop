import 'package:flutter/material.dart';
import 'dart:math';

import 'package:uxiadesktop/main.dart';

class TagData {
  final String name;
  final int count;
  final Color color;
  bool isSelected;

  TagData({required this.name, required this.count, required this.color, this.isSelected = false});
}

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  List<TagData> _allTags = []; 
  List<TagData> _filteredTags = [];
  bool _isLoading = true; 
  final TextEditingController _searchController = TextEditingController();
  bool get _isAllSelected => _allTags.isNotEmpty && _allTags.every((t) => t.isSelected);

  @override
  void initState() {
    super.initState();
    _loadApiTags();
    _searchController.addListener(_filterTags);
  }

  Future<void> _loadApiTags() async {
    setState(() => _isLoading = true);

    final dynamic response = await MainApp.data.callGetTags();

    if (response != null && response is List) {
      final List<dynamic> sortedData = List.from(response)
        ..sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));

      double hueStep = sortedData.isEmpty ? 0 : 360 / sortedData.length;

      setState(() {
        _allTags = sortedData.asMap().entries.map((entry) {
          int i = entry.key;
          var data = entry.value;

          return TagData(
            name: data['name'],
            count: data['count'],
            color: HSVColor.fromAHSV(
              1.0, 
              i * hueStep,
              0.7, 
              0.85
            ).toColor(),
          );
        }).toList();

        _filteredTags = _allTags;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
    _searchController.addListener(_filterTags);
  }

  void _filterTags() {
    setState(() {
      _filteredTags = _allTags
          .where((tag) => tag.name.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _toggleAll(bool? value) {
    if (value == null) return;
    setState(() {
      for (var tag in _allTags) {
        tag.isSelected = value;
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<TagData> selectedTags = _allTags.where((t) => t.isSelected).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Estadístiques d'Etiquetes", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: _isLoading
      ? const Center(child: CircularProgressIndicator())
      : Row(
        children: [
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(right: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Cerca etiqueta...",
                      prefixIcon: const Icon(Icons.search, size: 20),
                      isDense: true,
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                CheckboxListTile(
                  title: const Text(
                    "Seleccionar-ho tot",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  value: _isAllSelected,
                  activeColor: Colors.teal,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: _toggleAll,
                  dense: true,
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredTags.length,
                    itemBuilder: (context, index) {
                      final tag = _filteredTags[index];
                      return CheckboxListTile(
                        activeColor: tag.color,
                        title: Text(tag.name, style: const TextStyle(fontSize: 14)),
                        value: tag.isSelected,
                        controlAffinity: ListTileControlAffinity.leading,
                        secondary: Container(
                          width: 10, height: 10,
                          decoration: BoxDecoration(color: tag.color, shape: BoxShape.circle),
                        ),
                        onChanged: (val) {
                          setState(() => tag.isSelected = val!);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(40),
              color: Colors.grey[50],
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.grey[200]!),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: selectedTags.isEmpty
                      ? const Center(child: Text("Selecciona etiquetes per comparar"))
                      : CustomPaint(
                          size: Size.infinite,
                          painter: BarChartPainter(tags: selectedTags),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<TagData> tags;
  BarChartPainter({required this.tags});

  @override
  void paint(Canvas canvas, Size size) {
    if (tags.isEmpty) return;

    final paint = Paint()..style = PaintingStyle.fill;
    final maxCount = tags.map((t) => t.count).reduce(max);
    
    const double barGap = 25.0;
    final double barWidth = (size.width - (barGap * (tags.length - 1))) / tags.length;

    for (int i = 0; i < tags.length; i++) {
      final tag = tags[i];
      final double barHeight = (tag.count / maxCount) * size.height;
      
      paint.color = tag.color;

      final rect = Rect.fromLTWH(
        i * (barWidth + barGap),
        size.height - barHeight,
        barWidth,
        barHeight,
      );

      canvas.drawRRect(
        RRect.fromRectAndCorners(rect, 
          topLeft: const Radius.circular(6), 
          topRight: const Radius.circular(6)
        ),
        paint
      );

      _drawText(canvas, tag.count.toString(), 
        Offset(rect.left + (barWidth/2), rect.top - 25), 
        isBold: true, fontSize: 14);

      _drawText(canvas, tag.name, 
        Offset(rect.left + (barWidth/2), size.height + 15), 
        fontSize: 12, color: Colors.black54);
    }
  }

  void _drawText(Canvas canvas, String text, Offset center, {bool isBold = false, double fontSize = 12, Color color = Colors.black87}) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color, 
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal, 
          fontSize: fontSize
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();
    
    textPainter.paint(canvas, Offset(center.dx - (textPainter.width / 2), center.dy));
  }

  @override
  bool shouldRepaint(covariant BarChartPainter oldDelegate) => true;
}