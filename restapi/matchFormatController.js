const connection = require('../restapi/utilities/sqlConnection').connection;
const auth = require("../restapi/utilities/authService");
const config = require('../restapi/utilities/config.json');
const formatCtrl = {};
const mail = require('../restapi/utilities/mailService');

// This API use for login purpose

/**
 * User login api.
 * @requiredField email,password
 * @Developer Meenakshi
 */

 formatCtrl.addEditStablefordPoints = (req, res) => {
    try {
        const data = req.body;
        let sql = `Call saveStablefordPoint("${data.pointId}", "${data.netScoreName}", "${data.netScorePoints}", "${data.points}")`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            } else {
                res.send(JSON.stringify({ "error": "", "response": { result: results[0][0] } }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};


//get  stableford  ponits details
formatCtrl.getStablefordPoints= (req, res) => {

    try {

        let sql = `call getStablefordPoints()`;
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


//delete tournament format details
formatCtrl.deleteStablefordPoint = (req, res) => {
    try {
        let sql = `call delete_stablefordPoint("${req.query.ponitId}")`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            }
            else {
                res.send(JSON.stringify({ "error": "", "response": { result: results[0][0] } }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};



//get  tournament format details
formatCtrl.getTournamentFormat = (req, res) => {
    try {
        let sql = `call getTournamentFormats()`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            }
            else {
                res.send(JSON.stringify({ "error": "", "response": { result: results[0] } }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};


//
//save tournament format details
formatCtrl.addEditTournamentFormat = (req, res) => {
    try {
        const data = req.body;
        let sql = `call saveTournamentFormat("${data.formatId}","${data.formatName}")`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            }
            else {
                res.send(JSON.stringify({ "error": "", "response": { result: results[0][0] } }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};

//delete tournament format details
formatCtrl.deleteTournamentFormat = (req, res) => {
    try {
        let sql = `call delete_TournamentFormat("${req.query.formatId}")`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            }
            else {
                res.send(JSON.stringify({ "error": "", "response": { result: results[0][0] } }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};


//get handicap score details
formatCtrl.getHandicapScores = (req, res) => {
    try {
        let sql = `call getHandicapScores("${req.query.player_Id}","${req.query.isRecentScore}")`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            }
            else {
                if (results[2].length > 0) {
                    results[2].map(item => {
                        item.selected = false;
                        if (results[0].length > 0) {
                            results[0].map(record => {
                                if (item.tour_score_id == record.tour_score_id) {
                                    item.selected = true;
                                }
                            });
                        }
                    });
                    res.send(JSON.stringify({ "error": "", "response": { result: results[2],scoreCount:results[1][0] } }));
                }
                else{
                    res.send(JSON.stringify({ "error": "", "response": { result: [],scoreCount:{scoreCount:0} } }));
                }
               
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};







/**
 * Purpose connection release 
 */
 function releaseconnection() {
    connection.getConnection(function (err, result) {
        result.release();
    })
}

module.exports = formatCtrl;