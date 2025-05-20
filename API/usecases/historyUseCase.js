const pool = require('../db');
const History = require('../entities/History');

class HistoryUseCase {
  async getAllHistory() {
    const [rows] = await pool.query('SELECT * FROM history');
    return rows.map(row => new History(row));
  }

  async createHistory(data) {
    const { userId, barangId, status, alasan } = data;

    if (status === 'dipinjam') {
      const [barangRows] = await pool.query('SELECT stok FROM barang WHERE id = ?', [barangId]);
      if (barangRows.length === 0) throw new Error('Barang not found');
      if (barangRows[0].stok <= 0) throw new Error('Stock barang tidak cukup');
      await pool.query('UPDATE barang SET stok = stok - 1 WHERE id = ?', [barangId]);
    }

    const [result] = await pool.query(
      'INSERT INTO history (userId, barangId, status, alasan, date) VALUES (?, ?, ?, ?, NOW())',
      [userId, barangId, status, alasan]
    );
    return new History({ id: result.insertId.toString(), userId, barangId, status, alasan, date: new Date() });
  }

  async getHistoryById(id) {
    const [rows] = await pool.query('SELECT * FROM history WHERE id = ?', [id]);
    if (rows.length === 0) return null;
    return new History(rows[0]);
  }

  async updateHistory(id, data) {
    const history = await this.getHistoryById(id);
    if (!history) return null;
    const { status } = data;

    if (history.status === 'dipinjam' && status === 'dikembalikan') {
      await pool.query('UPDATE barang SET stok = stok + 1 WHERE id = ?', [history.barangId]);
    }

    await pool.query('UPDATE history SET status = ? WHERE id = ?', [status || history.status, id]);
    return this.getHistoryById(id);
  }

  async deleteHistory(id) {
    const [result] = await pool.query('DELETE FROM history WHERE id = ?', [id]);
    return result.affectedRows > 0;
  }
}

module.exports = HistoryUseCase;
