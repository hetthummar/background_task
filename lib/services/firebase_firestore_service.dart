import 'package:background_task/model/area_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseFireStoreService {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('area');
  CollectionReference userLocationCollectionRefrence =
      FirebaseFirestore.instance.collection('userLocation');

  String docId = "selectedArea";

  Future<bool> addArea(List<Map<String, dynamic>> data) async {
    try {
      Map<String, dynamic> areaMap = {};
      areaMap['area'] = data.map((e) => e).toList();

      await collectionReference.doc(docId).set(areaMap);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Area>> getArea() async {
    try {
      DocumentSnapshot a = await collectionReference.doc("selectedArea").get();
      List<Area> selectedArea = [];
      if (a.exists) {
        Map<String, dynamic>? fetchDoc = a.data() as Map<String, dynamic>?;
        selectedArea = AreaModel.fromJson(fetchDoc!).area;
      }
      return selectedArea;
    } catch (e) {
      return [];
    }
  }
}
