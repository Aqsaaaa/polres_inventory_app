const express = require('express');
const HistoryController = require('../controllers/historyController');
const HistoryUseCase = require('../usecases/historyUseCase');

const router = express.Router();
const historyUseCase = new HistoryUseCase();
const historyController = new HistoryController(historyUseCase);

router.get('/', historyController.getAllHistory);
router.post('/', historyController.createHistory);
router.get('/:id', historyController.getHistoryById);
router.put('/:id', historyController.updateHistory);
router.delete('/:id', historyController.deleteHistory);

module.exports = router;
