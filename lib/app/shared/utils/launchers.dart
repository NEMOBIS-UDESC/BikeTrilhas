import 'package:url_launcher/url_launcher.dart';

void launchURL(String url) async {
  canLaunchUrl(Uri.parse(url)).then((canLaunch) {
    if (canLaunch) {
      var encoded = Uri.encodeFull(url);
      Uri uri = Uri.parse(encoded);
      launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  });
}
