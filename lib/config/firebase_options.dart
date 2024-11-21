import 'package:firebase_core/firebase_core.dart';

const FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey:
      "AIzaSyDHYyMmUFD30itXFfSlJ3O-vIX0JffyxfY", // Firebase projesine bağlanmak için kullanılan anahtar.
  appId:
      "1:1093286089352:android:ebd64d29e7a5df366f453d", // Uygulamanın Firebase tarafındaki benzersiz kimliği.
  messagingSenderId: "1093286089352", // Messaging Sender ID'si
  projectId: "todoapp-2834f", // Proje ID'si.  Firebase projesinin adı.
  authDomain: "todoapp-2834f.firebaseapp.com", // Auth domain bilgisi
  databaseURL:
      "https://todoapp-2834f.firebaseio.com", // Firebase database URL (eğer kullanıyorsanız)
  storageBucket: "todoapp-2834f.appspot.com", // Firebase storage bucket bilgisi
  measurementId: "G-XXXXXXX", // Measurement ID
  // authDomain, databaseURL, storageBucket: Firebase servislerini kullanmak için gerekli bağlantı bilgileri.
);
