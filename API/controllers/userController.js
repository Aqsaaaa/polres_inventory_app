class UserController {
  constructor(userUseCase) {
    this.userUseCase = userUseCase;
  }

  getAllUsers = async (req, res) => {
    const users = await this.userUseCase.getAllUsers();
    res.json(users);
  };

  createUser = async (req, res) => {
    const user = await this.userUseCase.createUser(req.body);
    res.status(201).json(user);
  };

  getUserById = async (req, res) => {
    const user = await this.userUseCase.getUserById(req.params.id);
    if (!user) return res.status(404).json({ message: 'User not found' });
    res.json(user);
  };

  updateUser = async (req, res) => {
    const user = await this.userUseCase.updateUser(req.params.id, req.body);
    if (!user) return res.status(404).json({ message: 'User not found' });
    res.json(user);
  };

  deleteUser = async (req, res) => {
    const success = await this.userUseCase.deleteUser(req.params.id);
    if (!success) return res.status(404).json({ message: 'User not found' });
    res.status(204).send();
  };

  register = async (req, res) => {
    try {
      const user = await this.userUseCase.register(req.body);
      res.status(201).json(user);
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  };

  login = async (req, res) => {
    try {
      const { token, user } = await this.userUseCase.login(req.body);
      res.json({ token, user });
    } catch (error) {
      res.status(401).json({ message: error.message });
    }
  };
}

module.exports = UserController;
