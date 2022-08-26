

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
 * @Developer 
 * @param email
 * @param options
 * @return {err}
 * @return {Mail Sent}
 */



// function sendEmail() {
//     console.log("inside send mail");
//     var smtpTransport = nodemailer.createTransport({
//         // service: "Gmail",
//         // host: "smtp-mail.outlook.com",
//         host: "smtp.office365.com",
//         port: 587,
//         // secure: false,
//         secureConnection: false,
//         STARTTLS: true,
//         auth: {
//      user: "ankit.khandelwal@echelonedge.com",
//             pass: "svjvkmfflpfffjqx"

//         },
//   
//     });
//     var mailOptions = {
//         from: "ankit.khandelwal@echelonedge.com",
//         to: "ashish.kumar@echelonedge.com",
//       
//         subject: "test",
//        
//         text: "this is the test email with outlook",
//      
//     };
//     smtpTransport.sendMail(mailOptions, function (error, response) {
//         console.log("error======", error, "\nMessage sent: " + response);
//         if (error) {
//           
//         } else {
//             console.log("Message sent: " + response.message);
//         
//         }
//     });
// }







// sendEmail();






mail.sendEmail = (email, options) => {
    return new Promise((resolve, reject) => {
        try {
            var smtpTransport = nodemailer.createTransport({
                        // service: "Gmail",
                        // host: "smtp-mail.outlook.com",
                        host: "smtp.office365.com",
                        port: 587,
                        // secure: false,
                        secureConnection: false,
                        STARTTLS: true,
                        auth: {
                     user: "ankit.khandelwal@echelonedge.com",
                            pass: "svjvkmfflpfffjqx"
                
                        },
                  
                    });
            ejs.renderFile("views/" + options.template, options).then((resFile) => {
                smtpTransport.sendMail({
                    from: 'ankit.khandelwal@echelonedge.com',
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