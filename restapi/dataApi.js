const express = require('express');
// const router = express();
var path = require('path');
// const bodyParser = require('body-parser');
const router = express.Router();
const mysql = require('mysql');
//create database connection
const conn = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'golfersguild'
});


const mail = require('../restapi/utilities/mailService');
//const uploads=require('../restapi/uploads');
//connect to database
conn.connect((err) => {
    if (err) throw err;
    console.log('Mysql Connected...1234');
});











//add new product
// router.post('/contactdetails', (req, res) => {

  

//     let sql = "INSERT INTO contact (gname, gemail, phone, subject, msg) VALUES ('" + req.body.gname + "','" + req.body.gemail + "','" + req.body.phone + "','" + req.body.subject + "','" + req.body.msg + "');";
//     let query = conn.query(sql, (err, results) => {
//         if (err) throw err;
//         res.send(JSON.stringify({ "status": 200, "error": "", "response": results }));
//     });
// });



// Purpose:Tournament API
router.get('/getGroupList', (req, res) => {
    let sql = `call getGroupDetails()`;
    let query = conn.query(sql, (err, results) => {
        if (err) throw err;
        res.send(JSON.stringify({ "error": "", "result": results[0] }));
    });
});

// router.post('/saveTournamentDetails', (req, res) => {
//     const data = req.body;
//     let sql = `call saveTournamentDetails("${data.tournamentId}","${data.tournamentName}")`;
//     let query = conn.query(sql, (err, results) => {
//         if (err) throw err;
//         res.send(JSON.stringify({ "error": "", "result": results[0][0] }));
//     });
// });








module.exports = router;

