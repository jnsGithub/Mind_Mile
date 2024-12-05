import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mind_mile/global.dart';

class TestUpdate{
  final db = FirebaseFirestore.instance.collection('users').doc(uid);

  Future<void> updateTest(List<int> a) async{
    List<int> b = [];
    List<int> c = [];
    for(int i = 0; i < a.length; i++){
      if(i < 9){
        b.add(a[i]);
      } else{
        c.add(a[i]);
      }
    }
    try{
      await db.update({
        'PHQ9': b,
        'GAD7': c,
      });
    } catch(e){
      print(e);
    }
  }
}