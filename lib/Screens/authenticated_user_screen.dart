
import 'package:chattapplication/Model/user_model.dart'; // استيراد نموذج المستخدم من الحزمة
import 'package:flutter/material.dart'; // استيراد مكتبة الواجهة المادية الخاصة بفلاتر

class AuthenticatedUserScreen extends StatelessWidget { // تعريف فئة شاشة المستخدم المعتمد والتي هي غير قابلة للتغيير
  final UserModel user; // تعريف متغير من نوع نموذج المستخدم
  const AuthenticatedUserScreen({super.key, required this.user}); // مُنشئ للفئة مع خاصية المستخدم

  @override
  Widget build(BuildContext context) { // دالة لبناء واجهة المستخدم
    return Scaffold( // استخدام عنصر Scaffold لتوفير الهيكل الأساسي للشاشة
      appBar: AppBar( // تعريف شريط التطبيق العلوي
        centerTitle: true, // محاذاة العنوان في وسط الشريط
        title: const Text("Authenticated User"), // عنوان شريط التطبيق
        elevation: 0, // تعيين ارتفاع الظل لشريط التطبيق إلى صفر
      ),
      body: Center( // وضع العناصر في منتصف الشاشة
        child: Column( // استخدام عمود لترتيب العناصر عمودياً
          mainAxisAlignment: MainAxisAlignment.center, // محاذاة العناصر في وسط العمود
          children: [ // قائمة العناصر التي سيتم عرضها
            Text(
              "Hey ${user.name} !", // عرض اسم المستخدم في رسالة ترحيب
              style: const TextStyle( // تحديد نمط النص
                fontWeight: FontWeight.w600, // تعيين سمك الخط إلى وزن ثقيل
                fontSize: 26, // تعيين حجم الخط إلى 26
              ),
            ),
            const SizedBox(height: 8), // إضافة مساحة فارغة بمقدار 8 بكسل بين العناصر
            const Text(
              "You are Successfully Authenticated !", // رسالة نجاح التوثيق
              style: TextStyle( // تحديد نمط النص
                fontWeight: FontWeight.w400, // تعيين سمك الخط إلى وزن متوسط
                fontSize: 18, // تعيين حجم الخط إلى 18
              ),
            ),
          ],
        ),
      ),
    );
  }
}
