# Golden System — Code2Native-ready project

هذا المشروع Flutter كامل المصدر. لا يحتوي على APK جاهز لأن بيئة تجهيز الملف لا تحتوي على Flutter/Android SDK.
يتم إنشاء منصة Android تلقائيا في خدمة البناء ثم إنتاج APK Release.

## GitHub Actions (مناسب للهاتف)
1. أنشئ مستودعا جديدا على GitHub.
2. ارفع محتويات هذا المجلد إلى فرع `main`.
3. افتح تبويب Actions.
4. شغّل `Golden System APK` بواسطة Run workflow.
5. بعد انتهاء البناء افتح نتيجة الـworkflow ثم Artifacts ثم `golden-system-release`.
6. ستجد `app-release.apk`.

## Codemagic
ارفع المشروع إلى GitHub واربط المستودع مع Codemagic. ملف `codemagic.yaml` موجود ويحتوي خطوات البناء.

## ملاحظات
- اسم الحزمة المقترح: `com.goldensystem.golden_system`.
- الأيقونة: `assets/golden_system.png`.
- أكواد الاستبدال: `REDEEM_CODES.txt`.
- أكواد المسؤولين: `ADMIN_CODES.txt`.
- نظام الشات/الأصدقاء والنزال بالكود موجود في `lib/`.
- نظام الأكواد والمكافآت يعمل محليا باستخدام SharedPreferences.
- للحصول على شات/نزالات بين أجهزة مختلفة فعليا، يلزم Backend وقاعدة بيانات؛ التخزين المحلي وحده لا يزامن الأجهزة.
