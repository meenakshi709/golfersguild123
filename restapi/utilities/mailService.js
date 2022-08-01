

 "use strict"

 /**
  * Module dependencies.
  */
 const nodemailer = require('nodemailer');
 const ejs = require('ejs');
 //const config = require('./config.json');
 
 /**
  * Global varaiable.
  */
 let mail = {};
 
 /**
  * Email send method
  * @Developer Avinash, Shubham
  * @param email
  * @param options
  * @return {err}
  * @return {Mail Sent}
  */
 mail.sendEmail = (email, options) => {
     return new Promise((resolve, reject) => {
         try {
             let transporter = nodemailer.createTransport({
                // host: config.SMTP_HOST,
                 //port: config.SMTP_PORT,
                 pool: true,
                 secure: true,
                 service:"gmail",
                 auth: {
                     user: "meenakshi@echelonedge.com",
                     pass: "Aarav@1234"
                 },
                 tls: {
                     rejectUnauthorized: false
                 }
             });
             ejs.renderFile("views/" + options.template, options).then((resFile) => {
                 transporter.sendMail({
                     from: '"Golfersguild"<sender@example.com>',
                     to: email,
                     cc: options.cc,
                     subject: options.subject,
                     html: resFile,
                     attachDataUrls: true,
                     attachments: options.attachments
                 }).then((response) => {
                     resolve(response);
                 }).catch((error) => {
                     console.log(error);
                     reject(error);
                 });
             }).catch((error) => {
                 console.log(error);
                 reject(error);
             });
         } catch (error) {
             console.log(error);
             reject(error)
         }
     });
 }
 
 module.exports = mail;