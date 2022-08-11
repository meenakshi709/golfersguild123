const connection = require('../restapi/utilities/sqlConnection').connection;


const courseCtrl = {};


//add course

courseCtrl.addCourse = (req, res) => {
    try {

        const data = req.body;

    let sql = `Call saveCourseDetails("${data.cid}","${data.cname}", "${data.caddress}", "${data.par1}", "${data.par2}", "${data.par3}", "${data.par4}", "${data.par5}", "${data.par6}", "${data.par7}", "${data.par8}", "${data.par9}", "${data.par10}", "${data.par11}", "${data.par12}", "${data.par13}", "${data.par14}", "${data.par15}", "${data.par16}", "${data.par17}", "${data.par18}", "${data.pinn}", "${data.pout}", "${data.hdcp1}", "${data.hdcp2}", "${data.hdcp3}", "${data.hdcp4}", "${data.hdcp5}", "${data.hdcp6}", "${data.hdcp7}", "${data.hdcp8}", "${data.hdcp9}", "${data.hdcp10}", "${data.hdcp11}", "${data.hdcp12}", "${data.hdcp13}", "${data.hdcp14}", "${data.hdcp15}", "${data.hdcp16}", "${data.hdcp17}", "${data.hdcp18}","${data.courseRating}","${data.slopeRating}","${data.colorId}")`;
    

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


//Delete course



courseCtrl.deleteCourse = (req, res) => {
    try {
        let sql = `call delete_course("${req.query.courseId}")`;
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
