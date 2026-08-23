import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('سياسة الخصوصية')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('سياسة الخصوصية', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text(
            'نحن نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية. هذه السياسة توضح كيفية جمعنا واستخدامنا وحمايتنا لمعلوماتك.',
            style: TextStyle(fontSize: 16, height: 1.6),
          ),
          SizedBox(height: 16),
          Text('1. جمع البيانات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
            'نجمع بياناتك الشخصية مثل الاسم ورقم الهاتف عند التسجيل، بالإضافة إلى بيانات الموقع والحضور أثناء استخدام التطبيق.',
            style: TextStyle(fontSize: 16, height: 1.6),
          ),
          SizedBox(height: 16),
          Text('2. استخدام البيانات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
            'تُستخدم بياناتك لتسجيل الحضور والانصراف، وإدارة طلباتك، وتتبع زيارات المندوبين، وتحسين خدماتنا.',
            style: TextStyle(fontSize: 16, height: 1.6),
          ),
          SizedBox(height: 16),
          Text('3. حماية البيانات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
            'نتخذ إجراءات أمنية مناسبة لحماية بياناتك من الوصول غير المصرح به أو التعديل أو الإفصاح.',
            style: TextStyle(fontSize: 16, height: 1.6),
          ),
          SizedBox(height: 16),
          Text('4. مشاركة البيانات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
            'لا نشارك بياناتك مع أطراف ثالثة إلا عند الضرورة القانونية أو بموافقتك الصريحة.',
            style: TextStyle(fontSize: 16, height: 1.6),
          ),
        ],
      ),
    );
  }
}
