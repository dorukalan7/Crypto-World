const express = require('express');
const admin = require('firebase-admin');
const cors = require('cors'); // CORS modülünü ekleyin

// Firebase admin SDK'yı başlatın
const serviceAccount = require('./dorukalan-96115-firebase-adminsdk-bpgta-227f4f556b.json'); // Bu dosyayı Firebase Console'dan indirmelisiniz

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const app = express();
app.use(cors()); // CORS'u kullan
app.use(express.json());

// Bildirim gönderme isteğini kontrol etmek için log ekleyin
app.post('/send-notification', (req, res) => {
  console.log('Notification request received:', req.body); // Gelen isteği loglar

  const { token, title, body } = req.body;

  const message = {
    notification: {
      title: title,
      body: body,
    },
    token: token,
  };

  admin.messaging().send(message)
    .then(response => {
      console.log('Notification sent successfully:', response); // Başarı mesajını loglar
      res.status(200).send('Notification sent successfully: ' + response);
    })
    .catch(error => {
      console.error('Error sending notification:', error); // Hataları loglar
      res.status(500).send('Error sending notification: ' + error);
    });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`); // Sunucunun çalıştığını loglar
});
