import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gardener/constants/enums.dart';
import 'package:gardener/models/plant_data.dart';

class FirestoreService {
  final CollectionReference _plantsCollection =
      FirebaseFirestore.instance.collection('plants');
  DocumentSnapshot? lastDoc;
  int fetchedDocuments = 15;

  Future<List<PlantData>?> getPlants(
      {bool? changedFilters,
      String? query,
      PlantType? filter,
      required SortingDirection sortingDirection}) async {
    Query firestoreQuery = _plantsCollection;
    print("Query: $query");
    if (query != null && query.trim().isNotEmpty) {
      String searchKey = query.trim();
      String endKey = searchKey.substring(0, searchKey.length - 1) +
          String.fromCharCode(searchKey.codeUnitAt(searchKey.length - 1) + 1);

      // Perform Firestore query
      firestoreQuery = firestoreQuery
          .where('name', isGreaterThanOrEqualTo: searchKey)
          .where('name', isLessThan: endKey);
    }

    if (filter != null) {
      firestoreQuery =
          firestoreQuery.where("type", isEqualTo: filter.toString());
    }
    firestoreQuery = firestoreQuery.orderBy(FieldPath.documentId,
        descending: sortingDirection == SortingDirection.descending);
    if (changedFilters == true) {
      firestoreQuery = firestoreQuery.limit(fetchedDocuments);
    } else if (lastDoc != null) {
      firestoreQuery =
          firestoreQuery.startAfterDocument(lastDoc!).limit(fetchedDocuments);
    }
    firestoreQuery = firestoreQuery.limit(fetchedDocuments);
    final querySnapshot = await firestoreQuery.get();

    return querySnapshot.docs.map((doc) {
      lastDoc = doc;
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      PlantData plantData = PlantData.fromJson(data);
      print("PLANT DATA: $plantData");

      return plantData;
    }).toList();
  }
}
