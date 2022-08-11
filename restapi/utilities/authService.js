
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




auth.generateJwt = (option,key) => {
    return jwt.sign({
        id: option.p_id,
        email: option.email,
        contactNumber: option.contactNumber,
        role: option.roleId,
        secret: key
    }, config.JWTSECRET, { expiresIn: "24h" });
}

auth.verifyAuthToken = (req, res, next) => {
    try {
        let token = req.headers.authorization;
        let secret = config.JWTSECRET;
        if (typeof token !== 'undefined') {
            token = token.split(" ")[1];
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


function logoutFn(req) {
    let token = req.headers.authorization;
    token = token.split(" ")[0];
    let payload = jwt.verify(token, config.JWTSECRET, { ignoreExpiration: true });
}








module.exports = auth;