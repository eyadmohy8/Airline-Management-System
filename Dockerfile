# استخدام صورة تحتوي على Flutter جاهز
FROM ghcr.io/cirruslabs/flutter:stable

# تحديد مكان العمل داخل الحاوية
WORKDIR /app

# نسخ ملفات المشروع داخل الحاوية
COPY . .

# تحميل المكتبات والتأكد من صحة الكود
RUN flutter pub get
RUN flutter analyze

# أمر افتراضي لبناء التطبيق
CMD ["flutter", "build", "apk"]
