import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  // Enable debug painting to visualize render objects
  debugPaintSizeEnabled = false; // Set to true to see render boundaries
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Rendering Pipeline Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RenderingPipelineDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RenderingPipelineDemo extends StatefulWidget {
  @override
  _RenderingPipelineDemoState createState() => _RenderingPipelineDemoState();
}

class _RenderingPipelineDemoState extends State<RenderingPipelineDemo>
    with TickerProviderStateMixin {
  bool _showWidgetTree = true;
  bool _showElementTree = false;
  bool _showRenderTree = false;
  bool _enableDebugPaint = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDebugPaint() {
    setState(() {
      _enableDebugPaint = !_enableDebugPaint;
      debugPaintSizeEnabled = _enableDebugPaint;
    });
  }

  void _startAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Rendering Pipeline'),
        backgroundColor: Colors.blue[700],
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Understanding Flutter\'s Rendering Pipeline',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'From Widget Tree → Element Tree → Render Tree → Screen',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Control Panel
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pipeline Visualization Controls',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        FilterChip(
                          label: Text('Widget Tree'),
                          selected: _showWidgetTree,
                          onSelected: (selected) {
                            setState(() => _showWidgetTree = selected);
                          },
                          backgroundColor: Colors.green[100],
                          selectedColor: Colors.green[300],
                        ),
                        FilterChip(
                          label: Text('Element Tree'),
                          selected: _showElementTree,
                          onSelected: (selected) {
                            setState(() => _showElementTree = selected);
                          },
                          backgroundColor: Colors.orange[100],
                          selectedColor: Colors.orange[300],
                        ),
                        FilterChip(
                          label: Text('Render Tree'),
                          selected: _showRenderTree,
                          onSelected: (selected) {
                            setState(() => _showRenderTree = selected);
                          },
                          backgroundColor: Colors.red[100],
                          selectedColor: Colors.red[300],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _toggleDebugPaint,
                          icon: Icon(
                            _enableDebugPaint
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          label: Text(
                            _enableDebugPaint
                                ? 'Hide Debug Paint'
                                : 'Show Debug Paint',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _enableDebugPaint ? Colors.red : Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Pipeline Steps Visualization
            if (_showWidgetTree) _buildWidgetTreeSection(),
            if (_showElementTree) _buildElementTreeSection(),
            if (_showRenderTree) _buildRenderTreeSection(),

            SizedBox(height: 20),

            // Interactive Demo Section
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Interactive Rendering Demo',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Animated Container Demo
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Container(
                          width: 100 + (_animation.value * 150),
                          height: 100 + (_animation.value * 50),
                          decoration: BoxDecoration(
                            color: Color.lerp(
                              Colors.blue,
                              Colors.purple,
                              _animation.value,
                            ),
                            borderRadius: BorderRadius.circular(
                              12 + (_animation.value * 20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4 + (_animation.value * 8),
                                offset: Offset(0, 2 + (_animation.value * 4)),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Render\nObject',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14 + (_animation.value * 4),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 16),

                    ElevatedButton.icon(
                      onPressed: _startAnimation,
                      icon: Icon(Icons.play_arrow),
                      label: Text('Trigger Re-render'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    Text(
                      'Watch how the render object updates when state changes!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Performance Insights
            _buildPerformanceSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetTreeSection() {
    return Card(
      elevation: 2,
      color: Colors.green[50],
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_tree, color: Colors.green[700]),
                SizedBox(width: 8),
                Text(
                  'Widget Tree',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              '• Immutable configuration objects\n'
              '• Describes UI structure and appearance\n'
              '• Lightweight and rebuilt frequently\n'
              '• Examples: Container, Text, Column, Row',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Widget → build() method → Returns new Widget',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.green[800],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElementTreeSection() {
    return Card(
      elevation: 2,
      color: Colors.orange[50],
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.hub, color: Colors.orange[700]),
                SizedBox(width: 8),
                Text(
                  'Element Tree',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              '• Mutable objects that manage Widget lifecycle\n'
              '• Holds references to Widgets and RenderObjects\n'
              '• Implements the actual widget-render bridge\n'
              '• Handles state management and updates',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Element.mount() → Element.update() → Element.unmount()',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.orange[800],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRenderTreeSection() {
    return Card(
      elevation: 2,
      color: Colors.red[50],
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.brush, color: Colors.red[700]),
                SizedBox(width: 8),
                Text(
                  'Render Tree',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              '• Handles layout, painting, and hit testing\n'
              '• Performs the actual rendering to screen\n'
              '• Calculates sizes and positions\n'
              '• Examples: RenderBox, RenderFlex, RenderParagraph',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Layout Phase → Paint Phase → Composite Phase',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.red[800],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceSection() {
    return Card(
      elevation: 4,
      color: Colors.purple[50],
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.speed, color: Colors.purple[700]),
                SizedBox(width: 8),
                Text(
                  'Performance Insights',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Optimization Tips:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              '• Use const constructors for immutable widgets\n'
              '• Minimize widget rebuilds with keys and state management\n'
              '• Prefer RepaintBoundary for expensive paint operations\n'
              '• Use ListView.builder() for large lists\n'
              '• Profile with Flutter Inspector and Performance tools',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
