# Inventory API

This is an Express.js API for inventory management with the following tables:
- User
- Barang (items) with attributes: nama, gambar, kategori, stok
- History with status attribute (e.g., dipinjam)

## Features

- CRUD operations for users, barang, and history
- Image upload support for barang using multer
- MySQL database integration (using mysql2)
- Clean architecture design

## Setup

1. Install dependencies:
   ```
   npm install
   ```

2. Create an `uploads` folder in the project root to store uploaded images:
   ```
   mkdir uploads
   ```

3. Setup MySQL database:
   - Create a database named `inventory_db`
   - Run the SQL schema in `SQL_SCHEMA.md` to create tables
   - You can use phpMyAdmin to manage the database

4. Update database connection settings in `db.js` if needed (default is localhost, root user, no password)

5. Start the server:
   ```
   npm start
   ```

6. The API will be running at `http://localhost:3000`

## API Endpoints

- Users: `/users`
- Barang: `/barang`
- History: `/history`

## Notes

- Image files are stored in the `uploads` folder.
- This API uses MySQL for data persistence and can be managed via phpMyAdmin.
