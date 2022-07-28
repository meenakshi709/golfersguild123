/**
 * Project Name: FIDS.
 * Date: 22/01/2021
 * Author: Mohit
 * Contact: Echelon Edge FIDS Development Team.
 * Copyright: Echelon Edge Pvt. Ltd.
 */

"use strict";

/**
 * Module dependencies.
 */
const fs = require("fs");
const mysql = require("mysql");
let config = fs.readFileSync("connectionString.txt", "utf8");

// create mysql connection pool
const connection = mysql.createPool(JSON.parse(config));

//get connection from connection pool
connection.getConnection(function (err, data) {
    if (err) throw err;
    // console.log("Database", data.state, ", id", data.threadId)
});

// "host":"157.119.124.180",  old ip 
// "host":"192.168.100.159",New db ip
module.exports = {
    connection
};