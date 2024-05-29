import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Addappointment.dart';
import 'package:connect/AppointmentDetailsPage.dart';
import 'package:connect/Appointments.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'WelcomeLogIn/LoginPage.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarController _controller = CalendarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Book',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Addappointment()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Appointment>>(
        future: getAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Appointment> appointments = snapshot.data!;
            return SfCalendar(
              view: CalendarView.week,
              allowedViews: [
                CalendarView.day,
                CalendarView.week,
              ],
              controller: _controller,
              initialDisplayDate: DateTime.now(),
              dataSource: MeetingDataSource(appointments),
              onTap: calendarTapped,
              monthViewSettings: MonthViewSettings(
                navigationDirection: MonthNavigationDirection.vertical,
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> calendarTapped(CalendarTapDetails calendarTapDetails) async {
    if (_controller.view == CalendarView.month &&
        calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      setState(() {
        _controller.view = CalendarView.day;
      });
    } else if (_controller.view == CalendarView.week) {
      setState(() {
        _controller.view = CalendarView.day;
      });
    } else if (calendarTapDetails.targetElement ==
        CalendarElement.appointment) {
      final Appointment appointment = calendarTapDetails.appointments!.first;
      final subject = appointment.subject;
      final subject2 = appointment.id;

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Appointments').get();
      querySnapshot.docs.forEach((doc) {
        var field1 = doc.get("startTime");
        var field2 = doc.get("appointmentLength");
        var field3 = doc.get("date");
        var field4 = doc.get("subject");
        var field5 = doc.get("id");
        var field6 = doc.get("status");
        var field7 = doc.get("description");
        var field8 = doc.get("location");

        final DateTime startTime1 = (field1 as Timestamp).toDate();
        final DateTime date = (field3 as Timestamp).toDate();
        DateTime onlyDate = DateTime(date.year, date.month, date.day);
        //final DateTime endTime1 = startTime1.add(Duration(hours: field2));
        //final DateTime mergedDateTime = mergeDateTime(date, startTime1);
        //final DateTime mergedDateTime1 = mergeDateTime(date, endTime1);

        if ((field5 == subject2 && field4 == subject)) {
          Globals.app = Appointments(
              id: field5,
              subject: field4,
              description: field7,
              date: onlyDate,
              startTime: startTime1,
              appointmentLength: field2,
              location: field8,
              status: field6);
        }
      });
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AppointmentDetailsPage(appointment: Globals.app),
          ),
        );
      });
    }
  }

  Future<List<Appointment>> getAppointments() async {
    List<Appointment> meetings = <Appointment>[];
    bool check = false;

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Appointments').get();
    querySnapshot.docs.forEach((doc) {
      var field1 = doc.get("startTime");
      var field2 = doc.get("appointmentLength");
      var field3 = doc.get("date");
      var field4 = doc.get("subject");
      var field5 = doc.get("id");
      var field6 = doc.get("status");

      final DateTime startTime1 = (field1 as Timestamp).toDate();
      final DateTime date = (field3 as Timestamp).toDate();
      final DateTime endTime1 = startTime1.add(Duration(hours: field2));
      final DateTime mergedDateTime = mergeDateTime(date, startTime1);
      final DateTime mergedDateTime1 = mergeDateTime(date, endTime1);

      Color appointmentColor = Colors.blue;

      if (field5 == Globals.userID) {
        appointmentColor = Colors.red;
      }

      for (int i = 0; i < Globals.Schedule.length; i++) {
        if (Globals.Schedule[i] == "Public" ||
            Globals.Schedule[i] == "Private") {
        } else if (field6 == Globals.Schedule[i]) {
          check = true;
        }
      }
      if ((field5 == Globals.userID && field6 == "Private") ||
          field6 == "Public" ||
          check) {
        print(field6 + " " + field5 + check.toString());
        check = false;
        meetings.add(Appointment(
          startTime: mergedDateTime,
          endTime: mergedDateTime1,
          subject: field4,
          id: field5,
          color: appointmentColor,
        ));
      }
    });
    return meetings;
  }
}

DateTime mergeDateTime(DateTime date, DateTime time) {
  return DateTime(
      date.year, date.month, date.day, time.hour, time.minute, time.second);
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
