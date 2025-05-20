class HistoryController {
  constructor(historyUseCase) {
    this.historyUseCase = historyUseCase;
  }

  getAllHistory = async (req, res) => {
    const historyList = await this.historyUseCase.getAllHistory();
    if (historyList.length === 0) return res.status(404).json({ message: 'History record not found' });
    res.json(historyList);
  };

  createHistory = async (req, res) => {
    const { userId, barangId, status, alasan } = req.body;
    const history = await this.historyUseCase.createHistory({ userId, barangId, status, alasan });
    res.status(201).json(history);
  };

  getHistoryById = async (req, res) => {
    const history = await this.historyUseCase.getHistoryById(req.params.id);
    if (!history) return res.status(404).json({ message: 'History record not found' });
    res.json(history);
  };

  updateHistory = async (req, res) => {
    const { status, alasan } = req.body;
    const history = await this.historyUseCase.updateHistory(req.params.id, { status, alasan });
    if (!history) return res.status(404).json({ message: 'History record not found' });
    res.json(history);
  };

  deleteHistory = async (req, res) => {
    const success = await this.historyUseCase.deleteHistory(req.params.id);
    if (!success) return res.status(404).json({ message: 'History record not found' });
    res.status(204).send();
  };
}

module.exports = HistoryController;
