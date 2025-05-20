class History {
  constructor({ id, userId, barangId, status, alasan, date }) {
    this.id = id;
    this.userId = userId;
    this.barangId = barangId;
    this.status = status;
    this.alasan = alasan;
    this.date = date;
  }
}

module.exports = History;
