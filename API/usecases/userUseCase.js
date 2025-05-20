const pool = require('../db');
const User = require('../entities/User');

class UserUseCase {
  async getAllUsers() {
    const [rows] = await pool.query('SELECT * FROM users');
    return rows.map(row => new User(row));
  }

  async createUser(data) {
    const { name, email } = data;
    const [result] = await pool.query('INSERT INTO users (name, email) VALUES (?, ?)', [name, email]);
    return new User({ id: result.insertId.toString(), name, email });
  }

  async getUserById(id) {
    const [rows] = await pool.query('SELECT * FROM users WHERE id = ?', [id]);
    if (rows.length === 0) return null;
    return new User(rows[0]);
  }

  async updateUser(id, data) {
    const user = await this.getUserById(id);
    if (!user) return null;
    const { name, email } = data;
    await pool.query('UPDATE users SET name = ?, email = ? WHERE id = ?', [name || user.name, email || user.email, id]);
    return this.getUserById(id);
  }

  async deleteUser(id) {
    const [result] = await pool.query('DELETE FROM users WHERE id = ?', [id]);
    return result.affectedRows > 0;
  }
}

module.exports = UserUseCase;
