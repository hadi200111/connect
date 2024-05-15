class Appointments {
  String id;
  String subject;
  String description;
  DateTime date;
  DateTime startTime;
  int appointmentLength;
  String location;
  String? notes;
  String status;

  Appointments({
    required this.id,
    required this.subject,
    required this.description,
    required this.date,
    required this.startTime,
    required this.appointmentLength,
    required this.location,
    this.notes,
    required this.status,
  });

  void submitAppointment() {
    print("appointment submited");
  }

  @override
  String toString() {
    return 'Appointments{id: $id, subject: $subject, description: $description, date: $date, startTime: $startTime, appointmentLength: $appointmentLength, location: $location, notes: $notes, status: $status}';
  }
}
