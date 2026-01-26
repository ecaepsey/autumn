import 'package:autumn/presentation/screens/focus_timer_screen.dart';
import 'package:flutter/material.dart';





class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int index = 0;

  final pages = const [
    FocusTimerScreen()
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: index,
            onDestinationSelected: (i) => setState(() => index = i),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.timer),
                label: Text('Timer'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.checklist),
                label: Text('Tasks'),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: pages[index]),
        ],
      ),
    );
  }
}


