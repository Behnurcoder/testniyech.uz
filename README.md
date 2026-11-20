# testniyech.uz — Professional Online Testing Platform
> O‘zbekiston maktab o‘quvchilari uchun mo‘ljallangan professional variantli va ochiq javobli test platformasi.

---

## 🌟 Asosiy Imkoniyatlar

1. **O‘quvchilar Tizimi:**
   - 1-sinfdan 11-sinfgacha bo‘lgan barcha sinflar (1-A, 1-B, 5-A, 11-B va hokazo).
   - Bir xil ism, familiya va otasining ismi bilan bir nechta o‘quvchi ro‘yxatdan o‘tishi mumkin (tizim taqiqlamaydi).
   - Har bir o‘quvchiga takrorlanmas **ID** (masalan `TN-10023`) va **maxfiy PIN-kod** taqdim etiladi.
   - Kirish sahifasida: Ism, Familiya, Otasining ismi, Sinfi va PIN-kod kiritiladi.
   - Shaxsiy Dashboard: Mavjud testlar, ishlangan testlar, tugallanmagan testlar, o‘rtacha ball va natijalar tarixi.

2. **Savol Turlari va Aralashtirish:**
   - **1-tur: Variantli savollar (Multiple Choice):**
     - Savol matni, rasm biriktirish, A, B, C, D (va istalgancha variant qo‘shish/o‘chirish).
     - To‘g‘ri javobni radio orqali belgilash, har bir savol uchun ball.
     - Tizim tomonidan avtomatik tekshiriladi.
   - **2-tur: Ochiq javobli savollar (Open Text):**
     - Savol matni, rasm biriktirish, maksimal ball.
     - O‘quvchi o‘z fikrini yozadi. Javob saqlanadi va admin tekshiruviga yuboriladi.
     - Admin: To‘liq, qisman yoki 0 ball berishi hamda izoh qoldirishi mumkin.
   - **Aralash test:** Bitta test ichida istalgan ketma-ketlikda variantli va ochiq savollar aralashtiriladi.

3. **Test Ishlash Jarayoni:**
   - Savollar navigatsiyasi va palitrasi (ishlangan savollar ajratiladi).
   - Vaqt hisoblagich (Timer): vaqt tugaganda test avtomatik topshiriladi.
   - Javoblarni avtomatik saqlash (Auto-save): internet uzilsa yoki sahifa yangilansa javoblar yo‘qolmaydi.
   - Test topshirishdan oldin tasdiqlash dialogi. Topshirilgach javoblar qulflanadi.

4. **Xavfsizlik:**
   - Test topshirilmaguncha to‘g‘ri javoblar API orqali o‘quvchiga umuman yuborilmaydi.
   - Server vaqt nazorati va rate limiting.
   - Parollar bcrypt orqali hash qilingan, JWT autentifikatsiya.
   - Parametrlangan SQL so‘rovlar (SQL Injectionga qarshi).

5. **Professional Admin Panel:**
   - Dashboard: Jami ko‘rsatkichlar, diagrammalar, so‘nggi topshirilganlar.
   - O‘quvchilar: Qidiruv, sinf filtri, tahrirlash, sinfga ko‘chirish, PIN yangilash, o‘chirish.
   - Sinflar: Yangi sinf va harflar yaratish, tahrirlash, o‘quvchilarini ko‘rish.
   - Test yaratish: Dinamik savol konstruktori, rasm yuklash.
   - Ochiq javoblarni baholash ("Tekshirilmagan javoblar"): Ketma-ket qulay tekshirish va izoh qoldirish.
   - Natijalar: Barcha o‘quvchilar bo‘yicha filtrlar.

6. **PDF Hisobot Tizimi:**
   - Rasmiy A4 formatida har bir o‘quvchining test natijasi sertifikati / hisoboti.
   - O‘zbek tilidagi barcha harflar (o‘, g‘, sh, ch) to‘g‘ri ko‘rsatiladi.
   - Savollar jadvali, o‘quvchi javobi, to‘g‘ri javob, qo‘yilgan ball va o‘qituvchi izohi.
   - Butun sinf yoki butun test bo‘yicha umumiy reyting PDF hisoboti.

---

## 💻 Ishlatilgan Texnologiyalar

- **Frontend:** React.js, Tailwind CSS, Lucide Icons, Vite, Axios, Canvas Confetti.
- **Backend:** Node.js, Express.js, PostgreSQL (`pg`), JWT, bcryptjs, Multer, PDFKit.
- **Database:** PostgreSQL (Sxema: `testniyech`).

---

## 🚀 Windows PowerShell Orqali O‘rnatish va Ishga Tushirish

### 1-qadam: Repozitoriy papkasiga kirish
```powershell
cd C:\Users\NM\Desktop\testniyech.uz
```

### 2-qadam: Paketlarni o‘rnatish
```powershell
# Backend paketlarini o‘rnatish
cd backend
npm install

# Frontend paketlarini o‘rnatish
cd ..\frontend
npm install

cd ..
```

### 3-qadam: Ma'lumotlar bazasini initsializatsiya qilish (Sxema va Seed)
PostgreSQL serveringiz ishlab turganligiga ishonch hosil qiling va quyidagi buyruqni bajaring:
```powershell
cd backend
npm run seed
cd ..
```
*Bu buyruq barcha jadvallarni, 1-11 gacha barcha sinflarni, demo testlarni va demo adminni avtomatik yaratadi.*

### 4-qadam: Backend Serverni Ishga Tushirish
Alohida PowerShell oynasida:
```powershell
cd C:\Users\NM\Desktop\testniyech.uz\backend
npm start
```
*Backend `http://localhost:5000` portida ishga tushadi.*

### 5-qadam: Frontendni Ishga Tushirish
Boshqa PowerShell oynasida:
```powershell
cd C:\Users\NM\Desktop\testniyech.uz\frontend
npm run dev
```
*Frontend `http://localhost:5173` manzilida ochiladi.*

---

## 🔑 Demo Hisoblar

### Administrator (Admin Panel):
- **Kirish manzili:** `http://localhost:5173/admin/login`
- **Login:** `
- **Parol:** ``

### O‘quvchilar:
- **Ro‘yxatdan o‘tish manzili:** `http://localhost:5173/student/register`
- **Kirish manzili:** `http://localhost:5173/student/login`

*Tizimda demo o‘quvchilar mavjud emas. Yangi o‘quvchilar mustaqil ro‘yxatdan o‘tishlari yoki Admin paneli orqali qo‘shilishi mumkin.*

---

## 🧪 Sinov (Integration Test)

Barcha asosiy API va biznes mantiqni to‘liq avtomatlashtirilgan tarzda tekshirish uchun:
```powershell
node backend/test_all_features.js
```

---

## 📁 Loyiha Tuzilmasi

```
testniyech.uz/
├── backend/
│   ├── src/
│   │   ├── config/          # PostgreSQL db ulanishi va .env
│   │   ├── controllers/     # Auth, Student, Class, Test, Attempt, Admin, PDF
│   │   ├── middleware/      # Auth (JWT), Upload (Multer)
│   │   ├── models/          # InitDB scripti
│   │   ├── routes/          # API marshrutlari
│   │   ├── services/        # PDFKit hisobot xizmati
│   │   └── utils/           # PIN va ID generatorlari
│   ├── uploads/             # Yuklangan savol rasmlari
│   ├── server.js            # Express server
│   ├── package.json
│   └── .env
├── frontend/
│   ├── src/
│   │   ├── components/      # Navbar, Sidebar, Modal, ConfirmModal, Toast, StatCard
│   │   ├── context/         # AuthContext
│   │   ├── layouts/         # MainLayout, StudentLayout, AdminLayout
│   │   ├── pages/           # Home, Register, Login, Dashboard, TakeTest, Result, Admin...
│   │   ├── services/        # Axios API mijoz
│   │   ├── App.jsx          # React Router
│   │   ├── main.jsx
│   │   └── index.css        # Tailwind CSS
│   ├── index.html
│   ├── tailwind.config.js
│   └── package.json
├── database/
│   ├── schema.sql           # PostgreSQL to‘liq jadvallar sxemasi
│   └── seed.sql             # Demo admin, sinflar, testlar va savollar
├── package.json
└── README.md
```

---

## 📄 Litsenziya
Ushbu loyiha O‘zbekiston Respublikasi maktab ta'limini raqamlashtirish uchun ochiq ta'limiy maqsadlarda yaratilgan.
