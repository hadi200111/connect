import 'package:connect/Appointments.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentDetailsPage extends StatelessWidget {
  final Appointments appointment;

  const AppointmentDetailsPage({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Author:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(appointment.id),
            const SizedBox(height: 10),
            const Text(
              'Subject:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(appointment.subject),
            const SizedBox(height: 10),
            const Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(appointment.description),
            const SizedBox(height: 10),
            const Text(
              'Date:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(DateFormat('dd-MM-yyyy').format(appointment.date)),
            const SizedBox(height: 10),
            const Text(
              'Start Time:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(DateFormat('hh:MM').format(appointment.startTime)),
            const SizedBox(height: 10),
            const Text(
              'Appointment Length:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('${appointment.appointmentLength} hours'),
            const SizedBox(height: 10),
            const Text(
              'Location:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(appointment.location),
            const SizedBox(height: 10),
            if (appointment.notes != null) ...[
              const Text(
                'Notes:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(appointment.notes!),
              const SizedBox(height: 10),
            ],
            const Text(
              'Status:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(appointment.status ? 'Public' : 'Private'),
          ],
        ),
      ),
    );
  }
}
