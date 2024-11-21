import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth kütüphanesini ekliyoruz
import 'auth_page.dart'; // AuthPage sayfasını ekliyoruz
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Bildirim paketi
import 'package:intl/intl.dart'; // Tarih formatlama için
import 'generated/l10n.dart'; // Intl tarafından oluşturulan S sınıfı
import 'main.dart';

class TaskManagementScreen extends StatefulWidget {
  final Locale locale; // Dil bilgisi
  TaskManagementScreen({required this.locale});

  @override
  _TaskManagementScreenState createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  final TextEditingController _taskController = TextEditingController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final CollectionReference _tasks;
  String _filterOption = 'All';
  late String _selectedPriority; // Varsayılan değeri dinamik yapıyoruz.
  DateTime? _selectedDate;
  Locale _locale = const Locale('en');
  bool _isFirstBuild =
      true; // Lokalizasyonun sadece ilk sefer ayarlanmasını kontrol etmek için.

  @override
  void initState() {
    super.initState();
    _initializeNotifications();

    // Kullanıcının UID'sine göre koleksiyonu alıyoruz
    final String uid = _auth.currentUser!.uid;
    _tasks = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks');
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Eğer _filterOption geçerli dilin öğelerine uygun değilse, varsayılan değeri güncelle.
    if (_filterOption != S.of(context).all &&
        _filterOption != S.of(context).completed &&
        _filterOption != S.of(context).incomplete &&
        _filterOption != S.of(context).byDueDate &&
        _filterOption != S.of(context).byPriority) {
      setState(() {
        _filterOption = S.of(context).all; // Dil değiştiğinde varsayılan değer
      });
    }

    if (_isFirstBuild) {
      // İlk sefer çalıştırılır
      _locale = widget.locale;
      _selectedPriority = S.of(context).medium; // Dinamik başlangıç değeri
      _filterOption = S.of(context).all; // Varsayılan değer
      _isFirstBuild = false; // Sonraki çağrılarda çalıştırılmaz
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dil değişikliğini kontrol ederek `_selectedPriority`'yi güncelleriz.
    if (_selectedPriority != S.of(context).low &&
        _selectedPriority != S.of(context).medium &&
        _selectedPriority != S.of(context).high) {
      setState(() {
        _selectedPriority = S.of(context).medium; // Varsayılan değer
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).appTitle),
        actions: [
          DropdownButton<Locale>(
            value: _locale,
            items: S.delegate.supportedLocales.map((locale) {
              final flag = _getFlag(locale.languageCode);
              return DropdownMenuItem(
                value: locale,
                child: Center(
                  child: Text(
                    flag,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              );
            }).toList(),
            onChanged: (locale) {
              setState(() {
                _locale = locale!;
                MyApp.setLocale(context, _locale);
                _filterOption =
                    S.of(context).all; // Dil değiştiğinde varsayılan değer
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOutUser,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Kullanıcıdan yeni görev alıyoruz
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: S.of(context).enterTask,
              ),
            ),
            const SizedBox(height: 10),
            // Öncelik seçmek için dropdown
            Row(
              children: [
                Text(S.of(context).priorityLabel),
                DropdownButton<String>(
                  value: _selectedPriority,
                  items: [
                    S.of(context).low,
                    S.of(context).medium,
                    S.of(context).high
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPriority = newValue!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Hatırlatma zamanı seçmek için buton
            Row(
              children: [
                Expanded(
                  child: Text(_selectedDate == null
                      ? S.of(context).noReminderDate
                      : '${S.of(context).reminderDate}: ${DateFormat.yMd().add_Hm().format(_selectedDate!)}'),
                ),
                TextButton(
                  onPressed: _pickDateTime,
                  child: Text(S.of(context).chooseDate),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Yeni görev eklemek için buton
            ElevatedButton(
              onPressed: _addTask,
              child: Text(S.of(context).addTask),
            ),
            const SizedBox(height: 20),
            // Görevlerin filtrelenmesi için DropdownButton
            DropdownButton<String>(
              value: _filterOption,
              items: [
                S.of(context).all,
                S.of(context).completed,
                S.of(context).incomplete,
                S.of(context).byDueDate,
                S.of(context).byPriority,
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _filterOption = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),
            // Eklenen görevleri listeleyen bölüm
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _tasks.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Veri beklenirken bir yükleme göstergesi gösteriyoruz
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Hata durumunda kullanıcıya mesaj gösteriyoruz
                    return Center(
                        child:
                            Text('${S.of(context).error}: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    // Eğer hiçbir görev yoksa bilgilendirme yapıyoruz
                    return Center(child: Text(S.of(context).noTasksAvailable));
                  } else {
                    // Görevleri liste olarak gösteriyoruz
                    List<QueryDocumentSnapshot> filteredDocs =
                        snapshot.data!.docs;
                    return ListView(
                      children: filteredDocs.map((doc) {
                        var data = doc.data() as Map<String, dynamic>;
                        bool isCompleted = data['isCompleted'] ?? false;
                        DateTime? reminderDate =
                            data.containsKey('reminderDate')
                                ? (data['reminderDate'] as Timestamp).toDate()
                                : null;

                        return ListTile(
                          title: Text(
                            data['task'],
                            style: TextStyle(
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text(
                            '${S.of(context).priorityLabel}: ${data['priority'] ?? S.of(context).medium}'
                            '${reminderDate != null ? ' | ${S.of(context).reminderDate}: ${DateFormat.yMd().add_Hm().format(reminderDate)}' : ''}',
                          ),
                          leading: Checkbox(
                            value: isCompleted,
                            onChanged: (bool? value) {
                              _tasks.doc(doc.id).update({'isCompleted': value});
                            },
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteTask(doc.id),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFlag(String code) {
    switch (code) {
      case 'fi':
        return '🇫🇮';
      case 'en':
      default:
        return '🇺🇸';
    }
  }

  void _signOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AuthPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${S.of(context).error}: ${e.toString()}")),
      );
    }
  }

  // Yeni görev ekleme fonksiyonu
  void _addTask() {
    if (_taskController.text.trim().isNotEmpty) {
      final String taskText = _taskController.text.trim();
      final newTask = {
        'task': taskText,
        'isCompleted': false,
        'priority': _selectedPriority,
        if (_selectedDate != null) 'reminderDate': _selectedDate
      };
      _tasks.add(newTask);
      _taskController.clear();
      if (_selectedDate != null) {
        _scheduleNotification(taskText, _selectedDate!);
      }
      _selectedDate = null;
    }
  }

  // Öncelik seviyesini numaraya çeviren fonksiyon
  int _getPriorityLevel(String priority) {
    switch (priority) {
      case 'High':
        return 3;
      case 'Medium':
        return 2;
      case 'Low':
        return 1;
      default:
        return 2;
    }
  }

  // Hatırlatma zamanı seçmek için tarih ve saat seçici
  Future<void> _pickDateTime() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (date != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          _selectedDate =
              DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }

  // Bildirim zamanlama fonksiyonu
  Future<void> _scheduleNotification(
      String task, DateTime scheduledDate) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'task_reminder_channel',
      'Task Reminders',
      channelDescription: 'Channel for task reminder notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    try {
      await flutterLocalNotificationsPlugin.schedule(
        0,
        S.of(context).reminderTitle,
        task,
        scheduledDate,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
      );
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

  // Görev silme fonksiyonu
  void _deleteTask(String id) {
    _tasks.doc(id).delete(); // Belirtilen ID'ye sahip görevi siliyoruz
  }
}
