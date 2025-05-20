class BarangController {
  constructor(barangUseCase) {
    this.barangUseCase = barangUseCase;
  }

  getAllBarang = async (req, res) => {
    const barangList = await this.barangUseCase.getAllBarang();
    res.json(barangList);
  };

  createBarang = async (req, res) => {
    const { nama, kategori, stok } = req.body;
    const gambar = req.file ? req.file.filename : null;
    const barang = await this.barangUseCase.createBarang({ nama, kategori, stok: parseInt(stok), gambar });
    res.status(201).json(barang);
  };

  getBarangById = async (req, res) => {
    const barang = await this.barangUseCase.getBarangById(req.params.id);
    if (!barang) return res.status(404).json({ message: 'Barang not found' });
    res.json(barang);
  };

  updateBarang = async (req, res) => {
    const { nama, kategori, stok } = req.body;
    const gambar = req.file ? req.file.filename : null;
    const data = {};
    if (nama) data.nama = nama;
    if (kategori) data.kategori = kategori;
    if (stok) data.stok = parseInt(stok);
    if (gambar) data.gambar = gambar;
    const barang = await this.barangUseCase.updateBarang(req.params.id, data);
    if (!barang) return res.status(404).json({ message: 'Barang not found' });
    res.json(barang);
  };

  deleteBarang = async (req, res) => {
    const success = await this.barangUseCase.deleteBarang(req.params.id);
    if (!success) return res.status(404).json({ message: 'Barang not found' });
    res.status(204).send();
  };
}

module.exports = BarangController;
