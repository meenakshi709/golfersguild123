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
 const courseCtrl=require("../courseController");
 const formatCtrl=require("../matchFormatController");
/**
 * Utilites files.
 */
const auth = require("../utilities/authService");

//Define user routes.
router.post("/userRegistration", usrCtrl.addUpdateUser);
router.post("/userLogin", usrCtrl.userlogin);
router.get("/user/getUserRole", usrCtrl.getUserRole);
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
router.get("/getTournamentListing", auth.verifyAuthToken,tourCtrl.getTournamentListing);
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
router.get("/tournament/getTournamentCouponList",auth.verifyAuthToken, tourCtrl.getTournamentCouponList);
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
router.get("/course/getTeeColors",  courseCtrl.getTeeColors); 
router.post("/course/addCourse",  courseCtrl.addCourse); 
router.get("/course/deleteCourse",   courseCtrl.deleteCourse); 
router.get("/course/getCourseTeeList",   courseCtrl.getCourseTeeList); 
router.get("/course/getCourseHandicap",   courseCtrl.getCourseHandicap); 
router.post("/tournament/savePastScores",tourCtrl.savePastScores);
router.get("/course/updateCourseHandicap",   courseCtrl.updateCourseHandicap); 

router.get("/tournament/getTournamentFormat",   formatCtrl.getTournamentFormat); 
router.post("/tournament/addEditTournamentFormat",   formatCtrl.addEditTournamentFormat); 
router.get("/tournament/deleteTournamentFormat",formatCtrl.deleteTournamentFormat);

router.get("/tournament/getHandicapScores",formatCtrl.getHandicapScores);
router.get("/tournament/getStablefordPoints",formatCtrl.getStablefordPoints);
router.post("/tournament/addEditStablefordPoints",formatCtrl.addEditStablefordPoints);
router.get("/tournament/deleteStablefordPoint",formatCtrl.deleteStablefordPoint);



module.exports = router;




