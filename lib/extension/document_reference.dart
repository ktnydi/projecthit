import 'package:cloud_firestore/cloud_firestore.dart';

extension ExDocumentReference on DocumentReference {
  Future<DocumentSnapshot> getCacheThenServer() async {
    try {
      return await this.get(
        GetOptions(source: Source.cache),
      );
    } catch (e) {
      return await this.get(
        GetOptions(source: Source.server),
      );
    }
  }
}
