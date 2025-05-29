const pool = require('../db');
const User = require('../entities/User');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const JWT_SECRET = 'your_jwt_secret'; // Ideally, use environment variable for this

class UserUseCase {
  async getAllUsers() {
    const [rows] = await pool.query('SELECT id, name, NPM FROM users');
    return rows.map(row => new User(row));
  }

  async createUser(data) {
    const { name, NPM, password } = data;
    const hashedPassword = await bcrypt.hash(password, 10);
    const [result] = await pool.query('INSERT INTO users (name, NPM, password) VALUES (?, ?, ?)', [name, NPM, hashedPassword]);
    return new User({ id: result.insertId.toString(), name, NPM, password: hashedPassword });
  }

  async getUserById(id) {
    const [rows] = await pool.query('SELECT id, name, NPM FROM users WHERE id = ?', [id]);
    if (rows.length === 0) return null;
    return new User(rows[0]);
  }

  async updateUser(id, data) {
    const user = await this.getUserById(id);
    if (!user) return null;
    const { name, NPM, password } = data;
    let hashedPassword = user.password;
    if (password) {
      hashedPassword = await bcrypt.hash(password, 10);
    }
    await pool.query('UPDATE users SET name = ?, NPM = ?, password = ? WHERE id = ?', [name || user.name, NPM || user.NPM, hashedPassword, id]);
    return this.getUserById(id);
  }

  async deleteUser(id) {
    const [result] = await pool.query('DELETE FROM users WHERE id = ?', [id]);
    return result.affectedRows > 0;
  }

  async register(data) {
    const { name, NPM, password } = data;
    // Check if user already exists
    const [existing] = await pool.query('SELECT id FROM users WHERE NPM = ?', [NPM]);
    if (existing.length > 0) {
      throw new Error('User already exists');
    }
    const hashedPassword = await bcrypt.hash(password, 10);
    const [result] = await pool.query('INSERT INTO users (name, NPM, password) VALUES (?, ?, ?)', [name, NPM, hashedPassword]);
    return new User({ id: result.insertId.toString(), name, NPM, password: hashedPassword });
  }

  async login(data) {
    const { NPM, password } = data;
    const [rows] = await pool.query('SELECT * FROM users WHERE NPM = ?', [NPM]);
    if (rows.length === 0) {
      throw new Error('Invalid NPM or password');
    }
    const user = rows[0];
    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      throw new Error('Invalid NPM or password');
    }
    const token = jwt.sign({ id: user.id, NPM: user.NPM }, JWT_SECRET, { expiresIn: '1h' });
    return { token, user: new User(user) };
  }
}

module.exports = UserUseCase;
