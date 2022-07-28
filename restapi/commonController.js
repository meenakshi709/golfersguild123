const connection = require('../restapi/utilities/sqlConnection').connection;
const auth = require("../restapi/utilities/authService");
const config = require('../restapi/utilities/config.json');
const commonCtrl = {};
const mail = require('../restapi/utilities/mailService');

// This API use for get data  purpose

/**
 * User login api.
 * @requiredField email,password
 * @Developer Echelon Team
 */

//get all industry list
commonCtrl.industryList = (req, res) => {
    try {
        const data = req.body;
        let sql = "call getIndustryListing()";
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



//get all states

commonCtrl.getStates = (req, res) => {

    try {
     
        let sql = `call getStateListing("${req.query.countryId}")`;
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


//get all country

commonCtrl.getCountryList = (req, res) => {

    try {
        const data = req.body;
        let sql = "call getCountryList()";
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



//get all course

commonCtrl.course =(req, res) => {

    try {
    
        let sql = `call getCourseListing("${req.query.cid}")`;
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

commonCtrl.courseList =(req, res) => {

    try {
    
        let sql = `call getCourseList()`;
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



//show all products
commonCtrl.score = (req, res) => {
    try {

    let sql = "call getTournmentScoreList()";
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






commonCtrl.deleteScore= (req, res) => {
    try {
        let sql = `call delete_score("${req.query.scoreId}")`;
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




// contact quert form 


commonCtrl.contactdetails=(req, res) => {
    try {
        const data = req.body;
        let sql = `call saveContactQuery("${data.name}","${data.email}", "${data.phn}", "${data.subject}","${data.msg}")`;
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





commonCtrl.tourDetails =(req, res) => {

    try {
    
        let sql = `call getTournamentAndRoundDetail()`;
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



commonCtrl.getAdvertisementList = (req, res) => {
    try {
        let sql = `call getAdvertisementList()`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            }
            else {

                res.send(JSON.stringify({ "error": "", "response": { result: results[0]} }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};






commonCtrl.getSponserList = (req, res) => {
    try {
        let sql = `call getSponserList()`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            }
            else {

                res.send(JSON.stringify({ "error": "", "response": { result: results[0]} }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};



// add update client 
commonCtrl.addUpdateClient = (req, res) => {
try {
    const data = req.body;
    let addUpdateSql = `Call add_update_client("${data.clientId}","${data.clientName}", "${data.clientEmail}", "${data.clientAddress}","${data.clientContact}","${data.logo}","${data.clientCode}" )`;
    connection.query(addUpdateSql, function (error, results) {
        releaseconnection();
        if (error) {
            res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
        } else {
            res.send(JSON.stringify({ "error": "", "response": { result: results[0] } }));
        }
    });
} catch (error) {
    res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
}
};



// common 

function releaseconnection() {
    connection.getConnection(function (err, result) {
        result.release();
    })
}





module.exports = commonCtrl;