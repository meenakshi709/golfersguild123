/**
 * Module dependencies.
 */
const express = require("express");
const router = express.Router();

/**
 * Import Controllers.
 */
 const dataApi = require('../dataApi');
 const usrCtrl = require("../userController");
 const commonCtrl = require("../commonController");
 const tourCtrl = require("../tournamentController");
/**
 * Utilites files.
 */
const auth = require("../utilities/authService");

//Define user routes.
router.post("/userRegistration", usrCtrl.addUpdateUser);
router.post("/userLogin", usrCtrl.userlogin);
router.post('/forgotPassword',  usrCtrl.forgotPassword);
router.get('/refreshToken', auth.verifyAuthToken, usrCtrl.refreshToken);
router.post('/verifyUserAccount', auth.verifyAuthToken, usrCtrl.verifyUserAccount);
router.post('/verifyOTP', auth.verifyAuthToken, usrCtrl.verifyOTP);
router.post("/addUpdateUser",  usrCtrl.addUpdateUser);
router.post("/changePassword",  usrCtrl.changePassword);
router.get("/industryList",  commonCtrl.industryList);
router.get("/getStates", commonCtrl.getStates);
router.get("/getCountryList", commonCtrl.getCountryList);
router.get("/course", commonCtrl.course);
router.get("/score",commonCtrl.score);
router.post("/tournament/saveEventDetails",tourCtrl.saveEventDetails);
router.post("/tournamentInvitation",tourCtrl.tournamentInvitation);
router.get("/getTournamentListing",tourCtrl.getTournamentListing);
router.get("/tournament/invitedTournamentListById",tourCtrl.invitedTournamentListById);
router.post("/tournament/invitationAcceptDenyById",tourCtrl.invitationAcceptDenyById);
router.get("/tournament/tournamentScoreById",tourCtrl.tournamentScoreById);
router.post("/tournament/tournamnetPlayWithdrawById",tourCtrl.tournamnetPlayWithdrawById);
router.get("/getUserDetails",usrCtrl.getUserDetails);
router.get("/tournament/getApprovedPlayerList",tourCtrl.getApprovedPlayerList);
router.get("/tournament/getTournamentRoundDetails",tourCtrl.getTournamentRoundDetails);
router.get("/tournament/getAcceptedDenyPlayerList",tourCtrl.getAcceptedDenyPlayerList);
router.get("/tournament/getCourseTeeList",tourCtrl.getCourseTeeList);
router.post("/tournament/approvedListBytourOrganizer",tourCtrl.approvedListBytourOrganizer);
router.get("/tournament/deleteTournament",tourCtrl.deleteTournament);
router.post("/tournament/saveTournamentGroupDetails", tourCtrl.saveTournamentGroupDetails);
router.post("/tournament/saveTournamentCouponDetails", tourCtrl.saveTournamentCouponDetails);
router.post("/tournament/getTournamentCouponList", tourCtrl.getTournamentCouponList);
router.post("/contactdetails",commonCtrl.contactdetails);
router.get("/tournament/tournamentDetailedScoreById", tourCtrl.tournamentDetailedScoreById);
router.get("/tournament/getApprovalStatusForPlayer",tourCtrl.getApprovalStatusForPlayer);
router.get("/tournament/getTournamentGroups",tourCtrl.getTournamentGroups);
router.get("/tournament/getPlayerDetailForScore",tourCtrl.getPlayerDetailForScore);
router.post("/tournament/savetournamentScore",tourCtrl.savetournamentScore);
router.get("/courseList", commonCtrl.courseList);
router.get("/tourDetails", commonCtrl.tourDetails);
router.get("/tournament/groupList", tourCtrl.getTournamentGroupList);
router.get("/tournament/getTournamentGroupPlayerList", tourCtrl.getTournamentGroupPlayerList);
router.get("/score/deleteScore",commonCtrl.deleteScore);
router.get("/tournament/getTournamentWinner", tourCtrl.getTournamentWinner);

router.get("/getAdvertisementList", commonCtrl.getAdvertisementList);
router.get("/getSponserList", commonCtrl.getSponserList);
router.get("/tournament/getTourYearDetails", tourCtrl.getTourYearDetails);
router.get("/tournament/getWebTourDetails", tourCtrl.getWebTourDetails);
router.get("/tournament/getTourMonthDetails", tourCtrl.getTourMonthDetails);
router.get("/tournament/getTourDetails", tourCtrl.getTourDetails);

router.post("/addUpdateProfilePic",  usrCtrl.addUpdateProfilePic);
router.post("/addUpdateClient",  commonCtrl.addUpdateClient);
router.get("/tournament/getTournamentListById", tourCtrl.getTournamentListById);
router.get("/tournament/getCouponRedeemStatus", tourCtrl.getCouponRedeemStatus);

router.get("/players",  usrCtrl.getPlayersList); 
router.get("/deletePlayer",  usrCtrl.deletePlayer); 
router.post("/saveTournamentWinner", tourCtrl.saveTournamentWinner);


module.exports = router;




