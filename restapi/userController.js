const connection = require('../restapi/utilities/sqlConnection').connection;
const auth = require("../restapi/utilities/authService");
const config = require('../restapi/utilities/config.json');
const usrCtrl = {};
const mail = require('../restapi/utilities/mailService');

// This API use for login purpose

/**
 * User login api.
 * @requiredField email,password
 * @Developer Meenaxi 
 */
usrCtrl.userlogin = (req, res) => {
    try {
        const data = req.body;
        let sql = `Call user_login("${data.email}", "${data.password}","")`;
        if (data.isWebLogin == 1) {
            sql = `Call user_login("${data.email}", "${data.password}",${data.isWebLogin})`;
        }

        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            } else {
                if (results[1][0]?.err == '') {

                    const key = config.JWTSECRET;
                    let token = auth.generateJwt(results[0][0], key);
                    res.end(JSON.stringify({ "error": "", "response": { result: results[0], msg: results[1].msg, "token": token, "sessionKey": key } }));
                } else {
                    res.end(JSON.stringify({ "error": "X", "response": { msg: results[0][0].msg } }));
                }
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "error": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};

/**
 * Registration/Save userDetails api.
 * @requiredField p_id, firstName, lastName, username, email, contactNumber, password , dob
, gender, homeCourse, hdcp, hdcpCertificate , platformLink , vaccineStatus, employment ,
company , jobTitle, industry, countryId, stateId , profileImg, is_FirstLogin, is_WebLogin
 * @Developer Echelon Team
 */

usrCtrl.addUpdateUser = (req, res) => {
    try {
        const data = req.body;
        let addUpdateSql = `Call save_user_details("${data.playerId}","${data.firstName}", "${data.lastName}", "${data.roleId}", "${data.userName}","${data.email}", "${data.contactNumber}","${data.password}","${data.dob}","${data.gender}", "${data.homeCourse}", "${data.hdcp}","${data.hdcpCertificate}", "${data.platformLink}", "${data.vaccineStatus}",  "${data.employment}",  "${data.company}",  "${data.jobTitle}",  "${data.industry}",  "${data.countryId}",  "${data.stateId}",  "${data.profileImg}",  "${data.is_FirstLogin}",  "${data.is_WebLogin}" ,  "${data.device_id}" ,  "${data.device_platform}"   )`;
        connection.query(addUpdateSql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            } else {
                res.end(JSON.stringify({ "error": "", "response": results[0] }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};
/**
 * refresh token api.
 * @requiredField N/A
 * @Developer Echelon Team
 */
usrCtrl.refreshToken = (req, res) => {
    try {
        let tokenExpiryTime = req.payload.exp;
        let oldDate = new Date(0).setUTCSeconds(tokenExpiryTime);
        if ((oldDate - new Date().getTime()) / 1000 <= 120) {
            let option = {
                USR_ID: req.payload.id,
                USR_FULL_NAME: req.payload.fullName,
                USR_EMAIL_ID: req.payload.email,
                USR_CONTACT_NUMBER: req.payload.contactNumber,
                USR_ROLE_ID: req.payload.role
            }
            let token = auth.generateJwt(option, req.headers.sessionKey);
            res.end(JSON.stringify({ "err": '', "response": { token: token } }));
        } else {
            res.end(JSON.stringify({ "err": 'X', "response": { msg: "Current token is still active. New token cant be generated now." } }));
        }
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
}

/**
 * send otp to verify mail.
 * @requiredField N/A
 * @Developer Echelon Team
 */
usrCtrl.verifyUserAccount = (req, res) => {
    try {
        const data = req.body;
        let sql = `Call verify_User_Account("${data.p_id}")`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            } else {
                let option = {
                    template: "otp.ejs",
                    subject: "Verification Mail",
                    name: results[0][0].usrName,
                    otp: results[0][0].otp
                }
                mail.sendEmail(results[0][0].emailAddress, option).then((response) => {
                    res.end(JSON.stringify({ "err": "", "response": { result: {}, "msg": "OTP has been sent successfully to your registered Email ID" } }));
                }).catch((error) => {
                    res.end(JSON.stringify({ "err": "X", "response": { "msg": "Contact Developer " + error } }));
                });
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};


/**
 *  verify otp api.
 * @requiredField N/A
 * @Developer Echelon Team
 */
usrCtrl.verifyOTP = (req, res) => {
    try {
        const data = req.body;
        let sql = `Call check_otp("${data.p_id}","${data.otp}"  )`;
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

// send password to reset


usrCtrl.forgotPassword = (req, res) => {
    try {
        const data = req.body;


        let sql = `Call user_forgot_password("${data.email}")`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            } else {
                if (results[0][0].err == "") {
                    let option = {
                        template: "forgotpwd.ejs",
                        subject: "Reset Password",
                        name: results[0][0].usrName,
                        otp: results[0][0].passCode
                    }
                    mail.sendEmail(results[0][0].emailAddress, option).then((response) => {
                        res.end(JSON.stringify({ "err": "", "response": { "msg": "password has been sent successfully to your registered Email ID" } }));
                    }).catch((error) => {
                        res.end(JSON.stringify({ "err": "X", "response": { "msg": "Contact Developer " + error } }));
                    });
                }
                else {
                    res.end(JSON.stringify({ "err": "X", "response": { "result": results[0][0] } }));
                }

            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};





// change password

usrCtrl.changePassword = (req, res) => {
    try {
        const data = req.body;

        let sql = `Call user_change_password("${data.email}","${data.passcode}","${data.newPassword}")`;
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


// get user details

usrCtrl.getUserDetails = (req, res) => {

    try {

        let sql = `call getUserDetails(${req.query.playerId})`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            } else {
                res.send(JSON.stringify({ "error": "", "response": { result: results[0][0], scoreDiff: results[1][0] } }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};








//get all players

usrCtrl.getPlayersList = (req, res) => {
    try {

        let sql = "call getPlayerListing()";
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            } else {
                res.end(JSON.stringify({ "error": "", "response": { result: results[0] } }));
            }
        });
    }
    catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};





usrCtrl.deletePlayer = (req, res) => {
    try {

        let sql = `call delete_player("${req.query.playerId}")`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            } else {
                res.end(JSON.stringify({ "error": "", "response": results[0][0] }));
            }
        });
    }
    catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};



usrCtrl.getUserRole = (req, res) => {
    try {

        let sql = `call getUserRole()`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            } else {
                res.end(JSON.stringify({ "error": "", "response": { result: results[0] } }));
            }
        });
    }
    catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};

// profile image 

usrCtrl.addUpdateProfilePic = (req, res) => {
    try {

        uploadMedia(req);
        const data = req.body;
        let addUpdateSql = `Call save_user_picture("${data.p_id}", "${data.profileImg}"  )`;
        connection.query(addUpdateSql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            } else {
                res.end(JSON.stringify({ "error": "", "response": results[0] }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};



function uploadMedia(req) {
    let uploadPath;
    if (!req.files || Object.keys(req.files).length == 0) {
        res.end(JSON.stringify({ 'error': "X", 'msg': "No files were uploaded. " + '' }));
        return 0;
    } else {
        uploadPath = constants + req.files.fileName['name'];

        const abc = req.files.fileName.mv(uploadPath, function (err) {
            if (err) {

                res.end(JSON.stringify({ 'error': "X", 'msg': "Something went wrong" + err }));
                return 0;
            } else {
                return 1;
            }
        });
    }
}


/**
 * Purpose connection release 
 */
function releaseconnection() {
    connection.getConnection(function (err, result) {
        result.release();
    })
}

module.exports = usrCtrl;