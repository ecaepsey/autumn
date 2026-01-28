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
        
        child: Container(
         
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Left: Timer (big)
               
                Expanded(
                  flex: 2,
                  child: Container(
                  decoration: const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFBFD9F6), // верх — мягкий голубой
        Color(0xFFEAF2FD), // низ — почти белый
      ],
    ),
                  ),
                    child: _CardView(
                      title: '',
                    
                      child: Column(children: [
                        
                            PillToggle(
                                selectedIndex: _selectedIndex,
                                onChanged: (i) => setState(() => _selectedIndex = i),
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


class _Segment extends StatelessWidget {
  final bool selected;
  final BorderRadius radius;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _Segment({
    required this.selected,
    required this.radius,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    
    return Container(
      decoration: BoxDecoration(
        
        
        
      ),
      child: Material(
       color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
           hoverColor: Colors.transparent,      // 🟢 remove hover
          splashColor: Colors.transparent,     // 🟢 remove ripple
          highlightColor: Colors.transparent,  // 🟢 remove press highlight
          child: Ink(
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.grey.withOpacity(0.1),
              borderRadius: radius,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 18, color: selected ? Colors.blue : Colors.grey.withOpacity(1)),
                  const SizedBox(width: 6),
                  Text(label, style: const TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class PillToggle extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const PillToggle({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
    
   
  ),
      child: SizedBox(
        height: 48,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: _Segment(
                selected: selectedIndex == 0,
                radius: const BorderRadius.only(
                   topLeft:  Radius.circular(30),
                           bottomLeft:  Radius.circular(30),
                ),
                icon: Icons.timer,
                
                label: 'Ongoing',
                onTap: () => onChanged(0),
              ),
            ),
            Expanded(
              child: _Segment(
                selected: selectedIndex == 1,
                radius: const BorderRadius.only(
                  topRight:  Radius.circular(30),
                           bottomRight:  Radius.circular(30),
                    
                ),
                icon: Icons.coffee,
                label: 'Break',
                onTap: () => onChanged(1),
              ),
            ),
          ],
        ),
        
      ),
    );
    
  }
}
