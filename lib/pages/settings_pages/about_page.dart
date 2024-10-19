import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/self_pic.jpg'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Shahryar Rahman Saad',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'A passionate software developer with a focus on mobile app development and AI projects. '
              'I enjoy solving challenging problems and building apps that make an impact!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Connect with me',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.linkedin),
                  onPressed: () {
                    try {
                      launchURL(
                          'https://www.linkedin.com/in/shahryar-rahman-saad-969119328');
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('$e')));
                    }
                  },
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.github),
                  onPressed: () {
                    try {
                      launchURL('https://github.com/srOsaad');
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('$e')));
                    }
                  },
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.envelope),
                  onPressed: () {
                    try {
                      launchMail();
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('$e')));
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  void launchMail() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'sr.saad.sr@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'App<android>Batch Spor:',
      }),
    );

    launchUrl(emailLaunchUri);
  }
}
