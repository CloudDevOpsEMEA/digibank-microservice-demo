module.exports = function (app) {
  app.get('/health', function (req, res) {
    res.status(200).send({'message': 'Still healthy!'});
  });
}
