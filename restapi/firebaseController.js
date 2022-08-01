const admin=require('firebase-admin');
const serviceAccount=require('../restapi/firebase/golfersguild-firebase-adminsdk-1lixa-c0ec761dbd.json');
const firebaseCtrl = {};


admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
    });
    const db = admin.firestore();


    firebaseCtrl.savedata=(value)=>{
        return new Promise(function(resolve, reject) {
                db.collection('golfScore').doc(`${value.tour_id}`).set(value).then((result) =>{
               //     console.log('new Dialogue written to database'));
            
                        if(result){
                               console.log("result",result)
                            resolve("createdddddddddddd")
                         }else{
                             console.log("reje",result);
                            reject("not created ")
                         }
                 });
            console.log(value);
              
        }) 
      }


    //   firebaseCtrl.updateData=(value)=>{
    //     return new Promise(function(resolve,reject){
    //          db.collection('golfScore').doc(`${value.tour_id}`).update(value).then((result)=>{
    //             if (result) {
    //                  resolve("Updated");
    //                } else {
    //                 resolve("Not updated");
    //                }
    //         })
    //     })
    // }




module.exports = firebaseCtrl;