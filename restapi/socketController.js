var socketCtrl = {};
const connection = require('../restapi/utilities/sqlConnection').connection;
const auth = require("../restapi/utilities/authService");
const config = require('../restapi/utilities/config.json');

const mail = require('../restapi/utilities/mailService');



  var socket;

var devices = [];
var rooms = [];
var io;
  socketCtrl.socketConnection=(connection,i1)=>{
    try { 
            socket=connection;
            io=i1;
            console.log(socket);

    } catch (error) {
        // console.log("socketConnection catch ", error);
    }
  }

  socketCtrl.disconnectdevice=(socketId)=>{
    const removeIndex = devices.findIndex(item => item.socketId == socketId);
    // console.log(removeIndex);
    let group=devices[removeIndex];
     if(group && group.groupId){
      let updatedroom=rooms.filter(e=>e==group.groupId);
      let dev=devices.filter(e=> e.groupId==group.groupId);
        // remove object
        devices.splice(removeIndex,1);
      if(dev.length==1){
       
            socket.leave(group.groupId);
          }
          if(updatedroom.length==1){
            const index = rooms.indexOf(updatedroom[0]);
            if (index > -1) {
                rooms.splice(index, 1);
            }
          }
         
          // socket.broadcast.emit('lostdevice',  socketId + ' has disconnected from this group');
         }
        //  console.log("disconnected-------->",socketId);
         socket.emit('lostDevice', "device disconnected");
        //  console.log("eve
        }


        socketCtrl.registeredDevices=()=>{
            if (typeof socket !== 'undefined'  && socket !== null) {
                socket.on("registeredDevices",(deviceid)=>{
                    let sqlConnection=`call get_socket_updates_detail('${deviceid}');`
                    connection.query(sqlConnection,function(error,result){
                            if(error){
                                    // console.log(error);
                               }else{
                                   if(result[0].length!=0){
                                     let devicedetails={
                                      'deviceid':result[0][0].deviceid,
                                      'groupId':result[0][0].groupId
                                     }
                                     adddevice(devicedetails);
                                    socket.emit('returnRegisteredDevices', result[0]);
                                   }else{
                                    socket.emit('returnRegisteredDevices',result[0]);
                                   }
                               }
                    })
                })
                
            }
        }

module.exports = socketCtrl;
