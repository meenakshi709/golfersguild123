const connection = require('../restapi/utilities/sqlConnection').connection;


const courseCtrl = {};


courseCtrl.getTeeColors = (req, res) => {
    try {

        let sql = `call getTeeColors()`;

        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            } else {
                res.send(JSON.stringify({ "error": "", "response": { result: results[0] } }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};


function releaseconnection() {
    connection.getConnection(function (err, result) {
        result.release();
    })
}





module.exports = courseCtrl;
;