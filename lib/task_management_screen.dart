import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'generated/l10n.dart';
import 'main.dart';

class TaskManagementScreen extends StatefulWidget {
  final Locale locale;
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
  late String _selectedPriority;
  DateTime? _selectedDate;
  Locale _locale = const Locale('en');
  bool _isFirstBuild = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      final String uid = currentUser.uid;
      // Kullanıcının görevler koleksiyonuna ait Firestore referansını başlatıyoruz
      _tasks = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks');
    } else {
      // Eğer kullanıcı mevcut değilse, oturum açma sayfasına yönlendirilir
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AuthPage()),
        );
      });
    }
  }

  // Görev hatırlatmaları için yerel bildirimleri başlatma fonksiyonu
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

    // Lokalizasyon değişikliklerine bağlı olarak filtre seçeneklerini güncelleme
    if (_filterOption != S.of(context).all &&
        _filterOption != S.of(context).completed &&
        _filterOption != S.of(context).incomplete &&
        _filterOption != S.of(context).byDueDate &&
        _filterOption != S.of(context).byPriority) {
      setState(() {
        _filterOption = S.of(context).all;
      });
    }

    // İlk yapılandırmada yerel ayarları ve varsayılan değerleri ayarlama
    if (_isFirstBuild) {
      _locale = widget.locale;
      _selectedPriority = S.of(context).medium;
      _filterOption = S.of(context).all;
      _isFirstBuild = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lokalizasyon değişikliklerine bağlı olarak seçili önceliğin geçerli olmasını sağlama
    if (_selectedPriority != S.of(context).low &&
        _selectedPriority != S.of(context).medium &&
        _selectedPriority != S.of(context).high) {
      setState(() {
        _selectedPriority = S.of(context).medium;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).appTitle,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: <Color>[Color(0xFF42A5F5), Color(0xFF7E57C2)],
              ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
          ),
        ),
        actions: [_buildLanguageDropdown(), _buildLogoutButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTaskInputField(),
            const SizedBox(height: 10),
            _buildPriorityDropdown(),
            const SizedBox(height: 10),
            _buildReminderSelector(),
            const SizedBox(height: 10),
            _buildAddTaskButton(),
            const SizedBox(height: 20),
            _buildFilterDropdown(),
            const SizedBox(height: 20),
            _buildTaskList(),
          ],
        ),
      ),
    );
  }

  // Dili seçmek için dropdown widget'ı
  Widget _buildLanguageDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<Locale>(
        value: _locale,
        items: S.delegate.supportedLocales.map((locale) {
          return DropdownMenuItem(
            value: locale,
            child: Row(
              children: [
                // Her yerel ayar için uygun bayrağı gösterme
                Flag.fromString(
                  locale.languageCode == 'en' ? 'US' : 'FI',
                  height: 20,
                  width: 30,
                ),
                const SizedBox(width: 10),
                // Yerel ayar kodunu gösterme
                Text(
                  locale.languageCode.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }).toList(),
        dropdownColor: Colors.white,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        onChanged: (locale) {
          setState(() {
            _locale = locale!;
            // Uygulamanın yerel ayarını küresel olarak güncelle
            MyApp.setLocale(context, _locale);
          });
        },
      ),
    );
  }

  // Kullanıcıyı çıkış yapması için buton widget'ı
  Widget _buildLogoutButton() {
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: _signOutUser,
    );
  }

  // Görev giriş alanı için widget
  Widget _buildTaskInputField() {
    return TextField(
      controller: _taskController,
      decoration: InputDecoration(
        labelText: S.of(context).enterTask,
        errorText: _errorMessage,
      ),
    );
  }

  // Görev önceliği seçimi için dropdown widget'ı
  Widget _buildPriorityDropdown() {
    return Row(
      children: [
        Text(S.of(context).priorityLabel),
        const SizedBox(width: 50),
        DropdownButton<String>(
          value: _selectedPriority,
          items: [S.of(context).low, S.of(context).medium, S.of(context).high]
              .map((String value) {
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
    );
  }

  // Hatırlatma tarihi ve saatini seçmek için widget
  Widget _buildReminderSelector() {
    return Row(
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
    );
  }

  // Yeni bir görev eklemek için buton widget'ı
  Widget _buildAddTaskButton() {
    return ElevatedButton(
      onPressed: _addTask,
      child: Text(S.of(context).addTask),
    );
  }

  // Görev listesini filtrelemek için dropdown widget'ı
  Widget _buildFilterDropdown() {
    return DropdownButton<String>(
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
    );
  }

  // Görev listesini görüntülemek için widget
  Widget _buildTaskList() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: _tasks.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Veri getirilirken yükleme göstergesi
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Hata durumunda hata mesajı gösterme
            return Center(
                child: Text('${S.of(context).error}: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // Eğer görev yoksa kullanıcıya bilgi mesajı gösterme
            return Center(child: Text(S.of(context).noTasksAvailable));
          } else {
            // Görev listesini oluşturma
            List<QueryDocumentSnapshot> filteredDocs = snapshot.data!.docs;
            return ListView(
              children: filteredDocs.map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                bool isCompleted = data['isCompleted'] ?? false;
                DateTime? reminderDate = data.containsKey('reminderDate')
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
                      // Görevin tamamlanma durumunu güncelleme
                      _tasks.doc(doc.id).update({'isCompleted': value});
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editTask(doc),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _confirmDelete(doc.id),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  // Kullanıcıyı çıkış yaptırma fonksiyonu
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

  // Yeni bir görev ekleme fonksiyonu
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

  // Hatırlatma tarihi ve saati seçme fonksiyonu
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
          // Seçilen tarih ve saati birleştiriyoruz
          _selectedDate =
              DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }

  // Görev hatırlatması için yerel bildirim planlama fonksiyonu
  Future<void> _scheduleNotification(
      String task, DateTime scheduledDate) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'task_reminder_channel',
      'Task Reminders',
      channelDescription: 'Görev hatırlatma bildirimleri için kanal',
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
      print("Bildirim planlama hatası: $e");
    }
  }

  // Görev silme fonksiyonu
  void _deleteTask(String id) {
    _tasks.doc(id).delete();
  }

  // Görevin silinmesi için onay alma fonksiyonu
  void _confirmDelete(String taskId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).deleteTask),
          content: Text(S.of(context).deleteTaskConfirmation),
          actions: [
            TextButton(
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(S.of(context).delete),
              onPressed: () {
                _deleteTask(taskId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Görevi düzenlemek için fonksiyon
  void _editTask(QueryDocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    _taskController.text = data['task'];
    _selectedPriority = data['priority'] ?? S.of(context).medium;
    _selectedDate = data.containsKey('reminderDate')
        ? (data['reminderDate'] as Timestamp).toDate()
        : null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).editTask),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTaskInputField(),
              const SizedBox(height: 10),
              _buildPriorityDropdown(),
              const SizedBox(height: 10),
              _buildReminderSelector(),
            ],
          ),
          actions: [
            TextButton(
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(S.of(context).save),
              onPressed: () {
                _tasks.doc(doc.id).update({
                  'task': _taskController.text.trim(),
                  'priority': _selectedPriority,
                  if (_selectedDate != null) 'reminderDate': _selectedDate,
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
