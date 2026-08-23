import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('شروط الاستخدام')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('شروط الاستخدام', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text(
            'باستخدامك لهذا التطبيق فإنك توافق على الشروط والأحكام التالية:',
            style: TextStyle(fontSize: 16, height: 1.6),
          ),
          SizedBox(height: 16),
          Text('1. قبول الشروط', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
            'استخدامك للتطبيق يعني قبولك الكامل لجميع الشروط والأحكام المذكورة هنا.',
            style: TextStyle(fontSize: 16, height: 1.6),
          ),
          SizedBox(height: 16),
          Text('2. استخدام التطبيق', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
            'يُستخدم التطبيق لأغراض العمل فقط، ويُمنع استخدامه لأي أنشطة غير قانونية أو مخالفة للسياسات.',
            style: TextStyle(fontSize: 16, height: 1.6),
          ),
          SizedBox(height: 16),
          Text('3. دقة البيانات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
            'أنت مسؤول عن تقديم معلومات صحيحة ودقيقة عند التسجيل واستخدام التطبيق.',
            style: TextStyle(fontSize: 16, height: 1.6),
          ),
          SizedBox(height: 16),
          Text('4. الحساب', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
            'أنت مسؤول عن الحفاظ على سرية كلمة المرور وعن جميع الأنشطة التي تتم باستخدام حسابك.',
            style: TextStyle(fontSize: 16, height: 1.6),
          ),
        ],
      ),
    );
  }
}
