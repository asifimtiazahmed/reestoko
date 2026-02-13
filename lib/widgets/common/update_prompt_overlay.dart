import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePromptOverlay extends StatelessWidget {
  final VoidCallback? onIgnore;
  final bool forceUpdate;

  const UpdatePromptOverlay({
    super.key,
    this.onIgnore,
    this.forceUpdate = false,
  });

  Future<void> _launchStore() async {
    // Replace with actual store URLs
    final Uri url = Uri.parse('https://play.google.com/store/apps/details?id=com.baseproject'); 
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.system_update, size: 48, color: Colors.teal),
                const SizedBox(height: 16),
                Text(
                  'Update Avaliable',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'A new version of the app is available. Please update for the best experience.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _launchStore,
                  child: const Text('Update Now'),
                ),
                if (!forceUpdate) ...[
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: onIgnore,
                    child: const Text('Later'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
