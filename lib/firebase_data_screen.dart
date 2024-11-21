import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Firestore'dan 'testData2' koleksiyonunu almak
    CollectionReference users =
        FirebaseFirestore.instance.collection('testData2');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Veri Okuma'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        // Belirli bir dokümanı alıyoruz, burada 'hUCkjxE3W56JnJpZg8tn' ID'si kullanılıyor
        future: users.doc('hUCkjxE3W56JnJpZg8tn').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Veri beklenirken bir yükleme göstergesi gösteriyoruz
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Hata durumunda hata mesajını gösteriyoruz
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          } else if (snapshot.hasData && !snapshot.data!.exists) {
            // Veri bulunamıyorsa kullanıcıya bilgilendirme yapıyoruz
            return const Center(child: Text('Doküman bulunamadı'));
          } else {
            // Veri başarıyla alındıysa, veriyi ekranda gösteriyoruz
            var data = snapshot.data!.data() as Map<String, dynamic>;
            return Center(
              child: Text(
                  'Veri: ${data['Name2']}'), // 'Name2' alanındaki veriyi ekranda gösteriyoruz
            );
          }
        },
      ),
    );
  }
}
