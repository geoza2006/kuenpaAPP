import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  // ข้อมูลแผนที่
  GoogleMapController? mapController;
  static const LatLng _initialPosition = LatLng(13.789, 101.456); // พิกัดเริ่มต้น
  Set<Marker> _markers = {};

  // ข้อมูลรูปภาพ
  File? _image;
  final picker = ImagePicker();

  // Controller สำหรับรับค่าจาก Text Field
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // สร้างหมุดเริ่มต้นตอนเปิดหน้าจอ
    _markers.add(
      const Marker(
        markerId: MarkerId("current_loc"),
        position: _initialPosition,
      ),
    );
  }

  // ฟังก์ชันถ่ายรูป/เลือกรูป
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  // --------------------------------------------------------
  // ฟังก์ชันล้างข้อมูลหลังจากส่งเสร็จสิ้น
  // --------------------------------------------------------
  void _resetForm() {
    setState(() {
      _titleController.clear();
      _phoneController.clear();
      _nameController.clear();
      _locationController.clear();
      _detailController.clear();
      _image = null; // ลบรูป
      _markers.clear(); // ลบหมุด
      _markers.add(
        const Marker(
          markerId: MarkerId("current_loc"),
          position: _initialPosition,
        ),
      );
      // เลื่อนกล้องแผนที่กลับมาจุดเริ่มต้น
      mapController?.animateCamera(CameraUpdate.newLatLng(_initialPosition));
    });
  }

  // --------------------------------------------------------
  // Popup 1: ยืนยันการรายงาน
  // --------------------------------------------------------
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'ยืนยันการรายงาน',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF1B5E20), fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'คุณต้องการส่งรายงานเหตุการณ์นี้ใช่หรือไม่?',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // ปิด Popup ถ้ายกเลิก
              child: const Text('ยกเลิก', style: TextStyle(color: Colors.grey, fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // ปิด Popup ยืนยันก่อน
                _showSuccessDialog(); // เรียก Popup สำเร็จ
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E5B2C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('ยืนยัน', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  // --------------------------------------------------------
  // Popup 2: ส่งรายงานเรียบร้อยแล้ว (เหมือนในรูปเป๊ะ)
  // --------------------------------------------------------
  void _showSuccessDialog() {
    // TODO: ตรงนี้คือจุดที่คุณจะเอาคำสั่งส่งข้อมูลเข้า Firebase/Database มาใส่ในอนาคต
    
    showDialog(
      context: context,
      barrierDismissible: false, // บังคับให้ผู้ใช้ต้องกดปุ่ม "เสร็จสิ้น" เท่านั้น กดพื้นที่ว่างไม่ได้
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9FC), // สีพื้นหลังอมฟ้านิดๆ ตามรูป
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // ขนาดกล่องพอดีกับเนื้อหา
              children: [
                const Text(
                  'ส่งรายงานเรียบร้อยแล้ว',
                  style: TextStyle(
                    color: Color(0xFF0F5B3A), // สีเขียวเข้มตามรูป
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'รายงานของท่านถูกจัดส่งเรียบร้อยแล้ว\nติดตามสถานะการรายงานได้ที่หน้า\nสถานะการรายงาน',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF0F5B3A), // สีตัวหนังสือสีเขียว
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 140,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A5926), // สีปุ่มเขียวเข้ม
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // ปิด Popup
                      _resetForm(); // ล้างข้อมูลในหน้าจอ
                    },
                    child: const Text(
                      'เสร็จสิ้น',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- ส่วนที่ 1: แผนที่ Google Maps ---
            SizedBox(
              height: 350, // เพิ่มความสูงแผนที่ตามรูป
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: _initialPosition,
                  zoom: 15,
                ),
                onMapCreated: (controller) => mapController = controller,
                markers: _markers,
                mapType: MapType.normal, // ใช้แผนที่ปกติเหมือนในรูป
                onTap: (LatLng location) {
                  setState(() {
                    _markers.clear();
                    _markers.add(
                      Marker(
                        markerId: const MarkerId("current_loc"),
                        position: location,
                      ),
                    );
                    _locationController.text = "${location.latitude.toStringAsFixed(5)}, ${location.longitude.toStringAsFixed(5)}";
                  });
                },
              ),
            ),

            // --- ส่วนที่ 2: ฟอร์มข้อมูล ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ส่วนแสดงรูปถ่าย
                      GestureDetector(
                        onTap: getImage,
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC7E5B4), // สีพื้นหลังรูปสีเขียวอ่อนตามรูป
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: _image == null
                              ? const Icon(Icons.camera_alt, size: 50, color: Colors.black) // ไอคอนกล้องสีดำ
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.file(_image!, fit: BoxFit.cover),
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // ฟิลด์ข้อมูลทางขวาของรูป
                      Expanded(
                        child: Column(
                          children: [
                            _buildTextField("หัวข้อการรายงาน", _titleController),
                            const SizedBox(height: 12),
                            _buildTextField("โทรศัพท์", _phoneController),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField("ชื่อผู้แจ้งเหตุ", _nameController),
                  const SizedBox(height: 12),
                  _buildTextField("พิกัดการพบ", _locationController),
                  const SizedBox(height: 12),
                  
                  // รายละเอียด (กล่องใหญ่)
                  TextField(
                    controller: _detailController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "รายละเอียด",
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ปุ่มบันทึกการรายงาน
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _showConfirmationDialog, // กดปุ๊บ โชว์ Popup ยืนยัน
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9E9E9E), // สีเทาตามรูป
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("บันทึกการรายงาน", style: TextStyle(color: Colors.black, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget ช่วยสร้าง TextField แบบเอาข้อความไว้ข้างในกล่อง
  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}