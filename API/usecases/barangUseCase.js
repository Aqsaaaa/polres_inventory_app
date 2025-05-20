const pool = require('../db');
const Barang = require('../entities/Barang');

class BarangUseCase {
  async getAllBarang() {
    const [rows] = await pool.query('SELECT * FROM barang');
    return rows.map(row => new Barang(row));
  }

  async createBarang(data) {
    const { nama, gambar, kategori, stok } = data;
    const [result] = await pool.query(
      'INSERT INTO barang (nama, gambar, kategori, stok) VALUES (?, ?, ?, ?)',
      [nama, gambar, kategori, stok]
    );
    return new Barang({ id: result.insertId.toString(), nama, gambar, kategori, stok });
  }

  async getBarangById(id) {
    const [rows] = await pool.query('SELECT * FROM barang WHERE id = ?', [id]);
    if (rows.length === 0) return null;
    return new Barang(rows[0]);
  }

  async updateBarang(id, data) {
    const barang = await this.getBarangById(id);
    if (!barang) return null;
    const { nama, gambar, kategori, stok } = data;
    await pool.query(
      'UPDATE barang SET nama = ?, gambar = ?, kategori = ?, stok = ? WHERE id = ?',
      [
        nama || barang.nama,
        gambar || barang.gambar,
        kategori || barang.kategori,
        stok !== undefined ? stok : barang.stok,
        id
      ]
    );
    return this.getBarangById(id);
  }

  async deleteBarang(id) {
    const [result] = await pool.query('DELETE FROM barang WHERE id = ?', [id]);
    return result.affectedRows > 0;
  }
}

module.exports = BarangUseCase;
