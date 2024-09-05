import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gardener/models/plant_data.dart';

class FirestoreService {
  final CollectionReference _plantsCollection =
      FirebaseFirestore.instance.collection('plants');

  Stream<List<PlantData>> getPlants() {
    return _plantsCollection
        .orderBy(FieldPath.documentId)
        .snapshots()
        .map((snapshot) {
      List<PlantData> plants = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        PlantData plantData = PlantData.fromJson(data);
        // print("PLANT DATA: $plantData");
        return plantData;
      }).toList();
      return plants;
    });
  }
}
