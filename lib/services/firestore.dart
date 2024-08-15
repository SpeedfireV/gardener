import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gardener/models/plant_data.dart';

class FirestoreService {
  final CollectionReference _todosCollection =
      FirebaseFirestore.instance.collection('plants');

  Stream<List<PlantData>> getPlants() {
    return _todosCollection.snapshots().map((snapshot) {
      List<PlantData> plants = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        PlantData plantData = PlantData.fromJson(data);
        print("PLANT DATA: $plantData");
        return plantData;
      }).toList();
      plants
          .sort((a, b) => a.name.codeUnitAt(0).compareTo(b.name.codeUnitAt(0)));
      return plants;
    });
  }
}
