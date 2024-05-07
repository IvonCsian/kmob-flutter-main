

import 'package:flutter/material.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/profile_model.dart';
import 'package:kmob/ui/fragment/Administrasi/PinEwallet.dart';
import 'package:kmob/utils/constant.dart';
class TncEwallet extends StatefulWidget {
  final ProfileModel profile;

  const TncEwallet({Key key, this.profile}) : super(key: key);
  @override
  _TncEwalletState createState() => _TncEwalletState();
}

judul(String list) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Text(list,
          textAlign: TextAlign.justify,
          style: TextStyle(
              fontSize: 16.0,
              fontFamily: "NeoSans",
              fontWeight: FontWeight.bold)),
    ],
  );
}

paragraf(String list) {
  return Text(list,
      textAlign: TextAlign.justify,
      style: TextStyle(fontSize: 16.0, fontFamily: "NeoSans"));
}

class _TncEwalletState extends State<TncEwallet> {
  double maxWidth = 0;
  double maxHeight = 0;
  BuildContext _context;

  //main build method
  Widget build(BuildContext context) {
    _context = context;
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height >= 775.0
        ? MediaQuery.of(context).size.height
        : 775.0;
    return SafeArea(
      child: PlatformScaffold(
        appBar: appBarDetail(context, "Syarat dan Ketentuan"),
        backgroundColor: Colors.white,
        body: Container(
          child: new ListView(
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              new Container(
                  // padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: new Column(
                      children: <Widget>[
                        Center(
                          child: Text(
                            "SYARAT DAN KETENTUAN JAKONE PAY",
                            style: TextStyle(
                                fontSize: 20.0, fontFamily: "NeoSans"),
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        // new PhotoView(
                        //   imageProvider: NetworkImage(
                        //     widget.param.image,
                        //   ),
                        // ),
                        new ClipRRect(
                          borderRadius: new BorderRadius.circular(8.0),
                          child: new Image(
                            width: double.infinity,
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              "https://images.squarespace-cdn.com/content/59a14544d55b41551e0b745a/1560322368934-8YD28EW1JQQDO9WTNHJ0/Logo+Jakone+Mobile-01.png?content-type=image%2Fpng",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        paragraf('''
Selamat bergabung di JakOne Pay!

JakOne Pay adalah uang elektronik berbasis server yang dapat diakses melalui telepon seluler atau sarana lainnya yang ditentukan oleh Bank DKI sebagai media registrasi dan penggunaan JakOne Pay.
Silakan membaca Syarat dan Ketentuan berikut dengan seksama.
'''),
                        judul('''Instruksi Transaksi Digital'''),
                        paragraf('''
•	Seluruh instruksi transaksi dari pengguna JakOne Pay berasal dari aplikasi mobile dan/atau secara online.
•	Sistem akan meminta otorisasi transaksi dari pengguna menggunakan berbagai jenis informasi pengaman transaksi yang berbeda (PIN dan OTP) jika dibutuhkan. Setelah dilakukan otorisasi, sistem akan melakukan transaksi sesuai dengan instruksi dari pengguna JakOne Pay.
•	Pastikan pengguna JakOne Pay tidak memberikan Informasi pengamanan transaksi kepada orang lain.
•	Lakukan penggantian PIN otorisasi transaksi secara berkala jika dirasa perlu untuk keamanan pengguna.
•	Jangan menggunakan singkatan ataupun kombinasi angka yang mudah ditebak (contoh: tanggal lahir, angka berurutan). 

'''),
                        judul('''Registrasi & Data Identitas Pengguna'''),
                        paragraf(
                            '''•	Registrasi/pendaftaran aplikasi menggunakan data pribadi.
•	Pastikan data/informasi yang diberikan adalah benar dan akurat.
•	Bank DKI menjamin data pengguna JakOne Pay akan tersimpan dengan aman pada sistem dan memastikan bahwa penggunaan data/informasi milik pengguna telah sesuai dengan ketentuan yang berlaku.
•	Bank DKI memberikan transparansi mengenai layanan/produk, termasuk syarat &  ketentuan, skema biaya dan perubahannya apabila ada.
•	Untuk informasi lebih lanjut dapat menghubungi Call Center Bank DKI.
'''),
                        judul('''1. DEFINISI'''),
                        paragraf(
                            '''1.	Uang elektronik JakOne Pay selanjutnya disebut JakOne Pay adalah uang elektronik berbasis server yang dapat diakses melalui telepon seluler atau sarana lainnya yang ditentukan oleh Bank DKI sebagai media registrasi dan penggunaan JakOne Pay.
2.	Call Centre Bank DKI adalah 1500351.
3.	Daftar adalah akses awal layanan JakOne Pay oleh pengguna dengan nomor telepon seluler sebagai nomor rekening uang elektronik.
4.	Telepon seluler adalah perangkat komunikasi seluler yang dipakai pengguna untuk mengakses rekening JakOne Pay, termasuk di dalamnya jaringan operator jasa seluler yang digunakan oleh pengguna.
5.	Isi Ulang adalah layanan isi ulang saldo JakOne Pay (dalam hal ini JakOne Pay) yang dapat dilakukan via e-banking Bank DKI, transfer dari bank lain atau sarana lainnya yang akan ditentukan Bank DKI di kemudian hari.
6.	JakOne Pay adalah uang elektronik berbasis server untuk melakukan transaksi di JakOne Pay maupun transaksi perbankan lainnya.
7.	OTP (One Time Password) adalah password dinamis yang dikirimkan ke nomor telepon seluler pengguna JakOne Pay melalui SMS.
8.	PIN (Personal Identification Number) adalah nomor identifikasi pribadi yang dibuat pada saat awal pendaftaran JakOne Pay, yang bersifat rahasia dan hanya diketahui oleh Pengguna serta harus dicantumkan/dimasukkan oleh Pengguna JakOne Pay di telepon seluler pada saat menggunakan layanan.
9.	Pengguna JakOne Pay Unregistered adalah pemegang yang terdaftar namun tidak tercatat data identitasnya dengan saldo maksimal Rp. 2.000.000,00 (dua juta rupiah), dimana pemegang dapat melakukan pembayaran pembelian, transfer dan fitur lainnya.
10.	Pengguna JakOne Pay Registered adalah pemegang JakOne Mobile yang terdaftar dan tercatat data identitasnya dengan saldo maksimal Rp. 10.000.000,- (sepuluh juta rupiah), dimana pemegang dapat melakukan pembayaran, pembelian, transfer dan fitur lainnya.
11.	Pembelian adalah layanan transaksi pembelian melalui JakOne Pay yang didebet langsung dari saldo rekening JakOne Pay pengguna.
12.	Transaksi adalah setiap jenis akses dan/atau kegiatan yang saat ini atau di kemudian hari akan ditetapkan Bank dan diinformasikan dari waktu ke waktu kepada Pengguna untuk dapat dilakukan dengan menggunakan JakOne Pay. 
'''),
                        judul('''2.PERSYARATAN DAN TATA CARA'''),
                        paragraf(
                            '''1.	Pengajuan menjadi pengguna JakOne Pay dapat dilakukan dengan cara melakukan pendaftaran melalui telepon seluler di mana nomor telepon seluler dari operator manapun baik pascabayar maupun prabayar dapat menjadi nomor rekening JakOne Pay.
2.	Setiap nomor telepon seluler yang didaftarkan hanya dapat digunakan untuk 1 (satu) rekening. 
3.	Pengguna wajib memiliki nomor ponsel yang aktif dan valid serta pulsa agar dapat menerima SMS OTP yang dikirim oleh Bank DKI sebagai validasi registrasi dan transaksi JakOne Pay.
4.	JakOne Pay  dapat digunakan untuk bertransaksi di merchant-merchant yang telah bekerja sama.
5.	Pengguna dapat melakukan transaksi sepanjang saldo JakOne Pay yang ada di dalam JakOne Pay mencukupi.
6.	Batas maksimum transaksi dalam 1 (satu) bulan kalender adalah Rp 20.000.000,- (dua puluh juta rupiah) sesuai dengan ketentuan dari Bank Indonesia.
7.	Bank DKI berhak sewaktu-waktu untuk melakukan perubahan fitur layanan, manfaat serta biaya dan lain-lain terkait dengan JakOne Pay dengan syarat dan ketentuan akan diberitahukan melalui media pengumuman dan informasi.
8.	Alamat email aktif milik sendiri wajib diisi. Bank DKI tidak bertanggung jawab atas keabsahan, kepemilikan, aktivitas dan kapasitas alamat email tersebut.
9.	Semua transaksi yang dilakukan pengguna akan dibebankan sebagai pemakaian dalam mata uang Rupiah. 
10.	Pengguna setuju untuk melepaskan Bank DKI dari seluruh kerugian, tanggung jawab, tuntutan dan biaya (termasuk biaya adanya gugatan hukum) yang dapat muncul terkait dengan eksekusi instruksi Pengguna, kecuali Pengguna dapat membuktikan lain dan/atau transaksi tersebut dieksekusi karena kesalahan  yang sengaja disebabkan oleh Bank DKI.
11.	Bank DKI berhak untuk menutup, memblokir atau membekukan rekening pengguna jika:
a.	Saldo JakOne Pay yang dimiliki pengguna telah disalahgunakan, meliputi tetapi tidak terbatas pada mengakomodasi dan/atau melakukan tindak kriminal yang menimbulkan kerugian bagi masyarakat dan pihak lain, dan/atau Bank DKI;
b.	Pengguna memberikan data/informasi yang dianggap mencurigakan oleh Bank DKI dan/atau memberikan data/informasi palsu, dan/atau tidak bersedia memberikan data/ informasi apapun yang diminta oleh Bank DKI sesuai dengan hukum dan perundangan yang berlaku, Bank DKI akan berupaya untuk menghubungi Pengguna dalam hal ini.
12.	Pengguna dengan ini memberikan kuasa dan wewenang kepada Bank DKI untuk mendebet Rekening Pengguna di Bank DKI atas:
a.	Transaksi yang dilakukan oleh Pengguna melalui penggunaan uang elektronik JakOne Pay;
b.	Biaya pajak maupun denda terkait dengan Transaksi, produk atau jasa Bank melalui penggunaan uang elektronik JakOne Pay.
'''),
                        judul('''3. MANFAAT DAN RISIKO'''),
                        judul('''MANFAAT'''),
                        paragraf(
                            '''1.	Bertransaksi secara non-tunai menggunakan uang elektronik JakOne Pay.
2.	Mendapatkan promo khusus transaksi melalui penggunaan JakOne Pay.
3.	Saldo JakOne Pay sebagai pengganti tunai.
4.	Dapat digunakan di semua jenis telepon seluler berbasis Android dan iOS.
5.	Tidak perlu repot mencari uang pas untuk pembayaran transaksi dengan nominal kecil.
'''),
                        judul('''RISIKO'''),
                        paragraf(
                            '''1.	Pengguna bertanggung jawab untuk memastikan seluruh data, informasi dan instruksi yang diberikan pada Bank DKI telah benar dan lengkap. Pengguna bertanggung jawab atas dampak apapun yang dapat disebabkan oleh kelalaian, ketidaklengkapan atau ketidakjelasan data dan/atau instruksi yang diberikan oleh Pengguna.
2.	Untuk tiap transaksi yang menggunakan uang elektronik JakOne Pay, data dan/atau instruksi yang diberikan Pengguna akan dianggap benar dan valid untuk dieksekusi / diproses oleh Bank DKI.
3.	Bank DKI berhak untuk tidak mengeksekusi / memproses instruksi Pengguna meliputi, tetapi tidak terbatas pada keadaan berikut:
a.	Saldo Rekening Pengguna tidak mencukupi;
b.	Rekening tersebut dikenakan penyitaan atau blokir;
c.	Bank DKI memiliki alasan untuk mencurigai adanya tindakan fraud atau kriminal.
4.	Apabila terjadi sengketa antara Pengguna dan pihak ketiga, Bank DKI berhak untuk tidak melakukan pembayaran atau transfer pada siapapun hingga persengketaan yang terjadi antara pihak-pihak tersebut telah diselesaikan dan/atau sesuai dengan keputusan pengadilan yang mengikat secara hukum.
5.	Bank DKI berhak menghentikan sementara layanan uang elektronik JakOne Pay untuk periode yang telah ditentukan untuk tujuan pemeliharaan, dan tujuan lainnya yang dianggap sah oleh Bank DKI, dengan atau tanpa pemberitahuan sebelumnya pada Pengguna dan tanpa bertanggung jawab pada siapapun.
6.	Bank DKI berhak untuk memperbaharui, memodifikasi atau mengubah situs web atau perangkat lunak apapun yang digunakan untuk melakukan transaksi sewaktu-waktu tanpa pemberitahuan dan tanpa memberikan alasan apapun.
7.	Bank DKI berhak untuk tidak mendukung versi sebelumnya dari perangkat lunak (Mobile App) yang digunakan. Jika Pengguna gagal untuk memperbaharui perangkat lunak yang relevan atau menggunakan versi yang disempurnakan, Bank DKI tidak bertanggung jawab atas segala konsekuensi yang ditimbulkannya.
'''),
                        judul('''4. INFORMASI KEAMANAN'''),
                        paragraf(
                            '''1.	Informasi keamanan berupa Nama Pengguna, Kata Sandi, OTP (one-time-password), kode QR, dan PIN akan dibutuhkan untuk log-in, aktivasi perangkat dan mengeksekusi setiap transaksi yang menurut Bank DKI dibutuhkan sebagai tujuan otentikasi. Untuk tiap informasi keamanan yang akan ditentukan dan ditetapkan oleh Pengguna, Pengguna harus memastikan untuk menggunakan kata sandi yang kuat dan tidak memasukkan kata sandi yang mudah ditebak serta informasi diri seperti tanggal lahir dan alamat. Penggunaan informasi tersebut akan dianggap sebagai Kelalaian Pengguna.
2.	Informasi keamanan akan menjadi rahasia di bawah tanggung jawab Pengguna, karena informasi tersebut memiliki keberlakuan setara dengan instruksi tertulis yang ditandatangani oleh Pengguna, dan akan diperlakukan sebagai otorisasi eksplisit oleh Pengguna agar Bank DKI melaksanakan transaksi melalui Aplikasi Mobile dan/atau Internet banking.
3.	Pengguna bertanggung jawab penuh dengan keamanan terhadap seluruh penggunaan uang elektronik JakOne Pay, termasuk upaya-upaya pencegahan terhadap penyalahgunaan dari pihak lain.
4.	Pengguna mengetahui dan menyetujui bahwa Bank DKI tidak menanggung atau, menjamin, baik secara langsung atau tidak langsung terkait dengan penggunaan JakOne Pay, kecuali namun tidak terbatas terkait dengan Akses JakOne Pay dapat memenuhi persyaratan Pengguna akan selalu tersedia, dapat diakses ataupun berfungsi dengan jaringan infrastruktur, sistem atau layanan lain yang Bank DKI tawarkan dari waktu ke waktu.
5.	Bank DKI tidak bertanggung jawab atas segala kerugian yang dialami Pengguna (baik secara sengaja atau tidak sengaja), kecuali hal tersebut dipersyaratkan oleh ketentuan perundang-undangan yang berlaku termasuk timbulnya kerugian dari:
a.	Pelanggaran ketentuan dari Bank DKI oleh dan terkait penggunaan Pengguna; 
b.	Terjadinya suatu proses akses yang tidak terotorisasi dan/atau penggunaan dari perangkat elektronik secara tidak sah;
c.	Penggunaan dalam segala bentuk oleh pihak lain terhadap informasi atau data yang berhubungan dengan Pengguna karena penggunaan JakOne Pay diperoleh dari penggunaan Pengguna;
d.	Akses ke uang elektronik JakOne Pay oleh pihak lain selain Pengguna;
e.	Segala kejadian diluar pengendalian Bank DKI atau karena penggunaan yang tidak wajar.
6.	Bank DKI akan mengajukan proses verifikasi yang memenuhi standar Bank DKI untuk memungkinkan Pengguna melakukan transaksi keuangan dan/atau non keuangan.
7.	Pengguna menyetujui untuk membebaskan Bank DKI dari segala kerugian, tanggung jawab, klaim dan biaya (termasuk biaya hukum) yang mungkin terjadi dalam kaitannya dengan pelaksanaan instruksi dari Bank DKI, kecuali Pelanggan dapat membuktikan sebaliknya dan/atau transaksi yang dijalankan karena kesalahan dari Bank DKI
8.	Pengguna bertanggung jawab untuk memperoleh dan menggunakan perangkat lunak yang diperlukan dan/atau peralatan yang diperlukan untuk dapat mengakses JakOne Pay dengan risiko yang ditanggung Pengguna.
9.	Pengguna juga bertanggung jawab atas kinerja dan keamanan (termasuk tanpa batasan mengambil semua langkah yang diperlukan sejauh mungkin untuk mencegah penggunaan atau akses yang tidak sah) dari setiap peralatan yang digunakan oleh Pengguna untuk mengakses JakOne Pay.
10.	Pengguna harus memastikan bahwa peralatan yang digunakan untuk mengakses JakOne Pay bebas dari kegagalan elektronik, mekanik, data yang gagal atau terkorupsi, virus, bug dan/atau perangkat lunak yang berbahaya dan/atau perangkat lunak yang tidak diizinkan oleh penyedia layanan telekomunikasi, atau produsen atau vendor dari peralatan yang relevan.
Ini termasuk:
a.	Penggunaan komputer pribadi Pengguna, perangkat mobile dan/atau Terminal Pengguna lainnya dengan perangkat lunak berupa anti-virus terbaru, anti-malware dan firewall yang tersedia dan perangkat lunak yang digunakan secara teratur selalu diperbarui dan dijalankan dengan anti-virus signatures terbaru.
b.	Memastikan bahwa Pengguna tidak melakukan jailbreak, root atau memodifikasi perangkat mobile dan/atau Peralatan lainnya, atau menginstal aplikasi yang tidak diizinkan karena hal ini dapat membuat perangkat lebih rentan terhadap virus dan malware.
11.	Pengguna bertanggung jawab atas kegagalan elektronik maupun mekanik, atau data yang terkorupsi, virus komputer, bug dan/atau perangkat lunak yang berbahaya lainnya dari jenis apapun yang mungkin timbul dari layanan yang disediakan oleh penyedia layanan internet yang relevan atau informasi penyedia layanan. Sebagai syarat minimum keamanan yang harus dipenuhi Pengguna untuk dapat menggunakan JakOne Pay.
12.	Dengan melaksanakan transaksi menggunakan JakOne Pay, Pengguna memahami bahwa seluruh komunikasi dan instruksi dari Pengguna yang diterima oleh Bank DKI akan diperlakukan sebagai bukti solid meskipun tidak dibuat dalam bentuk dokumen tertulis atau diterbitkan dalam bentuk dokumen yang ditandatangani, dan, dengan demikian, Pengguna setuju untuk mengganti rugi dan melepaskan Bank DKI dari segala kerugian, tanggung jawab, tuntutan dan pengeluaran (termasuk biaya litigasi) yang dapat muncul terkait dengan eksekusi dari instruksi Pengguna.
'''),
                        judul('''5. PEMBUKUAN'''),
                        paragraf(
                            '''1.	Pencatatan setiap transaksi yang terjadi dalam seluruh rekening Bank DKI dan menyebabkan perubahan pada saldo akan diberikan dalam format yang dianggap tepat oleh Bank DKI.
2.	Bank DKI akan menerbitkan Bukti Transaksi seperti, tapi tidak terbatas pada informasi transaksi yang dapat diunduh oleh Pengguna dari aplikasi yang terkait dengan JakOne Pay dan saluran yang ditentukan oleh Bank DKI.
3.	Jika Bank DKI tidak menerima pengaduan apapun dari Pengguna dalam tujuh (7) hari setelah menerima notifikasi, Pengguna dianggap setuju dengan informasi yang tercantum dalam informasi transaksi.
'''),
                        judul('''6. BIAYA'''),
                        paragraf(
                            '''Informasi terkait biaya serta detail terkait lainnya juga dapat diperoleh dengan menghubungi Call Center Bank DKI 1500351.  
'''),
                        judul('''7. HUKUM DAN YURISDIKSI YANG BERLAKU'''),
                        paragraf(
                            '''1.	Interpretasi dan implementasi Syarat dan Ketentuan ini diatur dan tunduk pada hukum yang berlaku di Republik Indonesia.
2.	Untuk hal-hal yang terkait dengan Syarat dan Ketentuan serta seluruh konsekuensinya, Pengguna akan memilih tempat kedudukan hukum (domisili) yang tetap dan seumumnya di kantor kepaniteraan Pengadilan Negeri Jakarta Pusat dengan tidak mengurangi hak Bank DKI untuk mengajukan gugatan hukum atau tuntutan terhadap Pengguna dalam pengadilan lain di Indonesia sesuai dengan hukum dan perundangan yang berlaku.
3.	Syarat dan Ketentuan tunduk pada peraturan, termasuk ketentuan dari Peraturan OJK No. 01/POJK.07/2013 mengenai Perlindungan Konsumen Sektor Jasa Keuangan, termasuk seluruh perubahannya; Peraturan Bank DKI Indonesia No. 16/1/PBI/2014 tanggal 16 Januari 2014 Tentang Perlindungan Konsumen Jasa Sistem Pembayaran dan Surat Edaran BI No.16/16/DKSP tanggaL 30 September 2014 Perihal Tata Cara Pelaksanaan Perlindungan Konsumen Jasa Sistem Pembayaran;

'''),
                        judul('''8. PERNYATAAN DAN WEWENANG'''),
                        paragraf(
                            '''1.	Pengguna dengan ini menyatakan bahwa setiap data yang digunakan oleh Pengguna adalah valid dan sah serta mengikat pada fasilitas JakOne Pay, kecuali jika dinyatakan lain. Kelalaian Pengguna dalam memberitahukan perubahan tersebut pada Bank DKI sepenuhnya menjadi tanggung jawab Pengguna.
2.	Pengguna dengan ini menyatakan bahwa memahami dan sepenuhnya menyadari seluruh risiko yang ditimbulkan dari transaksi JakOne Pay atau transaksi lain melalui aplikasi yang terkait dengan JakOne Pay.
3.	Pengguna dengan ini menyatakan bahwa Pengguna bersedia dikunjungi dan/atau dihubungi oleh Bank DKI melalui sarana komunikasi pribadi Pengguna, untuk menyampaikan informasi (termasuk produk dan/atau layanan).
4.	Pengguna dengan ini menyatakan bahwa Bank DKI dibebaskan dari tuntutan/gugatan ganti rugi yang muncul akibat kegagalan sistem dan/atau fasilitas komunikasi yang disebabkan oleh faktor eksternal di luar kendali Bank DKI.                                              
5.	Pengguna dengan ini menyatakan akan tunduk dan terikat pada Syarat dan Ketentuan, persyaratan dan ketentuan yang terkait dengan JakOne Pay dan/atau fasilitas/layanan yang akan diterima oleh Pengguna seperti hukum, perundangan dan kuasa yang berlaku di Republik Indonesia, akan halnya ketentuan yang ditetapkan oleh Republik Indonesia terkait dengan fasilitas/layanan yang diberikan oleh Bank DKI pada Pengguna (meliputi tetapi tidak terbatas pada proses transaksi melalui media elektronik).
6.	Seluruh kuasa dan wewenang yang diberikan oleh Pengguna dalam Syarat dan Ketentuan tersebut diberikan dengan hak substitusi, dan sepanjang kewajiban Pengguna terhadap Bank DKI belum sepenuhnya selesai, kuasa dan wewenang tersebut tidak dapat ditarik dan diakhiri untuk alasan apapun, termasuk tetapi tidak terbatas pada alasan yang disebutkan pada Pasal 1813 Hukum Perdata karena wewenang tersebut adalah komponen tak terpisahkan dari Syarat dan Ketentuan yang ada.
7.	Pengguna menyetujui dan mengakui Bank DKI memiliki wewenang untuk meningkatkan, mengubah atau melengkapi Syarat dan Ketentuan tersebut sesuai dengan ketentuan yang berlaku. Setiap perubahan, tambahan atau pembaruan atas Syarat dan Ketentuan tersebut akan disosialisasikan melalui email Pengguna dan Pengguna terikat dengan perubahan di masa mendatang tersebut.

'''),
                        judul('''9. KEADAAN KAHAR (FORCE MAJEURE)'''),
                        paragraf(
                            '''1.	Pengguna akan membebaskan Bank DKI dari segala tuntutan, jika Bank DKI tidak dapat melaksanakan instruksi dari Pengguna, baik sebagian maupun sepenuhnya yang disebabkan oleh kejadian atau sebab yang berada di luar kendali atau kemampuan Bank DKI, meliputi tetapi tidak terbatas pada bencana alam, peperangan, kerusuhan, kondisi perangkat keras, kegagalan sistem infrastruktur elektronik atau transmisi, gangguan daya, gangguan telekomunikasi, kegagalan sistem kliring atau hal lainnya yang ditetapkan oleh Bank DKI Indonesia atau lembaga berwenang lainnya.
2.	Setelah kejadian yang menyebabkan Bank DKI tidak dapat melaksanakan instruksi dari Pengguna berakhir, Bank DKI akan melanjutkan kembali instruksi tersebut dalam kurun waktu sesuai dengan ketentuan dari Bank Indonesia dan atau Otoritas Jasa Keuangan.

'''),
                        judul('''10. PERTANYAAN DAN PENGADUAN'''),
                        paragraf(
                            '''1.	Pengguna dapat menghubungi Layanan Pelanggan untuk bertanya, mengajukan permintaan, dan/atau mengajukan pengaduan di nomor Bank DKI Jika pengguna ingin mengajukan pengaduan secara tertulis, pengguna harus menyertakan bukti yang mendukung pengaduan tersebut.
2.	Jika pengaduan tersebut terkait dengan transaksi keuangan yang telah dilakukan, Pengguna harus mengajukannya paling lambat 7 (tujuh) hari kerja sejak transaksi keuangan tersebut dilakukan. 
3.	Bank DKI akan melakukan pemeriksaan/penyelidikan atas pengaduan tersebut sesuai dengan kebijakan dan prosedur yang berlaku di Bank DKI.

'''),
                        judul('''11. KERJA SAMA DENGAN PIHAK LAIN'''),
                        paragraf(
                            '''Dengan ini pengguna memberikan persetujuan kepada Bank DKI  untuk memberikan identitas kepada pihak ketiga lainnya yang bekerja sama dengan Bank DKI dalam rangka pengembangan produk/fasilitas/jasa untuk tujuan komersial.
'''),
                        judul('''12. KETENTUAN LAIN-LAIN'''),
                        paragraf(
                            '''Syarat dan Ketentuan JakOne Pay ini telah disesuaikan dengan ketentuan peraturan perundang-undangan termasuk ketentuan Peraturan Otoritas Jasa Keuangan. '''),
                        MaterialButton(
                            color: ColorPalette.warnaCorporate,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 42.0),
                              child: Text(
                                "Setuju dan Lanjut",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontFamily: "WorkSansBold"),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  _context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PinEwallet(profile: widget.profile)));
                            }),
                            MaterialButton(
                            color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 42.0),
                              child: Text(
                                "Batal",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontFamily: "WorkSansBold"),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(_context);
                            })
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
