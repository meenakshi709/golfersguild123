const connection = require('../restapi/utilities/sqlConnection').connection;
const auth = require("../restapi/utilities/authService");
const config = require('../restapi/utilities/config.json');
const tourCtrl = {};
const mail = require('../restapi/utilities/mailService');
// const firebaseCtrl=require('../restapi/firebaseController')

// This API use for get data  purpose

/**
 * User login api.
 * @requiredField email,password
 * @Developer Meenakshi
 */


//save all events and round


tourCtrl.saveEventDetails = (req, res) => {
    try {
        const data = req.body;
        if (data && data.eventDetailsArr.length > 0) {
            let roundData = "";
            data.eventDetailsArr[0].roundsArray.filter((roundeDetails, index) => {
                const roundName = 'Round' + (index + 1);
                if (index == 0) {
                    roundData = `${roundeDetails.eventDate}/${roundeDetails.cname}/${roundName}`;
                } else {
                    roundData = roundData + ',' + ` ${roundeDetails.eventDate}/${roundeDetails.cname}/${roundName}`;
                }
            });
            data.eventDetailsArr.filter((item, eventIndex) => {

                let event = `call saveEventDetails("${item.tourID}","${item.tournamentName}","${item.eventType}","${item.numRounds}","${item.startDate}","${item.endDate}","${item.holes}","${roundData}")`;

                connection.query(event, function (error, results) {
                    if (error) {
                        res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
                    } else {
                        releaseconnection();
                        res.send(JSON.stringify({ "error": "", "response": { result: results[0][0] } }));
                    }

                });

            });

        }
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }

}

tourCtrl.tournamentInvitation = (req, res) => {
    try {
        const data = req.body;
        if (data.selectedPlayerList.length > 0) {
            data.selectedPlayerList.forEach((element, index) => {


                let sql = `Call saveTournamentPlayers("${data.tournamentId}","${element}","0","1","0","0","0","0")`;
                connection.query(sql, function (error, results) {
                    releaseconnection();

                    if (error) {
                        res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
                    } else {

                        if (results[0][0].err == "") {
                            let option = {
                                template: "tourInvite.ejs",
                                subject: "Tournament Invitation",
                                name: results[0][0].usrName,
                                tourName: results[0][0].tourName,
                                tourDate: results[0][0].tourDate
                            }
                            mail.sendEmail(results[0][0].emailAddress, option).then((response) => {
                                console.log(response)
                                // res.end(JSON.stringify({ "err": "", "response":{"msg": "password has been sent successfully to your registered Email ID" }}));
                            }).catch((error) => {
                                console
                                res.end(JSON.stringify({ "error": "X", "response": { "msg": "Contact Developer " + error } }));
                            });
                            if (data.selectedPlayerList.length == index + 1) {
                                res.end(JSON.stringify({ "error": "", "response": { "result": results[0][0] } }));
                            }
                        }

                    }

                });
            });
        }
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};

// function changeformat(date){
//     let myDate=new Date(date);
//    // var myDate = new Date(date);
//    if(myDate!="" ){
//    myDate=myDate.getDate()+ '/' +(myDate.getMonth() + 1)  + '/' + myDate.getFullYear();
//    }

//   return myDate;

//   }

tourCtrl.invitedTournamentListById = (req, res) => {
    try {
        let sql = `call get_invited_tournament_ListById(${req.query.user_id})`;
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


tourCtrl.invitationAcceptDenyById = (req, res) => {
    try {
        let sql = `call invitation_accepted_or_deny("${req.body.tournamentId}","${req.body.isAccepted}","${req.body.isDeny}","${req.body.playerId}")`;
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




tourCtrl.tournamnetPlayWithdrawById = (req, res) => {
    try {
        let sql = `call tournament_Play_or_withdraw("${req.body.tournamentId}","${req.body.isPlay}","${req.body.isWithdraw}","${req.body.playerId}","${req.body.roundId}")`;
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





tourCtrl.tournamentScoreById = (req, res) => {
    try {
        let sql = `call get_tournament_score_by_player("${req.query.tournamentId}","${req.query.playerId}")`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            } else {

                if (results[0]) {
                    let tournamentData = {};

                    if (req.query.playerId == 0) {
                        tournamentData = getTournamentDetails(results[0]);
                    } else {
                        tournamentData = getTournamentDetailsByPlayerId(results[0]);
                    }
                    res.send(JSON.stringify({ "error": "", "response": { result: tournamentData } }));
                }
                else {
                    res.send(JSON.stringify({ "error": "", "response": { result: [] } }));
                }
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};


function getTournamentDetailsByPlayerId(results) {
    const finalArr = [];
    const data = {};
    if (results.length > 0) {
        const keyName = Object.keys(results[0]);
        keyName.forEach(key => {
            if (key != "RoundTotal") {
                data[key] = key != "round" ? results[0][key] : [];
            }
        });

        results.forEach(details => {
            const dataObj = {
                round: details.round,
                score: details.RoundTotal
            }
            data.round.push(dataObj)
        });
    }
    finalArr.push(data);
    return finalArr;
}
function getTournamentDetails(results) {
    const finalList = [];
    if (results.length > 0) {
        const playerList = [];
        results.forEach(detail => {
            if (!playerList.includes(detail.playerId)) {
                playerList.push(detail.playerId)
            }
        });

        if (playerList.length > 0) {
            playerList.forEach(playerId => {
                const roundArray = [];
                results.forEach(record => {
                    if (playerId == record.playerId) {
                        roundArray.push(record);
                    }

                });
                const data = getTournamentDetailsByPlayerId(roundArray);
                finalList.push(data);
            });
        }
    }
    return finalList;

}


// common 

tourCtrl.getTournamentListing = (req, res) => {
    try {

        let sql = `call getTournamentDetails()`;

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

tourCtrl.getTournamentListById = (req, res) => {
    try {
        let sql = `call getTourDetailsByID(${req.query.tourId})`;
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


tourCtrl.getApprovedPlayerList = (req, res) => {
    try {
        let sql = `call getApprovedPlayerList(${req.query.tourId})`;
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



tourCtrl.getAcceptedDenyPlayerList = (req, res) => {
    try {
        let sql = `call getAccept_or_reject_PlayerList(${req.query.tourId}, ${req.query.value})`;
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

tourCtrl.getTournamentRoundDetails = (req, res) => {
    try {
        let sql = `call get_Tournament_RoundDetails("${req.query.tourId}")`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            }
            else {
                res.send(JSON.stringify({ "error": "", "response": { result: results[0], roundDetails: results[1][0] } }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};


tourCtrl.getCourseTeeList = (req, res) => {
    try {
        let sql = `call get_tee_list()`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            }
            else {
                res.send(JSON.stringify({ "error": "", "response": { result: results[0] } }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};


// new code 


tourCtrl.saveTournamentGroupDetails = (req, res) => {
    try {
        const data = req.body;
        if (data && data.groupDetailsArr.length > 0) {
            let deleteGroup = `call  delete_tournament_group_details("${data.tourId}")`;
            connection.query(deleteGroup, function (error, deleteGroup) {
                if (error) {
                    res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
                } else {

                    data.groupDetailsArr.filter((item, eventIndex) => {
                        let event = `call saveTournamentGroupDetails("${data.tourId}","${data.roundId}","${item.group}","${item.tee}","${item.teeTime}")`;
                        connection.query(event, function (error, results) {
                            if (error) {
                                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
                            } else {
                                item.playerDetails.filter((playerDetail, index) => {

                                    let round = `call saveTournamentGroupPlayerDetails("${data.tourId}","${item.group}","${playerDetail.id}","${playerDetail.teeTime}","${data.roundId}")`;
                                    connection.query(round, function (error, eventDetails) {
                                        if (error) {
                                            res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
                                        }
                                    });
                                });
                            }
                            if (eventIndex == data.groupDetailsArr.length - 1) {
                                releaseconnection();
                                res.send(JSON.stringify({ "error": "", "response": { result: results[0][0] } }));
                            }
                        });

                    });
                }
            });
        }
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }

}
tourCtrl.saveTournamentCouponDetails = (req, res) => {
    try {
        const data = req.body;
        if (data && data.couponArr.length > 0) {
            let deleteGroup = `call  delete_tournament_coupon_details("${data.tourId}")`;
            connection.query(deleteGroup, function (error, deleteGroup) {
                if (error) {
                    res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
                } else {
                    data.couponArr.filter((item, eventIndex) => {
                        let event = `call saveTournamentCouponDetails("${item.name}","${item.quantity}","${data.tourId}","${item.roundId}",0,0)`;
                        connection.query(event, function (error, results) {
                            if (error) {
                                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
                            } else {
                                if (eventIndex == data.couponArr.length - 1) {
                                    releaseconnection();
                                    res.send(JSON.stringify({ "error": "", "response": { result: results[0][0] } }));
                                }

                            }
                        });

                    });

                }

            });
        }

    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }

}

tourCtrl.getTournamentCouponList = (req, res) => {
    try {
        let sql = `call getTournamentCouponDetails("${req.query.tourId}","${req.query.roundId}")`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            }
            else {
                res.send(JSON.stringify({ "error": "", "response": { result: results[0] } }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};

// coupon status

tourCtrl.getCouponRedeemStatus = (req, res) => {
    try {
        let sql = `call updateCouponRedeemStatus("${req.query.couponId}","${req.query.playerId}","${req.query.status}")`;
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


// get approval status for player id 


tourCtrl.getApprovalStatusForPlayer = (req, res) => {
    try {
        let sql = `call getTournamentApprovalStatus("${req.query.tourId}","${req.query.playerId}")`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            }
            else {
                res.send(JSON.stringify({ "error": "", "response": { result: results[0] } }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};







// save approved list

tourCtrl.approvedListBytourOrganizer = (req, res) => {
    try {
        const data = req.body;
        if (data.selectedPlayerList.length > 0) {
            data.selectedPlayerList.forEach((element, index) => {


                let sql = `Call saveApprovedPlayersByOrganizer("${data.tournamentId}","${data.selectedPlayerList[index]}")`;
                connection.query(sql, function (error, results) {
                    releaseconnection();

                    if (error) {
                        res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
                    } else {



                        if (data.selectedPlayerList.length == index + 1) {
                            res.end(JSON.stringify({ "error": "", "response": { "result": results[0][0] } }));
                        }
                    }
                });
            });
        }
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};

tourCtrl.deleteTournament = (req, res) => {
    try {
        let sql = `call delete_Tournament("${req.query.tourId}")`;
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

tourCtrl.tournamentDetailedScoreById = (req, res) => {
    try {
        let sql = `call getTournamentDetailedScoreList("${req.query.tour_id}","${req.query.player_id}","${req.query.round_Id}")`;
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




tourCtrl.getTournamentGroups = (req, res) => {
    try {
        let sql = `call getTournamentGroupDetails("${req.query.tourId}","${req.query.roundId}")`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            }
            else {
                const dataToSend = getGroupDetails(results[0], results[1]);
                res.send(JSON.stringify({ "error": "", "response": { result: dataToSend } }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};


function getGroupDetails(playerList, groupList) {
    const groupArray = [];
    if (playerList && playerList.length > 0 && groupList && groupList.length > 0) {

        groupList.forEach(groupData => {
            const data = {
                'group': groupData.groupName,
                'groupId': groupData.groupId,
                playerList: []
            };
            playerList.forEach(playerDetails => {
                if (playerDetails.groupId == groupData.groupId) {
                    data.playerList.push(playerDetails);
                }
            });
            groupArray.push(data);
        });
    }
    return groupArray;

}


// api for add score 


tourCtrl.getPlayerDetailForScore = (req, res) => {
    try {
        let sql = `call getTournamentGroupById("${req.query.tour_id}","${req.query.group_id}")`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            } else {
                if (results && results[0].length > 0) {
                    let recordIndex = 0;
                    results[0].forEach((player, index) => {
                        if (player.playerId == req.query.loggedIn_userId) {
                            recordIndex = index;
                        }
                    });
                    let newIndex = results[0][recordIndex + 1] ? results[0][recordIndex + 1] : results[0][0];
                    res.send(JSON.stringify({ "error": "", "response": { result: newIndex } }));
                } else {
                    res.send(JSON.stringify({ "error": "X", "response": { msg: 'No record found' } }));
                }

            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};



tourCtrl.savetournamentScore = (req, res) => {
    try {
        const data = req.body;
        let sql = `call saveTournamentScores(" ${data.tour_score_Id}","${data.tour_id}","${data.p_id}","${data.round_Id}","${data.groupId}","${data.score1}","${data.score2}","${data.score3}","${data.score4}","${data.score5}","${data.score6}","${data.score7}","${data.score8}","${data.score9}","${data.outTotal}","${data.score10}","${data.score11}","${data.score12}","${data.score13}","${data.score14}","${data.score15}","${data.score16}","${data.score17}","${data.score18}","${data.inTotal}","${data.grossTotal}","${data.netTotal}","${data.birdieTotal}","${data.cid}","${data.hdcp}","${data.enteredHoleCount}","${data.scoreDiff}","${data.teeName}")`;
        connection.query(sql, function (error, results) {
            // releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            } else {
                // if(data.tour_id){
                //     firebaseCtrl.updateData(data).then(function (result) {
                //         console.log("result update data---->",result)
                //     })
                // }else{
                //     firebaseCtrl.savedata(data).then(function (result) {
                //         console.log("result- save data--->",result)
                //     })
                // }


                res.send(JSON.stringify({ "error": "", "response": { result: results[0][0] } }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};


//updated new api

tourCtrl.getTournamentGroupPlayerList = (req, res) => {
    try {
        let sql = `call getTournamentGroupPlayerList("${req.query.tourId}","${req.query.roundId}","${req.query.groupId}")`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            }
            else {

                res.send(JSON.stringify({ "error": "", "response": { result: results[0] } }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};

tourCtrl.getTournamentGroupList = (req, res) => {
    try {
        let sql = `call getTournamentGroupList("${req.query.tourId}","${req.query.roundId}")`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            }
            else {

                res.send(JSON.stringify({ "error": "", "response": { result: results[0] } }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};


//winners api
tourCtrl.getTournamentWinner = (req, res) => {
    try {
        let sql = `call getTournamentWinners("${req.query.tourId}","${req.query.playerId}")`;
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



//save winners api
tourCtrl.saveTournamentWinner = (req, res) => {
    try {
        // let sql = `call getTournamentWinners("${req.query.tourId}","${req.query.playerId}")`;
        const data = req.body;
        let sql = `call saveTournamentWinner("${data.tourId}","${data.playerId}","${data.category}","${data.score}")`;
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


//tournament details for web
tourCtrl.getWebTourDetails = (req, res) => {
    try {
        let sql = `call getWebTourDetails("${req.query.tourID}")`;
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




//year  wise tournament details
tourCtrl.getTourYearDetails = (req, res) => {
    try {
        let sql = `call getEventYear()`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            }
            else {
                res.send(JSON.stringify({ "error": "", "response": { result: results[0] } }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};

//month wise tournament details
tourCtrl.getTourMonthDetails = (req, res) => {
    try {
        let sql = `call getEventMonth("${req.query.year}")`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            }
            else {
                res.send(JSON.stringify({ "error": "", "response": { result: results[0] } }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};


//year /month/dates wise tournament details
tourCtrl.getTourDetails = (req, res) => {
    try {
        let sql = `call getTourDetails("${req.query.year}","${req.query.month}")`;
        connection.query(sql, function (error, results) {
            releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            }
            else {
                res.send(JSON.stringify({ "error": "", "response": { result: results[0] } }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};

// save past scores 



tourCtrl.savePastScores = (req, res) => {
    try {
        const data = req.body;
        let sql = `call savePastScores("${data.p_id}","${data.score1}","${data.score2}","${data.score3}","${data.score4}","${data.score5}","${data.score6}","${data.score7}","${data.score8}","${data.score9}","${data.outTotal}","${data.score10}","${data.score11}","${data.score12}","${data.score13}","${data.score14}","${data.score15}","${data.score16}","${data.score17}","${data.score18}","${data.inTotal}","${data.grossTotal}","${data.netTotal}","${data.birdieTotal}","${data.cid}","${data.hdcp}","${data.enteredHoleCount}","${data.scoreDiff}","${data.teeName}","${data.createdDate}")`;
        connection.query(sql, function (error, results) {
            // releaseconnection();
            if (error) {
                res.end(JSON.stringify({ 'error': 'X', "response": { 'msg': 'Contact Developers ' + error } }));
            } else {
                // if(data.tour_id){
                //     firebaseCtrl.updateData(data).then(function (result) {
                //         console.log("result update data---->",result)
                //     })
                // }else{
                //     firebaseCtrl.savedata(data).then(function (result) {
                //         console.log("result- save data--->",result)
                //     })
                // }


                res.send(JSON.stringify({ "error": "", "response": { result: results[0][0] } }));
            }
        });
    } catch (error) {
        res.end(JSON.stringify({ "err": 'X', "response": { "msg": "contact Developer" + error } }));
    }
};

//invited player list 
tourCtrl.getInvitedPlayerList= (req, res) => {
    try {
        let sql = `call getInvitedPlayerList(${req.query.tourID})`;
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





module.exports = tourCtrl;