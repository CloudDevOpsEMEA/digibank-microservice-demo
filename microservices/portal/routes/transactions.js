module.exports = function (app, request) {
    app.post('/endpoints/transactions/get', function (req, res) {
        var options = {
            method: 'POST',
            uri: `http://${process.env.TRANSACTIONS_SERVICE_HOST}:${process.env.TRANSACTIONS_SERVICE_PORT}${process.env.GET_TRANSACTIONS_ENDPOINT}`,
            body: req.body,
            json: true
        };
        request.post(options, function (error, response, body) {
            console.log('transactions for ', req.body, ': ', body);
            res.send(body);
        });
    });
};
