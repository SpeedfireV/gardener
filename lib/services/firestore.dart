import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gardener/models/plant_data.dart';

class FirestoreService {
  final CollectionReference _todosCollection =
      FirebaseFirestore.instance.collection('plants');

  Stream<List<PlantData>> getPlants() {
    return _todosCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        PlantData plantData = PlantData.fromJson(data);
        return plantData;
      }).toList();
    });
  }
}
