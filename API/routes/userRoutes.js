const express = require('express');
const UserController = require('../controllers/userController');
const UserUseCase = require('../usecases/userUseCase');

const router = express.Router();
const userUseCase = new UserUseCase();
const userController = new UserController(userUseCase);

router.get('/', userController.getAllUsers);
router.post('/', userController.createUser);
router.get('/:id', userController.getUserById);
router.put('/:id', userController.updateUser);
router.delete('/:id', userController.deleteUser);

// New routes for register and login
router.post('/register', userController.register);
router.post('/login', userController.login);

module.exports = router;
