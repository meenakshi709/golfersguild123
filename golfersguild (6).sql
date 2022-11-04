-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 04, 2022 at 12:52 PM
-- Server version: 10.4.14-MariaDB
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `golfersguild`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_update_client` (IN `param_clientId` VARCHAR(50), IN `param_clientName` VARCHAR(250), IN `param_clientEmail` VARCHAR(250), IN `param_clientAddress` VARCHAR(250), IN `param_clientContact` BIGINT, IN `param_logo` BLOB, IN `param_clientCode` VARCHAR(100))  BEGIN

Declare err varchar(2);
Declare  msg varchar(100);
DECLARE isRecordExist int;

SELECT count(*) into isRecordExist from guildclients WHERE clientId=param_clientId AND isDeleted=0;
if (isRecordExist<1)
THEN


INSERT INTO guildclients (clientName,clientEmail,clientAddress,clientContact,logo,clientCode,isDeleted)
  VALUES (param_clientName,param_clientEmail,param_clientAddress,param_clientContact,param_logo,param_clientCode,0 ); 
 
  set err="";
  set msg="Client Created Successfully";
 
 
else
  UPDATE guildclients set clientName=param_clientName, clientAddress=param_clientAddress,clientContact=param_clientContact,logo=param_logo
  where clientId=param_clientId;  
	set err="";
	set msg="Client Updated Successfully";
END IF;
Select err,msg from DUAL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CalculateCourseHandicap` (IN `param_playerId` INT, IN `param_courseId` INT, IN `param_Tee` VARCHAR(255))  BEGIN

DECLARE courseHandicap varchar(1000);
DECLARE isRecordExist int;
Declare handicapIndex varchar(1000);
Declare slopeRatng varchar(1000);
Declare courseRatng varchar(1000);
Declare par int;
SELECT count(*) into isRecordExist from user_details WHERE p_id=param_playerId AND isDeleted=0;
if (isRecordExist=1)THEN
select handicapIndex into handicapIndex from user_details where p_id=param_playerId  AND isDeleted=0;
select (pinn+pout) into par from courses where cid=param_courseId  AND is_deleted=0;
select round(((12.70*(slopeRating/113)) +(courseRating-72)),1)  into courseHandicap from course_rating where courseId=param_courseId and teeName=param_Tee;

select courseHandicap;

update user_details set hdcp=courseHandicap where p_id=param_playerId;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CalculateHandicapIndex` (IN `param_player_Id` INT)  BEGIN
Declare scoreCount varchar(1000);
Declare handicapIndex varchar(1000);
set handicapIndex=0;
SELECT count(*) into scoreCount FROM `tournament_score_details`where p_Id=param_player_Id;
if(scoreCount>=5 AND scoreCount<10) THEN
SELECT  round(result.scoreDifferential*0.96,1) into handicapIndex FROM(
select scoreDifferential from  `tournament_score_details` where p_Id=param_player_Id order by createdDate desc   limit 5)result order by  CONVERT(result.scoreDifferential,Decimal(10,2)) asc  limit 1;
ELSE IF (scoreCount>=10 AND scoreCount<15) THEN
select round((avg(result1.scoreDifferential)*0.96),1)into  handicapIndex  from (
SELECT   result.scoreDifferential as scoreDifferential FROM(
select scoreDifferential from  `tournament_score_details` where p_Id=param_player_Id order by createdDate desc   limit 10
)result   order by  CONVERT(result.scoreDifferential,Decimal(10,2))  limit 3 )result1;

ELSE IF (scoreCount>=15 AND scoreCount<20) THEN
select round((avg(result1.scoreDifferential)*0.96),1)into  handicapIndex  from (
SELECT   result.scoreDifferential as scoreDifferential FROM(
select scoreDifferential from  `tournament_score_details` where p_Id=param_player_Id order by createdDate desc   limit 15
)result   order by  CONVERT(result.scoreDifferential,Decimal(10,2))  limit 6 )result1;
ELSE IF (scoreCount>=20) THEN
select round((avg(result1.scoreDifferential)*0.96),1)into  handicapIndex  from (
SELECT   result.scoreDifferential as scoreDifferential FROM(
select scoreDifferential from  `tournament_score_details` where p_Id=param_player_Id order by createdDate desc   limit 20
)result   order by  CONVERT(result.scoreDifferential,Decimal(10,2))  limit 10 )result1;


END IF;
END IF;
END IF;
END IF;
update user_details set handicapIndex=handicapIndex where p_id=param_player_Id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `check_otp` (IN `param_userId` INT, IN `param_otp` INT)  BEGIN

 Declare err varchar(2);
Declare  msg varchar(100);
DECLARE isRecordExist int;

SELECT count(*) into isRecordExist from user_account_otp WHERE userId=param_userId AND otp=param_otp;
if (isRecordExist>0)
THEN
  
UPDATE user_details set isAccountVerified=1 where p_id=param_userId;
  set err="";
  set msg="Account Verified Successfully";
  ELSE
  set err="X";
  set msg="Incorrect OTP";
  end if;
  
  Select err,msg from DUAL;
  
  END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_course` (IN `param_cid` INT)  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);

Update courses set is_deleted=1 where cid=param_cid;
Set err="";
Set msg="course deleted successfully";	


Select err,msg from DUAL;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_player` (IN `param_pid` INT)  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);

Update user_details set isDeleted=1 where p_id=param_pid;
Set err="";
Set msg="player deleted successfully";	


Select err,msg from DUAL;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_score` (IN `param_tour_score_id` VARCHAR(10))  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);

Update tournament_score_details set isDeleted=1 where tour_score_id =param_tour_score_id ;
Set err="";
Set msg="Score deleted successfully";	


Select err,msg from DUAL;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_stablefordPoint` (IN `param_ponitId` INT)  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);

Update stableford_points  set isDeleted=1 where sno=param_ponitId;
Set err="";
Set msg="Stableford Point Deleted Successfully";


Select err,msg from DUAL;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_Tournament` (IN `param_tourID` INT)  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);

Update events set is_Deleted=1 where tourID=param_tourID;
Set err="";
Set msg="Tournament Deleted Successfully";


Select err,msg from DUAL;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_TournamentFormat` (IN `param_formatId` INT)  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);

Update master_event_format set isDeleted=1 where formatKey=param_formatId;
Set err="";
Set msg="Tournament Format Deleted Successfully";


Select err,msg from DUAL;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_tournament_coupon_details` (IN `param_tourId` INT)  BEGIN
DECLARE isTournamentExist int;
Declare err varchar(10);
Declare msg varchar(100);
 Select Count(*)into isTournamentExist  from events where tourId=param_tourId;
if(isTournamentExist>0) then
 Delete from tournament_coupon_details where tourId=param_tourId;
set err="";
set msg="Coupons deleted successfully";
else
set err="X";
set msg="Tournament not found";
END IF;
Select err,msg from DUAL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_tournament_group_details` (IN `param_tourId` INT)  BEGIN
DECLARE isGroupExist int;
Declare err varchar(10);
Declare msg varchar(100);
 Select Count(*)into isGroupExist  from tournament_group_details where tourId=param_tourId;
if(isGroupExist>0) then
 Delete from tournament_group_details where tourId=param_tourId;
 -- Delete from tournament_group_player_details where tournamentId=param_tourId;
set err="";
set msg="Group deleted successfully";
else
set err="X";
set msg="Tournament group not found";
END IF;
Select err,msg from DUAL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAccept_or_reject_PlayerList` (IN `param_tournamentId` VARCHAR(50), IN `param_value` VARCHAR(50))  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);
DECLARE isRecordExist int;

SELECT count(*) into isRecordExist from tournament_player_list WHERE tourID=param_tournamentId;
if(isRecordExist>0) THEN

if( param_value=1) then 

SELECT playerID, playerName,tourID, "Accepted" as Status from tournament_player_list INNER JOIN user_details on user_details.p_id=tournament_player_list.playerID   WHERE tourID=param_tournamentId and isAccepted=1 and isApproved=0 and  isDeleted=0;
elseif( param_value=2) then 

 SELECT playerID, playerName,tourID, "Pending" as Status   from tournament_player_list INNER JOIN user_details on user_details.p_id=tournament_player_list.playerID  WHERE tourID=param_tournamentId and isRejected=0 and isAccepted=0 and isDeleted=0;
 elseif( param_value=3) then 

SELECT playerID, playerName,tourID, "Approved" as Status from tournament_player_list INNER JOIN user_details on user_details.p_id=tournament_player_list.playerID  WHERE tourID=param_tournamentId and isApproved=1 and isDeleted=0;
 else
 SELECT playerID, playerName,tourID, "Deny" as Status   from tournament_player_list INNER JOIN user_details on user_details.p_id=tournament_player_list.playerID  WHERE tourID=param_tournamentId and isRejected=1 and isDeleted=0;



 end if ;
ELSE
set err="X";
set msg="Record not found";
END IF;
select err,msg from dual;
 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getApprovedPlayerList` (IN `param_tourId` VARCHAR(50))  BEGIN
Declare isRoundExist int;
Declare roundId varchar(10);
select Count(distinct round_Id)into isRoundExist from tournament_score_details where tour_id=param_tourId ;

if (isRoundExist=0)THEN
SELECT playerID, playerName,hdcp as value  from tournament_player_list 
INNER JOIN user_details on user_details.p_id=tournament_player_list.playerID 
WHERE tourID=param_tourId and isApproved=1 and isDeleted=0 order by hdcp;
ELSE
select Distinct round_Id into roundId from tournament_score_details where tour_id=param_tourId order by round_Id desc limit 1;

SELECT playerID,playerName,gross as value  from tournament_player_list
INNER JOIN user_details on user_details.p_id=tournament_player_list.playerID
INNER JOIN tournament_score_details on tournament_score_details.p_id=tournament_player_list.playerID 
WHERE tourID=param_tourId and round_id=roundId and isApproved=1 and user_details.isDeleted=0 and tournament_score_details.isDeleted=0 order by gross;
END IF;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getCountryList` ()  BEGIN
	SELECT * FROM country order by country_name asc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getCourseList` ()  BEGIN

SELECT * FROM courses where is_deleted=0 order by cname asc;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getCourseListing` (IN `param_cid` VARCHAR(100))  BEGIN
DECLARE isCidExist int;
Declare err varchar(2);
Declare  msg varchar(100);
select count(*) into isCidExist from courses where cid=param_cid;
if (isCidExist >0)  Then
SELECT * FROM courses where cid=param_cid and is_deleted=0;

else
set err="X";
set msg="Course not found";
end if;
select err,msg from dual;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getCourseTeeList` (IN `param_courseId` VARCHAR(50))  BEGIN
select * from course_rating where courseId=param_courseId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getEventDetails` (IN `param_tourID` INT)  BEGIN
select * from events where tourID=param_tourID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getEventMonth` (IN `param_year` VARCHAR(100))  BEGIN

select DISTINCT monthName(created_Date) as month, month(created_Date) as monthNum, year(created_Date) as year from events where  year(created_Date)=param_year and is_Deleted=0;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getEventYear` ()  BEGIN
select DISTINCT YEAR(created_Date) as year from events ORDER by YEAR(created_Date) DESC;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getGroupDetails` ()  BEGIN
	SELECT * FROM group_details order by groupName asc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getHandicapScores` (IN `param_player_Id` INT, IN `isRecentScore` INT)  BEGIN
Declare scoreCount varchar(1000);
Declare handicapIndex varchar(1000);
set handicapIndex=0;
SELECT count(*) into scoreCount FROM `tournament_score_details`where p_id=param_player_Id;
if(scoreCount>=5 AND scoreCount<10) THEN
SELECT  *  FROM(
select tournament_score_details.tour_score_id, tournament_score_details.gross,tournament_score_details.scoreDifferential,courses.cname, tournament_score_details.createdDate from  `tournament_score_details` inner join courses on courses.cid=tournament_score_details.cid where p_id=param_player_Id order by createdDate desc   limit 5)result order by  CONVERT(result.scoreDifferential,Decimal(10,2)) asc  limit 1;
ELSE IF (scoreCount>=10 AND scoreCount<15) THEN
select *  from (
SELECT  * FROM(
select  tournament_score_details.tour_score_id ,tournament_score_details.gross,tournament_score_details.scoreDifferential,courses.cname, tournament_score_details.createdDate from  `tournament_score_details` inner join courses on courses.cid=tournament_score_details.cid where p_id=param_player_Id order by createdDate desc   limit 10
)result   order by  CONVERT(result.scoreDifferential,Decimal(10,2))  limit 3 )result1;

ELSE IF (scoreCount>=15 AND scoreCount<20) THEN

select *  from (
SELECT   * FROM(
select  tournament_score_details.tour_score_id ,tournament_score_details.gross,tournament_score_details.scoreDifferential,courses.cname, tournament_score_details.createdDate from  `tournament_score_details` inner join courses on courses.cid=tournament_score_details.cid where p_id=param_player_Id order by createdDate desc   limit 15
)result   order by  CONVERT(result.scoreDifferential,Decimal(10,2))  limit 6 )result1;
ELSE IF (scoreCount>=20) THEN

select *  from (
SELECT   * FROM(
select  tournament_score_details.tour_score_id ,tournament_score_details.gross,tournament_score_details.scoreDifferential,courses.cname, tournament_score_details.createdDate from  `tournament_score_details` inner join courses on courses.cid=tournament_score_details.cid where p_id=param_player_Id order by createdDate desc   limit 20
)result   order by  CONVERT(result.scoreDifferential,Decimal(10,2))  limit 10 )result1;


END IF;
END IF;
END IF;
END IF;
SELECT CASE when scoreCount>20 then '20' else scoreCount END as scoreCount; 
if (isRecentScore=1) then 
select  tournament_score_details.tour_score_id ,tournament_score_details.gross,tournament_score_details.scoreDifferential,courses.cname, tournament_score_details.createdDate from  `tournament_score_details` inner join courses on courses.cid=tournament_score_details.cid where p_id=param_player_Id order by createdDate desc  limit 20;
else 
select  tournament_score_details.tour_score_id ,tournament_score_details.gross,tournament_score_details.scoreDifferential,courses.cname, tournament_score_details.createdDate from  `tournament_score_details` inner join courses on courses.cid=tournament_score_details.cid where p_id=param_player_Id order by createdDate desc ;
end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getIndustryListing` ()  BEGIN
select * from industry_details where isDeleted=0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getInvitedPlayerList` (IN `param_tourID` VARCHAR(50))  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);
DECLARE isRecordExist int;

SELECT count(*) into isRecordExist from tournament_player_list WHERE tourID=param_tourID;
if(isRecordExist>0) THEN


SELECT playerID, playerName,tourID, "Invited" as Status from tournament_player_list INNER JOIN user_details on user_details.p_id=tournament_player_list.playerID   WHERE tourID=param_tourID and isInvited=1 ;

ELSE
set err="X";
set msg="Record not found";
END IF;
select err,msg from dual;
 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getInvitedTournamentListById` (IN `param_userId` INT)  select * from tournament_player_list inner join events on events.tourID=tournament_player_list.tourID where isInvited=1 and playerID=param_userId and is_Deleted=0 and isPlay=0 and CURRENT_DATE() between startDate and endDate  ORDER by startDate$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getLiveTournamentDetails` ()  BEGIN
SELECT * FROM live_tournament_round_details 
inner join events on events.tourID=live_tournament_round_details.tour_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getPlayerListing` ()  BEGIN

SELECT *,p_id as playerId, userName,firstName,lastName,email,user_details.roleId,contactNumber,gender,DATE_FORMAT(dob, '%d/%m/%Y')  AS dob,user_details.countryId,country.country_name,user_details.stateId,profileImg,password,isWebUser,isFirstLogin, state.state_name,user_role.roleName  FROM user_details inner join user_role on user_role.roleId=user_details.roleId left join state on state.state_Id=user_details.stateId left join country on country.country_Id=user_details.countryId where user_details.isDeleted=0 AND 
 user_details.roleID !=1 order by playerName asc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getRoundDetails` (IN `param_tourID` VARCHAR(100))  BEGIN
select * from round_details where tourID=param_tourID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getStablefordPoints` ()  BEGIN
select * from stableford_points where isDeleted=0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getStateListing` (IN `param_countryId` INT)  BEGIN
	SELECT * FROM state WHERE country_Id=param_countryId order by state_name asc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTeeColors` ()  BEGIN
select * from master_tee_colors;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTourDetails` (IN `param_year` VARCHAR(100), IN `param_month` VARCHAR(100))  BEGIN
if(param_year !='' && param_month !='') THEN

select * from events where  year(created_Date)=param_year and month(created_Date)=param_month and is_Deleted=0 order by startDate;

ELSE
select * from events where  year(created_Date)=param_year and is_Deleted=0 order by startDate;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTourDetailsByID` (IN `param_tourId` VARCHAR(50))  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);
DECLARE isRecordExist int;

SELECT count(*) into isRecordExist from events WHERE tourID=param_tourId;
if(isRecordExist>0) THEN

select * from events where tourID=param_tourId;
ELSE
set err="X";
set msg="Record not found";
END IF;
select err,msg from dual;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTournamentApprovalStatus` (IN `param_tourId` VARCHAR(50), IN `param_playerId` VARCHAR(50))  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);
DECLARE isRecordExist int;

SELECT count(*) into isRecordExist from tournament_player_list WHERE tourID=param_tourId and playerID=param_playerId;
if(isRecordExist>0) THEN

SELECT playerID, playerName,tourID,isAccepted,isRejected, isApproved, case when isApproved=1 then "Approved" else "Pending" end as status  from tournament_player_list INNER JOIN user_details on user_details.p_id=tournament_player_list.playerID  WHERE tourID=param_tourId and playerID=param_playerId ;

 
ELSE
set err="X";
set msg="Record not found";
END IF;
select err,msg from dual;
 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTournamentCouponDetails` (IN `param_tourId` VARCHAR(100), IN `param_roundId` VARCHAR(100))  BEGIN
if(param_tourId !="" && param_roundId !="") THEN
Select * from tournament_coupon_details where tourID=param_tourId and round_Id=param_roundId; 
ELSE  
 Select * from tournament_coupon_details inner join round_details on round_details.round_Id=tournament_coupon_details.round_Id
 where tournament_coupon_details.tourID=param_tourId;

END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTournamentDetailedScoreList` (IN `param_tour_id` VARCHAR(100), IN `param_player_id` VARCHAR(100), IN `param_round_Id` VARCHAR(100))  BEGIN
if (param_player_id =0)  Then


SELECT p.p_id as playerId,playerName, sd.* ,c.* FROM tournament_score_details as sd LEFT JOIN courses as c on sd.cid=c.cid JOIN user_details as p on p.p_id=sd.p_id
WHERE sd.tour_id=param_tour_id and sd.round_Id=param_round_Id;
  ELSE
  
SELECT p.p_id as playerId,playerName, sd.* ,c.* FROM tournament_score_details as sd LEFT JOIN courses as c on sd.cid=c.cid JOIN user_details as p on p.p_id=sd.p_id
WHERE  sd.p_id=param_player_id and sd.tour_id=param_tour_id and sd.round_Id=param_round_Id;
 

  END IF;
 
 

 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTournamentDetails` ()  BEGIN
		SELECT *, DATE_FORMAT(startdate, '%d-%b-%Y')  as tournamentDate FROM events
        inner join master_event_format on master_event_format.formatKey=events.eventType
        
        WHERE is_Deleted=0 order by tournamentName asc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTournamentFormats` ()  BEGIN
select * from master_event_format where isDeleted=0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTournamentGroupById` (IN `param_tourId` VARCHAR(50), IN `param_groupId` VARCHAR(50))  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);
DECLARE isRecordExist int;

SELECT count(*) into isRecordExist from tournament_group_details WHERE tourID=param_tourId and groupId=param_groupId;
if(isRecordExist>0) THEN

select user_details.p_id as playerId,playerName,hdcp, round_name as roundName,tournament_group_details.round_Id, round_details.cid,tournament_group_player_details.tee_time, tournament_group_player_details.isPlay, tournament_group_player_details.isWithdraw,  tournament_group_details.groupId as groupId, tournament_group_player_details.groupName FROM tournament_group_details 
inner join tournament_group_player_details  on tournament_group_player_details.groupName =tournament_group_details.groupName 
inner JOIN user_details  on user_details.p_id=tournament_group_player_details.playerId
INNER JOIN round_details on round_details.round_Id=tournament_group_details.round_Id 
WHERE tournament_group_player_details.tournamentId=param_tourId AND groupId=param_groupId
And tournament_group_player_details.isplay=1
ORDER by user_details.p_id DESC;
 
ELSE
set err="X";
set msg="Record not found";
END IF;
select err,msg from dual;
 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTournamentGroupDetails` (IN `param_tourId` VARCHAR(50), IN `param_roundId` VARCHAR(50))  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);
DECLARE isRecordExist int;
DECLARE isRoundExist int;
DECLARE isExist int(100);

SELECT count(*) into isRecordExist from tournament_group_details WHERE tourID=param_tourId and round_Id=param_roundId;

SELECT count(*) into isRoundExist from tournament_group_details WHERE round_Id=param_roundId;
if(isRecordExist>0) THEN
if(isRoundExist=0) THEN
set err="X";
set msg="Empty";

ELSE

select user_details.p_id as playerId,playerName, tournament_group_player_details.tee_time, tournament_group_player_details.isPlay, tournament_group_player_details.isWithdraw,  tournament_group_details.groupId as groupId, tournament_group_player_details.groupName FROM tournament_group_details 
inner join tournament_group_player_details on tournament_group_player_details.groupName =tournament_group_details.groupName and tournament_group_player_details.roundId=tournament_group_details.round_Id
inner JOIN user_details  on user_details.p_id=tournament_group_player_details.playerId
WHERE tournament_group_player_details.tournamentId=param_tourId AND round_Id=param_roundId and isWithdraw=0 ORDER by user_details.p_id DESC;
 
 Select distinct tournament_group_player_details.groupName, groupId from tournament_group_player_details inner JOIN tournament_group_details on tournament_group_details.groupName=tournament_group_player_details.groupName where tourID=param_tourId AND round_Id=param_roundId;
 END IF;
ELSE

SELECT count(*) into isExist from tournament_group_details_archive WHERE round_Id=param_roundId;
if(isExist>0)
then 
select user_details.p_id as playerId,playerName, tournament_group_player_details.tee_time, tournament_group_player_details.isPlay, tournament_group_player_details.isWithdraw,  tournament_group_details_archive.groupId as groupId, tournament_group_player_details.groupName FROM tournament_group_details_archive 
inner join tournament_group_player_details  on tournament_group_player_details.groupName =tournament_group_details_archive.groupName and tournament_group_player_details.roundId=tournament_group_details_archive.round_Id 
inner JOIN user_details  on user_details.p_id=tournament_group_player_details.playerId 
WHERE tournament_group_player_details.tournamentId=param_tourId AND round_Id=param_roundId and isWithdraw=0 ORDER by user_details.p_id DESC;
 
 Select distinct tournament_group_player_details.groupName, groupId from tournament_group_player_details inner JOIN tournament_group_details_archive on tournament_group_details_archive.groupName=tournament_group_player_details.groupName where tourID=param_tourId AND round_Id=param_roundId;
 ELSE
set err="X";
set msg="Record not found";
END IF;
END IF;
select err,msg from dual;
 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTournamentGroupList` (`param_tour_id` VARCHAR(10), `param_roundId` VARCHAR(10))  BEGIN
select * from tournament_group_details where tourID=param_tour_id and round_Id=param_roundId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTournamentGroupPlayerList` (IN `param_tour_id` INT, IN `param_round_id` INT, IN `param_group_id` INT)  BEGIN
select user_details.p_id as playerId,playerName, user_details.hdcp,tournament_group_player_details.tee_time, tournament_group_player_details.isPlay, tournament_group_player_details.isWithdraw,  tournament_group_details.groupId as groupId, tournament_group_player_details.groupName FROM tournament_group_details 
inner join tournament_group_player_details  on tournament_group_player_details.groupName =tournament_group_details.groupName 
inner JOIN user_details  on user_details.p_id=tournament_group_player_details.playerId
WHERE tournament_group_player_details.tournamentId=param_tour_id AND round_Id=param_round_id and groupid=param_group_id and isWithdraw=0 ORDER by user_details.p_id DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTournamentWinners` (IN `param_tourId` VARCHAR(100), IN `param_p_id` VARCHAR(100))  BEGIN
DECLARE isWinnerExist int;
Declare err varchar(2);
Declare  msg varchar(100);
select count(*) into isWinnerExist from tournament_winners where  tourID=param_tourId;
if (isWinnerExist >0)  Then

if (param_p_id =0)  Then
SELECT user_details.playerName,events.tournamentName,tournament_winners.* FROM tournament_winners
inner join user_details on user_details.p_id=tournament_winners.playerId
inner join events on  events.tourID=tournament_winners.tourID
where tournament_winners.tourID=param_tourId;

else 
SELECT user_details.playerName,events.tournamentName,tournament_winners.* FROM tournament_winners
inner join user_details on user_details.p_id=tournament_winners.playerId
inner join events on  events.tourID=tournament_winners.tourID
where tournament_winners.playerId=param_p_id and tournament_winners.tourID=param_tourId;

  END IF;

else
set err="X";
set msg="No Tournament found";
end if;
select err,msg from dual;
  
 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTournmentScoreList` ()  BEGIN
SELECT ev.tournamentName,rd.round_name,p.playerName, sd.* FROM tournament_score_details as sd 
LEFT JOIN user_details as p on p.p_id=sd.p_id 
left join events as ev on sd.tour_id=ev.tourID
left join round_details as rd on rd.round_Id=sd.round_Id
where sd.isDeleted=0 order by sd.createdDate asc;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUserDetails` (IN `param_playerId` INT)  BEGIN

SELECT pd.p_id, pd.firstName,pd.lastName,pd.playerName,pd.userName,pd.contactNumber,pd.email,pd.gender,DATE_FORMAT(pd.dob, '%d/%m/%y')  AS dateofbirth,pd.homeCourse,pd.hdcp,pd.employment,pd.companyName,pd.jobTitle,pd.industry,pd.profileImg,pd.isFirstLogin,pd.roleId,pd.countryId,pd.stateId,pd.isAccountVerified,pd.createdDate,pd.updatedDate,
st.*,cntry.* FROM user_details as pd 
LEFT JOIN state as st on st.state_Id=pd.stateId LEFT JOIN country as cntry on cntry.country_Id=pd.countryId 
where p_id=param_playerId and isDeleted=0 AND 
 roleID !=1 ;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUserRole` ()  BEGIN
SELECT * FROM user_role where isDeleted=0 order by roleName asc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getWebTourDetails` (IN `param_tourID` VARCHAR(100))  BEGIN
select * from event_details where tourID=param_tourID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_invited_tournament_ListById` (IN `param_userId` INT)  select master_event_format.formatName, round_details.round_name,DATE_FORMAT(round_details.event_Date, '%Y-%m-%d') as eventDate,tournamentName,events.tourId as tournamentId,playerId,eventType as tournamentType from tournament_player_list inner join events on events.tourID=tournament_player_list.tourID inner JOIN round_details on events.tourID=round_details.tourID inner join master_event_format on master_event_format.formatKey=events.eventType where isInvited=1 and playerID=param_userId and is_Deleted=0 and isPlay=0 and round_details.event_Date>=CURRENT_DATE()  ORDER by round_details.event_Date$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tee_list` ()  BEGIN

Select * from course_tee;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_Tournament_RoundDetails` (IN `param_tournamentId` INT)  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);
DECLARE roundId int;

SELECT round_Id into roundId from tournament_score_details WHERE tour_id=param_tournamentId ORDER BY round_Id desc limit 1;



select round_Id,round_name,round_details
.cid,crs.cname, tourID, DATE_FORMAT(event_Date, '%m/%d/%Y') as "TournamentDate" from round_details inner join courses as crs on crs.cid=round_details.cid WHERE tourID=param_tournamentId ORDER by round_name;


SELECT roundId from DUAL;


 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tournament_score_by_player` (IN `param_tour_id` VARCHAR(50), IN `param_player_id` VARCHAR(50))  BEGIN
DECLARE isTourExist int;
Declare err varchar(2);
Declare  msg varchar(100);
SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
select count(*) into isTourExist from events where tourID=param_tour_id;
if (isTourExist >0)  Then

if (param_player_id =0)  Then
CREATE TEMPORARY TABLE tmprTbles
(pid int ,gross int, net int, birdie int, holeNum int);
insert into tmprTbles  
SELECT p_id, sum(gross) as gross, sum(net) as net, sum(birdie) as birdie, sum(holeNum) as holeNum  FROM `tournament_score_details` WHERE  
 tour_id=param_tour_id  GROUP by tournament_score_details.p_id;


SELECT tournament_score_details.round_Id,round_name as round, tournament_score_details.p_id as playerId,playerName,tournament_score_details.tour_id as tournamentId,tournamentName,tmprTbles.gross as TotalGross,tmprTbles.net as TotalNet,

tmprTbles.birdie as TotalBirdie,tournament_score_details.gross as RoundTotal,tmprTbles.holeNum as Totalholes,tournament_score_details.round_Id FROM `tournament_score_details`
inner join tmprTbles on tmprTbles.pid=tournament_score_details.p_id
inner join events on events.tourID=tournament_score_details.tour_id
inner join user_details on user_details.p_id=tournament_score_details.p_id
inner join round_details on round_details.round_Id=tournament_score_details.round_Id
WHERE tour_id=param_tour_id and tournament_score_details.isDeleted=0  GROUP by round_name,tournament_score_details.round_Id,tournament_score_details.p_id,tmprTbles.gross,tmprTbles.net,tmprTbles.birdie,tmprTbles.holeNum,tournament_score_details.gross order by round_name;

ELSE
CREATE TEMPORARY TABLE tmprTbles
(pid int ,gross int, net int, birdie int,holeNum int);
insert into tmprTbles  
SELECT p_id, sum(gross) as gross, sum(net) as net, sum(birdie) as birdie,  sum(holeNum) as holeNum FROM `tournament_score_details` WHERE tournament_score_details.p_id=param_player_id and tour_id=param_tour_id  group by p_id; 


SELECT tournament_score_details.round_Id,round_name as round, tournament_score_details.p_id as playerId,playerName,tournament_score_details.tour_id as tournamentId,tournamentName,tmprTbles.gross as TotalGross,tmprTbles.net as TotalNet,
tmprTbles.birdie as TotalBirdie, tournament_score_details.gross as RoundTotal,tmprTbles.holeNum as Totalholes,tournament_score_details.round_Id FROM `tournament_score_details`
inner join tmprTbles on tmprTbles.pid=tournament_score_details.p_id
inner join events on events.tourID=tournament_score_details.tour_id
inner join user_details on user_details.p_id=tournament_score_details.p_id
inner join round_details on round_details.round_Id=tournament_score_details.round_Id
WHERE  tournament_score_details.p_id=param_player_id and tour_id=param_tour_id and tournament_score_details.isDeleted=0  GROUP by round_name,tournament_score_details.tour_id,
 tournament_score_details.p_id,tournament_score_details.round_Id,tmprTbles.gross,tmprTbles.net,tmprTbles.birdie,tmprTbles.holeNum,
 tournament_score_details.gross order by round_name;
END IF;
drop table tmprTbles;
else
set err="X";
set msg="Tournament not exist";
end If;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `invitation_accepted_or_deny` (IN `param_tournamentId` VARCHAR(50), IN `param_isAccepted` INT, IN `param_isDeny` INT, IN `param_playerId` VARCHAR(50))  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);
DECLARE isRecordExist int;

SELECT count(*) into isRecordExist from tournament_player_list WHERE tourID=param_tournamentId and playerID=param_playerId;
if(isRecordExist>0) THEN
Update tournament_player_list set isAccepted=param_isAccepted, isRejected=param_isDeny where tourID=param_tournamentId and playerID=param_playerId;
set err="";
 if( param_isAccepted=1) then 
 set msg="Tournament accepted succesfully";
 else

 set msg="Tournament deny succesfully";
 end if ;
ELSE
set err="X";
set msg="Record not found";
END IF;
select err,msg from dual;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `saveApprovedPlayersByOrganizer` (IN `param_tourID` VARCHAR(50), IN `param_playerId` VARCHAR(50))  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);
DECLARE isRecordExist int;

SELECT count(*) into isRecordExist from tournament_player_list WHERE tourID=param_tourID and playerID=param_playerId;
if(isRecordExist>0) THEN

 UPDATE tournament_player_list set isApproved=1  where  tourID=param_tourID and playerID=param_playerId;
 set err="";
set msg="Updated Successfully";

ELSE
set err="X";
set msg="Record not found";
END IF;
select err,msg from dual;
 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `saveContactQuery` (IN `param_name` VARCHAR(200), IN `param_email` VARCHAR(200), IN `param_phn` VARCHAR(100), IN `param_subject` VARCHAR(200), IN `param_msg` VARCHAR(255))  BEGIN

DECLARE err varchar(100);
DECLARE msg varchar(255);
INSERT INTO contact (gname, gemail, phone, subject, msg) VALUES (param_name,param_email,param_phn,param_subject,param_msg);
  set err="";
  set msg="Sent Successfully";

  SELECT err,msg from DUAL;
 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `saveCourseDetails` (IN `param_cid` VARCHAR(10), IN `param_cname` VARCHAR(200), IN `param_caddress` VARCHAR(250), IN `param_par1` INT, IN `param_par2` INT, IN `param_par3` INT, IN `param_par4` INT, IN `param_par5` INT, IN `param_par6` INT, IN `param_par7` INT, IN `param_par8` INT, IN `param_par9` INT, IN `param_par10` INT, IN `param_par11` INT, IN `param_par12` INT, IN `param_par13` INT, IN `param_par14` INT, IN `param_par15` INT, IN `param_par16` INT, IN `param_par17` INT, IN `param_par18` INT, IN `param_pinn` INT, IN `param_pout` INT, IN `param_hdcp1` INT, IN `param_hdcp2` INT, IN `param_hdcp3` INT, IN `param_hdcp4` INT, IN `param_hdcp5` INT, IN `param_hdcp6` INT, IN `param_hdcp7` INT, IN `param_hdcp8` INT, IN `param_hdcp9` INT, IN `param_hdcp10` INT, IN `param_hdcp11` INT, IN `param_hdcp12` INT, IN `param_hdcp13` INT, IN `param_hdcp14` INT, IN `param_hdcp15` INT, IN `param_hdcp16` INT, IN `param_hdcp17` INT, IN `param_hdcp18` INT, IN `param_teeNameArr` LONGTEXT)  BEGIN
 Declare isRecordExit int;
 Declare isCnameExist int;
 Declare statusCode int;
 Declare msg varchar(100);
 Declare err varchar(2);
 DECLARE num_rows int;
Declare newCId int;
 DECLARE courseId varchar(100);
 select count(*)into isRecordExit from courses where cid=param_cid and is_deleted=0;
 select count(*)into isCnameExist from courses where cname=param_cname and is_deleted=0 limit 1;

 If(isRecordExit<1) Then
 BEGIN
  IF(isCnameExist<1) Then
 	Select cid into num_rows from courses ORDER BY cid DESC limit 1;
 	INSERT INTO courses (c_code,cname,caddress,par1,par2,par3,par4,par5,par6,par7,par8,par9,par10,par11,par12,par13,par14,par15,par16,     par17, par18,pinn,pout, hdcp1,hdcp2,hdcp3,hdcp4,hdcp5,hdcp6,hdcp7,hdcp8,hdcp9,hdcp10,hdcp11,hdcp12,hdcp13,hdcp14,hdcp15,hdcp16,hdcp17,hdcp18) 
    VALUES (concat('course',num_rows+1),param_cname,param_caddress,param_par1,param_par2,param_par3,param_par4,param_par5, param_par6,     param_par7,param_par8, param_par9, param_par10,param_par11, param_par12,param_par13, param_par14,param_par15,param_par16,           param_par17,param_par18,param_pinn,param_pout,param_hdcp1,param_hdcp2,param_hdcp3,param_hdcp4,param_hdcp5,param_hdcp6,param_hdcp7,   param_hdcp8,param_hdcp9,param_hdcp10,param_hdcp11,param_hdcp12,param_hdcp13,param_hdcp14,param_hdcp15,param_hdcp16,param_hdcp17,       param_hdcp18);
    
   set statusCode=200;
    set msg="Course save successfully";
    set err="";
   
    select LAST_INSERT_ID() into courseId ;
    call saveCourseTeeRating(courseId,1,param_teeNameArr);
    ELSE
    set statusCode=409;
    set msg="Course already exist with same name";
    set err="X";
    END IF;
END;
ELSE

  call saveCourseTeeRating(param_cid,0,param_teeNameArr);
UPDATE courses set cname=param_cname ,
 caddress=param_caddress,par1=param_par1,par2=param_par2,par3=param_par3,par4=param_par4, par5=param_par5,par6=param_par6,par7=param_par7,par8=param_par8,par9=param_par9,par10=param_par10,par11=param_par11,par12=param_par12,
 par13=param_par13,par14=param_par14,par15=param_par15,par16=param_par16,par17=param_par17,par18=param_par18,pinn=param_pinn,pout=param_pout,hdcp1=param_hdcp1,hdcp2=param_hdcp2,hdcp3=param_hdcp3,hdcp4=param_hdcp4,hdcp5=param_hdcp5,hdcp6=param_hdcp6,hdcp7=param_hdcp7,hdcp8=param_hdcp8,hdcp9=param_hdcp9,hdcp10=param_hdcp10,hdcp11=param_hdcp11,hdcp12=param_hdcp12,hdcp13=param_hdcp13,hdcp14=param_hdcp14,hdcp15=param_hdcp15,hdcp16=param_hdcp16,
 hdcp17=param_hdcp17,hdcp18=param_hdcp18 where cid=param_cid;
  set statusCode=200;
    set msg="Course update successfully";
    set err="";
  END IF;  
  Select statusCode,msg,err,newCId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `saveCourseTeeRating` (`param_course_Id` VARCHAR(5), `param_InsertUpdate` INT, `param_teeDetails` LONGTEXT)  BEGIN
   DECLARE teeDetails varchar(150);
   DECLARE strIDs varchar(150) ;
   Declare teeName varchar(200);
   Declare slopeRating varchar(200);
   Declare courseRating varchar(200);
   Declare element varchar(500);
   set strIDs=param_teeDetails;
   if(param_InsertUpdate=0)THEN
   delete from course_rating where courseId=param_course_Id;
   END IF;
    WHILE strIDs != '' DO
    set element='';
    SET element = SUBSTRING_INDEX(strIDs, ',', 1);      
  	 select SPLIT_STR(element, '-', 1) into teeName;
   	 select SPLIT_STR(element, '-', 2) into courseRating;
     select SPLIT_STR(element, '-', 3) into slopeRating;
     
     insert into course_rating(courseId,teeName,courseRating,slopeRating) values(param_course_Id,teeName,courseRating,slopeRating);
    IF LOCATE(',', strIDs) > 0 THEN
      SET strIDs = SUBSTRING(strIDs, LOCATE(',', strIDs) + 1);
    ELSE
      SET strIDs = '';
    END IF;

  END WHILE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `saveEventDetails` (IN `param_tourId` INT, IN `param_tourName` VARCHAR(200), IN `param_eventType` VARCHAR(100), IN `param_numRounds` INT, IN `param_startDate` VARCHAR(255), IN `param_endDate` VARCHAR(255), IN `param_holes` INT, IN `param_round_details` LONGTEXT)  BEGIN
DECLARE num_rows int;
DECLARE err varchar(100);
DECLARE msg varchar(255);
DECLARE isRecordExist int;
DECLARE isTourNameExist int;
DECLARE tour_id varchar(100);
SELECT count(*) into isTourNameExist from events WHERE tournamentName=param_tourName AND is_Deleted=0;
SELECT count(*) into isRecordExist from events WHERE tourID=param_tourId AND is_Deleted=0;
if (isRecordExist<1)THEN
if (isTourNameExist=0)THEN

INSERT INTO events (tournamentName,eventType,numRounds,startDate,endDate,holes)VALUES (param_tourName,param_eventType,param_numRounds,param_startDate,param_endDate,param_holes);
  set err="";
  set msg="Tournament Created Successfully";
  select tourID into tour_id from events order by created_Date desc limit 1; 
 call saveRoundDetails(tour_id,1,param_round_details);
 ELSEIF(isTourNameExist>0)THEN
  set err="X";
  set msg="Tournament Already Exist";
     ELSE
  set err="X";
  set msg="Invalid Entry";
  END IF;
  ELSE
  UPDATE events set tournamentName=param_tourName,eventType=param_eventType,numRounds=param_numRounds,startDate=param_startDate,endDate=param_endDate,holes=param_holes,modified_Date=now() where tourID=param_tourId;
   set err="";
  set msg="Event updated successfully";
  set tour_id=param_tourId;
   call saveRoundDetails(tour_id,0,param_round_details);
  END IF;

  SELECT err,msg,tour_id from DUAL;
 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `savePastScores` (IN `param_playerId` VARCHAR(50), IN `param_score1` INT(10), IN `param_score2` INT(50), IN `param_score3` INT(50), IN `param_score4` INT(50), IN `param_score5` INT(10), IN `param_score6` INT(10), IN `param_score7` INT(10), IN `param_score8` INT(10), IN `param_score9` INT(10), IN `param_outTotal` INT(10), IN `param_score10` INT(10), IN `param_score11` INT(10), IN `param_score12` INT(10), IN `param_score13` INT(10), IN `param_score14` INT(10), IN `param_score15` INT(10), IN `param_score16` INT(10), IN `param_score17` INT(10), IN `param_score18` INT(10), IN `param_inTotal` INT(10), IN `param_grossTotal` INT(10), IN `param_netTotal` INT(10), IN `param_birdieTotal` INT(10), IN `param_cid` VARCHAR(50), IN `param_hdcp` INT(50), IN `param_enteredHoleCount` INT(50), IN `param_scoreDiff` VARCHAR(250), IN `param_teeName` VARCHAR(250), IN `param_tournamentDate` DATE)  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);

DECLARE isPlayerExist int;
SELECT count(*) into isPlayerExist from user_details WHERE p_id=param_playerId; 
	if(isPlayerExist=1) then


insert into tournament_score_details (tour_id ,p_id ,round_Id  ,score1 ,score2 ,score3 ,score4 ,score5 ,score6 ,score7 ,score8 ,score9 ,outt ,score10 ,score11 ,score12 ,score13 ,score14 ,score15 ,score16 ,score17 ,score18,inn ,gross ,net ,birdie,cid,hdcp,holeNum,scoreDifferential,teeName,isDeleted,createdDate ) 
values ( "" , `param_playerId` , "" ,  `param_score1` , `param_score2` , `param_score3` , `param_score4` , `param_score5` , `param_score6` , `param_score7` , `param_score8` , `param_score9` , `param_outTotal` , `param_score10` , `param_score11` , `param_score12` , `param_score13` , `param_score14` , `param_score15` , `param_score16` , `param_score17` , `param_score18` , `param_inTotal` , `param_grossTotal` , `param_netTotal` , `param_birdieTotal`, `param_cid`,`param_hdcp`,`param_enteredHoleCount`,`param_scoreDiff`,`param_teeName`,0,`param_tournamentDate`);
set err="";
set msg="Score inserted successfully";




 call CalculateHandicapIndex(param_playerId);
ELSE
set err="X";
set msg="Record not found";
END IF;

select err,msg from dual;
 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `savePlayerDetails` (IN `param_p_id` VARCHAR(20), IN `param_firstName` VARCHAR(80), IN `param_lastName` VARCHAR(80), IN `param_userName` VARCHAR(80), IN `param_email` VARCHAR(150), IN `param_contactNumber` VARCHAR(100), IN `param_gender` VARCHAR(80), IN `param_dob` DATE, IN `param_country_Id` INT, IN `param_state_Id` INT, IN `param_password` VARCHAR(255), IN `param_profileImg` LONGTEXT, IN `param_isWebLogin` INT, IN `param_isFirstLogin` INT)  BEGIN
DECLARE num_rows int;
DECLARE playerName varchar(200);
DECLARE err varchar(100);
DECLARE msg varchar(255);
DECLARE isRecordExist int;
DECLARE isEmailExist int;
DECLARE isUserNameExist int;
SELECT count(*) into isUserNameExist from user_details WHERE userName=param_userName AND isDeleted=0;
SELECT count(*) into isEmailExist from user_details WHERE email=param_email AND isDeleted=0;
SELECT count(*) into isRecordExist from user_details WHERE p_id=param_p_id AND isDeleted=0;
if (isRecordExist<1)
THEN

IF( isEmailExist=0 and isUserNameExist=0) THEN

INSERT INTO user_details (playerName,userName,firstName,lastName,email,contactNumber,gender,dob,country_Id,state_Id,profileImg,password,role_Id,isWebUser,isFirstLogin)
  VALUES ( concat(param_firstName," ",param_lastName),param_userName,param_firstName,param_lastName,param_email,param_contactNumber,param_gender,param_dob,param_country_Id,param_state_Id,param_profileImg,param_password,2,param_isWebLogin,param_isFirstLogin);
 
  set err="";
  set msg="Player Created Successfully";
 
  ELSEIF(isEmailExist>0)
  THEN
  set err="X";
  set msg="Email Already Exist";
  ELSEIF(isUserNameExist>0)
  THEN
  set err="X";
  set msg="Username Already Exist";
   ELSE
  set err="X";
  set msg="Invalid Entry";
  END IF;

  ELSE

  UPDATE user_details set playerName=(concat(param_firstName," ",param_lastName)), 
  firstName=param_firstName,
  lastName=param_lastName,contactNumber=param_contactNumber,gender=param_gender,
  dob=param_dob,countryId=param_country_Id,stateId=param_state_Id,profile_Img=param_profile_Img,updatedDate=now() where p_id=param_p_id;
    set err="";
  set msg="Player updated successfully";
  END IF;

  SELECT err,msg from DUAL;
  END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `saveRoundDetails` (IN `param_tour_Id` INT, IN `param_InsertUpdate` INT, IN `param_round_details` LONGTEXT)  BEGIN
	DECLARE num_rows int;
	DECLARE err varchar(100);
	DECLARE msg varchar(255);
   DECLARE eventDate varchar(1500);
   Declare cid varchar(200);
   Declare round_name varchar(200);
     Declare element varchar(1000);
   DECLARE strIDs longtext;
   set strIDs=param_round_details;
   if(param_InsertUpdate=0)THEN
   delete from round_details where tourID=param_tour_Id;
   END IF;
    WHILE strIDs != '' DO
    set element='';
    SET element = SUBSTRING_INDEX(strIDs, ',', 1);      
  	 select SPLIT_STR(element, '/', 1) into eventDate;
   	 select SPLIT_STR(element, '/', 2) into cid;
     select SPLIT_STR(element, '/', 3) into round_name;
     
     insert into round_details(event_Date,cid,tourID,round_name) values(eventDate,cid,param_tour_Id,round_name);
    IF LOCATE(',', strIDs) > 0 THEN
      SET strIDs = SUBSTRING(strIDs, LOCATE(',', strIDs) + 1);
    ELSE
      SET strIDs = '';
    END IF;
  END WHILE;
    set err="";
  set msg="Round Created Successfully";
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `saveStablefordPoint` (IN `param_pointId` INT, IN `param_netScoreName` VARCHAR(250), IN `param_netScorePoints` INT(250), IN `param_points` INT(200))  BEGIN

DECLARE err varchar(100);
DECLARE msg varchar(255);
DECLARE isRecordExist int;
DECLARE isTourNameExist int;

SELECT count(*) into isTourNameExist from stableford_points  WHERE netScoreName=param_netScoreName and isDeleted=0;
SELECT count(*) into isRecordExist from stableford_points WHERE sno=param_pointId AND isDeleted=0;
if (isRecordExist<1)THEN
if (isTourNameExist=0)THEN

insert into stableford_points (points,netScoreName,netScorePoints,isDeleted ) values ( param_points,param_netScoreName,param_netScorePoints, 0);
  set err="";
  set msg="Created Successfully";

 ELSEIF(isTourNameExist>0)THEN
  set err="X";
  set msg="Score Name Already Exist";
     ELSE
  set err="X";
  set msg="Invalid Entry";
  END IF;
  ELSE
 update  stableford_points set netScoreName=param_netScoreName, netScorePoints=param_netScorePoints,points=param_points  where netScoreName=param_netScoreName and isDeleted=0;
   set err="";
  set msg="Score Name updated successfully";
  END IF;

  SELECT err,msg from DUAL;
 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `saveTournamentCouponDetails` (IN `param_couponCode` VARCHAR(100), IN `param_couponCount` INT, IN `param_tourId` INT, IN `param_roundId` VARCHAR(100), IN `param_playerId` VARCHAR(100), IN `param_status` INT(2))  BEGIN
DECLARE isTournamentExist int;
Declare err varchar(10);
Declare msg varchar(100);
Select Count(*)into isTournamentExist  from events where tourId=param_tourId;
if(isTournamentExist>0) then
Insert into tournament_coupon_details(couponCode,couponCount,tourID,round_Id,playerId,redeemStatus) values(param_couponCode,param_couponCount,param_tourId,param_roundId,param_playerId,param_status);
set err="";
set msg="Coupon save successfully";
else
set err="X";
set msg="Tournament group not found";
END IF;
Select err,msg from DUAL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `saveTournamentDetails` (IN `param_tourID` INT, IN `param_tournamentName` VARCHAR(200))  BEGIN
DECLARE num_rows int;
DECLARE err varchar(100);
DECLARE msg varchar(255);
DECLARE isRecordExist int;
DECLARE isTourNameExist int;
Declare tour_Id varchar(20);

SELECT count(*) into isTourNameExist from tournament_details WHERE tournamentName=param_tournamentName AND is_deleted=0;

SELECT count(*) into isRecordExist from tournament_details WHERE tourID=param_tourID AND is_deleted=0;
if (isRecordExist<1)THEN
IF( isTourNameExist=0) THEN
INSERT INTO tournament_details (tournamentName)VALUES ( param_tournamentName);
  set err="";
  set msg="Tournament Created Successfully";
  select tourID into tour_Id  from  tournament_details order by created_Date desc limit 1;
 
ELSEIF(isTourNameExist>0)THEN
  set err="X";
  set msg="Tournament Already Exist";
   ELSE
  set err="X";
  set msg="Invalid Entry";
  END IF;
  ELSE
  UPDATE tournament_details set tournamentName=param_tournamentName,modified_Date=now() where tourID=param_tourID;
   set err="";
  set msg="Tournament updated successfully";
  set tour_Id =param_tourID;
  END IF;

  SELECT err,msg,tour_Id from DUAL;
 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `saveTournamentFormat` (IN `param_formatId` INT, IN `param_tourFormat` VARCHAR(250))  BEGIN

DECLARE err varchar(100);
DECLARE msg varchar(255);
DECLARE isRecordExist int;
DECLARE isTourNameExist int;

SELECT count(*) into isTourNameExist from master_event_format  WHERE formatName=param_tourFormat and isDeleted=0;
SELECT count(*) into isRecordExist from master_event_format WHERE formatKey=param_formatId AND isDeleted=0;
if (isRecordExist<1)THEN
if (isTourNameExist=0)THEN

insert into master_event_format (formatName,isDeleted ) values ( param_tourFormat , 0);
  set err="";
  set msg="Format Created Successfully";

 ELSEIF(isTourNameExist>0)THEN
  set err="X";
  set msg="Format Name Already Exist";
     ELSE
  set err="X";
  set msg="Invalid Entry";
  END IF;
  ELSE
 update  master_event_format set formatName=param_tourFormat where formatName=param_tourFormat;
   set err="";
  set msg="Format updated successfully";
  END IF;

  SELECT err,msg from DUAL;
 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `saveTournamentGroupDetails` (IN `param_tourId` VARCHAR(50), IN `param_roundId` VARCHAR(50), IN `param_groupName` VARCHAR(100), IN `param_teeNumber` INT, IN `param_teeTime` VARCHAR(100))  BEGIN
DECLARE isTournamentExist int;
Declare err varchar(10);
Declare msg varchar(100);
Declare group_Id varchar(10);
Select Count(*)into isTournamentExist  from events where tourId=param_tourId;
if(isTournamentExist>0) then
Insert into tournament_group_details(groupName,tee_Number,tee_Time,tourID,round_Id) values(param_groupName,param_teeNumber,param_teeTime,param_tourId,param_roundId);

select groupId into group_Id   from tournament_group_details where tourID=param_tourId  order by groupId desc limit 1; 
set err="";
set msg="Tournament group details save successfully";
else
set err="X";
set msg="Tournament not found";
END IF;
Select err,msg,group_Id from DUAL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `saveTournamentGroupPlayerDetails` (IN `param_tourId` VARCHAR(50), IN `param_groupName` VARCHAR(200), IN `param_playerId` VARCHAR(100), IN `param_teeTime` VARCHAR(100), IN `param_roundId` VARCHAR(50))  BEGIN
DECLARE isGroupExist int;
Declare err varchar(10);
Declare msg varchar(100);
Select Count(*)into isGroupExist  from tournament_group_details where tourId=param_tourId and groupName=param_groupName ;
if(isGroupExist>0) then
Insert into tournament_group_player_details(tournamentId,groupName,playerId,tee_time,isPlay,roundId) values(param_tourId,param_groupName,param_playerId,param_teeTime,0,param_roundId);
set err="";
set msg="Player details save successfully";
else
set err="X";
set msg="Tournament group not found";
END IF;
Select err,msg from DUAL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `saveTournamentPlayerDetails` (IN `param_t_player_Id` INT, IN `param_tournamentId` INT, IN `param_groupId` INT, IN `param_playerId` INT, IN `param_tee_time` DATE)  BEGIN
DECLARE num_rows int;
DECLARE err varchar(100);
DECLARE msg varchar(255);
DECLARE isRecordExist int;
SELECT count(*) into isRecordExist from tournament_player_details WHERE t_player_Id=param_t_player_Id;
if (isRecordExist<1)THEN


INSERT INTO tournament_player_details (tournamentId,groupId,playerId,tee_time)VALUES (param_tournamentId,param_groupId,param_playerId,param_tee_time);
  set err="";
  set msg="Saved Successfully";


  ELSE
  UPDATE round_details set tournamentId=param_tournamentId,groupId=param_groupId,playerId=param_playerId,tee_time=param_tee_time,modified_Date=now() where t_player_Id=param_t_player_Id;
   set err="";
  set msg="Updated successfully";
  END IF;

  SELECT err,msg from DUAL;
 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `saveTournamentPlayers` (IN `param_tourID` INT, IN `param_playerID` INT, IN `param_isPlay` INT, IN `param_isInvited` INT, IN `param_isAccepted` INT, IN `param_isApproved` INT, IN `param_isRejected` INT, IN `param_isWithdraw` INT)  BEGIN

Declare err varchar(2);
Declare  msg varchar(100);
DECLARE isRecordExist int;
Declare emailAddress varchar(200);
DECLARE usrName varchar(100);
DECLARE tourName varchar(100);
DECLARE tourDate varchar(255);

SELECT count(*) into isRecordExist from events WHERE tourID=param_tourID AND is_Deleted=0;
if (isRecordExist>0)
THEN

    SELECT events.tournamentName, DATE_FORMAT(round_details.event_Date, '%d/%m/%Y') into tourName,tourDate from events 
    inner join round_details on events.tourID=round_details.tourID  WHERE events.tourID=param_tourID  AND round_details.round_name='Round1' AND events.is_Deleted=0;
	
    SELECT email , playerName into emailAddress, usrName from user_details WHERE p_id=param_playerID AND isDeleted=0;
	
INSERT INTO tournament_player_list (tourID,playerID,isPlay,isInvited,isAccepted,isApproved,isRejected,isWithdraw,created_Date)
  VALUES ( param_tourID,param_playerID,param_isPlay,param_isInvited,param_isAccepted,param_isApproved,param_isRejected,param_isWithdraw,now());
   
  set err="";
  set msg="Player has been invited Successfully";
  
  END IF;
  Select err,msg,emailAddress,usrName,tourName,tourDate from DUAL;
  
 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `saveTournamentScores` (IN `param_tour_score_Id` VARCHAR(50), IN `param_tourId` VARCHAR(50), IN `param_playerId` VARCHAR(50), IN `param_roundId` VARCHAR(50), IN `param_groupId` VARCHAR(50), IN `param_score1` INT(10), IN `param_score2` INT(50), IN `param_score3` INT(50), IN `param_score4` INT(50), IN `param_score5` INT(10), IN `param_score6` INT(10), IN `param_score7` INT(10), IN `param_score8` INT(10), IN `param_score9` INT(10), IN `param_outTotal` INT(10), IN `param_score10` INT(10), IN `param_score11` INT(10), IN `param_score12` INT(10), IN `param_score13` INT(10), IN `param_score14` INT(10), IN `param_score15` INT(10), IN `param_score16` INT(10), IN `param_score17` INT(10), IN `param_score18` INT(10), IN `param_inTotal` INT(10), IN `param_grossTotal` INT(10), IN `param_netTotal` INT(10), IN `param_birdieTotal` INT(10), IN `param_cid` VARCHAR(50), IN `param_hdcp` INT(50), IN `param_enteredHoleCount` INT(50), IN `param_scoreDiff` VARCHAR(250), IN `param_teeName` VARCHAR(250))  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);
DECLARE isRecordExist int;
DECLARE isSoreExist int;

SELECT count(*) into isRecordExist from tournament_group_details WHERE tourID=param_tourId and round_Id=param_roundId and groupId=param_groupId;
if(isRecordExist>0) THEN

SELECT count(*) into isSoreExist from tournament_score_details WHERE p_id=param_playerId and tour_id=param_tourId and round_Id=param_roundId and tour_score_id=param_tour_score_Id; 
	if(isSoreExist=0) then


insert into tournament_score_details (tour_id ,p_id ,round_Id  ,score1 ,score2 ,score3 ,score4 ,score5 ,score6 ,score7 ,score8 ,score9 ,outt ,score10 ,score11 ,score12 ,score13 ,score14 ,score15 ,score16 ,score17 ,score18,inn ,gross ,net ,birdie,cid,hdcp,createdDate,holeNum,scoreDifferential,teeName,groupId ) values ( `param_tourId` , `param_playerId` , `param_roundId` ,  `param_score1` , `param_score2` , `param_score3` , `param_score4` , `param_score5` , `param_score6` , `param_score7` , `param_score8` , `param_score9` , `param_outTotal` , `param_score10` , `param_score11` , `param_score12` , `param_score13` , `param_score14` , `param_score15` , `param_score16` , `param_score17` , `param_score18` , `param_inTotal` , `param_grossTotal` , `param_netTotal` , `param_birdieTotal`, `param_cid`,`param_hdcp`,now(),`param_enteredHoleCount`,`param_scoreDiff`,param_teeName,param_groupId);
set err="";
set msg="Score inserted successfully";


ELSE
update  tournament_score_details set score1=param_score1, score2=param_score2,score3=param_score3,score4=param_score4,score5=param_score5,score6=param_score6,
score7=param_score7,score8=param_score8,score9=param_score9,score10=param_score10,score11=param_score11,score12=param_score12,score13=param_score13,score14=param_score14,score15=param_score15,score16=param_score16,
score17=param_score17,score18=param_score18, inn=param_inTotal, outt= param_outTotal,gross=param_grossTotal, net=param_netTotal, birdie=param_birdieTotal, hdcp=param_hdcp, teeName=param_teeName,holeNum=param_enteredHoleCount,scoreDifferential=param_scoreDiff,groupId=param_groupId where tour_id=param_tourId and round_Id=param_roundId and p_id=param_playerId and  tour_score_id=param_tour_score_Id;

set err="";
set msg="Score updated successfully";
END IF;
 call CalculateHandicapIndex(param_playerId);
ELSE
set err="X";
set msg="Record not found";
END IF;

select err,msg from dual;
 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `saveTournamentWinner` (IN `param_tourId` VARCHAR(50), IN `param_playerId` VARCHAR(100), IN `param_category` VARCHAR(150), IN `param_score` VARCHAR(150))  BEGIN

Declare err varchar(2);
Declare  msg varchar(100);
DECLARE isRecordExist int;


SELECT count(*) into isRecordExist from tournament_winners WHERE tourID=param_tourId and playerId=param_playerId;
if (isRecordExist<1)
THEN


INSERT INTO tournament_winners (tourID,playerId,category,score)
  VALUES ( param_tourId,param_playerId,param_category,param_score);

  set err="";
  set msg="Winner saved";





else
  UPDATE tournament_winners set tourID=param_tourId, playerId=param_playerId, category=param_category ,score=param_score
  where tourID=param_tourId and playerId=param_playerId;
set err="";
set msg="Winner Updated Successfully";
END IF;
Select err,msg from DUAL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `save_user_details` (IN `param_p_id` VARCHAR(50), IN `param_FirstName` VARCHAR(100), IN `param_LastName` VARCHAR(150), IN `param_roleId` VARCHAR(50), IN `param_userName` VARCHAR(150), IN `param_email` VARCHAR(100), IN `param_contact` VARCHAR(250), IN `param_password` VARCHAR(100), IN `param_dob` DATE, IN `param_gender` VARCHAR(10), IN `param_HomeCourse` VARCHAR(255), IN `param_hdcp` INT(3), IN `param_hdcpCertificate` LONGTEXT, IN `param_platformLink` VARCHAR(255), IN `param_vaccineStatus` INT(2), IN `param_employment` INT(3), IN `param_company` VARCHAR(200), IN `param_jobTitle` VARCHAR(150), IN `param_industry` INT(200), IN `param_countryId` INT(10), IN `param_stateId` INT(10), IN `param_profileImg` LONGTEXT, IN `param_is_FirstLogin` INT, IN `param_is_WebLogin` INT, IN `param_device_id` VARCHAR(255), IN `param_device_platform` VARCHAR(255))  BEGIN
DECLARE playerName varchar(200);
Declare err varchar(2);
Declare  msg varchar(100);
DECLARE isRecordExist int;
DECLARE isEmailExist int;
SELECT count(*) into isEmailExist from user_details WHERE email=param_email AND isDeleted=0;
SELECT count(*) into isRecordExist from user_details WHERE p_id=param_p_id AND isDeleted=0;
if (isRecordExist<1)
THEN

IF( isEmailExist=0) THEN
INSERT INTO user_details (playerName,firstName,lastName,userName,email,contactNumber,gender,dob,password,homeCourse,vaccineStatus,hdcp,hdcpCertificate,employment,companyName,jobTitle,platformLink,industry,roleId,isWebUser,isFirstLogin,createdDate,isDeleted,updatedDate,isAccountVerified,device_id,device_platform,countryId,stateId)
  VALUES ( concat(param_FirstName," ",param_LastName),param_FirstName,param_LastName,param_userName,param_email,param_contact,param_gender,param_dob,param_password,
          param_HomeCourse,param_vaccineStatus,param_hdcp,param_hdcpCertificate,param_employment,param_company,param_jobTitle,param_platformLink,param_industry,param_roleId,param_is_WebLogin,0,now(),0,now(),0,param_device_id,param_device_platform,param_countryId,param_stateId);

  set err="";
  set msg="Player Created Successfully";

  ELSEIF(isEmailExist>0)
  THEN
  set err="X";
  set msg="Email Already Exist";



END IF;
else
  UPDATE user_details set playerName=(concat(param_FirstName," ",param_LastName)), userName=param_userName,
  firstName=param_FirstName,
  lastName=param_LastName,email=param_email,contactNumber=param_contact,gender=param_gender,
  dob=param_dob,countryId=param_countryId,stateId=param_stateId,profileImg=param_profileImg,device_id=param_device_id,device_platform=param_device_platform,homeCourse=param_HomeCourse,
  password=param_password, employment=param_employment, companyName=param_company,jobTitle=param_jobTitle, industry=param_industry,   updatedDate=now() where p_id=param_p_id;
set err="";
set msg="Player Updated Successfully";
END IF;
Select err,msg from DUAL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `save_user_picture` (IN `param_p_id` VARCHAR(50), IN `param_profileImg` LONGTEXT)  BEGIN

Declare err varchar(2);
Declare  msg varchar(100);
DECLARE isRecordExist int;

SELECT count(*) into isRecordExist from user_details WHERE p_id=param_p_id AND isDeleted=0;
if (isRecordExist=1)
THEN

  UPDATE user_details set profileImg=param_profileImg,
 updatedDate=now() where p_id=param_p_id;  
	set err="";
	set msg="Player Profile Picture Updated Successfully";
END IF;
Select err,msg from DUAL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `summaryTable` ()  begin
CREATE TEMPORARY TABLE tempTble
(pid int ,gross int, net int, birdie int);
insert into tempTble  
SELECT pid, sum(gross) as gross, sum(net) as net, sum(birdie) as birdie FROM `score_details` WHERE month(`tournament_date`) =9  GROUP by pid;
SELECT score_details.pid, round, '72' as Par, score_details.net, score_details.gross, score_details.birdie, tempTble.* FROM `score_details` left join tempTble on tempTble.pid=score_details.pid;
drop table tempTble;

   END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tournament_coupon` (IN `param_tourId` VARCHAR(100))  BEGIN
DECLARE err varchar(100);
DECLARE msg varchar(255);
DECLARE isRecordExist int;

SELECT count(*) into isRecordExist from tournament_score_details WHERE tour_id=param_tourId;
if (isRecordExist>=1)THEN 
 
 SELECT * FROM tournament_coupon_details where tourID=param_tourId;
  ELSE
     set err="X";
  set msg="Record not found";
 
  END IF;
 
  SELECT err,msg from DUAL; 

  END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tournament_Play_or_withdraw` (`param_tournamentId` VARCHAR(50), `param_isPlay` INT, `param_isWithdraw` INT, `param_playerId` VARCHAR(50), `param_roundId` INT)  BEGIN
Declare err varchar(2);

DECLARE isRecordExist int;
DECLARE msg varchar(200);
SELECT count(*) into isRecordExist from tournament_group_player_details WHERE tournamentId=param_tournamentId and playerId=param_playerId and roundId=param_roundId;
if(isRecordExist>0) THEN
Update tournament_group_player_details set isPlay=param_isPlay, isWithdraw=param_isWithdraw where tournamentId=param_tournamentId and playerId=param_playerId and roundId=param_roundId;


set err="";
if( param_isPlay=1) then
set msg="Tournament Playing";
else

 set msg="Tournament withdrawl succesfully";
end if ;
ELSE
set err="X";
set msg="Record not found";
END IF;
select err,msg from dual;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCouponRedeemStatus` (IN `param_couponId` VARCHAR(100), IN `param_playerId` VARCHAR(100), IN `param_status` INT(2))  BEGIN
DECLARE isCouponExist int;
Declare err varchar(2);
Declare  msg varchar(100);
select count(*) into isCouponExist from tournament_coupon_details where couponId=param_couponId;
if (isCouponExist >0)  Then
update tournament_coupon_details set playerId=param_playerId, redeemStatus=param_status where couponId=param_couponId; 
set err="";
set msg="Successfully Redeemed Coupon!";
else 

set err="X";
set msg="No Coupon Exist !";
end if;
select err,msg from dual;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCourseHandicap` (IN `param_playerId` VARCHAR(50), IN `param_hndycap` VARCHAR(255))  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);
DECLARE isRecordExist int;
DECLARE isPlayerExist int;

SELECT count(*) into isRecordExist from user_details WHERE p_id=param_playerId and isDeleted=0;
if(isRecordExist=1) THEN


UPDATE user_details SET hdcp = param_hndycap WHERE p_id=param_playerId;
set err="";
set msg="Handicap updated successfully";

ELSE
set err="X";
set msg="Record not found";
END IF;

select err,msg from dual;
 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `user_change_password` (IN `param_email` VARCHAR(200), IN `param_passcode` VARCHAR(200), IN `param_newPassword` VARCHAR(200))  BEGIN

 Declare err varchar(2);
Declare  msg varchar(100);
DECLARE isRecordExist int;

SELECT count(*) into isRecordExist from user_details WHERE email=param_email AND password=param_passcode;
if (isRecordExist>0)
THEN
  
UPDATE user_details set password=param_newPassword, isFirstLogin=0 where email=param_email;
  set err="";
  set msg="Reset password Successfully";
  ELSE 
  set err="X";
  set msg="Old password does not match";
  end if;
  
  Select err,msg from DUAL;
  
 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `user_forgot_password` (IN `param_email` VARCHAR(200))  BEGIN
 DECLARE passCode int;
 Declare err varchar(2);
Declare  msg varchar(100);
Declare emailAddress varchar(200);
DECLARE usrName varchar(100);
DECLARE isRecordExist int;

SELECT count(*) into isRecordExist from user_details WHERE email=param_email AND isDeleted=0;
if (isRecordExist>0)
THEN

  set passCode =floor(RAND()* (900000))+100000; /*Generate passCode*/
  SELECT email,userName into emailAddress, usrName from user_details WHERE email=param_email AND isDeleted=0;
  update user_details set password=passCode, updatedDate=now(), isFirstLogin=1 where email=param_email;
  
    set err="";
  set msg="Password Generated Successfully";
  ELSE
     set err="X";
  set msg="Record Does not exist";
  set emailAddress="";
  end if;
  
  Select err,msg,emailAddress,passCode,usrName from DUAL;
  
 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `user_login` (IN `param_emailId` VARCHAR(100), IN `param_password` VARCHAR(100))  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);
Declare isUserExist int;


select count(*) into isUserExist from user_details where email=param_emailId And  password=param_password And isDeleted=0;
if(isUserExist>0) then

SELECT * from user_details INNER join  user_role on user_role.roleId=user_details.roleId WHERE email=param_emailId And  password=param_password And user_details.roleId=1 and  user_details.isDeleted=0; 
Set err="";
Set msg="User login successfully";


ELSE

Set err="X";
Set msg="Sorry, either username or password is incorrect. Please try again";


END IF;
SELECT err,msg from DUAL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `verify_User_Account` (IN `param_userId` INT)  BEGIN
 DECLARE otp int;
 Declare err varchar(2);
Declare  msg varchar(100);
Declare emailAddress varchar(200);
DECLARE usrName varchar(100);

DECLARE isRecordExist int;

SELECT count(*) into isRecordExist from user_details WHERE p_id=param_userId AND isDeleted=0;
if (isRecordExist>0)
THEN

  set otp =floor(RAND()* (900000))+100000; /*Generate Otp*/
  SELECT email,userName into emailAddress, usrName from user_details WHERE p_id=param_userId AND isDeleted=0;
  
  INSERT into user_account_otp (userId,otp,createdDate)  VALUES (param_userId,otp,now());
  
    set err="";
  set msg="otp Generated Successfully";
  ELSE
     set err="X";
  set msg="Record Does not exist";
  set emailAddress="";
  end if;
  
  Select err,msg,emailAddress,otp,usrName from DUAL;
  
  END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `SPLIT_STR` (`x` VARCHAR(255), `delim` VARCHAR(12), `pos` INT) RETURNS VARCHAR(255) CHARSET utf8mb4 RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos),
       LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1),
       delim, '')$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `ads_list`
--

CREATE TABLE `ads_list` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `ads_list`
--

INSERT INTO `ads_list` (`id`, `name`, `url`) VALUES
(1, 'advertise 1', 'http://www.eisiltd.com/golfer_uploads/ads1.png'),
(2, 'advertise 2', 'http://www.eisiltd.com/golfer_uploads/ads2.png');

-- --------------------------------------------------------

--
-- Table structure for table `contact`
--

CREATE TABLE `contact` (
  `s.no` int(11) NOT NULL,
  `gname` varchar(150) NOT NULL,
  `gemail` varchar(150) NOT NULL,
  `phone` bigint(11) NOT NULL,
  `subject` varchar(100) NOT NULL,
  `msg` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `contact`
--

INSERT INTO `contact` (`s.no`, `gname`, `gemail`, `phone`, `subject`, `msg`) VALUES
(1, 'undefined', 'undefined', 0, '4444gff', 'test'),
(2, 'nokia', 'abc@nokia.com', 2147483647, 'grttret', 'undefined'),
(3, 'test', 'abc@nokia.com', 333333333, 'test', 'undefined'),
(6, 'ooooooooo', 'dd@ff.com', 6666444, 'grttret', 'trsss'),
(8, 'xyz', 'abc@nokia.com', 766767676767, 'tyg', 'fgfggf'),
(9, 'test', 'test@test.com', 7878787878, 'test', 'testttt'),
(10, 'nokia', 'abc@nokia.com', 3453454355, '4444ghg', 'dedse'),
(12, 'test', 'testtest@test.com', 7676767676, '4444ghg', 'dsfs'),
(13, 'Shiv Mishra', 'meenakshi@echelonedge.com', 9811111111, 'test', 'test'),
(14, 'dsfds', 'test@mail.com', 4444444444, '444tg', 'dfgf');

-- --------------------------------------------------------

--
-- Table structure for table `country`
--

CREATE TABLE `country` (
  `country_Id` int(11) NOT NULL,
  `country_name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `country`
--

INSERT INTO `country` (`country_Id`, `country_name`) VALUES
(1, 'INDIA'),
(2, 'USA');

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `cid` int(11) NOT NULL,
  `c_code` varchar(50) NOT NULL,
  `cname` varchar(100) NOT NULL,
  `caddress` varchar(200) NOT NULL,
  `par1` int(2) NOT NULL,
  `par2` int(2) NOT NULL,
  `par3` int(2) NOT NULL,
  `par4` int(2) NOT NULL,
  `par5` int(2) NOT NULL,
  `par6` int(2) NOT NULL,
  `par7` int(2) NOT NULL,
  `par8` int(2) NOT NULL,
  `par9` int(2) NOT NULL,
  `par10` int(2) NOT NULL,
  `par11` int(2) NOT NULL,
  `par12` int(2) NOT NULL,
  `par13` int(2) NOT NULL,
  `par14` int(2) NOT NULL,
  `par15` int(2) NOT NULL,
  `par16` int(2) NOT NULL,
  `par17` int(2) NOT NULL,
  `par18` int(2) NOT NULL,
  `pinn` int(2) NOT NULL,
  `pout` int(2) NOT NULL,
  `hdcp1` int(3) NOT NULL,
  `hdcp2` int(3) NOT NULL,
  `hdcp3` int(3) NOT NULL,
  `hdcp4` int(3) NOT NULL,
  `hdcp5` int(3) NOT NULL,
  `hdcp6` int(3) NOT NULL,
  `hdcp7` int(3) NOT NULL,
  `hdcp8` int(3) NOT NULL,
  `hdcp9` int(3) NOT NULL,
  `hdcp10` int(3) NOT NULL,
  `hdcp11` int(3) NOT NULL,
  `hdcp12` int(3) NOT NULL,
  `hdcp13` int(3) NOT NULL,
  `hdcp14` int(3) NOT NULL,
  `hdcp15` int(3) NOT NULL,
  `hdcp16` int(3) NOT NULL,
  `hdcp17` int(3) NOT NULL,
  `hdcp18` int(3) NOT NULL,
  `is_deleted` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`cid`, `c_code`, `cname`, `caddress`, `par1`, `par2`, `par3`, `par4`, `par5`, `par6`, `par7`, `par8`, `par9`, `par10`, `par11`, `par12`, `par13`, `par14`, `par15`, `par16`, `par17`, `par18`, `pinn`, `pout`, `hdcp1`, `hdcp2`, `hdcp3`, `hdcp4`, `hdcp5`, `hdcp6`, `hdcp7`, `hdcp8`, `hdcp9`, `hdcp10`, `hdcp11`, `hdcp12`, `hdcp13`, `hdcp14`, `hdcp15`, `hdcp16`, `hdcp17`, `hdcp18`, `is_deleted`) VALUES
(1, '', 'GOLDEN GREENS GOLF & RESORTS', 'Sector 79, Village, Sakatpur Rd, Gurugram, Haryana 122002', 4, 4, 4, 3, 5, 4, 4, 3, 5, 4, 5, 3, 4, 4, 4, 3, 4, 5, 36, 36, 15, 3, 11, 17, 7, 9, 1, 13, 5, 14, 8, 18, 2, 12, 6, 16, 4, 10, 0),
(2, '', 'CLASSIC GOLF RESORT | RIDGE/VALLEY', ' P.O. Hasanpur, Tauru, Haryana 122105', 4, 3, 5, 4, 3, 4, 4, 4, 5, 4, 3, 4, 4, 5, 4, 4, 3, 5, 36, 36, 13, 15, 3, 7, 17, 11, 5, 1, 9, 6, 14, 16, 4, 12, 8, 2, 18, 10, 0),
(3, '', 'Qutab Golf Course', ' 249/5 B, Sri Aurobindo Marg, Lado Sarai Extension, Lado Sarai, New Delhi, Delhi 110030', 4, 4, 4, 4, 4, 3, 4, 5, 4, 3, 4, 4, 3, 3, 4, 5, 4, 4, 34, 36, 1, 17, 11, 15, 7, 13, 3, 5, 9, 18, 12, 10, 14, 6, 8, 4, 2, 16, 0),
(29, 'course29', 'CLASSIC GOLF RESORT | CANYON/RIDGE', 'P.O. Hasanpur, Tauru, Haryana 122105', 3, 5, 3, 4, 4, 4, 4, 5, 4, 4, 3, 5, 4, 3, 4, 4, 4, 5, 36, 36, 17, 1, 15, 13, 11, 9, 5, 3, 7, 14, 16, 4, 8, 18, 12, 6, 2, 10, 0);

-- --------------------------------------------------------

--
-- Table structure for table `course_rating`
--

CREATE TABLE `course_rating` (
  `cRatingId` int(11) NOT NULL,
  `courseId` int(11) NOT NULL,
  `teeName` varchar(50) NOT NULL,
  `courseRating` varchar(255) NOT NULL,
  `slopeRating` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `course_rating`
--

INSERT INTO `course_rating` (`cRatingId`, `courseId`, `teeName`, `courseRating`, `slopeRating`) VALUES
(11, 3, 'red', '72.2', '111'),
(12, 29, 'blue', '64.7', '112'),
(13, 2, 'Black', '74.5', '108'),
(14, 2, 'Gold', '72.8', '113'),
(15, 2, 'Blue', '72.8', '102'),
(16, 2, 'White', '69.6', '105'),
(17, 1, 'Black', '73.3', '122'),
(18, 1, 'Blue', '72.3', '119'),
(19, 1, 'White', '71.2', '116'),
(20, 1, 'Red', '69.4', '111');

-- --------------------------------------------------------

--
-- Table structure for table `course_tee`
--

CREATE TABLE `course_tee` (
  `tee_Id` int(11) NOT NULL,
  `tee_Name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `course_tee`
--

INSERT INTO `course_tee` (`tee_Id`, `tee_Name`) VALUES
(1, 'Tee 1'),
(2, 'Tee 2'),
(3, 'Tee 3'),
(4, 'Tee 4'),
(7, 'Tee 5'),
(8, 'Tee 6'),
(9, 'Tee 7'),
(10, 'Tee 8'),
(11, 'Tee 9'),
(12, 'Tee 10'),
(13, 'Tee 11'),
(14, 'Tee 12'),
(15, 'Tee 13'),
(16, 'Tee 14'),
(17, 'Tee 15'),
(18, 'Tee 16'),
(19, 'Tee 17'),
(20, 'Tee 18');

-- --------------------------------------------------------

--
-- Table structure for table `employment`
--

CREATE TABLE `employment` (
  `employmentId` int(11) NOT NULL,
  `employmentName` varchar(150) DEFAULT NULL,
  `isDeleted` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `employment`
--

INSERT INTO `employment` (`employmentId`, `employmentName`, `isDeleted`) VALUES
(1, 'Salaried', 0),
(2, 'Self-Employed', 0);

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `tourID` int(11) NOT NULL,
  `tournamentName` varchar(300) NOT NULL,
  `eventType` varchar(150) NOT NULL,
  `numRounds` int(2) NOT NULL,
  `is_Deleted` int(2) NOT NULL,
  `startDate` timestamp NULL DEFAULT NULL,
  `endDate` timestamp NULL DEFAULT NULL,
  `created_Date` timestamp NOT NULL DEFAULT current_timestamp(),
  `modified_Date` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_By` varchar(100) NOT NULL,
  `modified_By` varchar(100) NOT NULL,
  `flag` int(2) DEFAULT 0,
  `holes` int(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`tourID`, `tournamentName`, `eventType`, `numRounds`, `is_Deleted`, `startDate`, `endDate`, `created_Date`, `modified_Date`, `created_By`, `modified_By`, `flag`, `holes`) VALUES
(1, 'test tour', '6', 2, 0, '2022-10-20 18:30:00', '2022-10-21 18:30:00', '2022-10-21 06:32:43', '2022-10-21 06:32:43', '', '', 0, 18),
(2, 'Test_today', '7', 3, 0, '2022-10-31 18:30:00', '2022-11-03 18:30:00', '2022-11-01 07:54:24', '2022-11-03 06:34:06', '', '', 0, 18),
(3, 'test21', '6', 2, 0, '2022-11-02 18:30:00', '2022-11-03 18:30:00', '2022-11-03 06:35:12', '2022-11-03 06:43:13', '', '', 0, 18);

-- --------------------------------------------------------

--
-- Table structure for table `event_details`
--

CREATE TABLE `event_details` (
  `t_id` int(11) NOT NULL,
  `tourID` varchar(50) NOT NULL,
  `messageType` varchar(100) NOT NULL,
  `message` longtext NOT NULL,
  `sponsor` varchar(255) NOT NULL,
  `sponsor_Logo` varchar(255) NOT NULL,
  `tournament_Date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `event_details`
--

INSERT INTO `event_details` (`t_id`, `tourID`, `messageType`, `message`, `sponsor`, `sponsor_Logo`, `tournament_Date`) VALUES
(1, '1', 'Review', 'Golfers\' Guild is back with yet another tough and an exciting challenge, thanks to love and support of the golfing fraternity in Gurgaon & Delhi. Covid-19 returned as Omicron and once again, life was disrupted and the world still couldn\'t breathe freely... Golf further reinforced itself as an antidote to the crisis mounted by the disease and was rightly the vanguard among sports that kept the human as well as sportsman spirit alive and kicking.This edition of the tournament is really special as Golfers\'Guild unveils it\'s digital platform that will be used to conduct this tournament, end to end. The tournament is to be held on 26th, 27th Feb and 3rd March at Golden Greens, Canyon - Ridge (Classic) & Ridge - Valley (Classic) respectively. Final day of this thrilling contest on 3rd March will be followed by gala lunch and award ceremony at Classic Golf and Country Club. The competition is tougher this time with low, single digit stalwarts like Ranndeep, Simran, Avneet, Aman, Mihirjit & Rohit S joining the Guild to mount challenge to defending champs Rajiv Ghuman and Aseem Vivek & Bobby Kochhar. Dont miss the thrill, log in to witness a fierce competition amongst these golf lovers.', 'Media Coverage Partner', 'http://golfersguild.in/assets/images/GolfPlusLogo.jpg', '2022-02-26 12:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `group_details`
--

CREATE TABLE `group_details` (
  `groupId` int(11) NOT NULL,
  `groupName` varchar(30) NOT NULL,
  `is_delete` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `group_details`
--

INSERT INTO `group_details` (`groupId`, `groupName`, `is_delete`) VALUES
(1, 'Group A', 0),
(2, 'Group B', 0),
(5, 'Group C', 0),
(6, 'Group D', 0),
(7, 'Group E', 0),
(8, 'Group F', 0);

-- --------------------------------------------------------

--
-- Table structure for table `guildclients`
--

CREATE TABLE `guildclients` (
  `clientId` int(11) NOT NULL,
  `clientName` varchar(250) NOT NULL,
  `clientEmail` varchar(250) NOT NULL,
  `clientAddress` varchar(255) NOT NULL,
  `clientContact` bigint(10) NOT NULL,
  `logo` blob NOT NULL,
  `clientCode` varchar(50) NOT NULL,
  `isDeleted` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `guildclients`
--

INSERT INTO `guildclients` (`clientId`, `clientName`, `clientEmail`, `clientAddress`, `clientContact`, `logo`, `clientCode`, `isDeleted`) VALUES
(1, 'TAG', 'TAG@GMAIL.COM', 'gururg', 5656565656, '', 'tag22', 0),
(2, 'TAG', 'tag@gmail.com', 'test data', 6756455677, '', 'TAG2022', 0);

-- --------------------------------------------------------

--
-- Table structure for table `industry_details`
--

CREATE TABLE `industry_details` (
  `industryId` int(11) NOT NULL,
  `industryName` varchar(150) DEFAULT NULL,
  `isDeleted` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `industry_details`
--

INSERT INTO `industry_details` (`industryId`, `industryName`, `isDeleted`) VALUES
(1, 'Advertising and marketing', 0),
(2, 'Aerospace', 0),
(3, 'Agriculture', 0),
(4, 'Computer and technology', 0),
(5, 'Construction', 0),
(6, 'Education', 0),
(7, 'Energy', 0),
(8, 'Entertainment', 0),
(9, 'Fashion', 0),
(10, 'Finance and economic', 0),
(11, 'Food and beverage', 0),
(12, 'Health care', 0),
(13, 'Hospitality', 0),
(14, 'Manufacturing', 0),
(15, 'Media and news', 0),
(16, 'Mining', 0),
(17, 'Pharmaceutical', 0),
(18, 'Telecommunication', 0),
(19, 'Transportation', 0);

-- --------------------------------------------------------

--
-- Table structure for table `live_tournament_round_details`
--

CREATE TABLE `live_tournament_round_details` (
  `st_id` int(11) NOT NULL,
  `tour_id` int(11) NOT NULL,
  `round_Id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `live_tournament_round_details`
--

INSERT INTO `live_tournament_round_details` (`st_id`, `tour_id`, `round_Id`) VALUES
(1, 1, 3);

-- --------------------------------------------------------

--
-- Table structure for table `master_event_format`
--

CREATE TABLE `master_event_format` (
  `formatKey` int(11) NOT NULL,
  `formatName` varchar(255) NOT NULL,
  `isDeleted` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `master_event_format`
--

INSERT INTO `master_event_format` (`formatKey`, `formatName`, `isDeleted`) VALUES
(1, 'Stableford', 0),
(6, 'Stroke Play', 0),
(7, 'Match Play', 0);

-- --------------------------------------------------------

--
-- Table structure for table `master_tee_colors`
--

CREATE TABLE `master_tee_colors` (
  `colorId` int(11) NOT NULL,
  `colorName` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `master_tee_colors`
--

INSERT INTO `master_tee_colors` (`colorId`, `colorName`) VALUES
(3, 'Black'),
(4, 'Silver'),
(5, 'White'),
(6, 'Blue/White'),
(7, 'Blue'),
(8, 'Teal');

-- --------------------------------------------------------

--
-- Table structure for table `master_vaccine_status`
--

CREATE TABLE `master_vaccine_status` (
  `vaccineId` int(11) NOT NULL,
  `vaccineStatus` varchar(100) DEFAULT NULL,
  `isDeleted` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `master_vaccine_status`
--

INSERT INTO `master_vaccine_status` (`vaccineId`, `vaccineStatus`, `isDeleted`) VALUES
(1, '1st Dose', NULL),
(2, 'Fully Vaccinated', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `old_score_details`
--

CREATE TABLE `old_score_details` (
  `tour_score_id` int(3) NOT NULL,
  `p_id` int(11) NOT NULL,
  `tour_id` int(11) NOT NULL,
  `score1` int(2) NOT NULL,
  `score2` int(2) NOT NULL,
  `score3` int(2) NOT NULL,
  `score4` int(2) NOT NULL,
  `score5` int(2) NOT NULL,
  `score6` int(2) NOT NULL,
  `score7` int(2) NOT NULL,
  `score8` int(2) NOT NULL,
  `score9` int(2) NOT NULL,
  `score10` int(2) NOT NULL,
  `score11` int(2) NOT NULL,
  `score12` int(2) NOT NULL,
  `score13` int(2) NOT NULL,
  `score14` int(2) NOT NULL,
  `score15` int(2) NOT NULL,
  `score16` int(2) NOT NULL,
  `score17` int(2) NOT NULL,
  `score18` int(2) NOT NULL,
  `round_Id` int(10) NOT NULL,
  `hdcp` float NOT NULL,
  `inn` int(11) NOT NULL,
  `outt` int(11) NOT NULL,
  `gross` int(11) NOT NULL,
  `net` int(11) NOT NULL,
  `birdie` int(11) NOT NULL,
  `holeNum` int(10) DEFAULT 0,
  `cid` varchar(4) NOT NULL,
  `scoreDifferential` varchar(250) NOT NULL,
  `createdDate` datetime DEFAULT NULL,
  `isDeleted` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `player_details`
--

CREATE TABLE `player_details` (
  `pid` int(11) NOT NULL,
  `playerName` varchar(50) NOT NULL,
  `userName` varchar(55) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `email` varchar(80) NOT NULL,
  `contact_Number` varchar(255) NOT NULL,
  `gender` varchar(6) NOT NULL,
  `dob` timestamp NULL DEFAULT NULL,
  `country_Id` int(10) NOT NULL,
  `state_Id` int(10) NOT NULL,
  `is_deleted` int(11) DEFAULT 0,
  `created_Date` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_Date` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_By` int(11) NOT NULL,
  `updated_By` int(11) NOT NULL,
  `profile_Img` longtext NOT NULL,
  `password` varchar(100) NOT NULL,
  `role_Id` int(11) NOT NULL,
  `is_Web_User` int(11) NOT NULL,
  `is_First_Login` int(11) NOT NULL,
  `homeCourse` varchar(255) NOT NULL,
  `vaccineStatus` varchar(50) NOT NULL,
  `handicap` int(3) NOT NULL,
  `handicapCertificate` longtext NOT NULL,
  `employment` int(2) NOT NULL,
  `companyName` varchar(100) NOT NULL,
  `jobTitle` varchar(150) NOT NULL,
  `platformLink` varchar(250) NOT NULL,
  `industry` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `player_details`
--

INSERT INTO `player_details` (`pid`, `playerName`, `userName`, `firstName`, `lastName`, `email`, `contact_Number`, `gender`, `dob`, `country_Id`, `state_Id`, `is_deleted`, `created_Date`, `updated_Date`, `created_By`, `updated_By`, `profile_Img`, `password`, `role_Id`, `is_Web_User`, `is_First_Login`, `homeCourse`, `vaccineStatus`, `handicap`, `handicapCertificate`, `employment`, `companyName`, `jobTitle`, `platformLink`, `industry`) VALUES
(1, 'Gaurav Gandhi', 'gauravgandhi123', '', '', 'gg@gamil.com', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', 'abc@123', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(2, 'Raman Dua', 'ramandua123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(3, 'Manish Dubey', 'manishdubey123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(4, 'C.B. Sharma', 'cbsharma123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(6, 'K.P. Kumar', 'kpkumar123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(7, 'Rohit Moudgil', 'rohitmoudgil123', '', '', '', '0', '', NULL, 0, 0, 1, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(8, 'Naresh Kumar', 'nareshkumar123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(9, 'Kuljit Walia', 'kuljitwalia123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(10, 'Rohit Sultania', 'rohitsultania123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(11, 'Rishi Poddar', 'rishipoddar123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(12, 'Aseem Vivek', 'aseemvivek123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(13, 'Pulak Chakraborty', 'pulakchakraborty123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(14, 'Dev Amritesh', 'devamritesh123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(15, 'Manjit Bagri', 'manjitbagri123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(16, 'Col. Sanjay Verma', 'colsanjayverma123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(18, 'Manish Rathi', 'manishrathi123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(19, 'Jaideep Brar', 'jaideepbrar123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(20, 'Pankaj Tandon', 'pankajtandon123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(21, 'Azaad Gill', 'azaadgill123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(22, 'Col. Manish Dubey', 'colmanishdubey123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(23, 'Col. Rajesh Bains', 'colrajeshbains123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(24, 'Bobby Kochhar', 'bobbykochhar123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(25, 'Rajiv Ghumman', 'rajivghumman123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(26, 'Col. Sunny Meitei', 'colsunnymeitei123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(27, 'Col. Azad S Ruhail', 'colazadsruhail123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(28, 'Gaurav Gill', 'gauravgill123', '', '', '', '0', '', NULL, 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(32, 'abac xyza', 'aaaassxx77f', 'abac', 'xyza', 'afajaabc@aa.com', '9898898980', 'male', '2020-11-10 18:30:00', 1, 8, 0, '2021-12-15 07:00:58', '2021-12-15 10:12:08', 0, 0, '', 'abc222', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(34, 'ankit aaaa', 'ankitaaaa123', 'ankit', 'aaaa', 'abc@nokia.com', '2147483647', 'female', '2021-12-03 18:30:00', 0, 0, 0, '2021-12-15 07:00:58', '2021-12-15 07:00:58', 0, 0, '', '', 0, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(36, 'abc xyz', 'ssxx', 'abc', 'xyz', 'abc@aa.com', '9898898980', 'male', '0000-00-00 00:00:00', 1, 8, 1, '2021-12-15 07:32:34', '2021-12-15 07:32:34', 0, 0, '', 'abc222', 2, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(38, 'abc xyz', 'ssxxdd', 'abc', 'xyz', 'abc@aa.com', '9898898980', 'male', '2011-11-10 18:30:00', 1, 27, 1, '2021-12-15 07:52:59', '2021-12-15 07:52:59', 0, 0, '', 'abc222', 2, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(40, 'abac xyza', 'aaaassxx77', 'abac', 'xyza', 'aaaabc@aa.com', '9898898980', 'male', '2020-11-10 18:30:00', 1, 4, 0, '2021-12-15 10:09:51', '2021-12-15 10:09:51', 0, 0, '', 'abc222', 2, 0, 0, '', '', 0, '', 0, '', '', '0', ''),
(41, 'ankit khandelwal', 'ankit123', 'ankit', 'khandelwal', 'ankit@gmail.com', '7878787867', 'male', '0000-00-00 00:00:00', 1, 6, 0, '2021-12-16 12:25:48', '2021-12-16 12:25:48', 0, 0, '', 'ankit123', 2, 1, 0, '', '', 0, '', 0, '', '', '0', ''),
(42, 'meenakshi ji', 'sassassa', 'meenakshi', 'ji', 'abc2@nokia.com', '3443534', 'female', '2021-05-10 18:30:00', 1, 34, 1, '2021-12-16 12:38:32', '2021-12-16 12:38:32', 0, 0, '', 'fdsfdsf', 2, 1, 0, '', '', 0, '', 0, '', '', '0', ''),
(43, 'Meena kumari', 'meen@aksh', 'Meena', 'kumari', 'meen@echelon.com', 'undefined', 'female', '2022-02-16 18:30:00', 1, 4, 0, '2022-06-03 07:01:49', '2022-06-03 07:01:49', 0, 0, 'undefined', '12345656', 2, 0, 0, '', '', 0, '', 0, '', '', '', ''),
(44, 'garima kapoor', 'garima123', 'garima', 'kapoor', 'garima@echeoln.com', 'undefined', 'female', '2022-06-09 18:30:00', 1, 33, 0, '2022-06-03 07:05:16', '2022-06-03 07:05:16', 0, 0, 'undefined', '344556777777', 2, 0, 0, '', '', 0, '', 0, '', '', '', ''),
(45, 'ankit kumar', 'ankit12356', 'ankit', 'kumar', 'ankitKumar@gmail.com', 'undefined', 'male', '2022-04-29 18:30:00', 1, 38, 0, '2022-06-03 07:14:24', '2022-06-03 07:14:24', 0, 0, 'undefined', '7878787878', 2, 0, 0, '', '', 0, '', 0, '', '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `round_details`
--

CREATE TABLE `round_details` (
  `round_Id` int(11) NOT NULL,
  `event_Date` varchar(255) DEFAULT NULL,
  `cid` int(11) NOT NULL,
  `tourID` int(11) NOT NULL,
  `created_Date` timestamp NOT NULL DEFAULT current_timestamp(),
  `modified_Date` timestamp NOT NULL DEFAULT current_timestamp(),
  `round_name` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `round_details`
--

INSERT INTO `round_details` (`round_Id`, `event_Date`, `cid`, `tourID`, `created_Date`, `modified_Date`, `round_name`) VALUES
(1, '2022-10-21 00:00:00', 2, 1, '2022-10-21 06:32:43', '2022-10-21 06:32:43', 'Round1'),
(2, ' 2022-10-22 00:00:00', 1, 1, '2022-10-21 06:32:43', '2022-10-21 06:32:43', 'Round2'),
(6, '2022-11-01 00:00:00', 2, 2, '2022-11-03 06:34:06', '2022-11-03 06:34:06', 'Round1'),
(7, ' 2022-11-02 00:00:00', 2, 2, '2022-11-03 06:34:06', '2022-11-03 06:34:06', 'Round2'),
(8, ' 2022-11-04 00:00:00', 1, 2, '2022-11-03 06:34:06', '2022-11-03 06:34:06', 'Round3'),
(11, '2022-11-03 00:00:00', 2, 3, '2022-11-03 06:43:13', '2022-11-03 06:43:13', 'Round1'),
(12, ' 2022-11-04 00:00:00', 2, 3, '2022-11-03 06:43:13', '2022-11-03 06:43:13', 'Round2');

-- --------------------------------------------------------

--
-- Table structure for table `score_details`
--

CREATE TABLE `score_details` (
  `playerId` varchar(250) NOT NULL,
  `serial` int(3) NOT NULL,
  `score1` int(2) NOT NULL,
  `score2` int(2) NOT NULL,
  `score3` int(2) NOT NULL,
  `score4` int(2) NOT NULL,
  `score5` int(2) NOT NULL,
  `score6` int(2) NOT NULL,
  `score7` int(2) NOT NULL,
  `score8` int(2) NOT NULL,
  `score9` int(2) NOT NULL,
  `score10` int(2) NOT NULL,
  `score11` int(2) NOT NULL,
  `score12` int(2) NOT NULL,
  `score13` int(2) NOT NULL,
  `score14` int(2) NOT NULL,
  `score15` int(2) NOT NULL,
  `score16` int(2) NOT NULL,
  `score17` int(2) NOT NULL,
  `score18` int(2) NOT NULL,
  `tournament_date` datetime NOT NULL,
  `hdcp` float NOT NULL,
  `inn` int(11) NOT NULL,
  `outt` int(11) NOT NULL,
  `gross` int(11) NOT NULL,
  `net` int(11) NOT NULL,
  `birdie` int(11) NOT NULL,
  `cid` varchar(4) NOT NULL,
  `createdDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `scoreDifferential` varchar(250) NOT NULL,
  `holeNum` int(10) NOT NULL,
  `teeName` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `score_details`
--

INSERT INTO `score_details` (`playerId`, `serial`, `score1`, `score2`, `score3`, `score4`, `score5`, `score6`, `score7`, `score8`, `score9`, `score10`, `score11`, `score12`, `score13`, `score14`, `score15`, `score16`, `score17`, `score18`, `tournament_date`, `hdcp`, `inn`, `outt`, `gross`, `net`, `birdie`, `cid`, `createdDate`, `scoreDifferential`, `holeNum`, `teeName`) VALUES
('6', 1, 4, 5, 6, 5, 4, 5, 6, 7, 3, 5, 8, 6, 5, 7, 4, 5, 3, 4, '1999-05-21 00:00:00', 16, 50, 4, 107, 90, 1, '2', '2022-09-06 09:26:30', '5.5', 18, ''),
('6', 2, 4, 0, 4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, '1990-08-12 00:00:00', 5, 6, 4, 4, 1, 0, '3', '2022-09-06 12:09:35', '4.5', 18, 'red');

-- --------------------------------------------------------

--
-- Table structure for table `sponserslist`
--

CREATE TABLE `sponserslist` (
  `id` int(11) NOT NULL,
  `imageAddress` varchar(255) NOT NULL,
  `alternateText` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `sponserslist`
--

INSERT INTO `sponserslist` (`id`, `imageAddress`, `alternateText`) VALUES
(1, 'http://www.eisiltd.com/golfer_uploads/sponsers/blueair.png', 'Blueair Purifier'),
(2, 'http://www.eisiltd.com/golfer_uploads/sponsers/EchelonLogo.png', 'Echelon Edge Pvt. Ltd'),
(3, 'http://www.eisiltd.com/golfer_uploads/sponsers/parknsecureLogo.png', 'ParknSecure');

-- --------------------------------------------------------

--
-- Table structure for table `stableford_points`
--

CREATE TABLE `stableford_points` (
  `sno` int(11) NOT NULL,
  `points` int(11) NOT NULL,
  `netScoreName` varchar(250) NOT NULL,
  `netScorePoints` int(11) NOT NULL,
  `isDeleted` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `stableford_points`
--

INSERT INTO `stableford_points` (`sno`, `points`, `netScoreName`, `netScorePoints`, `isDeleted`) VALUES
(1, 0, 'Double Bogie', 2, 0),
(2, 1, 'Bogie', 1, 0),
(3, 2, 'Par', 0, 0),
(4, 3, 'Birdie', -1, 0),
(5, 4, 'Eagle', -2, 0),
(6, 5, 'Albatross', -3, 0),
(7, 6, 'Albatross', -4, 0),
(8, 0, 'undefined', 0, 1),
(9, 0, 'dd', 4, 1);

-- --------------------------------------------------------

--
-- Table structure for table `state`
--

CREATE TABLE `state` (
  `state_Id` int(11) NOT NULL,
  `state_name` varchar(100) DEFAULT NULL,
  `country_Id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `state`
--

INSERT INTO `state` (`state_Id`, `state_name`, `country_Id`) VALUES
(4, 'ASSAM', 1),
(5, 'ARUNACHAL PRADESH', 1),
(6, 'BIHAR', 1),
(7, 'GUJRAT', 1),
(8, 'HARYANA', 1),
(9, 'HIMACHAL PRADESH', 1),
(10, 'JAMMU & KASHMIR', 1),
(11, 'KARNATAKA', 1),
(12, 'KERALA', 1),
(13, 'MADHYA PRADESH', 1),
(14, 'MAHARASHTRA', 1),
(15, 'MANIPUR', 1),
(16, 'MEGHALAYA', 1),
(17, 'MIZORAM', 1),
(18, 'NAGALAND', 1),
(19, 'ORISSA', 1),
(20, 'PUNJAB', 1),
(21, 'RAJASTHAN', 1),
(22, 'SIKKIM', 1),
(23, 'TAMIL NADU', 1),
(24, 'TRIPURA', 1),
(25, 'UTTAR PRADESH', 1),
(26, 'WEST BENGAL', 1),
(27, 'DELHI', 1),
(28, 'GOA', 1),
(29, 'PONDICHERY', 1),
(30, 'LAKSHDWEEP', 1),
(31, 'DAMAN & DIU', 1),
(32, 'DADRA & NAGAR', 1),
(33, 'CHANDIGARH', 1),
(34, 'ANDAMAN & NICOBAR', 1),
(35, 'UTTARANCHAL', 1),
(36, 'JHARKHAND', 1),
(37, 'CHATTISGARH', 1),
(38, 'ANDHRA PRADESH', 1);

-- --------------------------------------------------------

--
-- Table structure for table `tournament_coupon_details`
--

CREATE TABLE `tournament_coupon_details` (
  `couponId` int(11) NOT NULL,
  `couponCode` varchar(100) NOT NULL,
  `couponCount` int(30) NOT NULL,
  `tourID` int(11) DEFAULT NULL,
  `round_Id` int(11) DEFAULT NULL,
  `redeemStatus` int(2) DEFAULT NULL,
  `playerId` int(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tournament_coupon_details`
--

INSERT INTO `tournament_coupon_details` (`couponId`, `couponCode`, `couponCount`, `tourID`, `round_Id`, `redeemStatus`, `playerId`) VALUES
(4, 'HJSHDJHSJHDS', 1, 48, 78, 1, 19),
(5, 'GHKJHKJHKHH', 2, 48, 79, 1, 20),
(6, 'samosa', 1, 57, 98, 0, 0),
(7, 'cold drink', 1, 57, 100, 0, 0),
(8, 'idli', 2, 57, 0, 0, 0),
(9, 'Subway', 2, 72, 141, 0, 0),
(10, 'samosa', 2, 5, 8, 0, 0),
(16, '13ACV', 2, 8, 18, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tournament_details`
--

CREATE TABLE `tournament_details` (
  `tourID` int(10) NOT NULL,
  `tournamentName` varchar(300) NOT NULL,
  `created_By` varchar(100) NOT NULL,
  `modified_By` varchar(100) NOT NULL,
  `modified_Date` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_Date` timestamp NOT NULL DEFAULT current_timestamp(),
  `role_Id` int(11) NOT NULL,
  `is_Deleted` int(2) NOT NULL,
  `couponId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tournament_group_details`
--

CREATE TABLE `tournament_group_details` (
  `groupId` int(11) NOT NULL,
  `groupName` varchar(100) NOT NULL,
  `tee_Number` int(18) NOT NULL,
  `tee_Time` varchar(50) NOT NULL,
  `tourID` int(10) NOT NULL,
  `round_Id` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tournament_group_details`
--

INSERT INTO `tournament_group_details` (`groupId`, `groupName`, `tee_Number`, `tee_Time`, `tourID`, `round_Id`) VALUES
(1, 'Group1', 13, '12:10', 1, 1),
(2, 'Group1', 14, '12:12', 3, 11),
(3, 'Group2', 13, '12:30', 3, 11);

--
-- Triggers `tournament_group_details`
--
DELIMITER $$
CREATE TRIGGER `addUpdateTournamentGroupDetails` BEFORE DELETE ON `tournament_group_details` FOR EACH ROW BEGIN Insert into tournament_group_details_archive (groupId ,groupName,tee_Number,tee_Time,tourID,round_Id) values(old.groupId,old.groupName,old.tee_Number,old.tee_Time,old.tourID,old.round_Id); 
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tournament_group_details_archive`
--

CREATE TABLE `tournament_group_details_archive` (
  `groupId` int(11) NOT NULL,
  `groupName` varchar(100) NOT NULL,
  `tee_Number` int(18) NOT NULL,
  `tee_Time` varchar(50) NOT NULL,
  `tourID` int(10) NOT NULL,
  `round_Id` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tournament_group_player_details`
--

CREATE TABLE `tournament_group_player_details` (
  `t_player_Id` int(11) NOT NULL,
  `tournamentId` int(11) NOT NULL,
  `groupName` varchar(100) NOT NULL,
  `playerId` int(11) NOT NULL,
  `tee_time` varchar(50) NOT NULL,
  `isPlay` int(11) NOT NULL,
  `isWithdraw` int(10) NOT NULL DEFAULT 0,
  `roundId` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tournament_group_player_details`
--

INSERT INTO `tournament_group_player_details` (`t_player_Id`, `tournamentId`, `groupName`, `playerId`, `tee_time`, `isPlay`, `isWithdraw`, `roundId`) VALUES
(1, 1, 'Group1', 2, '12:10', 1, 0, '1'),
(2, 3, 'Group1', 4, '12:12', 0, 0, '11'),
(3, 3, 'Group2', 2, '12:30', 0, 0, '11'),
(4, 3, 'Group1', 3, '12:22', 0, 0, '11');

-- --------------------------------------------------------

--
-- Table structure for table `tournament_player_list`
--

CREATE TABLE `tournament_player_list` (
  `tour_player_id` int(11) NOT NULL,
  `tourID` int(11) NOT NULL,
  `playerID` int(11) NOT NULL,
  `isPlay` int(11) NOT NULL,
  `isInvited` int(11) NOT NULL,
  `isAccepted` int(11) NOT NULL,
  `isApproved` int(11) NOT NULL,
  `isRejected` int(11) NOT NULL,
  `isWithdraw` int(11) NOT NULL,
  `created_Date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tournament_player_list`
--

INSERT INTO `tournament_player_list` (`tour_player_id`, `tourID`, `playerID`, `isPlay`, `isInvited`, `isAccepted`, `isApproved`, `isRejected`, `isWithdraw`, `created_Date`) VALUES
(1, 1, 2, 0, 1, 1, 1, 0, 0, '2022-10-21'),
(2, 2, 2, 0, 1, 0, 0, 0, 0, '2022-11-01'),
(3, 2, 2, 0, 1, 0, 0, 0, 0, '2022-11-03'),
(5, 3, 2, 0, 1, 1, 1, 0, 0, '2022-11-03'),
(6, 3, 3, 0, 1, 1, 1, 0, 0, '2022-11-03'),
(7, 3, 4, 0, 1, 1, 1, 0, 0, '2022-11-03');

-- --------------------------------------------------------

--
-- Table structure for table `tournament_score_details`
--

CREATE TABLE `tournament_score_details` (
  `tour_score_id` int(3) NOT NULL,
  `p_id` int(11) NOT NULL,
  `tour_id` int(11) NOT NULL,
  `score1` int(2) NOT NULL,
  `score2` int(2) NOT NULL,
  `score3` int(2) NOT NULL,
  `score4` int(2) NOT NULL,
  `score5` int(2) NOT NULL,
  `score6` int(2) NOT NULL,
  `score7` int(2) NOT NULL,
  `score8` int(2) NOT NULL,
  `score9` int(2) NOT NULL,
  `score10` int(2) NOT NULL,
  `score11` int(2) NOT NULL,
  `score12` int(2) NOT NULL,
  `score13` int(2) NOT NULL,
  `score14` int(2) NOT NULL,
  `score15` int(2) NOT NULL,
  `score16` int(2) NOT NULL,
  `score17` int(2) NOT NULL,
  `score18` int(2) NOT NULL,
  `round_Id` int(10) NOT NULL,
  `hdcp` float NOT NULL,
  `inn` int(11) NOT NULL,
  `outt` int(11) NOT NULL,
  `gross` int(11) NOT NULL,
  `net` int(11) NOT NULL,
  `birdie` int(11) NOT NULL,
  `holeNum` int(10) DEFAULT 0,
  `cid` varchar(4) NOT NULL,
  `scoreDifferential` varchar(250) NOT NULL,
  `createdDate` date DEFAULT NULL,
  `isDeleted` int(11) NOT NULL DEFAULT 0,
  `teeName` varchar(250) NOT NULL,
  `groupId` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tournament_score_details`
--

INSERT INTO `tournament_score_details` (`tour_score_id`, `p_id`, `tour_id`, `score1`, `score2`, `score3`, `score4`, `score5`, `score6`, `score7`, `score8`, `score9`, `score10`, `score11`, `score12`, `score13`, `score14`, `score15`, `score16`, `score17`, `score18`, `round_Id`, `hdcp`, `inn`, `outt`, `gross`, `net`, `birdie`, `holeNum`, `cid`, `scoreDifferential`, `createdDate`, `isDeleted`, `teeName`, `groupId`) VALUES
(1, 4, 3, 5, 6, 5, 6, 7, 8, 7, 6, 5, 4, 5, 6, 6, 7, 8, 8, 7, 5, 11, 10, 56, 55, 111, 101, 0, 17, '2', '26.2', '2022-11-03', 0, '14', '2'),
(2, 2, 0, 6, 7, 5, 4, 5, 6, 7, 6, 5, 4, 5, 3, 6, 5, 3, 4, 8, 6, 0, 10, 44, 51, 95, 85, 2, 17, '2', '16.2', '2022-11-01', 0, '14', '');

-- --------------------------------------------------------

--
-- Table structure for table `tournament_winners`
--

CREATE TABLE `tournament_winners` (
  `t_win` int(11) NOT NULL,
  `tourID` varchar(10) NOT NULL,
  `category` varchar(100) NOT NULL,
  `score` int(50) DEFAULT 0,
  `playerId` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tournament_winners`
--

INSERT INTO `tournament_winners` (`t_win`, `tourID`, `category`, `score`, `playerId`) VALUES
(1, '21', 'Gross', 250, '10'),
(2, '21', 'Gross Runner up', 251, '11'),
(3, '21', 'Net', 219, '19'),
(4, '21', 'Net Runner-up', 220, '17'),
(5, '21', 'Birdie', 4, '21'),
(6, '48', 'gross', 255, '11');

-- --------------------------------------------------------

--
-- Table structure for table `user_account_otp`
--

CREATE TABLE `user_account_otp` (
  `id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `otp` int(11) NOT NULL,
  `createdDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user_account_otp`
--

INSERT INTO `user_account_otp` (`id`, `userId`, `otp`, `createdDate`) VALUES
(39, 6, 263762, '2022-01-20 12:00:03'),
(40, 6, 961409, '2022-01-21 14:56:48'),
(41, 6, 164931, '2022-01-21 14:57:58'),
(42, 41, 499189, '2022-06-28 11:11:15'),
(43, 41, 940354, '2022-06-29 15:16:37'),
(44, 41, 873398, '2022-06-29 15:17:52'),
(45, 41, 257789, '2022-06-29 15:19:02'),
(46, 42, 368753, '2022-06-29 15:20:40'),
(47, 6, 408741, '2022-08-04 15:36:49'),
(48, 6, 291617, '2022-08-04 15:37:39'),
(49, 6, 263405, '2022-08-04 15:40:22'),
(50, 6, 668467, '2022-08-04 15:44:32'),
(51, 6, 362597, '2022-08-04 15:45:28'),
(52, 6, 765230, '2022-08-04 15:59:52'),
(53, 6, 643662, '2022-08-04 16:04:18'),
(54, 6, 246721, '2022-08-04 16:17:50'),
(55, 6, 343613, '2022-08-04 16:18:26'),
(56, 6, 358973, '2022-08-04 16:45:27'),
(57, 6, 537175, '2022-08-04 16:47:03'),
(58, 6, 242654, '2022-08-04 16:47:58'),
(59, 6, 485122, '2022-08-04 16:49:43'),
(60, 6, 743689, '2022-08-04 16:50:15'),
(61, 6, 297672, '2022-08-04 16:52:16'),
(62, 6, 191958, '2022-08-04 16:53:33'),
(63, 6, 496724, '2022-08-04 16:55:03'),
(64, 6, 877485, '2022-08-04 16:55:38'),
(65, 6, 411234, '2022-08-04 16:57:34'),
(66, 6, 877016, '2022-08-04 16:58:44'),
(67, 6, 590020, '2022-08-04 16:59:40'),
(68, 6, 470583, '2022-08-04 17:00:49'),
(69, 6, 253366, '2022-08-04 17:01:28'),
(70, 6, 480350, '2022-08-05 11:59:53'),
(71, 6, 708644, '2022-08-05 12:06:00'),
(72, 6, 990130, '2022-08-05 12:09:48'),
(73, 6, 755930, '2022-08-05 12:16:06'),
(74, 6, 709991, '2022-08-05 12:20:10'),
(75, 6, 725450, '2022-08-05 12:22:11'),
(76, 6, 428612, '2022-08-05 12:24:11'),
(77, 6, 765095, '2022-08-05 12:37:51'),
(78, 6, 477706, '2022-08-05 12:39:24'),
(79, 6, 296013, '2022-08-05 12:56:14'),
(80, 6, 798943, '2022-08-05 12:57:50'),
(81, 6, 411567, '2022-08-05 13:39:53');

-- --------------------------------------------------------

--
-- Table structure for table `user_details`
--

CREATE TABLE `user_details` (
  `p_id` int(10) NOT NULL,
  `firstName` varchar(100) DEFAULT NULL,
  `lastName` varchar(100) DEFAULT NULL,
  `playerName` varchar(250) NOT NULL,
  `userName` varchar(100) DEFAULT NULL,
  `contactNumber` varchar(250) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `homeCourse` varchar(250) DEFAULT NULL,
  `hdcp` decimal(10,2) DEFAULT NULL,
  `handicapIndex` decimal(10,2) NOT NULL,
  `hdcpCertificate` longtext DEFAULT NULL,
  `platformLink` varchar(250) DEFAULT NULL,
  `vaccineStatus` int(10) DEFAULT NULL,
  `employment` int(10) DEFAULT NULL,
  `companyName` varchar(150) DEFAULT NULL,
  `jobTitle` varchar(150) DEFAULT NULL,
  `industry` varchar(150) DEFAULT NULL,
  `profileImg` longtext DEFAULT NULL,
  `roleId` int(10) DEFAULT NULL,
  `isDeleted` int(10) DEFAULT NULL,
  `isWebUser` int(10) DEFAULT NULL,
  `isFirstLogin` int(10) DEFAULT NULL,
  `countryId` int(10) DEFAULT NULL,
  `stateId` int(10) DEFAULT NULL,
  `createdDate` datetime DEFAULT NULL,
  `updatedDate` datetime DEFAULT NULL,
  `isAccountVerified` int(11) NOT NULL,
  `device_id` varchar(255) DEFAULT NULL,
  `device_platform` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user_details`
--

INSERT INTO `user_details` (`p_id`, `firstName`, `lastName`, `playerName`, `userName`, `contactNumber`, `email`, `password`, `dob`, `gender`, `homeCourse`, `hdcp`, `handicapIndex`, `hdcpCertificate`, `platformLink`, `vaccineStatus`, `employment`, `companyName`, `jobTitle`, `industry`, `profileImg`, `roleId`, `isDeleted`, `isWebUser`, `isFirstLogin`, `countryId`, `stateId`, `createdDate`, `updatedDate`, `isAccountVerified`, `device_id`, `device_platform`) VALUES
(1, 'Meenakshi', 'Dhariwal', 'Meenakshi Dhariwal', 'Meen1234', '8786567898', 'meenakshi@echelonedge.com', 'test123@A', '1994-01-07', 'female', 'undefined', '0.00', '0.00', 'undefined', 'undefined', 0, 0, 'undefined', 'undefined', '0', NULL, 1, 0, 0, 0, NULL, NULL, '2022-10-15 16:13:19', '2022-10-15 16:13:19', 0, 'undefined', 'undefined'),
(2, 'Ankit', 'Khandelwal', 'Ankit Khandelwal', 'ankit123', '8278767678', 'ankit.khandelwal@echelonedge.com', 'test123@A', '2022-07-31', 'male', 'undefined', '0.00', '0.00', 'undefined', 'undefined', 0, 0, 'undefined', 'undefined', '0', NULL, 2, 0, 0, 0, 1, 25, '2022-10-16 20:00:45', '2022-10-16 20:00:45', 0, 'undefined', 'undefined'),
(3, 'anuj', 'chauhan', 'anuj chauhan', 'anujc', '7010112233', 'anuj.chauhan@echelonedge.com', 'Anuj@1234', '2000-04-07', 'male', 'undefined', '0.00', '0.00', 'undefined', 'undefined', 0, 0, 'undefined', 'undefined', '0', NULL, 3, 0, 0, 0, 1, 6, '2022-11-03 12:10:23', '2022-11-03 12:10:23', 0, 'undefined', 'undefined'),
(4, 'shivani', 'singh', 'shivani singh', 'shivaniSingh', '7010112233', 'shivani.singh@echelonedge.com', 'Shivi@1234', '1999-09-10', 'male', 'undefined', '0.00', '0.00', 'undefined', 'undefined', 0, 0, 'undefined', 'undefined', '0', NULL, 3, 0, 0, 0, 1, 37, '2022-11-03 12:12:19', '2022-11-03 12:12:19', 0, 'undefined', 'undefined');

-- --------------------------------------------------------

--
-- Table structure for table `user_role`
--

CREATE TABLE `user_role` (
  `roleId` int(11) NOT NULL,
  `roleName` varchar(100) DEFAULT NULL,
  `isDeleted` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user_role`
--

INSERT INTO `user_role` (`roleId`, `roleName`, `isDeleted`) VALUES
(1, 'super Admin', 0),
(2, 'admin', 0),
(3, 'user', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ads_list`
--
ALTER TABLE `ads_list`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `contact`
--
ALTER TABLE `contact`
  ADD PRIMARY KEY (`s.no`),
  ADD UNIQUE KEY `phone` (`phone`);

--
-- Indexes for table `country`
--
ALTER TABLE `country`
  ADD PRIMARY KEY (`country_Id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`cid`),
  ADD UNIQUE KEY `cname` (`cname`);

--
-- Indexes for table `course_rating`
--
ALTER TABLE `course_rating`
  ADD PRIMARY KEY (`cRatingId`);

--
-- Indexes for table `course_tee`
--
ALTER TABLE `course_tee`
  ADD PRIMARY KEY (`tee_Id`);

--
-- Indexes for table `employment`
--
ALTER TABLE `employment`
  ADD PRIMARY KEY (`employmentId`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`tourID`);

--
-- Indexes for table `event_details`
--
ALTER TABLE `event_details`
  ADD PRIMARY KEY (`t_id`);

--
-- Indexes for table `group_details`
--
ALTER TABLE `group_details`
  ADD PRIMARY KEY (`groupId`);

--
-- Indexes for table `guildclients`
--
ALTER TABLE `guildclients`
  ADD PRIMARY KEY (`clientId`);

--
-- Indexes for table `industry_details`
--
ALTER TABLE `industry_details`
  ADD PRIMARY KEY (`industryId`);

--
-- Indexes for table `live_tournament_round_details`
--
ALTER TABLE `live_tournament_round_details`
  ADD PRIMARY KEY (`st_id`);

--
-- Indexes for table `master_event_format`
--
ALTER TABLE `master_event_format`
  ADD PRIMARY KEY (`formatKey`);

--
-- Indexes for table `master_tee_colors`
--
ALTER TABLE `master_tee_colors`
  ADD PRIMARY KEY (`colorId`);

--
-- Indexes for table `master_vaccine_status`
--
ALTER TABLE `master_vaccine_status`
  ADD PRIMARY KEY (`vaccineId`);

--
-- Indexes for table `old_score_details`
--
ALTER TABLE `old_score_details`
  ADD PRIMARY KEY (`tour_score_id`);

--
-- Indexes for table `player_details`
--
ALTER TABLE `player_details`
  ADD PRIMARY KEY (`pid`),
  ADD UNIQUE KEY `userName` (`userName`);

--
-- Indexes for table `round_details`
--
ALTER TABLE `round_details`
  ADD PRIMARY KEY (`round_Id`);

--
-- Indexes for table `score_details`
--
ALTER TABLE `score_details`
  ADD PRIMARY KEY (`serial`),
  ADD KEY `pid` (`playerId`),
  ADD KEY `cid` (`cid`);

--
-- Indexes for table `sponserslist`
--
ALTER TABLE `sponserslist`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `stableford_points`
--
ALTER TABLE `stableford_points`
  ADD PRIMARY KEY (`sno`);

--
-- Indexes for table `state`
--
ALTER TABLE `state`
  ADD PRIMARY KEY (`state_Id`);

--
-- Indexes for table `tournament_coupon_details`
--
ALTER TABLE `tournament_coupon_details`
  ADD PRIMARY KEY (`couponId`);

--
-- Indexes for table `tournament_details`
--
ALTER TABLE `tournament_details`
  ADD PRIMARY KEY (`tourID`);

--
-- Indexes for table `tournament_group_details`
--
ALTER TABLE `tournament_group_details`
  ADD PRIMARY KEY (`groupId`);

--
-- Indexes for table `tournament_group_details_archive`
--
ALTER TABLE `tournament_group_details_archive`
  ADD PRIMARY KEY (`groupId`);

--
-- Indexes for table `tournament_group_player_details`
--
ALTER TABLE `tournament_group_player_details`
  ADD PRIMARY KEY (`t_player_Id`);

--
-- Indexes for table `tournament_player_list`
--
ALTER TABLE `tournament_player_list`
  ADD PRIMARY KEY (`tour_player_id`);

--
-- Indexes for table `tournament_score_details`
--
ALTER TABLE `tournament_score_details`
  ADD PRIMARY KEY (`tour_score_id`);

--
-- Indexes for table `tournament_winners`
--
ALTER TABLE `tournament_winners`
  ADD PRIMARY KEY (`t_win`);

--
-- Indexes for table `user_account_otp`
--
ALTER TABLE `user_account_otp`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_details`
--
ALTER TABLE `user_details`
  ADD PRIMARY KEY (`p_id`);

--
-- Indexes for table `user_role`
--
ALTER TABLE `user_role`
  ADD PRIMARY KEY (`roleId`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `ads_list`
--
ALTER TABLE `ads_list`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `contact`
--
ALTER TABLE `contact`
  MODIFY `s.no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `country`
--
ALTER TABLE `country`
  MODIFY `country_Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `cid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT for table `course_rating`
--
ALTER TABLE `course_rating`
  MODIFY `cRatingId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `course_tee`
--
ALTER TABLE `course_tee`
  MODIFY `tee_Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `employment`
--
ALTER TABLE `employment`
  MODIFY `employmentId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `tourID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `event_details`
--
ALTER TABLE `event_details`
  MODIFY `t_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `group_details`
--
ALTER TABLE `group_details`
  MODIFY `groupId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `guildclients`
--
ALTER TABLE `guildclients`
  MODIFY `clientId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `industry_details`
--
ALTER TABLE `industry_details`
  MODIFY `industryId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `live_tournament_round_details`
--
ALTER TABLE `live_tournament_round_details`
  MODIFY `st_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `master_event_format`
--
ALTER TABLE `master_event_format`
  MODIFY `formatKey` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `master_tee_colors`
--
ALTER TABLE `master_tee_colors`
  MODIFY `colorId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `master_vaccine_status`
--
ALTER TABLE `master_vaccine_status`
  MODIFY `vaccineId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `old_score_details`
--
ALTER TABLE `old_score_details`
  MODIFY `tour_score_id` int(3) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_details`
--
ALTER TABLE `player_details`
  MODIFY `pid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `round_details`
--
ALTER TABLE `round_details`
  MODIFY `round_Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `score_details`
--
ALTER TABLE `score_details`
  MODIFY `serial` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `sponserslist`
--
ALTER TABLE `sponserslist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `stableford_points`
--
ALTER TABLE `stableford_points`
  MODIFY `sno` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `state`
--
ALTER TABLE `state`
  MODIFY `state_Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `tournament_coupon_details`
--
ALTER TABLE `tournament_coupon_details`
  MODIFY `couponId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `tournament_details`
--
ALTER TABLE `tournament_details`
  MODIFY `tourID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `tournament_group_details`
--
ALTER TABLE `tournament_group_details`
  MODIFY `groupId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tournament_group_player_details`
--
ALTER TABLE `tournament_group_player_details`
  MODIFY `t_player_Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tournament_player_list`
--
ALTER TABLE `tournament_player_list`
  MODIFY `tour_player_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tournament_score_details`
--
ALTER TABLE `tournament_score_details`
  MODIFY `tour_score_id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tournament_winners`
--
ALTER TABLE `tournament_winners`
  MODIFY `t_win` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `user_account_otp`
--
ALTER TABLE `user_account_otp`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT for table `user_details`
--
ALTER TABLE `user_details`
  MODIFY `p_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `user_role`
--
ALTER TABLE `user_role`
  MODIFY `roleId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
