/**
 * Project Name: FIDS.
 * Date: 22/01/2021
 * Contact: Echelon Edge FIDS Development Team.
 * Copyright: Echelon Edge Pvt. Ltd.
 */

"use strict";

/**
 * Module dependencies.
 */
const jwt = require('jsonwebtoken');
const config = require('../utilities/config.json');
const connection = require('../utilities/sqlConnection');

/**
 * Global variable.
 */
const auth = {};




/**
 * Generate JWT here.
 * @Developer Shubham
 */
auth.generateJwt = (option,key) => {
    return jwt.sign({
        id: option.p_id,
        email: option.email,
        contactNumber: option.contactNumber,
        role: option.roleId,
        secret: key
    }, config.JWTSECRET, { expiresIn: "24h" });
}

/**
 * Verify JWT here
 *  @Developer Shubham
 */
auth.verifyAuthToken = (req, res, next) => {
    try {
        let token = req.headers.authorization;
        let secret = req.headers.sessionkey;
        if (typeof token !== 'undefined') {
            token = token.split(" ")[0];
            let decoded = jwt.verify(token, config.JWTSECRET);
            if (decoded.secret && decoded.secret === secret) {
                req.payload = decoded;
                next();
            } else {
                logoutFn(req)
                res.status(401).json({ msg: "Unauthorized request" });
            }
        } else {
            logoutFn(req);
            res.status(401).json({ msg: "Unauthorized request" });
        }
    } catch (error) {
        if (error.message === 'jwt expired') {
            logoutFn(req)
        }
        res.status(401).json({ "err":"X","response":{ msg: "Your session has been expired" }});
    }
}

/**
 * Logout function for session logout
 * @Developer Shubham, Avinash
 */
function logoutFn(req) {
    let token = req.headers.authorization;
    token = token.split(" ")[0];
    let payload = jwt.verify(token, config.JWTSECRET, { ignoreExpiration: true });
}








module.exports = auth;