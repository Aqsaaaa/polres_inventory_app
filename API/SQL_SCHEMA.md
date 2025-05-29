# MySQL Database Schema for Inventory API

Run the following SQL commands in your MySQL database (e.g., via phpMyAdmin) to create the necessary tables:

```sql
CREATE DATABASE IF NOT EXISTS inventory_db;
USE inventory_db;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  NPM VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL
);

CREATE TABLE barang (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(255) NOT NULL,
  gambar VARCHAR(255),
  kategori VARCHAR(255),
  stok INT DEFAULT 0
);

CREATE TABLE history (
  id INT AUTO_INCREMENT PRIMARY KEY,
  userId INT NOT NULL,
  barangId INT NOT NULL,
  status VARCHAR(255) NOT NULL,
  alasan VARCHAR(255),
  date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (barangId) REFERENCES barang(id) ON DELETE CASCADE
);
```

Make sure your MySQL user has the necessary privileges to create databases and tables.

You can manage this database using phpMyAdmin by importing this schema or running the SQL commands directly.
