import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:vibration/vibration.dart';

class JapaProvider extends ChangeNotifier {
  int _count = 0;
  int _target = 108;
  bool _isFocusMode = false;
  String _currentMantra = "Hare Krishna Hare Rama";

  int get count => _count;
  int get target => _target;
  bool get isFocusMode => _isFocusMode;
  String get currentMantra => _currentMantra;

  void incrementCount() async {
    _count++;
    
    // Haptic feedback
    if (await Vibration.hasVibrator() ?? false) {
      if (_count % _target == 0) {
        Vibration.vibrate(duration: 500); // Longer vibration on completing a mala
      } else {
        Vibration.vibrate(duration: 50); // Short tap
      }
    }
    
    notifyListeners();
  }

  void resetCount() {
    _count = 0;
    notifyListeners();
  }

  void toggleFocusMode() {
    _isFocusMode = !_isFocusMode;
    notifyListeners();
  }

  void setTarget(int newTarget) {
    _target = newTarget;
    notifyListeners();
  }
}

class JapaScreen extends StatefulWidget {
  const JapaScreen({super.key});

  @override
  State<JapaScreen> createState() => _JapaScreenState();
}

class _JapaScreenState extends State<JapaScreen> {
  @override
  void initState() {
    super.initState();
    // Keep screen awake during Japa
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    // Disable wake lock when leaving the screen
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JapaProvider(),
      child: const _JapaView(),
    );
  }
}

class _JapaView extends StatelessWidget {
  const _JapaView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JapaProvider>();

    return Scaffold(
      appBar: provider.isFocusMode
          ? null
          : AppBar(
              title: const Text('Japa Counter'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => _showResetDialog(context, provider),
                ),
                IconButton(
                  icon: const Icon(Icons.center_focus_strong),
                  onPressed: provider.toggleFocusMode,
                  tooltip: 'Focus Mode',
                ),
              ],
            ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: provider.incrementCount,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            // Placeholder for Deity Integration
            color: Theme.of(context).colorScheme.surface,
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!provider.isFocusMode) ...[
                  Text(
                    provider.currentMantra,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                ],
                Text(
                  '${provider.count}',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 120,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                if (!provider.isFocusMode) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Target: ${provider.target}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Malas: ${provider.count ~/ provider.target}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
                if (provider.isFocusMode) ...[
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IconButton(
                      icon: const Icon(Icons.fullscreen_exit),
                      onPressed: provider.toggleFocusMode,
                      color: Colors.grey,
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context, JapaProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Counter?'),
        content: const Text('Are you sure you want to reset your current count?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.resetCount();
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
