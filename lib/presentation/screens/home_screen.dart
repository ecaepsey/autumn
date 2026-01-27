import 'package:flutter/material.dart';

class FocusDashboardScreen extends StatefulWidget {
  const FocusDashboardScreen({super.key});

  @override
  State<FocusDashboardScreen> createState() => _FocusDashboardScreenState();
}

class _FocusDashboardScreenState extends State<FocusDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final gap = 16.0;
    int _selectedIndex = 0;


    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Left: Timer (big)
             
              Expanded(
                flex: 2,
                child: _CardView(
                  title: 'Timer',
                
                  child: Column(children: [
                    
                        
LayoutBuilder(
  builder: (context, constraints) {
    final w = constraints.maxWidth / 2 - 40;

    return ToggleButtons(
        borderRadius: BorderRadius.circular(15),
      isSelected: [_selectedIndex == 0, _selectedIndex == 1],
      onPressed: (i) => setState(() => _selectedIndex = i),
       borderColor: Colors.transparent,
  selectedBorderColor: Colors.transparent,
  disabledBorderColor: Colors.transparent,

  constraints: const BoxConstraints(minHeight: 48),
      children: [
        SizedBox(width: w, height: 48, child: const _ToggleItem(icon: Icons.timer, label: 'Ongoing')),
        SizedBox(width: w, height: 48, child: const _ToggleItem(icon: Icons.coffee, label: 'Break')),
      ],
    );
  },
)

      
                  
                    //  Center(
                      
                    //   child: Stack(
                    //     alignment: Alignment.center,
                    //     children: const [
                         
                         
                    //       StaticCircle(size: 280, strokeWidth: 4),
                    //       Text(
                    //         '25:00',
                    //         style: TextStyle(fontSize: 56, fontWeight: FontWeight.w700),
                    //       ),
                    //     ],
                    //   ),
                    //                     ),
                    

                  ],)
                ),
              ),

              SizedBox(width: gap),

              // Right: Tasks + Stats stacked
              // Expanded(
              //   flex: 1,
              //   child: Column(
              //     children: [
              //       Expanded(
              //         flex: 2,
              //         child: _CardView(
              //           title: 'Tasks',
              //           child: ListView(
              //             children: const [
              //               ListTile(title: Text('Write Flutter UI')),
              //               ListTile(title: Text('Add timer logic')),
              //               ListTile(title: Text('Create tasks page')),
              //             ],
              //           ),
              //         ),
              //       ),
              //       SizedBox(height: gap),
              //       Expanded(
              //         flex: 1,
              //         child: _CardView(
              //           title: 'Stats',
              //           child: const Center(
              //             child: Text('0 sessions\n0 min',
              //                 textAlign: TextAlign.center,
              //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardView extends StatelessWidget {
  final String title;
  final Widget child;

  const _CardView({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          
          
          child
        ],
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ToggleItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48, // ✅ real height
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}

/// Static circle (no progress)
class StaticCircle extends StatelessWidget {
  final double size;
  final double strokeWidth;

  const StaticCircle({
    super.key,
    this.size = 280,
    this.strokeWidth = 4,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CirclePainter(
          strokeWidth: strokeWidth,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double strokeWidth;
  final Color color;

  _CirclePainter({required this.strokeWidth, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - strokeWidth / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
