import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:mycompass/pages/settings.dart';
import 'package:mycompass/widgets/compass.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  static String get path => '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int mode = 0;
  bool _hasPermissions = false;

  void _fetchPermissionStatus() {
    Permission.locationWhenInUse.status.then((status) {
      if (mounted) {
        setState(() => _hasPermissions = status == PermissionStatus.granted);
      }
    });
  }

  Widget _buildPermissionSheet() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Enable Location',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
                'Please provide us access to your location, which is required for show you the compass',
                textAlign: TextAlign.justify),
            const SizedBox(height: 40),
            ElevatedButton(
              child: const Text('Request Permissions'),
              onPressed: () {
                Permission.locationWhenInUse.request().then((ignored) {
                  _fetchPermissionStatus();
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Open App Settings'),
              onPressed: () {
                openAppSettings().then((opened) {
                  //
                });
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        double? direction = snapshot.data!.heading;
        if (direction == null) {
          return const Center(
            child: Text("Device does not have sensors !"),
          );
        }

        return Align(
          alignment: const Alignment(0, -0.2),
          child: CompassView(
            bearing: 0,
            heading: direction,
            foregroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _fetchPermissionStatus();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          actions: [
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            )
          ],
        ),
        body: Builder(builder: (context) {
          if (_hasPermissions) {
            return Column(
              children: <Widget>[Expanded(child: _buildCompass())],
            );
          } else {
            return _buildPermissionSheet();
          }
        }));
  }
}
