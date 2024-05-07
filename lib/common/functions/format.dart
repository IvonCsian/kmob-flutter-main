import 'package:money_formatter/money_formatter.dart';
import 'package:intl/intl.dart';

String formatCurrency(double nominal, [int fractiondigit]) {
  MoneyFormatter fmf = new MoneyFormatter(
      amount: nominal,
      settings: MoneyFormatterSettings(
          symbol: 'Rp.',
          thousandSeparator: '.',
          decimalSeparator: ',',
          symbolAndNumberSeparator: ' ',
          fractionDigits: fractiondigit ?? 2));
  return fmf.output.symbolOnLeft;
}

String formatDate(String param, [bool time, String format]) {
  DateTime tm = DateTime.parse(param.toString());
  String tanggal;
  String month;

  switch (tm.month) {
    case 1:
      month = "Januari";
      break;
    case 2:
      month = "Februari";
      break;
    case 3:
      month = "Maret";
      break;
    case 4:
      month = "April";
      break;
    case 5:
      month = "Mei";
      break;
    case 6:
      month = "Juni";
      break;
    case 7:
      month = "Juli";
      break;
    case 8:
      month = "Agustus";
      break;
    case 9:
      month = "September";
      break;
    case 10:
      month = "Oktober";
      break;
    case 11:
      month = "November";
      break;
    case 12:
      month = "Desember";
      break;
  }
  switch (tm.weekday) {
    case 1:
      tanggal = "Senin";
      break;
    case 2:
      tanggal = "Selasa";
      break;
    case 3:
      tanggal = "Rabu";
      break;
    case 4:
      tanggal = "Kamis";
      break;
    case 5:
      tanggal = "Jumat";
      break;
    case 6:
      tanggal = "Sabtu";
      break;
    case 7:
      tanggal = "Minggu";
      break;
  }

  if (format == "dd/mmm/yyyy") {
    return DateFormat('dd/MMM/yyyy').format(DateTime.parse(param.toString()));
    //return DateTime.parse(param.toString());
  } else if (format == "ddd dd/mmm/yyyy") {
    return tanggal +
        ' ' +
        DateFormat('dd/MMM/yyyy').format(DateTime.parse(param.toString()));
  }

  tanggal = tanggal + ', ${tm.day} $month ${tm.year}';
  if (time != null)
    tanggal = tanggal +
        ', ${tm.hour.toString().padLeft(2, '0')}:${tm.minute.toString().padLeft(2, '0')}:${tm.second.toString().padLeft(2, '0')} WIB';

  return tanggal;
}

String formatDateNew(String param, {bool time, String format}) {
  DateTime tm = DateTime.parse(param.toString());
  String tanggal;
  String month;

  switch (tm.month) {
    case 1:
      month = "Januari";
      break;
    case 2:
      month = "Februari";
      break;
    case 3:
      month = "Maret";
      break;
    case 4:
      month = "April";
      break;
    case 5:
      month = "Mei";
      break;
    case 6:
      month = "Juni";
      break;
    case 7:
      month = "Juli";
      break;
    case 8:
      month = "Agustus";
      break;
    case 9:
      month = "September";
      break;
    case 10:
      month = "Oktober";
      break;
    case 11:
      month = "November";
      break;
    case 12:
      month = "Desember";
      break;
  }
  switch (tm.weekday) {
    case 1:
      tanggal = "Senin";
      break;
    case 2:
      tanggal = "Selasa";
      break;
    case 3:
      tanggal = "Rabu";
      break;
    case 4:
      tanggal = "Kamis";
      break;
    case 5:
      tanggal = "Jumat";
      break;
    case 6:
      tanggal = "Sabtu";
      break;
    case 7:
      tanggal = "Minggu";
      break;
  }

  if (format == "dd/mmm/yyyy") {
    return DateFormat('dd MMM yyyy').format(DateTime.parse(param.toString()));
    //return DateTime.parse(param.toString());
  } else if (format == "ddd dd/mmm/yyyy") {
    return tanggal +
        ' ' +
        DateFormat('dd/MMM/yyyy').format(DateTime.parse(param.toString()));
  }

  tanggal = tanggal + ', ${tm.day} $month ${tm.year}';
  if (time != null)
    tanggal = tanggal +
        ', ${tm.hour.toString().padLeft(2, '0')}:${tm.minute.toString().padLeft(2, '0')}:${tm.second.toString().padLeft(2, '0')} WIB';

  return tanggal;
}
