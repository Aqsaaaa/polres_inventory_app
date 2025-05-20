const express = require('express');
const multer = require('multer');
const path = require('path');
const BarangController = require('../controllers/barangController');
const BarangUseCase = require('../usecases/barangUseCase');

const router = express.Router();
const barangUseCase = new BarangUseCase();
const barangController = new BarangController(barangUseCase);

// Setup multer for image uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, uniqueSuffix + path.extname(file.originalname));
  }
});
const upload = multer({ storage: storage });

router.get('/', barangController.getAllBarang);
router.post('/', upload.single('gambar'), barangController.createBarang);
router.get('/:id', barangController.getBarangById);
router.put('/:id', upload.single('gambar'), barangController.updateBarang);
router.delete('/:id', barangController.deleteBarang);

module.exports = router;
