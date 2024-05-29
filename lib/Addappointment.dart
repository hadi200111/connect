import 'package:connect/Appointments.dart';
import 'package:connect/CalendarPage.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';

import 'WelcomeLogIn/LoginPage.dart';

class Addappointment extends StatefulWidget {
  const Addappointment({Key? key}) : super(key: key);

  @override
  _AppointmentsInputFormState createState() => _AppointmentsInputFormState();
}

class _AppointmentsInputFormState extends State<Addappointment> {
  late TextEditingController subjectController;
  late TextEditingController descriptionController;
  late TextEditingController startTimeController;
  late TextEditingController appointmentLengthController;
  late TextEditingController locationController;
  late TextEditingController notesController;
  late TextEditingController statusController;

  @override
  void initState() {
    super.initState();
    subjectController = TextEditingController();
    descriptionController = TextEditingController();
    startTimeController = TextEditingController();
    appointmentLengthController = TextEditingController();
    locationController = TextEditingController();
    notesController = TextEditingController();
    statusController = TextEditingController();
  }

  @override
  void dispose() {
    subjectController.dispose();
    descriptionController.dispose();
    startTimeController.dispose();
    appointmentLengthController.dispose();
    locationController.dispose();
    notesController.dispose();
    statusController.dispose();
    super.dispose();
  }

  String _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    print("HEYS");
    return "";
  }

  DateTime dateTime = DateTime.now();
  DateTime selectedDate = DateTime.now();
  String dropdownValue = 'Private';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Appointments'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 300,
                            child: SfDateRangePicker(
                              onSelectionChanged:
                                  (DateRangePickerSelectionChangedArgs args) {
                                setState(() {
                                  selectedDate = args.value;
                                  print("AA");
                                });
                              },
                              selectionMode:
                                  DateRangePickerSelectionMode.single,
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.calendar_today),
                    tooltip: 'Select Date',
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 300,
                            child: TimePickerSpinner(
                              locale: const Locale('en', ''),
                              time: dateTime,
                              is24HourMode: false,
                              isShowSeconds: false,
                              itemHeight: 80,
                              normalTextStyle: const TextStyle(
                                fontSize: 24,
                              ),
                              highlightedTextStyle: const TextStyle(
                                fontSize: 24,
                                color: Colors.blue,
                              ),
                              isForce2Digits: true,
                              onTimeChange: (time) {
                                setState(() {
                                  dateTime = time;
                                  print("that");
                                  print(dateTime);
                                });
                              },
                            ),
                          );
                        },
                      ).then((_) {
                        setState(() {
                          dateTime = DateTime(
                            dateTime.year,
                            dateTime.month,
                            dateTime.day,
                            dateTime.hour,
                            dateTime.minute,
                          );
                          print(dateTime.hour.toString() + "HAHA");
                          print("this");
                          print(dateTime);
                        });
                      });
                    },
                    icon: const Icon(Icons.access_time),
                    tooltip: 'Select Time',
                  ),
                  if (Globals.roll == "Doctor")
                    DropdownButton<String>(
                      value: dropdownValue,
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: Globals.Schedule.map<DropdownMenuItem<String>>(
                          (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              Icon(value == 'Private'
                                  ? Icons.lock
                                  : Icons.public),
                              const SizedBox(width: 8),
                              Text(value),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
              TextFormField(
                controller: subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
              ),
              TextField(
                controller: descriptionController,
                decoration:
                    new InputDecoration.collapsed(hintText: 'Description'),
                minLines: 10,
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              TextFormField(
                controller: appointmentLengthController,
                decoration: InputDecoration(labelText: 'Appointment Length'),
              ),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              TextFormField(
                controller: notesController,
                decoration: InputDecoration(labelText: 'Notes'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await writeAppointment(_submitForm());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CalendarPage()),
                  );
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Appointments _submitForm() {
    String myid = Globals.userID;
    final appointments = Appointments(
      id: myid,
      subject: subjectController.text,
      description: descriptionController.text,
      date: selectedDate,
      startTime: dateTime,
      appointmentLength: int.parse(appointmentLengthController.text),
      location: locationController.text,
      notes: notesController.text.isNotEmpty ? notesController.text : null,
      status: dropdownValue,
    );

    print(appointments);
    return appointments;
  }

  Future<void> writeAppointment(Appointments appointment) async {
    try {
      CollectionReference appointmentsCollection =
          FirebaseFirestore.instance.collection('Appointments');

      await appointmentsCollection.add({
        'id': appointment.id,
        'subject': appointment.subject,
        'description': appointment.description,
        'date': appointment.date,
        'startTime': appointment.startTime,
        'appointmentLength': appointment.appointmentLength,
        'location': appointment.location,
        'notes': appointment.notes,
        'status': appointment.status,
      });

      print('Appointment added successfully.');
    } catch (error) {
      print('Error adding appointment: $error');
    }
  }
}
