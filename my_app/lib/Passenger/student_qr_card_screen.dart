import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../services/student_service.dart';

class StudentQrCardScreen extends StatelessWidget {
  final Student student;
  const StudentQrCardScreen({super.key, required this.student});

  Future<void> _shareQrPdf(BuildContext context) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context ctx) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text("SafeRide Scan Code", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text("Student: ${student.fullName}", style: const pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 30),
                pw.Container(
                  padding: const pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(border: pw.Border.all(width: 2)),
                  child: pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: student.id,
                    width: 250,
                    height: 250,
                  ),
                ),
                pw.SizedBox(height: 30),
                pw.Text("School: ${student.schoolName}", style: const pw.TextStyle(fontSize: 16)),
              ],
            ),
          );
        },
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'student-${student.fullName.replaceAll(' ', '-')}-qrcode.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F4F8),
      appBar: AppBar(
        title: const Text('Student QR Code', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))]
                ),
                child: Column(
                  children: [
                    Text(student.fullName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF00C2E0))),
                    const SizedBox(height: 5),
                    const Text("Authorized Passenger ID", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 20),
                    QrImageView(
                      data: student.id,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    const SizedBox(height: 20),
                    Text("ID: ${student.id}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () => _shareQrPdf(context),
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                  label: const Text("Export as PDF", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C2E0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Hand this exact barcode to the Driver so they can scan the student into their bus via mobile_scanner.", textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}
