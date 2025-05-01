import 'package:fig_app/models/client_model.dart';
import 'package:flutter/material.dart';
import 'package:fig_app/models/invoice_model.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:fig_app/repositories/client_repository.dart';

class InvoiceDetails extends StatelessWidget {
  final Invoice invoice;
  const InvoiceDetails({super.key, required this.invoice});

  Future<void> _generatePdf(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InvoicePdfPreview(invoice: invoice),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.deepPurple,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB388FF), Color(0xFF7C4DFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.deepPurple.shade100,
                          child: Icon(
                            Icons.receipt_long,
                            color: Colors.deepPurple.shade700,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                invoice.clientName ?? 'Unknown Client',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              if (invoice.description != null &&
                                  invoice.description!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    invoice.description!,
                                    style: TextStyle(
                                      color: Colors.deepPurple.shade400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    _DetailRow(
                      label: 'Amount',
                      value: '\$${invoice.amount?.toStringAsFixed(2) ?? '--'}',
                    ),
                    const SizedBox(height: 16),
                    _DetailRow(
                      label: 'Date',
                      value:
                          invoice.createdAt != null
                              ? '${invoice.createdAt.day}/${invoice.createdAt.month}/${invoice.createdAt.year}'
                              : '',
                    ),
                    const SizedBox(height: 16),
                    _DetailRow(
                      label: 'Due Date',
                      value:
                          invoice.dueDate != null
                              ? '${invoice.dueDate!.day}/${invoice.dueDate!.month}/${invoice.dueDate!.year}'
                              : 'N/A',
                    ),
                    const SizedBox(height: 16),
                    _DetailRow(label: 'Status', value: invoice.status ?? 'N/A'),
                    if (invoice.clientId != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _DetailRow(
                              label: 'Client ID',
                              value: invoice.clientId!,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.copy,
                              size: 18,
                              color: Colors.deepPurple,
                            ),
                            tooltip: 'Copy Client ID',
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: invoice.clientId!),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Client ID copied!'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                    if (invoice.id != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _DetailRow(
                              label: 'Invoice ID',
                              value: invoice.id!,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.copy,
                              size: 18,
                              color: Colors.deepPurple,
                            ),
                            tooltip: 'Copy Invoice ID',
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: invoice.id!),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invoice ID copied!'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                    _DetailRow(
                      label: 'Notes',
                      value:
                          invoice.notes != null && invoice.notes!.isNotEmpty
                              ? invoice.notes!
                              : 'N/A',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Generate PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => _generatePdf(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple.shade700,
            fontSize: 15,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 15))),
      ],
    );
  }
}

class InvoicePdfPreview extends StatefulWidget {
  final Invoice invoice;
  const InvoicePdfPreview({Key? key, required this.invoice}) : super(key: key);

  @override
  State<InvoicePdfPreview> createState() => _InvoicePdfPreviewState();
}

class _InvoicePdfPreviewState extends State<InvoicePdfPreview> {
  Client? client;
  bool _loading = true;
  Uint8List? _logoBytes;

  @override
  void initState() {
    super.initState();
    _fetchClient();
    _loadLogo();
  }

  Future<void> _loadLogo() async {
    try {
      final bytes = await rootBundle.load('assets/images/logo.png');
      setState(() {
        _logoBytes = bytes.buffer.asUint8List();
      });
    } catch (e) {
      // Logo not found or error loading
      setState(() {
        _logoBytes = null;
      });
    }
  }

  Future<void> _fetchClient() async {
    try {
      final repo = ClientRepository();
      final clients = await repo.fetchClients();
      final found = clients.firstWhere(
        (c) => c.id == widget.invoice.clientId,
        orElse: () => Client(id: '', name: 'Unknown', email: '', phone: ''),
      );
      setState(() {
        client = found;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  pw.Document _buildPdf() {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(32),
        build:
            (pw.Context context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (_logoBytes != null) ...[
                  pw.Center(
                    child: pw.Image(
                      pw.MemoryImage(_logoBytes!),
                      width: 100,
                      height: 100,
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                  pw.SizedBox(height: 16),
                ],
                // Company Info Row
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          client?.name ??
                              widget.invoice.clientName ??
                              'Client Name',
                          style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.deepPurple800,
                          ),
                        ),
                        if (widget.invoice.description != null)
                          pw.Text("Description: ${widget.invoice.description}"),
                        if ((client?.phone ?? '').isNotEmpty)
                          pw.Text('Phone: ${client!.phone}'),
                        if ((client?.email ?? '').isNotEmpty)
                          pw.Text('Email: ${client!.email}'),
                      ],
                    ),
                    // Only show logo if you have valid bytes
                    // pw.Container(
                    //   width: 80,
                    //   height: 80,
                    //   child: pw.Image(
                    //     pw.MemoryImage(logoBytes),
                    //     fit: pw.BoxFit.contain,
                    //   ),
                    // ),
                  ],
                ),
                pw.SizedBox(height: 24),
                pw.Text(
                  'INVOICE',
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.deepPurple,
                  ),
                ),
                pw.Divider(),
                pw.SizedBox(height: 12),
                // Invoice & Client Info
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Billed To:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(width: 8),
                        pw.Text(
                          widget.invoice.clientName ?? 'Unknown Client',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),

                    if (widget.invoice.clientId != null)
                      pw.Text(
                        'Client ID: ${widget.invoice.clientId!}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),

                    if (widget.invoice.id != null)
                      pw.Text(
                        'Invoice ID: ${widget.invoice.id!}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    pw.Text(
                      'Date: ${widget.invoice.createdAt.day}/${widget.invoice.createdAt.month}/${widget.invoice.createdAt.year}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),

                    pw.Text(
                      'Due Date: ${widget.invoice.dueDate != null ? '${widget.invoice.dueDate!.day}/${widget.invoice.dueDate!.month}/${widget.invoice.dueDate!.year}' : 'N/A'}, ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
                pw.SizedBox(height: 24),
                // Description/Items Table
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey400),
                  defaultVerticalAlignment:
                      pw.TableCellVerticalAlignment.middle,
                  children: [
                    pw.TableRow(
                      decoration: pw.BoxDecoration(
                        color: PdfColors.deepPurple100,
                      ),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'Description',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'Amount',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(widget.invoice.description ?? '-'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            '${widget.invoice.amount?.toStringAsFixed(2) ?? '--'}',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 24),
                // Notes
                if (widget.invoice.notes != null &&
                    widget.invoice.notes!.isNotEmpty) ...[
                  pw.Text(
                    'Notes:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(widget.invoice.notes!),
                  pw.SizedBox(height: 16),
                ],
                // Status
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: pw.BoxDecoration(
                        color:
                            widget.invoice.status == 'Paid'
                                ? PdfColors.green100
                                : PdfColors.red100,
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Text(
                        'Status: ${widget.invoice.status ?? 'N/A'}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                pw.Spacer(),
                // Footer
                pw.Divider(),
                pw.Center(
                  child: pw.Text(
                    'Thank you for your business!',
                    style: pw.TextStyle(
                      fontStyle: pw.FontStyle.italic,
                      color: PdfColors.grey600,
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
    return pdf;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice PDF Preview'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: PdfPreview(
              build: (format) async => _buildPdf().save(),
              canChangePageFormat: false,
              canChangeOrientation: false,
              canDebug: false,
            ),
          ),
        ],
      ),
    );
  }
}
