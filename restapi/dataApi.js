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











//add course
router.post('/addCourse', (req, res) => {
    const data = req.body;

    let sql = `Call saveCourseDetails("${data.cid}","${data.cname}", "${data.caddress}", "${data.par1}", "${data.par2}", "${data.par3}", "${data.par4}", "${data.par5}", "${data.par6}", "${data.par7}", "${data.par8}", "${data.par9}", "${data.par10}", "${data.par11}", "${data.par12}", "${data.par13}", "${data.par14}", "${data.par15}", "${data.par16}", "${data.par17}", "${data.par18}", "${data.pinn}", "${data.pout}", "${data.hdcp1}", "${data.hdcp2}", "${data.hdcp3}", "${data.hdcp4}", "${data.hdcp5}", "${data.hdcp6}", "${data.hdcp7}", "${data.hdcp8}", "${data.hdcp9}", "${data.hdcp10}", "${data.hdcp11}", "${data.hdcp12}", "${data.hdcp13}", "${data.hdcp14}", "${data.hdcp15}", "${data.hdcp16}", "${data.hdcp17}", "${data.hdcp18}")`;
    //  let sql = "INSERT INTO courses (cid,cname, caddress, pa1,par2,par3,par4,par5,par6,par7,par8,par9,par10,par11,par12,par13,par14,par15,par16,par17,par18,pinn,pout,hdcp1,hdcp2,hdcp3,hdcp4,hdcp5,hdcp6,hdcp7,hdcp8,hdcp9,hdcp10,hdcp11,hdcp12,hdcp13,hdcp14,hdcp15,hdcp16,hdcp17,hdcp18) VALUES ('"+data.cid+"','"+data.courseName+"','"+data.courseAddress+"','"+data.par1+"','"+data.par2+"','"+data.par3+"','"+data.par4+"','"+data.par5+"','"+data.par6+"','"+data.par7+"','"+data.par8+"','"+data.par9+"','"+data.par10+"','"+data.par11+"','"+data.par12+"','"+data.par13+"','"+data.par14+"','"+data.par15+"',,'"+data.par16+"','"+data.par17+"','"+data.par18+"','"+data.pinn+"','"+data.pout+"','"+data.hdcp1+"','"+data.hdcp1+"','"+data.hdcp1+"','"+data.hdcp2+"','"+data.hdcp3+"','"+data.hdcp4+"','"+data.hdcp5+"','"+data.hdcp6+"','"+data.hdcp7+"','"+data.hdcp8+"','"+data.hdcp9+"','"+data.hdcp10+"','"+data.hdcp11+"','"+data.hdcp12+"','"+data.hdcp13+"','"+data.hdcp14+"','"+data.hdcp15+"','"+data.hdcp16+"','"+data.hdcp17+"','"+data.hdcp18+"');";


    let query = conn.query(sql, (err, results) => {
        if (err) throw err;
        res.send(JSON.stringify({ "error": "", "result": results[0][0] }));
    });
});






//Delete course
router.get('/deleteCourse', (req, res) => {
    let sql = `call delete_course("${req.query.courseId}")`;
    let query = conn.query(sql, (err, results) => {
        if (err) throw err;
        res.send(JSON.stringify({ "error": "", "result": results[0][0] }));
    });
});


// Purpose:Tournament API
router.get('/getGroupList', (req, res) => {
    let sql = `call getGroupDetails()`;
    let query = conn.query(sql, (err, results) => {
        if (err) throw err;
        res.send(JSON.stringify({ "error": "", "result": results[0] }));
    });
});

router.post('/saveTournamentDetails', (req, res) => {
    const data = req.body;
    let sql = `call saveTournamentDetails("${data.tournamentId}","${data.tournamentName}")`;
    let query = conn.query(sql, (err, results) => {
        if (err) throw err;
        res.send(JSON.stringify({ "error": "", "result": results[0][0] }));
    });
});








module.exports = router;

