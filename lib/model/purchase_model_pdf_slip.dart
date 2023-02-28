import 'package:wooodapp/model/purchase_model.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pd;

buildpdf(PurchaseOrderModel element) {
  return pd.Padding(
        padding: pd.EdgeInsets.all(20),
        child: pd.Column(
          children: [
            pd.Row(
              mainAxisAlignment: pd.MainAxisAlignment.spaceBetween,
              children: [
                pd.Text(
                  'Aiswarya\nFurnitures',
                  textAlign: pd.TextAlign.center,
                  style: pd.TextStyle(
                    color: PdfColors.black,
                    fontSize: 30,
                  ),
                ),
                pd.Column(
                  children: [
                    pd.Container(
                      color: PdfColors.black,
                      height: 2,
                      width: 250,
                    ),
                    pd.SizedBox(height: 20),
                    pd.Text(
                      'Invoice No : ${element.ref_no}',
                      style: pd.TextStyle(
                        color: PdfColors.black,
                        fontSize: 14,
                      ),
                    ),
                    pd.SizedBox(height: 20),
                    pd.Text(
                      'Invoice Date : ${DateFormat.yMMMd().format(DateTime.now())}',
                      style: pd.TextStyle(
                        color: PdfColors.black,
                        fontSize: 14,
                      ),
                    )
                  ],
                )
              ],
            ),
            pd.SizedBox(height: 30),
            pd.Divider(color: PdfColors.green),
            pd.SizedBox(height: 30),
            pdfItemRow('Supplier', element.supplier_name),
            pdfItemRow('Arrival Data', element.arrival_date),
            pdfItemRow('Quantity', element.quantity),
            pdfItemRow('Item', element.item_name),
            pdfItemRow('Item Code', element.item_code),
            pdfItemRow('Item Description', element.item_desc),
            pd.SizedBox(height: 30),
            pd.Divider(color: PdfColors.green),
          ],
        ),
      );
}

pdfItemRow(String title, String data) {
  return pd.Padding(
    padding: pd.EdgeInsets.symmetric(vertical: 10),
    child: pd.Row(
      children: [
        pd.SizedBox(
          width: 200,
          child: pd.Text(
            title,
            style: pd.TextStyle(
              fontSize: 22,
            ),
          ),
        ),
        pd.Text(
          ': ',
          style: pd.TextStyle(
            fontSize: 22,
            fontWeight: pd.FontWeight.bold,
          ),
        ),
        pd.Text(
          data,
          style: pd.TextStyle(fontSize: 20),
        ),
      ],
    ),
  );
}
