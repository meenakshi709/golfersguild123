

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



function sendEmail() {
    console.log("inside send mail");
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
    var mailOptions = {
        from: "ankit.khandelwal@echelonedge.com",
        to: "ashish.kumar@echelonedge.com",
      
        subject: "test",
       
        text: "this is the test email with outlook",
     
    };
    smtpTransport.sendMail(mailOptions, function (error, response) {
        console.log("error======", error, "\nMessage sent: " + response);
        if (error) {
          
        } else {
            console.log("Message sent: " + response.message);
        
        }
    });
}




function test_mail() {
    let transporter = nodemailer.createTransport({
        service: "smtp.office365.com",
        port: 587,
        startls: true,
        auth: {
            user: "ankit.khandelwal@echelonedge.com",
            pass: "svjvkmfflpfffjqx"

        },
    });

    transporter.sendMail({
        from: 'ankit.khandelwal@echelonedge.com',
        to: 'ankit.khandelwal@echelonedge.com',
        // cc: options.cc,
        subject: "options.subject",
        html: "  my test mail",
        // attachDataUrls: true,
        // attachments: options.attachments
    },
        function (error, msg) {
            console.log(error)
            console.log(msg)
        }
    )
}


sendEmail();





return
mail.sendEmail = (email, options) => {
    return new Promise((resolve, reject) => {
        try {
            let transporter = nodemailer.createTransport({
                service: "smtp.office365.com",
                port: 587,
                startls: true,
                auth: {
                    user: "ankit.khandelwal@echelonedge.com",
                    pass: "svjvkmfflpfffjqx"

                },
            });
            // let transporter = nodemailer.createTransport({
            //     service: 'gmail',
            //     auth: {
            //         user: 'paypalshopping2021@gmail.com',
            //         pass: 'test123@A'
            //     }
            // });
            ejs.renderFile("views/" + options.template, options).then((resFile) => {
                transporter.sendMail({
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