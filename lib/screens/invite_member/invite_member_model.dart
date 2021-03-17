import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:projecthit/class/flavor.dart';
import 'package:projecthit/entity/project.dart';

class InviteMemberModel extends ChangeNotifier {
  Flavor _flavor;
  Uri url;

  InviteMemberModel() {
    const flavorString = String.fromEnvironment('Flavor');
    _flavor = Flavor.fromString(flavorString);
  }

  Future<void> createDynamicLink(Project project) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final afterTwoWeeks = DateTime.now().add(Duration(days: 14));
    final timestamp = Timestamp.fromDate(afterTwoWeeks).seconds;

    final parameters = DynamicLinkParameters(
      uriPrefix: _uriPrefix,
      link: Uri.parse(
        '$_uriPrefix/join?id=${project.id}&expired=$timestamp',
      ),
      androidParameters: AndroidParameters(
        packageName: packageInfo.packageName,
        minimumVersion: 0,
      ),
      iosParameters: IosParameters(
        bundleId: packageInfo.packageName,
        minimumVersion: '0',
        appStoreId: '1558795186',
      ),
    );

    final ShortDynamicLink shortLink = await parameters.buildShortLink();
    url = shortLink.shortUrl;
    notifyListeners();
  }

  String get _uriPrefix {
    switch (_flavor.now) {
      case Flavor.development:
        return 'https://projecthitdev.page.link';
      case Flavor.staging:
        return 'https://projecthitstg.page.link';
      case Flavor.production:
        return 'https://projecthit01.page.link';
    }
    throw ('Invalid flavor: $_flavor');
  }
}
