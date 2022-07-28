-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 28, 2022 at 08:18 AM
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
CREATE DATABASE IF NOT EXISTS `golfersguild` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `golfersguild`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `add_update_client`$$
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

DROP PROCEDURE IF EXISTS `check_otp`$$
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

DROP PROCEDURE IF EXISTS `delete_course`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_course` (IN `param_cid` INT)  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);

Update courses set is_deleted=1 where cid=param_cid;
Set err="";
Set msg="course deleted successfully";	


Select err,msg from DUAL;

END$$

DROP PROCEDURE IF EXISTS `delete_player`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_player` (IN `param_pid` INT)  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);

Update user_details set isDeleted=1 where p_id=param_pid;
Set err="";
Set msg="player deleted successfully";	


Select err,msg from DUAL;

END$$

DROP PROCEDURE IF EXISTS `delete_score`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_score` (IN `param_tour_score_id` VARCHAR(10))  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);

Update tournament_score_details set isDeleted=1 where tour_score_id =param_tour_score_id ;
Set err="";
Set msg="Score deleted successfully";	


Select err,msg from DUAL;

END$$

DROP PROCEDURE IF EXISTS `delete_Tournament`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_Tournament` (IN `param_tourID` INT)  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);

Update events set is_Deleted=1 where tourID=param_tourID;
Set err="";
Set msg="Tournament Deleted Successfully";


Select err,msg from DUAL;

END$$

DROP PROCEDURE IF EXISTS `delete_tournament_coupon_details`$$
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

DROP PROCEDURE IF EXISTS `delete_tournament_group_details`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_tournament_group_details` (IN `param_tourId` INT)  BEGIN
DECLARE isGroupExist int;
Declare err varchar(10);
Declare msg varchar(100);
 Select Count(*)into isGroupExist  from tournament_group_details where tourId=param_tourId;
if(isGroupExist>0) then
 Delete from tournament_group_details where tourId=param_tourId;
 Delete from tournament_group_player_details where tournamentId=param_tourId;
set err="";
set msg="Group deleted successfully";
else
set err="X";
set msg="Tournament group not found";
END IF;
Select err,msg from DUAL;
END$$

DROP PROCEDURE IF EXISTS `getAccept_or_reject_PlayerList`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAccept_or_reject_PlayerList` (IN `param_tournamentId` VARCHAR(50), IN `param_value` VARCHAR(50))  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);
DECLARE isRecordExist int;

SELECT count(*) into isRecordExist from tournament_player_list WHERE tourID=param_tournamentId;
if(isRecordExist>0) THEN

if( param_value=1) then 

SELECT playerID, playerName,tourID, "Accepted" as Status from tournament_player_list INNER JOIN user_details on user_details.p_id=tournament_player_list.playerID  WHERE tourID=param_tournamentId and isAccepted=1 and isDeleted=0;
elseif( param_value=2) then 

 SELECT playerID, playerName,tourID, "Pending" as Status   from tournament_player_list INNER JOIN user_details on user_details.p_id=tournament_player_list.playerID  WHERE tourID=param_tournamentId and isRejected=0 and isAccepted=0 and isDeleted=0;
 
 else
 SELECT playerID, playerName,tourID, "Deny" as Status   from tournament_player_list INNER JOIN user_details on user_details.p_id=tournament_player_list.playerID  WHERE tourID=param_tournamentId and isRejected=1 and isDeleted=0;



 end if ;
ELSE
set err="X";
set msg="Record not found";
END IF;
select err,msg from dual;
 END$$

DROP PROCEDURE IF EXISTS `getApprovedPlayerList`$$
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

DROP PROCEDURE IF EXISTS `getCountryList`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCountryList` ()  BEGIN
	SELECT * FROM country order by country_name asc;
END$$

DROP PROCEDURE IF EXISTS `getCourseList`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCourseList` ()  BEGIN

SELECT * FROM courses where is_deleted=0 order by cname asc;



END$$

DROP PROCEDURE IF EXISTS `getCourseListing`$$
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

DROP PROCEDURE IF EXISTS `getEventDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getEventDetails` (IN `param_tourID` INT)  BEGIN
select * from events where tourID=param_tourID;
END$$

DROP PROCEDURE IF EXISTS `getEventMonth`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getEventMonth` (IN `param_year` VARCHAR(100))  BEGIN

select DISTINCT monthName(created_Date) as month, month(created_Date) as monthNum, year(created_Date) as year from events where  year(created_Date)=param_year and is_Deleted=0;

END$$

DROP PROCEDURE IF EXISTS `getEventYear`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getEventYear` ()  BEGIN
select DISTINCT YEAR(created_Date) as year from events ORDER by YEAR(created_Date) DESC;

END$$

DROP PROCEDURE IF EXISTS `getGroupDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getGroupDetails` ()  BEGIN
	SELECT * FROM group_details order by groupName asc;
END$$

DROP PROCEDURE IF EXISTS `getIndustryListing`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getIndustryListing` ()  BEGIN
select * from industry_details where isDeleted=0;
END$$

DROP PROCEDURE IF EXISTS `getInvitedTournamentListById`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getInvitedTournamentListById` (IN `param_userId` INT)  select * from tournament_player_list inner join events on events.tourID=tournament_player_list.tourID where isInvited=1 and playerID=param_userId and is_Deleted=0 and isPlay=0 and CURRENT_DATE() between startDate and endDate  ORDER by startDate$$

DROP PROCEDURE IF EXISTS `getPlayerListing`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getPlayerListing` ()  BEGIN

SELECT st.*,pd.*,cntry.*,DATE_FORMAT(dob, '%d/%m/%Y')  AS dateofbirth FROM user_details as pd LEFT JOIN state as st on st.state_Id=pd.stateId LEFT JOIN country as cntry on cntry.country_Id=pd.countryId where isDeleted=0 AND 
 roleID !=1 order by playerName asc;
END$$

DROP PROCEDURE IF EXISTS `getRoundDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getRoundDetails` (IN `param_tourID` VARCHAR(100))  BEGIN
select * from round_details where tourID=param_tourID;
END$$

DROP PROCEDURE IF EXISTS `getStateListing`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getStateListing` (IN `param_countryId` INT)  BEGIN
	SELECT * FROM state WHERE country_Id=param_countryId order by state_name asc;
END$$

DROP PROCEDURE IF EXISTS `getTourDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getTourDetails` (IN `param_year` VARCHAR(100), IN `param_month` VARCHAR(100))  BEGIN
if(param_year !='' && param_month !='') THEN

select * from events where  year(created_Date)=param_year and month(created_Date)=param_month and is_Deleted=0 order by startDate;

ELSE
select * from events where  year(created_Date)=param_year and is_Deleted=0 order by startDate;

END IF;

END$$

DROP PROCEDURE IF EXISTS `getTourDetailsByID`$$
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

DROP PROCEDURE IF EXISTS `getTournamentAndRoundDetail`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getTournamentAndRoundDetail` ()  BEGIN
	SELECT * FROM statictournamentrounddetails;
END$$

DROP PROCEDURE IF EXISTS `getTournamentApprovalStatus`$$
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

DROP PROCEDURE IF EXISTS `getTournamentCouponDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getTournamentCouponDetails` (IN `param_tourId` VARCHAR(100), IN `param_roundId` VARCHAR(100))  BEGIN
if(param_tourId !="" || param_roundId !="") THEN
 
Select * from tournament_coupon_details where tourID=param_tourId and round_Id=param_roundId; 

END IF;
END$$

DROP PROCEDURE IF EXISTS `getTournamentDetailedScoreList`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getTournamentDetailedScoreList` (IN `param_tour_id` VARCHAR(100), IN `param_player_id` VARCHAR(100), IN `param_round_Id` VARCHAR(100))  BEGIN
if (param_player_id =0)  Then


SELECT p.p_id as playerId,playerName, sd.* ,c.* FROM tournament_score_details as sd LEFT JOIN courses as c on sd.cid=c.cid JOIN user_details as p on p.p_id=sd.p_id
WHERE sd.tour_id=param_tour_id and sd.round_Id=param_round_Id;
  ELSE
  
SELECT p.p_id as playerId,playerName, sd.* ,c.* FROM tournament_score_details as sd LEFT JOIN courses as c on sd.cid=c.cid JOIN user_details as p on p.p_id=sd.p_id
WHERE  sd.p_id=param_player_id and sd.tour_id=param_tour_id and sd.round_Id=param_round_Id;
 

  END IF;
 
 

 END$$

DROP PROCEDURE IF EXISTS `getTournamentDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getTournamentDetails` ()  BEGIN
	SELECT * FROM events WHERE is_Deleted=0 order by tournamentName asc;
END$$

DROP PROCEDURE IF EXISTS `getTournamentGroupById`$$
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

DROP PROCEDURE IF EXISTS `getTournamentGroupDetails`$$
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
inner join tournament_group_player_details  on tournament_group_player_details.groupName =tournament_group_details.groupName 
inner JOIN user_details  on user_details.p_id=tournament_group_player_details.playerId
WHERE tournament_group_player_details.tournamentId=param_tourId AND round_Id=param_roundId and isWithdraw=0 ORDER by user_details.p_id DESC;
 
 Select distinct tournament_group_player_details.groupName, groupId from tournament_group_player_details INNER JOIN tournament_group_details on tournament_group_details.groupName=tournament_group_player_details.groupName where tourID=param_tourId AND round_Id=param_roundId;
 END IF;
ELSE

SELECT count(*) into isExist from tournament_group_details_archive WHERE round_Id=param_roundId;
if(isExist>0)
then 
select user_details.p_id as playerId,playerName, tournament_group_player_details.tee_time, tournament_group_player_details.isPlay, tournament_group_player_details.isWithdraw,  tournament_group_details_archive.groupId as groupId, tournament_group_player_details.groupName FROM tournament_group_details_archive 
inner join tournament_group_player_details  on tournament_group_player_details.groupName =tournament_group_details_archive.groupName 
inner JOIN user_details  on user_details.p_id=tournament_group_player_details.playerId
WHERE tournament_group_player_details.tournamentId=param_tourId AND round_Id=param_roundId and isWithdraw=0 ORDER by user_details.p_id DESC;
 
 Select distinct tournament_group_player_details.groupName, groupId from tournament_group_player_details INNER JOIN tournament_group_details_archive on tournament_group_details_archive.groupName=tournament_group_player_details.groupName where tourID=param_tourId AND round_Id=param_roundId;
 ELSE
set err="X";
set msg="Record not found";
END IF;
END IF;
select err,msg from dual;
 END$$

DROP PROCEDURE IF EXISTS `getTournamentGroupList`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getTournamentGroupList` (`param_tour_id` VARCHAR(10), `param_roundId` VARCHAR(10))  BEGIN
select * from tournament_group_details where tourID=param_tour_id and round_Id=param_roundId;
END$$

DROP PROCEDURE IF EXISTS `getTournamentGroupPlayerList`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getTournamentGroupPlayerList` (IN `param_tour_id` INT, IN `param_round_id` INT, IN `param_group_id` INT)  BEGIN
select user_details.p_id as playerId,playerName, tournament_group_player_details.tee_time, tournament_group_player_details.isPlay, tournament_group_player_details.isWithdraw,  tournament_group_details.groupId as groupId, tournament_group_player_details.groupName FROM tournament_group_details 
inner join tournament_group_player_details  on tournament_group_player_details.groupName =tournament_group_details.groupName 
inner JOIN user_details  on user_details.p_id=tournament_group_player_details.playerId
WHERE tournament_group_player_details.tournamentId=param_tour_id AND round_Id=param_round_id and groupid=param_group_id and isWithdraw=0 ORDER by user_details.p_id DESC;
END$$

DROP PROCEDURE IF EXISTS `getTournamentWinners`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getTournamentWinners` (IN `param_tourId` VARCHAR(100), IN `param_p_id` VARCHAR(100))  BEGIN
DECLARE isWinnerExist int;
Declare err varchar(2);
Declare  msg varchar(100);
select count(*) into isWinnerExist from tournament_winners where playerId=param_p_id and tourID=param_tourId;
if (isWinnerExist >0)  Then
SELECT user_details.playerName,events.tournamentName,tournament_winners.* FROM tournament_winners
inner join user_details on user_details.p_id=tournament_winners.playerId
inner join events on  events.tourID=tournament_winners.tourID
where tournament_winners.playerId=param_p_id and tournament_winners.tourID=param_tourId;

else
set err="X";
set msg="No Winnings Yet !";
end if;
select err,msg from dual;
  
 END$$

DROP PROCEDURE IF EXISTS `getTournmentScoreList`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getTournmentScoreList` ()  BEGIN

SELECT ev.tournamentName,rd.round_name,p.playerName, sd.* FROM tournament_score_details as sd 
LEFT JOIN user_details as p on p.p_id=sd.p_id 
inner join events as ev on sd.tour_id=ev.tourID
inner join round_details as rd on rd.round_Id=sd.round_Id
inner join tournament_group_details on tournament_group_details.round_id=rd.round_Id and tournament_group_details.tourID=rd.tourID
inner join tournament_group_player_details on tournament_group_player_details.groupName=tournament_group_player_details.groupName and  tournament_group_player_details.tournamentId=tournament_group_details.tourID
where sd.isDeleted=0 order by sd.createdDate asc;



END$$

DROP PROCEDURE IF EXISTS `getUserDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getUserDetails` (IN `param_playerId` INT)  BEGIN

SELECT pd.p_id, pd.firstName,pd.lastName,pd.playerName,pd.userName,pd.contactNumber,pd.email,pd.gender,DATE_FORMAT(pd.dob, '%d/%m/%y')  AS dateofbirth,pd.homeCourse,pd.hdcp,pd.employment,pd.companyName,pd.jobTitle,pd.industry,pd.profileImg,pd.isFirstLogin,pd.roleId,pd.countryId,pd.stateId,pd.isAccountVerified,pd.createdDate,pd.updatedDate,
st.*,cntry.* FROM user_details as pd 
LEFT JOIN state as st on st.state_Id=pd.stateId LEFT JOIN country as cntry on cntry.country_Id=pd.countryId 
where p_id=param_playerId and isDeleted=0 AND 
 roleID !=1 ;


END$$

DROP PROCEDURE IF EXISTS `getWebTourDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getWebTourDetails` (IN `param_tourID` VARCHAR(100))  BEGIN
select * from event_details where tourID=param_tourID;

END$$

DROP PROCEDURE IF EXISTS `get_invited_tournament_ListById`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_invited_tournament_ListById` (IN `param_userId` INT)  select round_details.round_name,DATE_FORMAT(round_details.event_Date, '%Y-%m-%d') as eventDate,tournamentName,events.tourId as tournamentId,playerId,eventType as tournamentType from tournament_player_list inner join events on events.tourID=tournament_player_list.tourID inner JOIN round_details on events.tourID=round_details.tourID where isInvited=1 and playerID=param_userId and is_Deleted=0 and isPlay=0 and round_details.event_Date>=CURRENT_DATE()  ORDER by round_details.event_Date$$

DROP PROCEDURE IF EXISTS `get_tee_list`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tee_list` ()  BEGIN

Select * from course_tee;

END$$

DROP PROCEDURE IF EXISTS `get_Tournament_RoundDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_Tournament_RoundDetails` (IN `param_tournamentId` INT)  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);
DECLARE roundId int;

SELECT round_Id into roundId from tournament_score_details WHERE tour_id=param_tournamentId ORDER BY round_Id desc limit 1;



select round_Id,round_name,round_details
.cid,crs.cname, tourID, DATE_FORMAT(event_Date, '%m/%d/%Y') as "TournamentDate" from round_details inner join courses as crs on crs.cid=round_details.cid WHERE tourID=param_tournamentId ORDER by round_name;

SELECT roundId from DUAL;
 END$$

DROP PROCEDURE IF EXISTS `get_tournament_score_by_player`$$
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

DROP PROCEDURE IF EXISTS `invitation_accepted_or_deny`$$
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

DROP PROCEDURE IF EXISTS `saveApprovedPlayersByOrganizer`$$
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

DROP PROCEDURE IF EXISTS `saveContactQuery`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `saveContactQuery` (IN `param_name` VARCHAR(200), IN `param_email` VARCHAR(200), IN `param_phn` VARCHAR(100), IN `param_subject` VARCHAR(200), IN `param_msg` VARCHAR(255))  BEGIN

DECLARE err varchar(100);
DECLARE msg varchar(255);
INSERT INTO contact (gname, gemail, phone, subject, msg) VALUES (param_name,param_email,param_phn,param_subject,param_msg);
  set err="";
  set msg="Sent Successfully";

  SELECT err,msg from DUAL;
 
END$$

DROP PROCEDURE IF EXISTS `saveCourseDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `saveCourseDetails` (IN `param_cid` VARCHAR(10), IN `param_cname` VARCHAR(200), IN `param_caddress` VARCHAR(250), IN `param_par1` INT, IN `param_par2` INT, IN `param_par3` INT, IN `param_par4` INT, IN `param_par5` INT, IN `param_par6` INT, IN `param_par7` INT, IN `param_par8` INT, IN `param_par9` INT, IN `param_par10` INT, IN `param_par11` INT, IN `param_par12` INT, IN `param_par13` INT, IN `param_par14` INT, IN `param_par15` INT, IN `param_par16` INT, IN `param_par17` INT, IN `param_par18` INT, IN `param_pinn` INT, IN `param_pout` INT, IN `param_hdcp1` INT, IN `param_hdcp2` INT, IN `param_hdcp3` INT, IN `param_hdcp4` INT, IN `param_hdcp5` INT, IN `param_hdcp6` INT, IN `param_hdcp7` INT, IN `param_hdcp8` INT, IN `param_hdcp9` INT, IN `param_hdcp10` INT, IN `param_hdcp11` INT, IN `param_hdcp12` INT, IN `param_hdcp13` INT, IN `param_hdcp14` INT, IN `param_hdcp15` INT, IN `param_hdcp16` INT, IN `param_hdcp17` INT, IN `param_hdcp18` INT)  BEGIN
 Declare isRecordExit int;
 Declare isCnameExist int;
 Declare statusCode int;
 Declare msg varchar(100);
 Declare err varchar(2);
 DECLARE num_rows int;
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
    ELSE
    set statusCode=409;
    set msg="Course already exist with same name";
    set err="X";
    END IF;
END;
ELSE

UPDATE courses set cname=param_cname ,
 caddress=param_caddress,par1=param_par1,par2=param_par2,par3=param_par3,par4=param_par4, par5=param_par5,par6=param_par6,par7=param_par7,par8=param_par8,par9=param_par9,par10=param_par10,par11=param_par11,par12=param_par12,
 par13=param_par13,par14=param_par14,par15=param_par15,par16=param_par16,par17=param_par17,par18=param_par18,pinn=param_pinn,pout=param_pout,hdcp1=param_hdcp1,hdcp2=param_hdcp2,hdcp3=param_hdcp3,hdcp4=param_hdcp4,hdcp5=param_hdcp5,hdcp6=param_hdcp6,hdcp7=param_hdcp7,hdcp8=param_hdcp8,hdcp9=param_hdcp9,hdcp10=param_hdcp10,hdcp11=param_hdcp11,hdcp12=param_hdcp12,hdcp13=param_hdcp13,hdcp14=param_hdcp14,hdcp15=param_hdcp15,hdcp16=param_hdcp16,
 hdcp17=param_hdcp17,hdcp18=param_hdcp18 where cid=param_cid;
  set statusCode=200;
    set msg="Course update successfully";
    set err="";
  END IF;  
  Select statusCode,msg,err;
END$$

DROP PROCEDURE IF EXISTS `saveEventDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `saveEventDetails` (IN `param_tourId` INT, IN `param_tourName` VARCHAR(200), IN `param_eventType` VARCHAR(100), IN `param_numRounds` INT, IN `param_startDate` VARCHAR(255), IN `param_endDate` VARCHAR(255), IN `param_holes` INT)  BEGIN
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
 ELSEIF(isTourNameExist>0)THEN
  set err="X";
  set msg="Tournament Already Exist";
     ELSE
  set err="X";
  set msg="Invalid Entry";
  END IF;
  ELSE
  UPDATE events set tournamentName=param_tourName,eventType=param_eventType,numRounds=param_numRounds,startDate=param_startDate,endDate=param_endDate,holes=param_holes,param_modified_Date=now() where tourID=param_tourId;
   set err="";
  set msg="Event updated successfully";
  set tour_id=param_tourId;
  END IF;

  SELECT err,msg,tour_id from DUAL;
 
END$$

DROP PROCEDURE IF EXISTS `savePlayerDetails`$$
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
  dob=param_dob,countryId=param_country_Id,stateId=param_state_Id,profile_Img=param_profile_Img,
  password=param_password,updatedDate=now() where p_id=param_p_id;
    set err="";
  set msg="Player updated successfully";
  END IF;

  SELECT err,msg from DUAL;
  END$$

DROP PROCEDURE IF EXISTS `saveRoundDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `saveRoundDetails` (IN `param_round_Id` INT, IN `param_tour_Id` INT, IN `param_event_Date` DATE, IN `param_cid` INT, IN `param_roundName` VARCHAR(200))  BEGIN
DECLARE num_rows int;
DECLARE err varchar(100);
DECLARE msg varchar(255);
DECLARE isRecordExist int;
SELECT count(*) into isRecordExist from round_details WHERE round_Id=param_round_Id;
if (isRecordExist<1)THEN


INSERT INTO round_details (event_Date,tourID,cid,round_name)VALUES (param_event_Date,param_tour_Id,param_cid,param_roundName);
  set err="";
  set msg="Round Created Successfully";


  ELSE
  UPDATE round_details set event_Date=param_event_Date,tourID=param_tour_Id,cid=param_cid,round_name=param_roundName,modified_Date=now() where round_Id=param_round_Id;
   set err="";
  set msg="Round updated successfully";
  END IF;

  SELECT err,msg from DUAL;
 
END$$

DROP PROCEDURE IF EXISTS `saveTournamentCouponDetails`$$
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

DROP PROCEDURE IF EXISTS `saveTournamentDetails`$$
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

DROP PROCEDURE IF EXISTS `saveTournamentGroupDetails`$$
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

DROP PROCEDURE IF EXISTS `saveTournamentGroupPlayerDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `saveTournamentGroupPlayerDetails` (IN `param_tourId` VARCHAR(50), IN `param_groupName` VARCHAR(200), IN `param_playerId` VARCHAR(100), IN `param_teeTime` VARCHAR(100))  BEGIN
DECLARE isGroupExist int;
Declare err varchar(10);
Declare msg varchar(100);
Select Count(*)into isGroupExist  from tournament_group_details where tourId=param_tourId and groupName=param_groupName ;
if(isGroupExist>0) then
Insert into tournament_group_player_details(tournamentId,groupName,playerId,tee_time,isPlay) values(param_tourId,param_groupName,param_playerId,param_teeTime,0);
set err="";
set msg="Player details save successfully";
else
set err="X";
set msg="Tournament group not found";
END IF;
Select err,msg from DUAL;
END$$

DROP PROCEDURE IF EXISTS `saveTournamentPlayerDetails`$$
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

DROP PROCEDURE IF EXISTS `saveTournamentPlayers`$$
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

DROP PROCEDURE IF EXISTS `saveTournamentScores`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `saveTournamentScores` (IN `param_tourId` VARCHAR(50), IN `param_playerId` VARCHAR(50), IN `param_roundId` VARCHAR(50), IN `param_groupId` VARCHAR(50), IN `param_score1` INT(10), IN `param_score2` INT(50), IN `param_score3` INT(50), IN `param_score4` INT(50), IN `param_score5` INT(10), IN `param_score6` INT(10), IN `param_score7` INT(10), IN `param_score8` INT(10), IN `param_score9` INT(10), IN `param_outTotal` INT(10), IN `param_score10` INT(10), IN `param_score11` INT(10), IN `param_score12` INT(10), IN `param_score13` INT(10), IN `param_score14` INT(10), IN `param_score15` INT(10), IN `param_score16` INT(10), IN `param_score17` INT(10), IN `param_score18` INT(10), IN `param_inTotal` INT(10), IN `param_grossTotal` INT(10), IN `param_netTotal` INT(10), IN `param_birdieTotal` INT(10), IN `param_cid` VARCHAR(50), IN `param_hdcp` INT(50), IN `param_enteredHoleCount` INT(50))  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);
DECLARE isRecordExist int;
DECLARE isPlayerExist int;

SELECT count(*) into isRecordExist from tournament_group_details WHERE tourID=param_tourId and round_Id=param_roundId and groupId=param_groupId;
if(isRecordExist>0) THEN

SELECT count(*) into isPlayerExist from tournament_score_details WHERE p_id=param_playerId and tour_id=param_tourId and round_Id=param_roundId; 
	if(isPlayerExist=0) then


insert into tournament_score_details (tour_id ,p_id ,round_Id  ,score1 ,score2 ,score3 ,score4 ,score5 ,score6 ,score7 ,score8 ,score9 ,outt ,score10 ,score11 ,score12 ,score13 ,score14 ,score15 ,score16 ,score17 ,score18,inn ,gross ,net ,birdie,cid,hdcp,createdDate,holeNum ) values ( `param_tourId` , `param_playerId` , `param_roundId` ,  `param_score1` , `param_score2` , `param_score3` , `param_score4` , `param_score5` , `param_score6` , `param_score7` , `param_score8` , `param_score9` , `param_outTotal` , `param_score10` , `param_score11` , `param_score12` , `param_score13` , `param_score14` , `param_score15` , `param_score16` , `param_score17` , `param_score18` , `param_inTotal` , `param_grossTotal` , `param_netTotal` , `param_birdieTotal`, `param_cid`,`param_hdcp`,now(),`param_enteredHoleCount`);
set err="";
set msg="Score inserted successfully";

 
ELSE
update  tournament_score_details set score1=param_score1, score2=param_score2,score3=param_score3,score4=param_score4,score5=param_score5,score6=param_score6,
score7=param_score7,score8=param_score8,score9=param_score9,score10=param_score10,score11=param_score11,score12=param_score12,score13=param_score13,score14=param_score14,score15=param_score15,score16=param_score16,
score17=param_score17,score18=param_score18, inn=param_inTotal, outt= param_outTotal,gross=param_grossTotal, net=param_netTotal, birdie=param_birdieTotal, hdcp=param_hdcp, holeNum=param_enteredHoleCount where tour_id=param_tourId and round_Id=param_roundId and p_id=param_playerId;

set err="";
set msg="Score updated successfully";
END IF;

ELSE
set err="X";
set msg="Record not found";
END IF;

select err,msg from dual;
 END$$

DROP PROCEDURE IF EXISTS `saveTournamentWinner`$$
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

DROP PROCEDURE IF EXISTS `save_user_details`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `save_user_details` (IN `param_p_id` VARCHAR(50), IN `param_FirstName` VARCHAR(100), IN `param_LastName` VARCHAR(150), IN `param_userName` VARCHAR(150), IN `param_email` VARCHAR(100), IN `param_contact` VARCHAR(250), IN `param_password` VARCHAR(100), IN `param_dob` DATE, IN `param_gender` VARCHAR(10), IN `param_HomeCourse` VARCHAR(255), IN `param_hdcp` INT(3), IN `param_hdcpCertificate` LONGTEXT, IN `param_platformLink` VARCHAR(255), IN `param_vaccineStatus` INT(2), IN `param_employment` INT(3), IN `param_company` VARCHAR(200), IN `param_jobTitle` VARCHAR(150), IN `param_industry` INT(200), IN `param_countryId` INT(10), IN `param_stateId` INT(10), IN `param_profileImg` LONGTEXT, IN `param_is_FirstLogin` INT, IN `param_is_WebLogin` INT, IN `param_device_id` VARCHAR(255), IN `param_device_platform` VARCHAR(255))  BEGIN
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
INSERT INTO user_details (playerName,firstName,lastName,userName,email,contactNumber,gender,dob,password,homeCourse,vaccineStatus,hdcp,hdcpCertificate,employment,companyName,jobTitle,platformLink,industry,roleId,isWebUser,isFirstLogin,createdDate,isDeleted,updatedDate,isAccountVerified,device_id,device_platform)
  VALUES ( concat(param_FirstName," ",param_LastName),param_FirstName,param_LastName,param_userName,param_email,param_contact,param_gender,param_dob,param_password,param_HomeCourse,param_vaccineStatus,param_hdcp,param_hdcpCertificate,param_employment,param_company,param_jobTitle,param_platformLink,param_industry,3,param_is_WebLogin,0,now(),0,now(),0,param_device_id,param_device_platform);

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

DROP PROCEDURE IF EXISTS `save_user_picture`$$
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

DROP PROCEDURE IF EXISTS `summaryTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `summaryTable` ()  begin
CREATE TEMPORARY TABLE tempTble
(pid int ,gross int, net int, birdie int);
insert into tempTble  
SELECT pid, sum(gross) as gross, sum(net) as net, sum(birdie) as birdie FROM `score_details` WHERE month(`tournament_date`) =9  GROUP by pid;
SELECT score_details.pid, round, '72' as Par, score_details.net, score_details.gross, score_details.birdie, tempTble.* FROM `score_details` left join tempTble on tempTble.pid=score_details.pid;
drop table tempTble;

   END$$

DROP PROCEDURE IF EXISTS `tournament_coupon`$$
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

DROP PROCEDURE IF EXISTS `tournament_Play_or_withdraw`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `tournament_Play_or_withdraw` (IN `param_tournamentId` VARCHAR(50), IN `param_isPlay` INT, IN `param_isWithdraw` INT, IN `param_playerId` VARCHAR(50))  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);
DECLARE isRecordExist int;

SELECT count(*) into isRecordExist from tournament_group_player_details WHERE tournamentId=param_tournamentId and playerId=param_playerId;
if(isRecordExist>0) THEN
Update tournament_group_player_details set isPlay=param_isPlay, isWithdraw=param_isWithdraw where tournamentId=param_tournamentId and playerId=param_playerId;
Update tournament_player_list set isPlay=param_isPlay, isWithdraw=param_isWithdraw where tourID=param_tournamentId and playerID=param_playerId;

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

DROP PROCEDURE IF EXISTS `updateCouponRedeemStatus`$$
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

DROP PROCEDURE IF EXISTS `user_change_password`$$
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

DROP PROCEDURE IF EXISTS `user_forgot_password`$$
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

DROP PROCEDURE IF EXISTS `user_login`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_login` (IN `param_emailId` VARCHAR(100), IN `param_password` VARCHAR(100))  BEGIN
Declare err varchar(2);
Declare  msg varchar(100);
Declare isUserExist int;


select count(*) into isUserExist from user_details where email=param_emailId And  password=param_password And isDeleted=0;
if(isUserExist>0) then

SELECT * from user_details WHERE email=param_emailId And  password=param_password And isDeleted=0; 
Set err="";
Set msg="User logged in successfully";


ELSE

Set err="X";
Set msg="Please enter valid login details";


END IF;
SELECT err,msg from DUAL;
END$$

DROP PROCEDURE IF EXISTS `verify_User_Account`$$
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

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `ads_list`
--

DROP TABLE IF EXISTS `ads_list`;
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

DROP TABLE IF EXISTS `contact`;
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

DROP TABLE IF EXISTS `country`;
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

DROP TABLE IF EXISTS `courses`;
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
(4, '', 'aaaaa', 'dsfsdfds', 13, 3, 3, 3, 3, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 1),
(6, 'course1', 'sdfdsfds', 'sdfdsfdsdsf', 4, 4, 4, 4, 4, 4, 4, 5, 5, 4, 4, 3, 3, 3, 3, 3, 3, 3, 5, 0, 5, 5, 5, 5, 5, 5, 5, 4, 4, 3, 7, 5, 5, 6, 8, 9, 7, 6, 1),
(9, 'course2', 'golf club', 'sdfdsfdsdsf', 4, 4, 4, 4, 4, 4, 4, 5, 5, 4, 4, 3, 3, 3, 3, 3, 3, 3, 44, 44, 5, 5, 5, 5, 5, 5, 5, 4, 4, 3, 7, 5, 5, 6, 8, 9, 7, 6, 1),
(12, 'course10', 'golf gold ddd', 'golffssss cxfvdvf saaas', 1, 2, 3, 4, 4, 5, 5, 5, 5, 5, 5, 4, 2, 3, 3, 3, 3, 3, 50, 20, 3, 4, 5, 6, 7, 8, 9, 10, 9, 8, 7, 6, 6, 5, 4, 4, 4, 2, 1),
(16, 'course13', 'dsdsad', 'asdsadsa', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 18, 18, 2, 2, 2, 2, 2, 2, 2, 2, 22, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1),
(18, 'course17', 'dxds', 'dsds', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 18, 18, 2, 2, 2, 2, 2, 2, 2, 2, 22, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1),
(20, 'course19', 'dummy1', 'hasdhaj', 5, 5, 5, 5, 5, 5, 5, 5, 5, 4, 4, 4, 44, 4, 4, 4, 4, 4, 45, 23, 4, 44, 4, 4, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0),
(24, 'course21', 'golf gold', 'golffssss cxfvdvf ', 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 17, 18, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
(25, 'course25', 'golf club sss', 'golffssss cxfvdvf ', 4, 4, 4, 4, 4, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 28, 9, 1, 2, 3, 1, 2, 3, 1, 2, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1),
(26, 'course26', 'aaaa', 'sdfdsfds', 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 17, 18, 2, 2, 3, 4, 3, 4, 4, 5, 5, 6, 5, 5, 4, 4, 3, 3, 3, 3, 1),
(27, 'course27', 'dum', 'sdfdsds', 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 18, 18, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1),
(28, 'course28', 'abc', 'asdasdads', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9, 9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
(29, 'course29', 'CLASSIC GOLF RESORT | CANYON/RIDGE', 'P.O. Hasanpur, Tauru, Haryana 122105', 3, 5, 3, 4, 4, 4, 4, 5, 4, 4, 3, 5, 4, 3, 4, 4, 4, 5, 36, 36, 17, 1, 15, 13, 11, 9, 5, 3, 7, 14, 16, 4, 8, 18, 12, 6, 2, 10, 0);

-- --------------------------------------------------------

--
-- Table structure for table `course_tee`
--

DROP TABLE IF EXISTS `course_tee`;
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

DROP TABLE IF EXISTS `employment`;
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

DROP TABLE IF EXISTS `events`;
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
(91, 'test tt', 'Stroke Play', 2, 1, '2022-06-11 13:00:00', '2022-06-13 13:00:00', '2022-06-03 06:56:08', '2022-06-10 11:51:43', '', '', NULL, NULL),
(92, 'new test', 'Stroke Play', 3, 1, '2022-06-14 13:00:00', '2022-06-21 13:00:00', '2022-06-13 07:20:55', '2022-06-13 07:20:55', '', '', NULL, NULL),
(93, 'arjun tour', 'Stroke Play', 3, 1, '2022-06-18 13:00:00', '2022-06-21 13:00:00', '2022-06-17 06:20:23', '2022-06-17 06:20:23', '', '', 0, NULL),
(94, 'teeeeet', 'Stroke Play', 1, 1, '2022-07-29 13:00:00', '2022-07-29 13:00:00', '2022-07-04 11:42:44', '2022-07-04 11:42:44', '', '', 0, NULL),
(95, 'teeeeerrrt', 'Stroke Play', 1, 0, '2022-07-05 13:00:00', '2022-07-05 13:00:00', '2022-07-04 11:50:55', '2022-07-04 11:50:55', '', '', 0, NULL),
(96, 'ddd', 'Stroke Play', 2, 1, '2022-07-13 13:00:00', '2022-07-14 13:00:00', '2022-07-12 06:18:50', '2022-07-12 06:18:50', '', '', 0, NULL),
(97, 'abc', 'Stroke Play', 2, 1, '2022-07-15 13:00:00', '2022-07-16 13:00:00', '2022-07-15 07:01:15', '2022-07-15 07:01:15', '', '', 0, NULL),
(98, 'teeeeet ffff', 'Stroke Play', 2, 1, '2022-07-23 13:00:00', '2022-07-30 13:00:00', '2022-07-15 10:25:25', '2022-07-15 10:25:25', '', '', 0, NULL),
(99, 'test', 'Stroke Play', 2, 1, '2022-07-20 13:00:00', '2022-07-28 13:00:00', '2022-07-18 10:34:31', '2022-07-18 10:34:31', '', '', 0, NULL),
(100, 'teeeeetd', 'Stroke Play', 1, 1, '2022-07-23 13:00:00', '2022-07-23 13:00:00', '2022-07-18 10:36:50', '2022-07-18 10:36:50', '', '', 0, NULL),
(101, 'foresome', 'Stroke Play', 1, 0, '2022-07-19 13:00:00', '2022-07-19 13:00:00', '2022-07-18 10:43:57', '2022-07-18 10:43:57', '', '', 0, 18),
(102, 'abhi ', 'Stroke Play', 1, 1, '2022-07-27 13:00:00', '2022-07-27 13:00:00', '2022-07-27 05:51:49', '2022-07-27 05:51:49', '', '', 0, 18),
(103, 'test4', 'Stroke Play', 2, 1, '2022-07-26 13:00:00', '2022-07-27 13:00:00', '2022-07-27 06:16:57', '2022-07-27 06:16:57', '', '', 0, 18),
(104, 'test1234', 'Stroke Play', 1, 1, '2022-07-28 13:00:00', '2022-07-28 13:00:00', '2022-07-27 06:19:32', '2022-07-27 06:19:32', '', '', 0, 18),
(105, 'test141', 'Stroke Play', 1, 1, '2022-07-27 13:00:00', '2022-07-27 13:00:00', '2022-07-27 06:25:31', '2022-07-27 06:25:31', '', '', 0, 18),
(106, 'tes123', 'Stroke Play', 2, 1, '2022-07-27 13:00:00', '2022-07-28 13:00:00', '2022-07-27 06:39:55', '2022-07-27 06:39:55', '', '', 0, 18);

-- --------------------------------------------------------

--
-- Table structure for table `event_details`
--

DROP TABLE IF EXISTS `event_details`;
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

DROP TABLE IF EXISTS `group_details`;
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

DROP TABLE IF EXISTS `guildclients`;
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

DROP TABLE IF EXISTS `industry_details`;
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
-- Table structure for table `master_vaccine_status`
--

DROP TABLE IF EXISTS `master_vaccine_status`;
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
-- Table structure for table `player_details`
--

DROP TABLE IF EXISTS `player_details`;
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

DROP TABLE IF EXISTS `round_details`;
CREATE TABLE `round_details` (
  `round_Id` int(11) NOT NULL,
  `event_Date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
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
(126, '2022-02-24 18:30:00', 1, 66, '2022-04-07 06:55:40', '2022-04-07 06:55:40', 'Round1'),
(127, '2022-02-25 18:30:00', 29, 66, '2022-04-07 06:55:40', '2022-04-07 06:55:40', 'Round2'),
(128, '2022-03-01 18:30:00', 2, 66, '2022-04-07 06:55:40', '2022-04-07 06:55:40', 'Round3'),
(129, '2022-04-24 18:30:00', 29, 67, '2022-04-26 06:44:53', '2022-04-26 06:44:53', 'Round1'),
(130, '2022-04-26 18:30:00', 3, 67, '2022-04-26 06:44:53', '2022-04-26 06:44:53', 'Round3'),
(131, '2022-04-25 18:30:00', 1, 67, '2022-04-26 06:44:53', '2022-04-26 06:44:53', 'Round2'),
(132, '2022-04-27 18:30:00', 1, 68, '2022-04-27 06:07:39', '2022-04-27 06:07:39', 'Round3'),
(133, '2022-04-26 18:30:00', 3, 68, '2022-04-27 06:07:39', '2022-04-27 06:07:39', 'Round2'),
(134, '2022-04-25 18:30:00', 2, 68, '2022-04-27 06:07:39', '2022-04-27 06:07:39', 'Round1'),
(135, '2022-05-18 18:30:00', 3, 69, '2022-05-13 06:48:55', '2022-05-13 06:48:55', 'Round1'),
(136, '2022-05-16 18:30:00', 3, 70, '2022-05-13 06:51:33', '2022-05-13 06:51:33', 'Round1'),
(137, '2022-05-25 18:30:00', 29, 70, '2022-05-13 06:51:33', '2022-05-13 06:51:33', 'Round2'),
(138, '2022-05-24 18:30:00', 2, 71, '2022-05-24 06:11:59', '2022-05-24 06:11:59', 'Round1'),
(139, '2022-05-26 18:30:00', 3, 71, '2022-05-24 06:11:59', '2022-05-24 06:11:59', 'Round2'),
(140, '2022-05-24 18:30:00', 1, 0, '2022-05-24 06:56:54', '2022-05-24 06:56:54', 'Round1'),
(141, '2022-05-24 18:30:00', 1, 72, '2022-05-24 06:56:59', '2022-05-24 06:56:59', 'Round1'),
(142, '2022-05-26 18:30:00', 3, 0, '2022-05-24 07:07:11', '2022-05-24 07:07:11', 'Round1'),
(143, '2022-05-25 18:30:00', 3, 0, '2022-05-24 07:10:26', '2022-05-24 07:10:26', 'Round1'),
(144, '2022-05-26 18:30:00', 1, 0, '2022-05-24 07:16:25', '2022-05-24 07:16:25', 'Round1'),
(145, '2022-05-26 18:30:00', 1, 0, '2022-05-24 07:19:20', '2022-05-24 07:19:20', 'Round1'),
(146, '2022-05-26 18:30:00', 3, 0, '2022-05-25 12:38:23', '2022-05-25 12:38:23', 'Round1'),
(147, '2022-05-25 18:30:00', 2, 73, '2022-05-26 12:01:26', '2022-05-26 12:01:26', 'Round1'),
(148, '2022-05-26 18:30:00', 1, 73, '2022-05-26 12:01:26', '2022-05-26 12:01:26', 'Round2'),
(149, '2022-05-29 18:30:00', 1, 74, '2022-05-30 06:04:10', '2022-05-30 06:04:10', 'Round1'),
(150, '2022-06-01 18:30:00', 1, 74, '2022-05-30 06:04:10', '2022-05-30 06:04:10', 'Round3'),
(151, '2022-05-30 18:30:00', 2, 74, '2022-05-30 06:04:10', '2022-05-30 06:04:10', 'Round2'),
(152, '2022-05-15 18:30:00', 3, 0, '2022-06-01 09:08:05', '2022-06-01 09:08:05', 'Round1'),
(153, '2022-05-25 18:30:00', 29, 0, '2022-06-01 09:08:07', '2022-06-01 09:08:07', 'Round2'),
(154, '2022-05-30 18:30:00', 2, 75, '2022-06-01 09:09:48', '2022-06-01 09:09:48', 'Round1'),
(155, '2022-05-31 18:30:00', 2, 75, '2022-06-01 09:09:48', '2022-06-01 09:09:48', 'Round2'),
(156, '2022-06-02 18:30:00', 1, 75, '2022-06-01 09:09:49', '2022-06-01 09:09:49', 'Round3'),
(157, '2022-06-01 18:30:00', 2, 76, '2022-06-01 09:50:27', '2022-06-01 09:50:27', 'Round1'),
(158, '2022-06-02 18:30:00', 1, 76, '2022-06-01 09:50:28', '2022-06-01 09:50:28', 'Round2'),
(159, '2022-05-31 18:30:00', 2, 77, '2022-06-01 12:02:26', '2022-06-01 12:02:26', 'Round1'),
(160, '2022-06-02 18:30:00', 2, 77, '2022-06-01 12:02:26', '2022-06-01 12:02:26', 'Round2'),
(161, '2022-06-28 18:30:00', 3, 0, '2022-06-03 10:21:55', '2022-06-03 10:21:55', 'Round1'),
(162, '2022-06-28 18:30:00', 3, 0, '2022-06-03 10:24:28', '2022-06-03 10:24:28', 'Round1'),
(163, '2022-06-28 18:30:00', 3, 72, '2022-06-03 10:25:07', '2022-06-03 10:25:07', 'Round1'),
(164, '2022-05-23 18:30:00', 1, 72, '2022-06-03 10:33:23', '2022-06-03 10:33:23', 'Round1'),
(165, '2022-05-23 18:30:00', 1, 72, '2022-06-03 10:35:14', '2022-06-03 10:35:14', 'Round1'),
(166, '2022-06-05 18:30:00', 29, 78, '2022-06-06 06:03:42', '2022-06-06 06:03:42', 'Round1'),
(167, '2022-06-07 18:30:00', 3, 78, '2022-06-06 06:03:42', '2022-06-06 06:03:42', 'Round3'),
(168, '2022-06-06 18:30:00', 2, 78, '2022-06-06 06:03:42', '2022-06-06 06:03:42', 'Round2'),
(169, '2022-06-26 18:30:00', 2, 79, '2022-06-06 06:07:40', '2022-06-06 06:07:40', 'Round1'),
(170, '2022-06-27 18:30:00', 2, 79, '2022-06-06 06:07:40', '2022-06-06 06:07:40', 'Round2'),
(171, '2022-06-06 18:30:00', 29, 80, '2022-06-06 06:12:42', '2022-06-06 06:12:42', 'Round1'),
(172, '2022-06-08 18:30:00', 2, 80, '2022-06-06 06:12:42', '2022-06-06 06:12:42', 'Round2'),
(173, '2022-06-09 18:30:00', 2, 81, '2022-06-06 06:16:08', '2022-06-06 06:16:08', 'Round1'),
(174, '2022-06-12 18:30:00', 2, 81, '2022-06-06 06:16:08', '2022-06-06 06:16:08', 'Round2'),
(175, '2022-06-05 18:30:00', 2, 82, '2022-06-06 06:22:23', '2022-06-06 06:22:23', 'Round1'),
(176, '2022-06-06 18:30:00', 1, 82, '2022-06-06 06:22:23', '2022-06-06 06:22:23', 'Round2'),
(177, '2022-06-05 18:30:00', 29, 83, '2022-06-06 06:26:56', '2022-06-06 06:26:56', 'Round1'),
(178, '2022-06-06 18:30:00', 2, 83, '2022-06-06 06:26:56', '2022-06-06 06:26:56', 'Round2'),
(179, '2022-06-06 18:30:00', 2, 84, '2022-06-07 05:59:10', '2022-06-07 05:59:10', 'Round1'),
(180, '2022-06-07 18:30:00', 2, 85, '2022-06-07 06:18:04', '2022-06-07 06:18:04', 'Round1'),
(181, '2022-06-08 18:30:00', 1, 85, '2022-06-07 06:18:04', '2022-06-07 06:18:04', 'Round2'),
(182, '2022-06-08 18:30:00', 2, 86, '2022-06-07 06:46:40', '2022-06-07 06:46:40', 'Round1'),
(183, '2022-06-06 18:30:00', 2, 87, '2022-06-07 07:04:55', '2022-06-07 07:04:55', 'Round1'),
(184, '2022-06-28 18:30:00', 1, 87, '2022-06-07 07:04:55', '2022-06-07 07:04:55', 'Round3'),
(185, '2022-06-07 18:30:00', 2, 87, '2022-06-07 07:04:55', '2022-06-07 07:04:55', 'Round2'),
(186, '2022-06-04 18:30:00', 29, 88, '2022-06-07 07:05:39', '2022-06-07 07:05:39', 'Round1'),
(187, '2022-06-05 18:30:00', 2, 88, '2022-06-07 07:05:39', '2022-06-07 07:05:39', 'Round2'),
(188, '2022-06-06 18:30:00', 3, 88, '2022-06-07 07:05:39', '2022-06-07 07:05:39', 'Round3'),
(189, '2022-06-06 18:30:00', 2, 87, '2022-06-07 07:28:38', '2022-06-07 07:28:38', 'Round1'),
(190, '2022-06-07 18:30:00', 2, 87, '2022-06-07 07:28:38', '2022-06-07 07:28:38', 'Round2'),
(191, '2022-06-28 18:30:00', 1, 87, '2022-06-07 07:28:38', '2022-06-07 07:28:38', 'Round3'),
(192, '2022-06-10 18:30:00', 2, 89, '2022-06-10 07:26:08', '2022-06-10 07:26:08', 'Round2'),
(193, '2022-06-09 18:30:00', 29, 89, '2022-06-10 07:26:08', '2022-06-10 07:26:08', 'Round1'),
(194, '2022-06-15 18:30:00', 2, 90, '2022-06-10 11:25:17', '2022-06-10 11:25:17', 'Round2'),
(195, '2022-06-09 18:30:00', 2, 90, '2022-06-10 11:25:17', '2022-06-10 11:25:17', 'Round1'),
(196, '2022-06-09 18:30:00', 2, 91, '2022-06-10 11:51:44', '2022-06-10 11:51:44', 'Round1'),
(197, '2022-06-11 18:30:00', 1, 91, '2022-06-10 11:51:44', '2022-06-10 11:51:44', 'Round2'),
(198, '2022-06-12 18:30:00', 29, 92, '2022-06-13 07:20:55', '2022-06-13 07:20:55', 'Round1'),
(199, '2022-06-19 18:30:00', 1, 92, '2022-06-13 07:20:55', '2022-06-13 07:20:55', 'Round3'),
(200, '2022-06-14 18:30:00', 2, 92, '2022-06-13 07:20:55', '2022-06-13 07:20:55', 'Round2'),
(201, '2022-06-16 18:30:00', 29, 93, '2022-06-17 06:20:30', '2022-06-17 06:20:30', 'Round1'),
(202, '2022-06-16 18:30:00', 29, 0, '2022-06-17 06:20:31', '2022-06-17 06:20:31', 'Round1'),
(203, '2022-06-17 18:30:00', 1, 93, '2022-06-17 06:20:31', '2022-06-17 06:20:31', 'Round2'),
(204, '2022-06-17 18:30:00', 1, 0, '2022-06-17 06:20:31', '2022-06-17 06:20:31', 'Round2'),
(205, '2022-06-19 18:30:00', 3, 93, '2022-06-17 06:20:31', '2022-06-17 06:20:31', 'Round3'),
(206, '2022-06-19 18:30:00', 3, 0, '2022-06-17 06:20:31', '2022-06-17 06:20:31', 'Round3'),
(207, '2022-07-27 18:30:00', 29, 94, '2022-07-04 11:42:44', '2022-07-04 11:42:44', 'Round1'),
(208, '2022-07-03 18:30:00', 3, 0, '2022-07-04 11:50:42', '2022-07-04 11:50:42', 'Round1'),
(209, '2022-07-03 18:30:00', 3, 95, '2022-07-04 11:50:55', '2022-07-04 11:50:55', 'Round1'),
(210, '2022-07-11 18:30:00', 2, 96, '2022-07-12 06:18:50', '2022-07-12 06:18:50', 'Round1'),
(211, '2022-07-12 18:30:00', 3, 96, '2022-07-12 06:18:50', '2022-07-12 06:18:50', 'Round2'),
(212, '2022-07-13 18:30:00', 29, 97, '2022-07-15 07:01:15', '2022-07-15 07:01:15', 'Round1'),
(213, '2022-07-14 18:30:00', 1, 97, '2022-07-15 07:01:15', '2022-07-15 07:01:15', 'Round2'),
(214, '2022-07-21 18:30:00', 2, 98, '2022-07-15 10:25:25', '2022-07-15 10:25:25', 'Round1'),
(215, '2022-07-28 18:30:00', 3, 98, '2022-07-15 10:25:25', '2022-07-15 10:25:25', 'Round2'),
(216, '2022-07-18 18:30:00', 29, 99, '2022-07-18 10:34:31', '2022-07-18 10:34:31', 'Round1'),
(217, '2022-07-26 18:30:00', 3, 99, '2022-07-18 10:34:31', '2022-07-18 10:34:31', 'Round2'),
(218, '2022-07-21 18:30:00', 3, 100, '2022-07-18 10:36:50', '2022-07-18 10:36:50', 'Round1'),
(219, '2022-07-17 18:30:00', 2, 101, '2022-07-18 10:43:57', '2022-07-18 10:43:57', 'Round1'),
(220, '2022-07-25 18:30:00', 3, 102, '2022-07-27 05:51:49', '2022-07-27 05:51:49', 'Round1'),
(221, '2022-07-25 18:30:00', 29, 103, '2022-07-27 06:16:57', '2022-07-27 06:16:57', 'Round1'),
(222, '2022-07-26 18:30:00', 3, 103, '2022-07-27 06:16:57', '2022-07-27 06:16:57', 'Round2'),
(223, '2022-07-26 18:30:00', 29, 104, '2022-07-27 06:19:32', '2022-07-27 06:19:32', 'Round1'),
(224, '2022-07-25 18:30:00', 29, 105, '2022-07-27 06:27:54', '2022-07-27 06:27:54', 'Round1'),
(225, '2022-07-25 18:30:00', 29, 106, '2022-07-27 06:40:21', '2022-07-27 06:40:21', 'Round1'),
(226, '2022-07-26 18:30:00', 3, 106, '2022-07-27 06:40:21', '2022-07-27 06:40:21', 'Round2');

-- --------------------------------------------------------

--
-- Table structure for table `score_details`
--

DROP TABLE IF EXISTS `score_details`;
CREATE TABLE `score_details` (
  `pid` int(11) NOT NULL,
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
  `tournament_date` date NOT NULL,
  `round` varchar(2) NOT NULL,
  `hdcp` int(11) NOT NULL,
  `inn` int(11) NOT NULL,
  `outt` int(11) NOT NULL,
  `gross` int(11) NOT NULL,
  `net` int(11) NOT NULL,
  `birdie` int(11) NOT NULL,
  `cid` varchar(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `score_details`
--

INSERT INTO `score_details` (`pid`, `serial`, `score1`, `score2`, `score3`, `score4`, `score5`, `score6`, `score7`, `score8`, `score9`, `score10`, `score11`, `score12`, `score13`, `score14`, `score15`, `score16`, `score17`, `score18`, `tournament_date`, `round`, `hdcp`, `inn`, `outt`, `gross`, `net`, `birdie`, `cid`) VALUES
(15, 31, 4, 3, 4, 5, 6, 4, 5, 4, 5, 4, 4, 4, 5, 6, 4, 5, 3, 5, '2021-03-04', 'r1', 7, 40, 40, 80, 73, 1, 'c002'),
(14, 32, 5, 5, 5, 4, 3, 4, 5, 4, 6, 5, 5, 5, 4, 6, 4, 4, 3, 5, '2021-03-04', 'r1', 9, 41, 41, 82, 73, 0, 'c002'),
(13, 33, 5, 3, 6, 3, 4, 5, 5, 5, 5, 4, 4, 6, 5, 5, 4, 5, 3, 5, '2021-03-04', 'r1', 11, 41, 41, 82, 71, 1, 'c002'),
(12, 34, 4, 3, 7, 4, 3, 6, 4, 5, 5, 5, 5, 4, 4, 5, 4, 6, 4, 5, '2021-03-04', 'r1', 7, 42, 41, 83, 76, 0, 'c002'),
(11, 35, 5, 4, 6, 5, 3, 4, 5, 5, 6, 4, 4, 4, 5, 6, 4, 5, 3, 6, '2021-03-04', 'r1', 12, 41, 43, 84, 72, 0, 'c002'),
(10, 36, 5, 3, 5, 5, 4, 4, 5, 7, 5, 5, 3, 6, 5, 7, 6, 4, 4, 5, '2021-03-04', 'r1', 12, 45, 43, 88, 76, 0, 'c002'),
(9, 37, 4, 4, 6, 5, 3, 6, 5, 5, 6, 5, 4, 3, 5, 7, 5, 6, 4, 6, '2021-03-04', 'r1', 12, 45, 44, 89, 77, 1, 'c002'),
(8, 38, 6, 3, 6, 6, 4, 4, 4, 6, 5, 6, 4, 7, 5, 5, 4, 6, 4, 4, '2021-03-04', 'r1', 10, 45, 44, 89, 79, 1, 'c002'),
(3, 39, 4, 6, 6, 5, 3, 6, 5, 5, 5, 5, 4, 5, 4, 6, 5, 6, 5, 6, '2021-03-04', 'r1', 11, 46, 45, 91, 80, 0, 'c002'),
(1, 40, 6, 3, 5, 5, 4, 5, 7, 5, 7, 3, 4, 5, 8, 6, 5, 5, 4, 5, '2021-03-04', 'r1', 12, 45, 47, 92, 80, 1, 'c002'),
(6, 41, 8, 3, 6, 4, 5, 5, 6, 6, 4, 5, 4, 4, 4, 8, 5, 7, 4, 7, '2021-03-04', 'r1', 12, 48, 47, 95, 83, 1, 'c002'),
(4, 42, 6, 4, 6, 4, 4, 6, 4, 4, 8, 5, 4, 4, 5, 7, 5, 5, 4, 6, '2021-03-04', 'r1', 5, 45, 46, 91, 86, 0, 'c002'),
(3, 43, 4, 5, 5, 6, 5, 7, 5, 6, 7, 6, 4, 5, 6, 6, 5, 6, 5, 5, '2021-03-04', 'r1', 12, 48, 50, 98, 86, 0, 'c002'),
(2, 44, 4, 4, 4, 8, 2, 4, 5, 6, 7, 4, 5, 7, 5, 6, 7, 4, 7, 6, '2021-03-04', 'r1', 7, 51, 44, 95, 88, 2, 'c002'),
(13, 45, 6, 3, 6, 4, 2, 3, 4, 5, 6, 5, 3, 5, 4, 6, 5, 5, 4, 4, '2021-03-09', 'r2', 11, 41, 39, 80, 69, 3, 'c002'),
(8, 46, 4, 3, 5, 5, 4, 4, 5, 5, 7, 4, 3, 6, 5, 5, 5, 4, 4, 5, '2021-03-09', 'r2', 10, 41, 42, 83, 73, 0, 'c002'),
(14, 47, 4, 3, 5, 5, 3, 6, 5, 5, 5, 6, 3, 6, 4, 5, 5, 4, 3, 6, '2021-03-09', 'r2', 9, 42, 41, 83, 74, 0, 'c002'),
(11, 48, 6, 3, 6, 5, 3, 4, 5, 5, 10, 4, 3, 5, 6, 5, 4, 4, 3, 5, '2021-03-09', 'r2', 12, 39, 47, 86, 74, 0, 'c002'),
(12, 49, 6, 3, 6, 6, 3, 4, 4, 6, 7, 4, 4, 3, 4, 6, 4, 5, 3, 5, '2021-03-09', 'r2', 7, 38, 45, 83, 76, 1, 'c002'),
(6, 50, 5, 4, 6, 5, 4, 5, 5, 5, 4, 6, 6, 5, 4, 5, 5, 6, 3, 8, '2021-03-09', 'r2', 12, 48, 43, 91, 79, 1, 'c002'),
(1, 51, 4, 4, 6, 4, 4, 4, 6, 7, 6, 5, 4, 5, 8, 7, 5, 5, 3, 5, '2021-03-09', 'r2', 12, 47, 45, 92, 80, 0, 'c002'),
(2, 52, 6, 3, 6, 5, 3, 5, 4, 8, 6, 5, 4, 4, 4, 6, 4, 6, 3, 5, '2021-03-09', 'r2', 7, 41, 46, 87, 80, 0, 'c002'),
(10, 53, 7, 4, 6, 5, 4, 5, 5, 5, 5, 4, 4, 6, 5, 6, 5, 5, 4, 7, '2021-03-09', 'r2', 12, 46, 46, 92, 80, 0, 'c002'),
(9, 54, 5, 3, 5, 5, 4, 5, 5, 6, 6, 6, 4, 7, 7, 5, 4, 4, 4, 8, '2021-03-09', 'r2', 12, 49, 44, 93, 81, 0, 'c002'),
(3, 55, 6, 3, 7, 5, 4, 6, 4, 5, 6, 5, 5, 5, 4, 6, 7, 6, 5, 6, '2021-03-09', 'r2', 11, 49, 46, 95, 84, 0, 'c002'),
(15, 56, 5, 3, 7, 6, 3, 4, 6, 6, 5, 7, 3, 5, 4, 8, 4, 5, 5, 7, '2021-03-09', 'r2', 7, 48, 45, 93, 86, 0, 'c002'),
(4, 58, 5, 3, 5, 5, 3, 5, 5, 5, 4, 4, 3, 3, 4, 5, 4, 6, 4, 5, '2021-03-17', 'r3', 5, 38, 40, 78, 73, 2, 'c002'),
(14, 59, 4, 4, 6, 4, 4, 4, 4, 4, 6, 4, 3, 5, 4, 5, 5, 4, 4, 5, '2021-03-17', 'r3', 9, 39, 40, 79, 70, 0, 'c002'),
(1, 60, 6, 4, 5, 4, 4, 5, 3, 5, 5, 5, 4, 4, 6, 6, 5, 4, 4, 5, '2021-03-17', 'r3', 12, 43, 41, 84, 72, 1, 'c002'),
(15, 61, 5, 3, 8, 5, 3, 4, 4, 5, 4, 6, 2, 7, 4, 4, 4, 6, 5, 5, '2021-03-17', 'r3', 7, 43, 41, 84, 77, 3, 'c002'),
(13, 62, 5, 4, 7, 4, 4, 6, 5, 5, 6, 4, 4, 5, 4, 6, 4, 5, 2, 5, '2021-03-17', 'r3', 11, 39, 46, 85, 74, 1, 'c002'),
(11, 63, 5, 3, 5, 5, 3, 5, 5, 6, 6, 4, 5, 4, 4, 4, 4, 7, 4, 6, '2021-03-17', 'r3', 12, 42, 43, 85, 73, 1, 'c002'),
(2, 64, 5, 3, 5, 5, 4, 5, 6, 5, 5, 5, 5, 5, 6, 6, 4, 4, 4, 4, '2021-03-17', 'r3', 7, 43, 43, 86, 79, 1, 'c002'),
(12, 65, 5, 4, 8, 5, 3, 5, 5, 4, 8, 4, 4, 4, 5, 6, 4, 4, 4, 5, '2021-03-17', 'r3', 7, 40, 47, 87, 80, 0, 'c002'),
(10, 66, 5, 3, 5, 5, 4, 5, 6, 5, 5, 5, 6, 4, 4, 6, 5, 5, 5, 6, '2021-03-17', 'r3', 12, 46, 43, 89, 77, 0, 'c002'),
(8, 67, 4, 3, 7, 4, 3, 5, 8, 5, 8, 6, 3, 4, 3, 6, 6, 5, 4, 6, '2021-03-17', 'r3', 10, 43, 47, 90, 80, 1, 'c002'),
(3, 68, 5, 3, 6, 5, 4, 5, 5, 6, 7, 5, 6, 4, 4, 6, 4, 7, 5, 5, '2021-03-17', 'r3', 12, 46, 46, 92, 80, 0, 'c002'),
(9, 69, 5, 4, 5, 6, 3, 7, 6, 7, 6, 6, 4, 5, 5, 5, 5, 6, 3, 7, '2021-03-17', 'r3', 12, 46, 49, 95, 83, 0, 'c002'),
(6, 70, 4, 4, 6, 4, 4, 4, 6, 5, 8, 5, 4, 5, 6, 8, 5, 8, 6, 5, '2021-03-17', 'r3', 12, 52, 45, 97, 85, 0, 'c002'),
(7, 71, 6, 4, 8, 4, 3, 5, 5, 6, 11, 6, 5, 5, 5, 5, 5, 5, 5, 5, '2021-03-17', 'r3', 11, 46, 52, 98, 87, 0, 'c002'),
(16, 72, 5, 4, 5, 7, 3, 5, 5, 4, 8, 4, 4, 7, 4, 7, 6, 4, 3, 6, '2021-09-04', 'r1', 11, 45, 46, 91, 80, 0, 'c002'),
(18, 73, 4, 4, 6, 4, 5, 5, 6, 7, 5, 6, 8, 4, 5, 6, 4, 4, 3, 6, '2021-09-04', 'r1', 11, 46, 46, 92, 81, 0, 'c002'),
(19, 74, 6, 3, 7, 5, 3, 5, 5, 4, 6, 5, 3, 6, 5, 5, 5, 5, 4, 4, '2021-09-04', 'r1', 12, 42, 44, 86, 74, 1, 'c002'),
(20, 75, 4, 4, 7, 4, 3, 5, 5, 5, 6, 4, 4, 7, 4, 6, 6, 5, 6, 7, '2021-09-04', 'r1', 12, 49, 43, 92, 80, 0, 'c002'),
(21, 76, 6, 3, 4, 6, 4, 6, 5, 5, 8, 5, 5, 5, 5, 5, 4, 5, 3, 6, '2021-09-04', 'r1', 12, 43, 47, 90, 78, 1, 'c002'),
(22, 77, 5, 4, 4, 5, 2, 4, 5, 5, 7, 4, 4, 5, 4, 6, 5, 4, 4, 6, '2021-09-04', 'r1', 12, 42, 41, 83, 71, 2, 'c002'),
(14, 78, 6, 3, 7, 5, 3, 4, 4, 5, 5, 4, 4, 4, 4, 5, 4, 4, 5, 5, '2021-09-04', 'r1', 9, 39, 42, 81, 72, 0, 'c002'),
(11, 79, 5, 4, 6, 5, 5, 6, 7, 5, 6, 5, 3, 5, 6, 5, 5, 5, 5, 5, '2021-09-04', 'r1', 10, 44, 49, 93, 83, 0, 'c002'),
(1, 80, 6, 3, 7, 5, 4, 4, 5, 6, 4, 4, 5, 5, 5, 7, 4, 7, 5, 6, '2021-09-04', 'r1', 10, 48, 44, 92, 82, 1, 'c002'),
(8, 81, 4, 3, 5, 5, 3, 4, 5, 7, 5, 4, 6, 5, 5, 6, 5, 4, 2, 5, '2021-09-04', 'r1', 11, 42, 41, 83, 72, 1, 'c002'),
(23, 82, 4, 3, 5, 4, 3, 5, 5, 6, 7, 7, 4, 3, 5, 6, 5, 5, 4, 6, '2021-09-04', 'r1', 11, 45, 42, 87, 76, 1, 'c002'),
(24, 83, 5, 2, 6, 5, 6, 5, 4, 5, 6, 5, 5, 3, 5, 5, 5, 5, 4, 7, '2021-09-04', 'r1', 11, 44, 44, 88, 77, 2, 'c002'),
(25, 84, 4, 4, 5, 4, 2, 5, 3, 5, 5, 4, 4, 4, 4, 7, 4, 4, 3, 5, '2021-09-04', 'r1', 5, 39, 37, 76, 71, 2, 'c002'),
(13, 85, 6, 2, 6, 5, 3, 5, 5, 4, 5, 4, 6, 5, 5, 5, 5, 5, 3, 4, '2021-09-04', 'r1', 5, 42, 41, 83, 78, 2, 'c002'),
(15, 86, 6, 3, 6, 4, 4, 5, 4, 5, 5, 4, 4, 7, 4, 6, 4, 5, 4, 4, '2021-09-04', 'r1', 6, 42, 42, 84, 78, 1, 'c002'),
(12, 87, 4, 3, 6, 5, 4, 4, 4, 4, 4, 4, 4, 4, 6, 7, 4, 5, 4, 5, '2021-09-04', 'r1', 6, 43, 38, 81, 75, 1, 'c002'),
(26, 88, 4, 3, 6, 5, 4, 7, 5, 5, 8, 5, 4, 5, 4, 6, 4, 6, 4, 5, '2021-09-04', 'r1', 6, 43, 47, 90, 84, 0, 'c002'),
(27, 89, 4, 4, 6, 5, 3, 6, 5, 5, 6, 6, 5, 5, 5, 6, 4, 5, 4, 5, '2021-09-04', 'r1', 9, 45, 44, 89, 80, 0, 'c002'),
(18, 90, 5, 6, 6, 4, 6, 4, 4, 4, 5, 4, 8, 4, 4, 5, 4, 4, 10, 8, '2021-09-05', 'r2', 12, 51, 44, 95, 83, 0, 'c001'),
(20, 91, 4, 6, 5, 5, 5, 5, 5, 4, 7, 4, 5, 3, 5, 5, 5, 4, 7, 6, '2021-09-05', 'r2', 12, 44, 46, 90, 78, 0, '1'),
(11, 92, 5, 7, 4, 3, 7, 4, 7, 3, 6, 4, 5, 5, 5, 4, 5, 3, 6, 5, '2021-09-05', 'r2', 11, 42, 46, 88, 77, 0, '1'),
(26, 93, 5, 6, 4, 4, 5, 6, 4, 4, 5, 6, 5, 4, 7, 5, 6, 3, 5, 6, '2021-09-05', 'r2', 7, 47, 43, 90, 83, 0, '1'),
(16, 94, 6, 5, 5, 4, 5, 5, 5, 3, 4, 6, 5, 3, 4, 7, 5, 4, 5, 5, '2021-09-05', 'r2', 12, 44, 42, 86, 74, 1, '1'),
(1, 95, 5, 4, 4, 2, 7, 5, 4, 4, 6, 6, 7, 5, 6, 6, 6, 4, 5, 5, '2021-09-05', 'r2', 11, 50, 41, 91, 80, 1, '1'),
(24, 96, 6, 6, 5, 3, 6, 4, 4, 3, 5, 4, 6, 3, 5, 7, 5, 4, 4, 5, '2021-09-05', 'r2', 11, 43, 42, 85, 74, 0, '1'),
(27, 97, 5, 7, 5, 3, 5, 4, 5, 4, 6, 4, 6, 3, 6, 3, 7, 5, 5, 6, '2021-09-05', 'r2', 9, 45, 44, 89, 80, 1, 'c001'),
(21, 98, 7, 5, 4, 4, 6, 8, 5, 4, 6, 7, 4, 4, 6, 5, 6, 4, 4, 6, '2021-09-05', 'r2', 12, 46, 49, 95, 83, 1, 'c001'),
(15, 99, 8, 6, 6, 3, 7, 6, 4, 3, 5, 5, 5, 3, 5, 6, 4, 3, 5, 5, '2021-09-05', 'r2', 6, 41, 48, 89, 83, 0, 'c001'),
(19, 100, 4, 4, 4, 3, 5, 6, 5, 5, 5, 5, 5, 4, 7, 5, 5, 5, 5, 6, '2021-09-05', 'r2', 12, 47, 41, 88, 76, 0, 'c001'),
(23, 101, 6, 5, 5, 4, 5, 6, 4, 4, 8, 5, 8, 3, 6, 6, 5, 4, 4, 6, '2021-09-05', 'r2', 11, 47, 47, 94, 83, 0, 'c001'),
(22, 102, 5, 6, 4, 3, 8, 8, 7, 4, 6, 5, 5, 3, 5, 6, 4, 6, 5, 6, '2021-09-05', 'r2', 12, 45, 51, 96, 84, 0, 'c001'),
(13, 103, 5, 7, 5, 4, 5, 6, 3, 3, 6, 4, 6, 5, 7, 6, 5, 5, 5, 6, '2021-09-05', 'r2', 6, 49, 44, 93, 87, 1, 'c001'),
(8, 104, 4, 5, 5, 4, 5, 5, 5, 3, 5, 5, 6, 6, 4, 6, 4, 7, 4, 5, '2021-09-05', 'r2', 11, 47, 41, 88, 77, 0, '1'),
(25, 105, 5, 4, 5, 2, 4, 4, 4, 3, 4, 4, 4, 4, 4, 7, 3, 3, 5, 6, '2021-09-05', 'r2', 5, 40, 35, 75, 70, 5, 'c001'),
(14, 106, 4, 5, 5, 3, 5, 4, 5, 4, 6, 5, 5, 3, 4, 5, 5, 4, 5, 7, '2021-09-05', 'r2', 9, 43, 41, 84, 75, 0, '1'),
(12, 107, 4, 4, 7, 3, 4, 5, 4, 4, 7, 4, 6, 4, 5, 5, 5, 3, 5, 5, '2021-09-05', 'r2', 6, 42, 42, 84, 78, 1, '1'),
(23, 108, 6, 4, 5, 3, 6, 6, 4, 4, 6, 6, 6, 4, 4, 5, 5, 4, 5, 6, '2021-09-13', 'r3', 11, 45, 44, 89, 78, 0, '1'),
(20, 110, 5, 3, 7, 4, 6, 5, 4, 3, 7, 6, 8, 4, 5, 4, 5, 5, 5, 5, '2021-09-13', 'r3', 12, 47, 44, 91, 79, 1, '1'),
(21, 111, 5, 5, 6, 4, 6, 5, 8, 6, 6, 3, 5, 3, 5, 7, 6, 3, 4, 7, '2021-09-13', 'r3', 12, 43, 51, 94, 82, 1, '1'),
(19, 113, 4, 5, 6, 3, 9, 5, 5, 4, 5, 5, 6, 3, 5, 6, 9, 3, 7, 5, '2021-09-13', 'r3', 12, 49, 46, 95, 83, 0, '1'),
(13, 114, 4, 4, 5, 2, 6, 4, 5, 4, 4, 7, 10, 3, 5, 5, 7, 2, 5, 5, '2021-09-13', 'r3', 6, 49, 38, 87, 81, 3, '1'),
(16, 115, 4, 4, 5, 3, 5, 6, 4, 3, 5, 6, 6, 4, 7, 7, 6, 4, 5, 6, '2021-09-13', 'r3', 12, 51, 39, 90, 78, 0, '1'),
(27, 116, 4, 4, 6, 3, 8, 5, 6, 4, 6, 6, 5, 4, 6, 5, 5, 4, 5, 6, '2021-09-13', 'r3', 9, 46, 46, 92, 83, 0, '1'),
(22, 117, 5, 3, 6, 3, 8, 11, 6, 3, 6, 6, 6, 5, 5, 6, 7, 4, 4, 5, '2021-09-13', 'r3', 12, 48, 51, 99, 87, 1, '1'),
(26, 118, 4, 5, 4, 4, 4, 4, 4, 3, 6, 4, 6, 3, 4, 4, 4, 3, 5, 6, '2021-09-13', 'r3', 7, 39, 38, 77, 70, 1, '1'),
(8, 119, 4, 5, 5, 3, 7, 4, 5, 3, 6, 5, 8, 3, 4, 5, 5, 4, 5, 5, '2021-09-13', 'r3', 11, 44, 42, 86, 75, 0, '1'),
(24, 120, 4, 5, 6, 3, 6, 4, 5, 3, 6, 5, 6, 3, 5, 5, 5, 3, 4, 5, '2021-09-13', 'r3', 11, 41, 42, 83, 72, 0, '1'),
(15, 121, 4, 5, 6, 3, 6, 6, 4, 4, 5, 4, 4, 4, 6, 4, 4, 3, 4, 5, '2021-09-13', 'r3', 6, 38, 43, 81, 75, 1, '1'),
(25, 122, 5, 4, 4, 4, 6, 5, 4, 3, 7, 5, 5, 3, 3, 4, 4, 3, 4, 5, '2021-09-13', 'r3', 5, 36, 42, 78, 73, 1, '1'),
(14, 123, 5, 4, 5, 3, 6, 3, 5, 5, 6, 4, 5, 3, 3, 6, 5, 4, 6, 5, '2021-09-13', 'r3', 9, 41, 42, 83, 74, 2, '1'),
(12, 124, 4, 4, 6, 3, 6, 4, 5, 3, 7, 5, 5, 3, 5, 4, 5, 3, 4, 5, '2021-09-13', 'r3', 6, 39, 42, 81, 75, 0, '1'),
(1, 125, 5, 5, 6, 3, 6, 5, 4, 4, 6, 5, 6, 5, 5, 6, 5, 5, 4, 5, '2021-09-13', 'r3', 11, 46, 44, 90, 79, 0, '1'),
(25, 126, 4, 4, 5, 4, 4, 3, 3, 5, 5, 5, 3, 4, 4, 5, 5, 6, 4, 5, '2021-01-21', 'r1', 5, 41, 37, 78, 73, 2, 'c002'),
(15, 127, 4, 3, 7, 4, 3, 4, 4, 4, 5, 5, 4, 3, 7, 6, 4, 6, 4, 5, '2021-01-21', 'r1', 6, 44, 38, 82, 76, 1, 'c002'),
(14, 128, 5, 4, 5, 4, 3, 4, 5, 8, 6, 5, 4, 5, 5, 5, 4, 5, 4, 5, '2021-01-21', 'r1', 10, 42, 44, 86, 76, 0, 'c002'),
(7, 129, 6, 4, 5, 4, 5, 4, 4, 6, 8, 4, 5, 5, 5, 4, 5, 4, 4, 6, '2021-01-21', 'r1', 12, 42, 46, 88, 76, 1, '2'),
(12, 130, 5, 6, 5, 4, 4, 3, 5, 4, 6, 4, 5, 5, 4, 6, 4, 6, 4, 6, '2021-01-21', 'r1', 9, 44, 42, 86, 77, 1, 'c002'),
(1, 131, 4, 5, 7, 4, 3, 4, 5, 8, 5, 5, 4, 4, 6, 7, 5, 4, 3, 7, '2021-01-21', 'r1', 12, 45, 45, 90, 78, 0, 'c002'),
(9, 132, 5, 5, 6, 4, 3, 5, 6, 5, 7, 4, 7, 5, 4, 6, 5, 5, 3, 7, '2021-01-21', 'r1', 12, 46, 46, 92, 80, 0, 'c002'),
(2, 133, 4, 4, 6, 5, 3, 5, 5, 5, 5, 5, 4, 5, 5, 6, 6, 5, 3, 6, '2021-01-21', 'r1', 6, 45, 42, 87, 81, 0, 'c002'),
(18, 134, 4, 4, 6, 4, 3, 6, 5, 4, 8, 4, 4, 9, 8, 5, 4, 6, 4, 7, '2021-01-21', 'r1', 10, 51, 44, 95, 85, 0, 'c002'),
(11, 135, 4, 3, 5, 5, 4, 6, 9, 9, 9, 5, 6, 6, 4, 5, 3, 6, 3, 8, '2021-01-21', 'r1', 12, 46, 54, 100, 88, 1, 'c002'),
(12, 148, 5, 4, 5, 3, 6, 4, 4, 6, 4, 3, 4, 5, 3, 3, 5, 5, 5, 4, '2021-01-23', 'r2', 4, 37, 41, 78, 74, 1, 'c003'),
(22, 149, 6, 3, 6, 4, 4, 3, 6, 7, 7, 4, 3, 6, 5, 4, 7, 6, 4, 6, '2021-01-21', 'r1', 12, 45, 46, 91, 79, 2, '2'),
(28, 150, 5, 3, 7, 4, 5, 6, 7, 5, 5, 8, 3, 4, 5, 6, 6, 6, 5, 6, '2021-01-21', 'r1', 10, 49, 47, 96, 86, 0, '2'),
(7, 151, 5, 4, 5, 4, 4, 4, 4, 6, 5, 3, 5, 5, 4, 3, 4, 7, 4, 5, '2021-01-23', 'r2', 7, 40, 41, 81, 74, 0, 'c003'),
(18, 152, 5, 5, 4, 5, 4, 4, 4, 5, 5, 4, 5, 5, 4, 4, 5, 5, 4, 4, '2021-01-23', 'r2', 5, 40, 41, 81, 76, 0, 'c003'),
(14, 153, 6, 3, 5, 4, 6, 3, 4, 5, 5, 3, 4, 5, 4, 5, 5, 6, 5, 4, '2021-01-23', 'r2', 5, 41, 41, 82, 77, 1, 'c003'),
(1, 154, 8, 4, 4, 6, 5, 3, 4, 8, 5, 4, 5, 5, 3, 3, 3, 6, 5, 4, '2021-01-23', 'r2', 8, 38, 47, 85, 77, 1, 'c003'),
(11, 155, 5, 5, 6, 6, 5, 4, 5, 5, 6, 3, 5, 4, 3, 5, 4, 6, 5, 4, '2021-01-23', 'r2', 7, 39, 47, 86, 79, 0, 'c003'),
(9, 156, 6, 4, 6, 5, 5, 3, 6, 5, 4, 3, 4, 7, 3, 3, 6, 7, 6, 6, '2021-01-23', 'r2', 8, 45, 44, 89, 81, 0, 'c003'),
(25, 157, 5, 5, 4, 5, 6, 4, 6, 5, 3, 3, 4, 5, 3, 3, 5, 6, 5, 6, '2021-01-23', 'r2', 1, 40, 43, 83, 82, 1, 'c003'),
(28, 158, 6, 4, 6, 7, 6, 4, 5, 7, 4, 4, 4, 5, 4, 4, 4, 7, 6, 3, '2021-01-23', 'r2', 6, 41, 49, 90, 84, 1, 'c003'),
(15, 159, 5, 6, 6, 5, 5, 5, 5, 5, 4, 4, 7, 5, 3, 4, 5, 6, 4, 3, '2021-01-23', 'r2', 2, 41, 46, 87, 85, 1, 'c003'),
(2, 160, 6, 4, 4, 5, 5, 5, 5, 7, 5, 4, 6, 5, 3, 4, 6, 5, 4, 4, '2021-01-23', 'r2', 1, 41, 46, 87, 86, 0, 'c003'),
(3, 161, 5, 8, 6, 4, 6, 5, 7, 4, 6, 4, 6, 4, 4, 4, 5, 9, 7, 6, '2021-01-23', 'r2', 8, 49, 51, 100, 92, 1, 'c003'),
(11, 162, 4, 5, 5, 3, 6, 5, 5, 4, 5, 4, 5, 4, 5, 4, 4, 3, 6, 5, '2021-01-28', 'r3', 12, 40, 42, 82, 70, 0, 'c001'),
(14, 163, 6, 7, 4, 3, 5, 6, 4, 2, 6, 5, 4, 3, 5, 4, 5, 3, 5, 5, '2021-01-28', 'r3', 11, 39, 43, 82, 71, 2, 'c001'),
(15, 164, 5, 2, 3, 4, 5, 4, 4, 3, 9, 6, 4, 3, 4, 4, 7, 3, 4, 7, '2021-01-28', 'r3', 7, 42, 39, 81, 74, 4, 'c001'),
(25, 165, 4, 4, 5, 3, 4, 4, 4, 4, 4, 4, 6, 3, 4, 5, 4, 5, 4, 8, '2021-01-28', 'r3', 5, 43, 36, 79, 74, 2, 'c001'),
(12, 166, 5, 5, 4, 4, 5, 5, 6, 5, 4, 4, 6, 3, 5, 5, 4, 4, 5, 5, '2021-01-28', 'r3', 9, 41, 43, 84, 75, 1, 'c001'),
(18, 167, 5, 5, 5, 3, 5, 5, 5, 4, 7, 6, 6, 3, 5, 6, 4, 2, 5, 5, '2021-01-28', 'r3', 11, 42, 44, 86, 75, 1, 'c001'),
(2, 168, 4, 5, 4, 3, 6, 6, 4, 5, 7, 6, 4, 5, 5, 5, 5, 3, 4, 6, '2021-01-28', 'r3', 6, 43, 44, 87, 81, 1, 'c001'),
(9, 169, 5, 9, 6, 3, 7, 4, 6, 4, 5, 4, 6, 4, 6, 6, 5, 3, 5, 7, '2021-01-28', 'r3', 12, 46, 49, 95, 83, 0, 'c001'),
(28, 170, 4, 5, 6, 4, 7, 4, 7, 4, 7, 6, 5, 4, 6, 5, 6, 4, 5, 7, '2021-01-28', 'r3', 11, 48, 48, 96, 85, 0, 'c001'),
(7, 171, 5, 7, 7, 4, 6, 4, 7, 4, 7, 5, 5, 3, 6, 6, 6, 5, 4, 7, '2021-01-28', 'r3', 12, 47, 51, 98, 86, 0, 'c001'),
(1, 172, 7, 7, 10, 4, 5, 6, 5, 3, 6, 4, 4, 4, 5, 7, 5, 3, 6, 8, '2021-01-28', 'r3', 12, 46, 53, 99, 87, 1, 'c001'),
(3, 173, 6, 6, 8, 3, 7, 6, 5, 5, 6, 5, 6, 3, 6, 6, 6, 4, 5, 6, '2021-01-28', 'r3', 12, 47, 52, 99, 87, 0, 'c001');

-- --------------------------------------------------------

--
-- Table structure for table `sponserslist`
--

DROP TABLE IF EXISTS `sponserslist`;
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
-- Table structure for table `state`
--

DROP TABLE IF EXISTS `state`;
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
-- Table structure for table `statictournamentrounddetails`
--

DROP TABLE IF EXISTS `statictournamentrounddetails`;
CREATE TABLE `statictournamentrounddetails` (
  `st.id` int(11) NOT NULL,
  `tour_id` int(11) NOT NULL,
  `round_Id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `statictournamentrounddetails`
--

INSERT INTO `statictournamentrounddetails` (`st.id`, `tour_id`, `round_Id`) VALUES
(1, 1, 3);

-- --------------------------------------------------------

--
-- Table structure for table `tournament_coupon_details`
--

DROP TABLE IF EXISTS `tournament_coupon_details`;
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
(9, 'Subway', 2, 72, 141, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tournament_details`
--

DROP TABLE IF EXISTS `tournament_details`;
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

DROP TABLE IF EXISTS `tournament_group_details`;
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
(38, 'group 1', 1, '12:00', 1, 2),
(39, 'Group1', 1, '10:10', 74, 149),
(44, 'Group1', 1, '10:10', 75, 156),
(45, 'Group2', 2, '12:00', 75, 156),
(47, 'Group1', 2, '12:00', 70, 137),
(49, 'Group1', 2, '12:45', 77, 160),
(52, 'Group1', 2, '12:01', 93, 205);

--
-- Triggers `tournament_group_details`
--
DROP TRIGGER IF EXISTS `add_tournament_gropu_details`;
DELIMITER $$
CREATE TRIGGER `add_tournament_gropu_details` BEFORE DELETE ON `tournament_group_details` FOR EACH ROW BEGIN
Insert into tournament_group_details_archive (groupId ,groupName,tee_Number,tee_Time,tourID,round_Id)
  	values(old.groupId,old.groupName,old.tee_Number,old.tee_Time,old.tourID,old.round_Id);
     	
  END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tournament_group_details_archive`
--

DROP TABLE IF EXISTS `tournament_group_details_archive`;
CREATE TABLE `tournament_group_details_archive` (
  `groupId` int(11) NOT NULL,
  `groupName` varchar(100) NOT NULL,
  `tee_Number` int(18) NOT NULL,
  `tee_Time` varchar(50) NOT NULL,
  `tourID` int(10) NOT NULL,
  `round_Id` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tournament_group_details_archive`
--

INSERT INTO `tournament_group_details_archive` (`groupId`, `groupName`, `tee_Number`, `tee_Time`, `tourID`, `round_Id`) VALUES
(46, 'Group1', 1, '10:10', 70, 136),
(48, 'Group1', 1, '12:00', 77, 159),
(50, 'Group1', 1, '12:12', 93, 201),
(51, 'Group1', 2, '12:12', 93, 203);

-- --------------------------------------------------------

--
-- Table structure for table `tournament_group_player_details`
--

DROP TABLE IF EXISTS `tournament_group_player_details`;
CREATE TABLE `tournament_group_player_details` (
  `t_player_Id` int(11) NOT NULL,
  `tournamentId` int(11) NOT NULL,
  `groupName` varchar(100) NOT NULL,
  `playerId` int(11) NOT NULL,
  `tee_time` varchar(50) NOT NULL,
  `isPlay` int(11) NOT NULL,
  `isWithdraw` int(10) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tournament_group_player_details`
--

INSERT INTO `tournament_group_player_details` (`t_player_Id`, `tournamentId`, `groupName`, `playerId`, `tee_time`, `isPlay`, `isWithdraw`) VALUES
(48, 74, 'Group1', 6, '10:10', 1, 0),
(57, 75, 'Group2', 19, '12:00', 0, 0),
(58, 75, 'Group2', 39, '12:10', 0, 0),
(59, 75, 'Group1', 6, '10:10', 0, 0),
(60, 75, 'Group1', 38, '10:20', 0, 0),
(62, 70, 'Group1', 6, '12:00', 0, 0),
(64, 77, 'Group1', 6, '12:45', 0, 0),
(67, 93, 'Group1', 6, '12:01', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tournament_player_details`
--

DROP TABLE IF EXISTS `tournament_player_details`;
CREATE TABLE `tournament_player_details` (
  `t_player_Id` int(11) NOT NULL,
  `tournamentId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `playerId` int(11) NOT NULL,
  `tee_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `isPlay` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tournament_player_list`
--

DROP TABLE IF EXISTS `tournament_player_list`;
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
(1, 48, 5, 0, 1, 1, 1, 0, 1, '2022-02-02'),
(2, 48, 6, 0, 1, 1, 1, 0, 0, '2022-02-02'),
(3, 48, 7, 1, 1, 0, 1, 0, 0, '2022-02-02'),
(4, 49, 5, 0, 1, 0, 0, 1, 0, '2022-02-02'),
(5, 49, 6, 0, 1, 1, 0, 0, 0, '2022-02-02'),
(6, 49, 7, 0, 1, 0, 1, 1, 0, '2022-02-02'),
(7, 50, 7, 0, 1, 0, 0, 0, 0, '2022-02-02'),
(8, 50, 6, 1, 1, 0, 0, 0, 0, '2022-02-02'),
(9, 51, 6, 0, 1, 0, 0, 0, 0, '2022-02-03'),
(10, 51, 6, 0, 1, 0, 0, 1, 0, '2022-02-03'),
(11, 52, 6, 0, 1, 0, 1, 0, 0, '2022-02-04'),
(12, 52, 7, 0, 1, 0, 1, 0, 0, '2022-02-04'),
(15, 53, 6, 0, 1, 0, 0, 0, 0, '2022-02-04'),
(16, 54, 6, 0, 1, 0, 0, 0, 0, '2022-02-04'),
(17, 55, 7, 0, 1, 0, 0, 0, 0, '2022-02-04'),
(18, 56, 6, 0, 1, 0, 0, 0, 0, '2022-02-04'),
(19, 57, 5, 0, 1, 1, 1, 0, 0, '2022-02-16'),
(20, 57, 6, 0, 1, 1, 1, 0, 0, '2022-02-16'),
(21, 57, 7, 0, 1, 1, 1, 0, 0, '2022-02-16'),
(22, 59, 6, 0, 1, 0, 0, 0, 0, '2022-02-23'),
(23, 60, 6, 0, 1, 0, 0, 0, 0, '2022-02-23'),
(24, 60, 5, 0, 1, 0, 0, 0, 0, '2022-02-23'),
(25, 61, 5, 0, 1, 1, 1, 0, 0, '2022-02-26'),
(26, 61, 6, 0, 1, 1, 1, 0, 0, '2022-02-26'),
(27, 62, 10, 0, 1, 0, 0, 0, 0, '2022-02-26'),
(28, 62, 11, 0, 1, 0, 0, 0, 0, '2022-02-26'),
(29, 63, 6, 0, 1, 0, 0, 0, 0, '2022-03-02'),
(30, 63, 30, 0, 1, 0, 0, 0, 0, '2022-03-02'),
(31, 63, 18, 0, 1, 0, 0, 0, 0, '2022-03-02'),
(32, 63, 27, 0, 1, 0, 0, 0, 0, '2022-03-02'),
(33, 63, 22, 0, 1, 0, 0, 0, 0, '2022-03-02'),
(34, 63, 17, 0, 1, 0, 0, 0, 0, '2022-03-02'),
(35, 63, 23, 0, 1, 0, 0, 0, 0, '2022-03-02'),
(36, 63, 16, 0, 1, 0, 0, 0, 0, '2022-03-02'),
(37, 63, 26, 0, 1, 0, 0, 0, 0, '2022-03-02'),
(38, 63, 10, 0, 1, 0, 0, 0, 0, '2022-03-02'),
(39, 63, 32, 0, 1, 0, 0, 0, 0, '2022-03-02'),
(40, 63, 15, 0, 1, 0, 0, 0, 0, '2022-03-02'),
(41, 63, 11, 0, 1, 0, 0, 0, 0, '2022-03-02'),
(42, 63, 13, 0, 1, 0, 0, 0, 0, '2022-03-02'),
(43, 64, 6, 0, 1, 0, 0, 0, 0, '2022-03-02'),
(44, 64, 38, 0, 1, 1, 1, 0, 0, '2022-03-02'),
(45, 65, 39, 1, 1, 1, 1, 0, 0, '2022-04-05'),
(46, 65, 6, 0, 1, 0, 0, 0, 0, '2022-04-05'),
(47, 66, 36, 1, 1, 1, 1, 0, 0, '2022-04-07'),
(48, 66, 12, 1, 1, 1, 1, 0, 0, '2022-04-07'),
(49, 66, 25, 1, 1, 1, 1, 0, 0, '2022-04-07'),
(50, 66, 37, 1, 1, 1, 1, 0, 0, '2022-04-07'),
(51, 66, 13, 1, 1, 1, 1, 0, 0, '2022-04-07'),
(52, 66, 20, 1, 1, 1, 1, 0, 0, '2022-04-07'),
(53, 66, 10, 1, 1, 1, 1, 0, 0, '2022-04-07'),
(54, 66, 11, 1, 1, 1, 1, 0, 0, '2022-04-07'),
(55, 66, 23, 1, 1, 1, 1, 0, 0, '2022-04-07'),
(56, 66, 17, 1, 1, 1, 1, 0, 0, '2022-04-07'),
(57, 66, 32, 1, 1, 1, 1, 0, 0, '2022-04-07'),
(58, 66, 19, 1, 1, 1, 1, 0, 0, '2022-04-07'),
(59, 66, 24, 1, 1, 1, 1, 0, 0, '2022-04-07'),
(60, 66, 33, 1, 1, 1, 1, 0, 0, '2022-04-07'),
(61, 66, 35, 1, 1, 1, 1, 0, 0, '2022-04-07'),
(62, 66, 18, 1, 1, 1, 1, 0, 0, '2022-04-07'),
(63, 66, 30, 1, 1, 1, 1, 0, 0, '2022-04-07'),
(64, 66, 21, 1, 1, 1, 1, 0, 0, '2022-04-07'),
(65, 66, 16, 1, 1, 1, 1, 0, 0, '2022-04-07'),
(66, 66, 31, 1, 1, 1, 1, 0, 0, '2022-04-07'),
(67, 66, 22, 1, 1, 1, 1, 0, 0, '2022-04-07'),
(68, 67, 36, 0, 1, 0, 0, 0, 0, '2022-04-26'),
(69, 67, 6, 0, 1, 0, 0, 0, 0, '2022-04-26'),
(70, 68, 30, 0, 1, 0, 0, 0, 0, '2022-04-27'),
(71, 68, 16, 0, 1, 0, 0, 0, 0, '2022-04-27'),
(72, 68, 6, 0, 1, 0, 0, 0, 0, '2022-04-27'),
(73, 68, 14, 0, 1, 0, 0, 0, 0, '2022-04-27'),
(74, 68, 26, 0, 1, 0, 0, 0, 0, '2022-04-27'),
(75, 68, 35, 0, 1, 0, 0, 0, 0, '2022-04-27'),
(76, 68, 39, 0, 1, 0, 0, 0, 0, '2022-04-27'),
(77, 68, 10, 0, 1, 0, 0, 0, 0, '2022-04-27'),
(78, 66, 19, 1, 1, 1, 1, 0, 0, '2022-05-10'),
(79, 48, 16, 1, 1, 1, 1, 0, 0, '2022-05-11'),
(80, 66, 19, 1, 1, 1, 1, 0, 0, '2022-05-11'),
(81, 70, 6, 1, 1, 1, 1, 0, 0, '2022-05-13'),
(82, 71, 6, 0, 1, 0, 0, 0, 0, '2022-05-24'),
(83, 72, 6, 0, 1, 0, 0, 0, 0, '2022-05-24'),
(84, 73, 6, 0, 1, 0, 0, 0, 0, '2022-05-26'),
(85, 74, 6, 1, 1, 1, 1, 0, 0, '2022-05-30'),
(86, 75, 39, 1, 1, 1, 1, 0, 0, '2022-06-01'),
(87, 75, 19, 1, 1, 1, 1, 0, 0, '2022-06-01'),
(88, 75, 38, 1, 1, 1, 1, 0, 0, '2022-06-01'),
(89, 75, 6, 1, 1, 1, 1, 0, 0, '2022-06-01'),
(90, 76, 6, 0, 1, 0, 0, 0, 0, '2022-06-01'),
(91, 76, 6, 0, 1, 0, 0, 0, 0, '2022-06-01'),
(92, 76, 6, 0, 1, 0, 0, 0, 0, '2022-06-01'),
(93, 76, 6, 0, 1, 0, 0, 0, 0, '2022-06-01'),
(94, 76, 6, 0, 1, 0, 0, 0, 0, '2022-06-01'),
(95, 48, 19, 0, 1, 0, 0, 0, 0, '2022-06-01'),
(96, 76, 19, 0, 1, 0, 0, 0, 0, '2022-06-01'),
(97, 76, 10, 0, 1, 0, 0, 0, 0, '2022-06-01'),
(98, 76, 10, 0, 1, 0, 0, 0, 0, '2022-06-01'),
(99, 77, 6, 1, 1, 1, 1, 0, 0, '2022-06-01'),
(100, 78, 6, 0, 1, 0, 0, 0, 0, '2022-06-06'),
(101, 78, 6, 0, 1, 0, 0, 0, 0, '2022-06-06'),
(102, 79, 6, 0, 1, 0, 0, 0, 0, '2022-06-06'),
(103, 79, 6, 0, 1, 0, 0, 0, 0, '2022-06-06'),
(104, 80, 6, 0, 1, 0, 0, 0, 0, '2022-06-06'),
(105, 81, 6, 0, 1, 0, 0, 0, 0, '2022-06-06'),
(106, 82, 6, 0, 1, 0, 0, 0, 0, '2022-06-06'),
(107, 83, 6, 0, 1, 0, 0, 0, 0, '2022-06-06'),
(108, 84, 6, 0, 1, 0, 0, 0, 0, '2022-06-07'),
(109, 85, 6, 0, 1, 0, 0, 0, 0, '2022-06-07'),
(110, 87, 6, 0, 1, 0, 0, 0, 0, '2022-06-07'),
(111, 88, 6, 0, 1, 0, 0, 0, 0, '2022-06-07'),
(112, 92, 6, 0, 1, 1, 1, 0, 0, '2022-06-13'),
(113, 93, 6, 1, 1, 1, 1, 0, 0, '2022-06-17'),
(114, 94, 6, 0, 1, 0, 0, 0, 0, '2022-07-04'),
(115, 94, 6, 0, 1, 0, 0, 0, 0, '2022-07-04'),
(116, 95, 6, 0, 1, 0, 0, 0, 0, '2022-07-04'),
(117, 97, 6, 0, 1, 0, 0, 0, 0, '2022-07-15'),
(118, 98, 6, 0, 1, 0, 0, 0, 0, '2022-07-15'),
(119, 101, 6, 0, 1, 0, 0, 0, 0, '2022-07-18'),
(120, 103, 6, 0, 1, 0, 0, 0, 0, '2022-07-27');

-- --------------------------------------------------------

--
-- Table structure for table `tournament_score_details`
--

DROP TABLE IF EXISTS `tournament_score_details`;
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
  `hdcp` int(11) NOT NULL,
  `inn` int(11) NOT NULL,
  `outt` int(11) NOT NULL,
  `gross` int(11) NOT NULL,
  `net` int(11) NOT NULL,
  `birdie` int(11) NOT NULL,
  `holeNum` int(10) DEFAULT 0,
  `cid` varchar(4) NOT NULL,
  `createdDate` datetime DEFAULT NULL,
  `isDeleted` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tournament_score_details`
--

INSERT INTO `tournament_score_details` (`tour_score_id`, `p_id`, `tour_id`, `score1`, `score2`, `score3`, `score4`, `score5`, `score6`, `score7`, `score8`, `score9`, `score10`, `score11`, `score12`, `score13`, `score14`, `score15`, `score16`, `score17`, `score18`, `round_Id`, `hdcp`, `inn`, `outt`, `gross`, `net`, `birdie`, `holeNum`, `cid`, `createdDate`, `isDeleted`) VALUES
(19, 38, 75, 5, 3, 5, 4, 4, 6, 6, 5, 5, 5, 4, 4, 4, 7, 4, 5, 3, 6, 154, 9, 42, 43, 85, 76, 0, NULL, '2', '2022-06-02 11:25:13', 0),
(20, 6, 75, 5, 3, 5, 4, 4, 6, 6, 5, 5, 5, 4, 4, 4, 7, 4, 5, 3, 6, 154, 9, 42, 43, 100, 76, 2, NULL, '2', '2022-06-02 11:28:21', 0),
(21, 39, 75, 5, 3, 5, 4, 4, 6, 6, 5, 5, 5, 4, 4, 4, 7, 4, 5, 3, 6, 154, 9, 42, 43, 100, 76, 2, NULL, '2', '2022-06-02 11:30:13', 0),
(22, 19, 75, 5, 3, 5, 4, 4, 6, 6, 5, 5, 5, 4, 4, 4, 7, 4, 5, 3, 6, 154, 9, 42, 43, 120, 76, 2, NULL, '2', '2022-06-02 11:33:19', 0),
(23, 19, 75, 5, 3, 5, 4, 4, 6, 6, 5, 5, 5, 4, 4, 4, 7, 4, 5, 3, 6, 155, 9, 42, 43, 120, 76, 2, NULL, '2', '2022-06-02 11:42:09', 0),
(24, 6, 75, 5, 3, 5, 4, 4, 6, 6, 5, 5, 5, 4, 4, 4, 7, 4, 5, 3, 6, 155, 9, 42, 43, 120, 76, 2, NULL, '2', '2022-06-02 11:42:16', 0),
(25, 38, 75, 5, 3, 5, 4, 4, 6, 6, 5, 5, 5, 4, 4, 4, 7, 4, 5, 3, 6, 155, 9, 42, 43, 120, 76, 2, NULL, '2', '2022-06-02 11:42:25', 0),
(26, 39, 75, 5, 3, 5, 4, 4, 6, 6, 5, 5, 5, 4, 4, 4, 7, 4, 5, 3, 6, 155, 9, 42, 43, 120, 76, 2, NULL, '2', '2022-06-02 11:42:30', 0),
(27, 6, 70, 5, 3, 5, 4, 4, 6, 6, 5, 5, 5, 4, 4, 4, 7, 4, 5, 3, 6, 136, 9, 42, 43, 120, 76, 2, NULL, '2', '2022-06-02 12:13:23', 0),
(28, 6, 77, 5, 3, 5, 4, 4, 6, 6, 5, 5, 5, 4, 4, 4, 7, 4, 5, 3, 6, 159, 9, 42, 43, 120, 76, 2, NULL, '2', '2022-06-02 12:28:20', 0),
(29, 6, 93, 3, 4, 5, 4, 3, 4, 5, 6, 5, 6, 5, 6, 3, 4, 5, 6, 6, 4, 201, 12, 45, 39, 84, 72, 0, 10, '29', '2022-06-17 15:19:20', 0),
(30, 6, 93, 5, 4, 4, 5, 6, 5, 6, 5, 6, 5, 6, 7, 6, 7, 2, 6, 6, 5, 203, 10, 50, 46, 96, 86, 0, 3, '1', '2022-06-17 17:23:00', 0),
(31, 6, 93, 5, 6, 9, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 205, 6, 0, 22, 22, 16, 0, 4, '3', '2022-07-11 14:53:09', 0);

-- --------------------------------------------------------

--
-- Table structure for table `tournament_winners`
--

DROP TABLE IF EXISTS `tournament_winners`;
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

DROP TABLE IF EXISTS `user_account_otp`;
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
(46, 42, 368753, '2022-06-29 15:20:40');

-- --------------------------------------------------------

--
-- Table structure for table `user_details`
--

DROP TABLE IF EXISTS `user_details`;
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
  `hdcp` int(10) DEFAULT NULL,
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

INSERT INTO `user_details` (`p_id`, `firstName`, `lastName`, `playerName`, `userName`, `contactNumber`, `email`, `password`, `dob`, `gender`, `homeCourse`, `hdcp`, `hdcpCertificate`, `platformLink`, `vaccineStatus`, `employment`, `companyName`, `jobTitle`, `industry`, `profileImg`, `roleId`, `isDeleted`, `isWebUser`, `isFirstLogin`, `countryId`, `stateId`, `createdDate`, `updatedDate`, `isAccountVerified`, `device_id`, `device_platform`) VALUES
(1, 'super', 'admin', '', 'superAdmin', 'h', 'meenakshi@echelonedge.com', 'Meen@1234', NULL, 'female', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 0, NULL, NULL, NULL, NULL, 0, '', ''),
(6, 'test', ' testii', 'test mina testii', 'test@1234', '5544667788', 'er.minaxi18@gmail.com', 'testi@123456', '2000-01-01', 'male', 'test mnmjk', 12, '', '', 1, 2, 'test test', 'manager', '2', NULL, 3, 0, 0, 0, NULL, NULL, '2022-01-19 00:00:00', '2022-01-21 00:00:00', 1, '', ''),
(10, 'Rajiv', 'Ghumman', 'Rajiv Ghumman', 'RajivGhumman2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, NULL, 0, NULL, NULL, '2022-02-26 06:51:44', '2022-02-26 06:51:44', 1, '', ''),
(11, 'Aseem', 'Vivek', 'Aseem Vivek', 'AseemVivek2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, NULL, 0, NULL, NULL, '2022-02-26 06:51:44', '2022-02-26 06:51:44', 1, '', ''),
(12, 'Avneet', 'Vohra', 'Avneet Vohra', 'AvneetVohra2', '0', NULL, '0', NULL, NULL, NULL, 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, NULL, NULL, '2022-02-26 06:59:37', '2022-02-26 06:59:37', 1, '', ''),
(13, 'Manjit', 'Bagri', 'Manjit Bagri', 'ManjitBagri2', '0', NULL, NULL, NULL, NULL, NULL, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, 1, NULL, '2022-02-26 06:59:37', '2022-02-26 06:59:37', 1, '', ''),
(14, 'Tarun', 'Mehrotra', 'Tarun Mehrotra', 'TarunMehrotra2', '0', NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, 1, NULL, '2022-02-26 07:04:16', '2022-02-26 07:04:16', 1, '', ''),
(15, 'Bobby', 'Kochchar', 'Bobby Kochchar', 'BobbyKochchar2', NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, 1, NULL, '2022-02-26 07:04:16', '2022-02-26 07:04:16', 0, '', ''),
(16, 'Tarun', 'Mehrotra', 'Tarun Mehrotra', 'TarunMehrotra2', '0', NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, 1, NULL, '2022-02-26 07:04:16', '2022-02-26 07:04:16', 1, '', ''),
(17, 'Bobby', 'Kochchar', 'Bobby Kochchar', 'BobbyKochchar2', NULL, NULL, NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, 1, NULL, '2022-02-26 07:04:16', '2022-02-26 07:04:16', 1, '', ''),
(18, 'Raman', 'Dua', 'Raman Dua', 'RamanDua2', '0', NULL, NULL, NULL, NULL, NULL, 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, NULL, NULL, '2022-02-26 07:06:56', '2022-02-26 07:06:56', 1, '', ''),
(19, 'Gaurav', 'Gandhi', 'Gaurav Gandhi', 'GauravGandhi2', '0', NULL, NULL, NULL, NULL, NULL, 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, NULL, NULL, '2022-02-26 07:06:56', '2022-02-26 07:06:56', 1, '', ''),
(20, 'Anand', 'Bansal', 'Anand Bansal', 'AnandBansal2', NULL, NULL, NULL, NULL, NULL, NULL, 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, NULL, NULL, '2022-02-26 07:08:55', '2022-02-26 07:08:55', 1, '', ''),
(21, 'Azaad', 'Gill', 'Azaad Gill', 'AzaadGill2', NULL, NULL, NULL, NULL, NULL, NULL, 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, NULL, NULL, '2022-02-26 07:08:55', '2022-02-26 07:08:55', 1, '', ''),
(22, 'Col. Manish', 'Dubey', 'Col. Manish Dubey', 'ColManishDubey2', NULL, NULL, NULL, NULL, NULL, NULL, 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, NULL, NULL, '2022-02-26 07:08:55', '2022-02-26 07:08:55', 1, '', ''),
(23, 'Ashok', 'Singh', 'Ashok Singh', 'AshokSingh2', '0', NULL, NULL, NULL, NULL, NULL, 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, NULL, NULL, '2022-02-26 07:11:52', '2022-02-26 07:11:52', 1, '', ''),
(24, 'Naresh', 'Kumar', 'Naresh Kumar', 'NareshKumar2', '0', NULL, NULL, NULL, NULL, NULL, 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, NULL, NULL, '2022-02-26 07:11:52', '2022-02-26 07:11:52', 1, '', ''),
(25, 'Bobby', 'Tewari', 'Bobby Tewari', 'BobbyTewari2', '', NULL, NULL, NULL, NULL, NULL, 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, NULL, NULL, '2022-02-26 07:11:52', '2022-02-26 07:11:52', 1, '', ''),
(26, 'Rohit', 'Shukla', 'Rohit Shukla', 'RohitShukla2', NULL, NULL, NULL, NULL, NULL, NULL, 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 1, 0, 0, NULL, NULL, '2022-02-26 07:16:03', '2022-02-26 07:16:03', 1, '', ''),
(27, 'Mhirjit', 'Singh', 'Mhirjit Singh', 'MhirjitSingh2', NULL, NULL, NULL, NULL, NULL, NULL, 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, NULL, NULL, '2022-02-26 07:16:03', '2022-02-26 07:16:03', 1, '', ''),
(28, 'Col. Azad S ', 'Ruhail', 'Col. Azad S Ruhail', 'AzadSRuhail', '0', NULL, NULL, NULL, NULL, NULL, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, NULL, NULL, '2022-02-26 07:16:03', '2022-02-26 07:16:03', 1, '', ''),
(29, 'Rishi', 'Poddar', 'Rishi Poddar', 'RishiPoddar2', '0', NULL, NULL, NULL, NULL, NULL, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, NULL, NULL, '2022-02-26 07:16:03', '2022-02-26 07:16:03', 0, '', ''),
(30, 'Rohit', 'Shukla', 'Rohit Shukla', 'RohitShukla2', NULL, NULL, NULL, NULL, NULL, NULL, 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, NULL, NULL, '2022-02-26 07:16:03', '2022-02-26 07:16:03', 1, '', ''),
(31, 'Mhirjit', 'Singh', 'Mhirjit Singh', 'MhirjitSingh2', NULL, NULL, NULL, NULL, NULL, NULL, 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, NULL, NULL, '2022-02-26 07:16:03', '2022-02-26 07:16:03', 1, '', ''),
(32, 'Col. Azad S ', 'Ruhail', 'Col. Azad S Ruhail', 'AzadSRuhail', '0', NULL, NULL, NULL, NULL, NULL, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, NULL, NULL, '2022-02-26 07:16:03', '2022-02-26 07:16:03', 1, '', ''),
(33, 'Rishi', 'Poddar', 'Rishi Poddar', 'RishiPoddar2', '0', NULL, NULL, NULL, NULL, NULL, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, NULL, NULL, '2022-02-26 07:16:03', '2022-02-26 07:16:03', 1, '', ''),
(34, 'Ranndeep', 'Chonker', 'Ranndeep Chonker', 'RanndeepChonker2', '0', NULL, NULL, NULL, NULL, NULL, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 1, 0, 0, 1, NULL, '2022-02-26 07:20:24', '2022-02-26 07:20:24', 1, '', ''),
(35, 'Simran', 'Gujral', 'Simran Gujral', 'SimranGujral2', NULL, NULL, NULL, NULL, NULL, NULL, 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, 1, NULL, '2022-02-26 07:20:24', '2022-02-26 07:20:24', 1, '', ''),
(36, 'Aman', 'Guleria', 'Aman Guleria', 'AmanGuleria2', NULL, NULL, NULL, NULL, NULL, NULL, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, 1, NULL, '2022-02-26 07:20:24', '2022-02-26 07:20:24', 1, '', ''),
(37, 'Col. Rajesh', 'Bains', 'Col. Rajesh Bains', 'RajeshBains2', NULL, NULL, NULL, NULL, NULL, NULL, 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 0, 0, 1, NULL, '2022-02-26 07:20:24', '2022-02-26 07:20:24', 1, '', ''),
(38, 'garima', ' testii', 'garima  testii', 'test@1234', '5544667788', 'garima.kapoor@echelonedge.com', 'testis@1234', '2000-01-01', 'male', 'test mnmjk', 12, '', '', 1, 2, 'test test', 'manager', '2', NULL, 3, 1, 0, 0, NULL, NULL, '2022-03-02 15:30:12', '2022-03-02 15:30:12', 1, '', ''),
(39, 'tt', 'tt', 'tt tt', 'abc@123', '5554454', 'shivdra@echelonedge.com', '55555', '0000-00-00', 'male', 'itc', 12, '', '', 0, 0, 'https://www.echelonedge.com/', '', '0', NULL, 3, 1, 0, 0, NULL, NULL, '2022-03-22 17:53:32', '2022-03-22 17:53:32', 0, '', ''),
(40, 'device', ' testii', 'device  testii', 'test@1234', '5544667788', 'test123@gmail.com', 'test@1234', '2000-01-01', 'male', 'test mnmjk', 12, '', '', 1, 2, 'test test', 'manager', '2', NULL, 3, 1, 0, 0, NULL, NULL, '2022-03-22 17:58:05', '2022-03-22 17:58:05', 0, '', ''),
(41, 'device', ' testii', 'device  testii', 'test@1234', '6677889900', 'meenakshi2@echelonedge.com', 'test@1234', '2000-01-01', 'male', 'test mnmjk', 12, '', '', 1, 2, 'test test', 'manager', '2', NULL, 3, 0, 0, 0, NULL, NULL, '2022-06-28 11:09:07', '2022-06-28 11:09:07', 0, NULL, NULL),
(42, 'devicee', ' testii', 'devicee  testii', 'test@1234', '6677889900', 'meenakshi3@echelonedge.com', 'test@1234', '2000-01-01', 'male', 'test mnmjk', 12, '', '', 1, 2, 'test test', 'manager', '2', NULL, 3, 0, 0, 0, NULL, NULL, '2022-06-29 15:20:06', '2022-06-29 15:20:06', 0, '', '');

-- --------------------------------------------------------

--
-- Table structure for table `user_role`
--

DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role` (
  `roleId` int(11) NOT NULL,
  `roleName` varchar(100) DEFAULT NULL,
  `isDeleted` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user_role`
--

INSERT INTO `user_role` (`roleId`, `roleName`, `isDeleted`) VALUES
(1, 'superAdmin', 0),
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
-- Indexes for table `master_vaccine_status`
--
ALTER TABLE `master_vaccine_status`
  ADD PRIMARY KEY (`vaccineId`);

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
  ADD KEY `pid` (`pid`),
  ADD KEY `cid` (`cid`);

--
-- Indexes for table `sponserslist`
--
ALTER TABLE `sponserslist`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `state`
--
ALTER TABLE `state`
  ADD PRIMARY KEY (`state_Id`);

--
-- Indexes for table `statictournamentrounddetails`
--
ALTER TABLE `statictournamentrounddetails`
  ADD PRIMARY KEY (`st.id`);

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
-- Indexes for table `tournament_player_details`
--
ALTER TABLE `tournament_player_details`
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
  MODIFY `cid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

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
  MODIFY `tourID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=107;

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
-- AUTO_INCREMENT for table `master_vaccine_status`
--
ALTER TABLE `master_vaccine_status`
  MODIFY `vaccineId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `player_details`
--
ALTER TABLE `player_details`
  MODIFY `pid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `round_details`
--
ALTER TABLE `round_details`
  MODIFY `round_Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=227;

--
-- AUTO_INCREMENT for table `score_details`
--
ALTER TABLE `score_details`
  MODIFY `serial` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=177;

--
-- AUTO_INCREMENT for table `sponserslist`
--
ALTER TABLE `sponserslist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `state`
--
ALTER TABLE `state`
  MODIFY `state_Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `statictournamentrounddetails`
--
ALTER TABLE `statictournamentrounddetails`
  MODIFY `st.id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tournament_coupon_details`
--
ALTER TABLE `tournament_coupon_details`
  MODIFY `couponId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `tournament_details`
--
ALTER TABLE `tournament_details`
  MODIFY `tourID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `tournament_group_details`
--
ALTER TABLE `tournament_group_details`
  MODIFY `groupId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `tournament_group_player_details`
--
ALTER TABLE `tournament_group_player_details`
  MODIFY `t_player_Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT for table `tournament_player_details`
--
ALTER TABLE `tournament_player_details`
  MODIFY `t_player_Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tournament_player_list`
--
ALTER TABLE `tournament_player_list`
  MODIFY `tour_player_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=121;

--
-- AUTO_INCREMENT for table `tournament_score_details`
--
ALTER TABLE `tournament_score_details`
  MODIFY `tour_score_id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `tournament_winners`
--
ALTER TABLE `tournament_winners`
  MODIFY `t_win` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `user_account_otp`
--
ALTER TABLE `user_account_otp`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `user_details`
--
ALTER TABLE `user_details`
  MODIFY `p_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `user_role`
--
ALTER TABLE `user_role`
  MODIFY `roleId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
