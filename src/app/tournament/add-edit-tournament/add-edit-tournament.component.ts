import { DatePipe } from '@angular/common';
import { Component, Inject, OnInit } from '@angular/core';
import { FormArray, FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { CommonServiceService } from 'src/app/Service/common.service';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import Swal from 'sweetalert2';
import { forkJoin } from 'rxjs';


@Component({
  selector: 'app-add-edit-tournament',
  templateUrl: './add-edit-tournament.component.html',
  styleUrls: ['./add-edit-tournament.component.css']
})
export class AddEditTournamentComponent implements OnInit {

  todayDate = new Date();
  isButtonDisable: boolean = false;
  approvalStatus: any = 1;
  inviteStatus: any = 1;
  approvedPlayerList: any = [];
  tourID: any;
  playerList: any = [];
  teeNameList: any = [];
  eventDetailsArr: any = new FormArray([]);
  eventFormGroup: any = new FormGroup({
    eventDetailsArr: new FormArray([]),
  });
  groupDetailsArr: any = new FormArray([]);
  groupFormGroup: any = new FormGroup({

    tourId: new FormControl('', []),
    roundId: new FormControl('', []),

    groupDetailsArr: new FormArray([]),
  });
  acceptRejectPlayerList: any = [];
  invitedplayersList: any = [];
  couponArr: any = new FormArray([]);
  couponFormGroup: any = new FormGroup({

    couponArr: new FormArray([]),
  });
  noPlayerGroup = new FormControl('', [Validators.required]);
  groupTournamentName = new FormControl('', [Validators.required]);
  groupRoundName = new FormControl('', [Validators.required]);
  invitedPlayerList: any;
  constructor(
    public dialogRef: MatDialogRef<AddEditTournamentComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private fb: FormBuilder,
    private service: CommonServiceService,
    public route: Router,
    public datePipe: DatePipe) {


    // this.addCheckboxesToForm();
  }

  ngOnInit(): void {
    console.log("data=", this.data);

    debugger;


    if (this.data.sectionName == 'tournament') {
      this.eventFormGroupInit('');
      if (this.data.details) {
        this.eventFormGroup.controls.eventDetailsArr.controls[0].controls.numRounds.disable();
        this.eventFormGroup.controls.eventDetailsArr.controls[0].controls.tournamentName.disable();
        this.eventFormGroup.controls.eventDetailsArr.controls[0].controls.eventType.disable();
        this.eventFormGroup.controls.eventDetailsArr.controls[0].controls.holes.disable();
        // this.eventFormGroup.controls.eventDetailsArr.controls[0].controls.cname.disable();
        this.setEventDetails();
      }
    }
    else if (this.data.sectionName == 'coupon') {

      if (this.data.couponList.length > 0) {

        this.data.couponList.forEach((item: any) => {
          this.couponFormGroupInit(item);
        });
      } else {
        this.couponFormGroupInit('');
      }

    } else if (this.data.sectionName == 'group') {
      this.data.roundList.forEach((round: any, index: any) => {
        if (round.round_Id == this.data.previousRoundDetails.roundId) {
          this.groupRoundName.setValue(this.data.roundList[index + 1].round_Id);
        }
      });
      if (!this.groupRoundName.value) {
        this.groupRoundName.setValue(this.data.roundList[0].round_Id);
      }

      this.groupTournamentName.setValue(this.data.details.tournamentName)

    }
    if (this.data.sectionName == 'invite') {
      this.tourID = this.data.details.tourID
    }

  }

  setEventDetails() {
    const keys = Object.keys(this.eventFormGroup.controls.eventDetailsArr.controls[0].controls);
    const formControl = this.eventFormGroup.controls.eventDetailsArr.controls[0].controls;
    console.log(keys);
    for (let i = 0; i < keys.length; i++) {
      const keyName = keys[i];
      if (keyName == 'numRounds') {
        const numRoundString = this.data.details[keyName].toString();
        formControl[keyName].setValue(numRoundString);

        this.onShownRounds(this.eventFormGroup.controls.eventDetailsArr.controls[0]);

      } else {

        if (keyName == 'eventType') {
          formControl[keyName].setValue(Number(this.data.details[keyName]));
        } else if (keyName == 'holes') {
          formControl[keyName].setValue(this.data.details[keyName].toString());
        }
        else if (keyName != 'roundsArray') {

          formControl[keyName].setValue(this.data.details[keyName])
        }
      }
    }
  }


  eventFormGroupInit(data: any) {
    const eventsFormGroup: FormGroup = new FormGroup({
      tourID: new FormControl(''),
      tournamentName: new FormControl('', [Validators.required]),
      eventType: new FormControl('', [Validators.required]),
      numRounds: new FormControl('', [Validators.required]),
      holes: new FormControl('18', [Validators.required]),
      roundsArray: new FormArray([])
    });

    (this.eventFormGroup.get('eventDetailsArr') as FormArray).push(eventsFormGroup);
  }
  roundFormGroupInit(rounds: any) {
    let eventDate: any;
    if (rounds?.TournamentDate) {

      const dateNum = new Date(rounds.TournamentDate).getDate() + 1;
      eventDate = new Date(rounds.TournamentDate);
      debugger;
      // if(rounds){
      // eventDate = new Date(eventDate.setDate(dateNum));
      // }
    }
    const roundFormGroup: FormGroup = new FormGroup({
      round_Id: new FormControl(rounds ? rounds.round_Id : ''),
      tourID: new FormControl(rounds ? rounds.tourID : ''),
      eventDate: new FormControl(rounds ? eventDate : '', [Validators.required]),
      cname: new FormControl(rounds ? rounds.cid : '', [Validators.required]),
      roundName: new FormControl(rounds ? rounds.round_name : ''),
    });
    return roundFormGroup;
  }


  onShownRounds(selectedEvent: any) {

    if (selectedEvent.controls.roundsArray.length > 0) {
      selectedEvent.controls.roundsArray.controls.splice(0, selectedEvent.controls.roundsArray.length);
    }
    let count = 0;
    for (let i = 0; i < selectedEvent.controls.numRounds.value; i++) {

      selectedEvent.controls.roundsArray.push(this.roundFormGroupInit(this.data.selectedRound[i]));
      ;
      if (this.data?.details) {
        const formControl = selectedEvent?.controls?.roundsArray?.controls[i].controls;
        // const getEventTime = formControl.eventDate.value.getTime();
        const getTodayDate = new Date(new Date().toJSON().slice(0, 10).replace(/-/g, '/'));
        if (formControl.eventDate.value < getTodayDate) {
          count = count + 1;
          formControl.eventDate.disable();
          formControl.cname.disable();

        }
      }
    }
    if (count == selectedEvent.controls.numRounds.value) {
      this.isButtonDisable = true;
    } else {
      this.isButtonDisable = false;
    }
  }





  // -----------------------------Coupon section starts-------------------------------------------------------
  couponFormGroupInit(data: any) {
    const couponForm: FormGroup = new FormGroup({
      roundId: new FormControl(data.round_Id ? data.round_Id : '', []),
      name: new FormControl(data.couponCode ? data.couponCode : '', [Validators.required]),
      quantity: new FormControl(data.couponCount ? data.couponCount : '1', [Validators.required])
    });
    couponForm.controls.quantity.disable();
    (this.couponFormGroup.get('couponArr') as FormArray).push(couponForm);
  }

  onAddingNewCoupon() {
    this.couponFormGroupInit('');
  }
  onDeleteNewCoupon(index: any) {
    const couponArray = (this.couponFormGroup.get('couponArr') as FormArray).controls;
    if (couponArray.length > 1) {
      couponArray.splice(index, 1);
    }
  }

  onSaveCouponDetails() {
    const data = this.couponFormGroup.getRawValue();
    data.tourId = this.data.details.tourID;
    this.service.postAPIMethod("/tournament/saveTournamentCouponDetails", data).subscribe((APIResponse: any) => {
      if (APIResponse.error != 'X') {
        this.sweetAlertMsg("success", APIResponse.response.result.msg);
        this.closeDialogClick();
      } else {
        this.sweetAlertMsg("error", APIResponse.response.msg);
      }
    });
  }
  // ###################################################################################################
  //----------------------------------section Starts for tournament group-------------------------------
  groupFormGroupInit(data: any) {

    const groupForm: FormGroup = new FormGroup({
      group: new FormControl(data ? data.group : '', [Validators.required]),
      players: new FormControl(data ? data.players : '', [Validators.required]),
      playerDetails: new FormArray([]),
      tee: new FormControl(data ? data.tee : '', [Validators.required]),
      teeTime: new FormControl(data ? data.teeTime : '', [Validators.required]),
    });
    (this.groupFormGroup.get('groupDetailsArr') as FormArray).push(groupForm);


  }
  onAddingNewGroup() {
    this.groupFormGroupInit('');
  }
  onDeleteGroup(index: any) {
    const groupArray = (this.groupFormGroup.get('groupDetailsArr') as FormArray).controls;
    groupArray.splice(index, 1);
  }
  manualGroupInit() {
    this.resetGroupForm();
    if (this.noPlayerGroup.value) {
      this.genrateGroup();
      this.groupFormGroupInit('');
    } else {
      this.sweetAlertMsg("error", "Please enter number of player in a group")
    }
  }
  genrateGroup() {
    {
      if (this.data.playerList.length > 0) {
        this.playerList = JSON.parse(JSON.stringify(this.data.playerList))
        let noGroup = this.data.playerList.length / this.noPlayerGroup.value;
        noGroup = Math.ceil(noGroup);
        for (let i = 0; i < noGroup; i++) {
          const groupName = "Group" + (i + 1);
          this.data.groupList.push(groupName);
        }
        let roundIndex = 0;
        this.data.roundList.forEach((round: any, index: any) => {

          if (round.round_Id == this.data.previousRoundDetails.roundId) {
            roundIndex = index + 1;
          }

        });
        this.groupFormGroup.controls.roundId.setValue(this.data.roundList[roundIndex].round_Id);
        this.service.getAPIMethod(`/course/getCourseTeeList?courseId=` + this.data.roundList[roundIndex].cid).subscribe((APIResponse: any) => {
          if (APIResponse.error == '') {
            this.teeNameList = APIResponse.response.result;
          } else {

          }
        });


        this.groupFormGroup.controls.roundId.disable();
      }


    }
  }

  automaticGroupInit() {
    if (this.noPlayerGroup.value) {
      this.resetGroupForm();
      this.genrateGroup();
      if (this.data.groupList.length > 0) {
        for (let i = 0; i < this.data.groupList.length; i++) {
          const groupDetails: any = {
            group: '',
            players: '',
            tee: '',
            teeTime: '',

          };
          groupDetails.group = this.data.groupList[i];
          const playerList = [];

          for (let j = 0; j < this.data.playerList.length; j++) {

            if (playerList.length < this.noPlayerGroup.value && this.playerList[j]) {

              playerList.push(this.playerList[j].playerID);
            }
            console.log();
            if (playerList.length == this.noPlayerGroup.value || (this.playerList.length == playerList.length)) {
              ;
              groupDetails.players = playerList;
              this.playerList.splice(0, this.noPlayerGroup.value);
              this.groupFormGroupInit(groupDetails);

              let groupControls = this.groupFormGroup.controls.groupDetailsArr['controls'][this.groupFormGroup.controls.groupDetailsArr.controls.length - 1];
              this.getPlayerNames(groupControls);
              groupControls.controls.group.disable();
              groupControls.controls.players.disable();
              break;

            }
          }
        }
      }
    } else {
      this.sweetAlertMsg("error", "Please enter number of player in a group");
    }
  }
  resetGroupForm() {
    const groupControls = (this.groupFormGroup.get('groupDetailsArr') as FormArray).controls;
    if (groupControls.length > 0) {
      groupControls.splice(0, groupControls.length);
    }
    this.groupFormGroup.reset();
    this.playerList = JSON.parse(JSON.stringify(this.data.playerList));
  }
  getGroupNames(data: any) {
    let groupName = "";
    if (this.data.groupList.length > 0) {

      this.data.groupList.filter((details: any) => {

        if (details == data.controls.group.value) {
          groupName = details;
        }
      });
    }
    return groupName;
  }

  getPlayerNames(data: any) {

    if (data.controls.playerDetails.length > 0) {
      data.controls.playerDetails.controls.splice(0, data.controls.playerDetails.length);
    }
    console.log('Player', data.controls.players.value);
    data.controls.players.value.filter((item: any) => {
      this.data.playerList.filter((pData: any) => {

        if (pData.playerID == item) {
          const playerForm = new FormGroup({
            name: new FormControl(pData.playerName),
            id: new FormControl(item),
            teeTime: new FormControl("")
          });
          data.controls.playerDetails.controls.push(playerForm);
        }
      });
    });
    this.assignTeeTime(data);
  }

  assignTeeTime(details: any) {
    let teeTimeValue: any = details.controls.teeTime.value ? details.controls.teeTime.value : "";
    if (details.controls.players.value.length > 0) {

      let teeTimeValue: any = details.controls.teeTime.value ? details.controls.teeTime.value : "";
      details.controls.playerDetails.controls.filter((item: any, index: any) => {
        if (teeTimeValue && index > 0) {
          let oldDateObj: any = new Date();
          let newDateObj = new Date();
          oldDateObj = new Date(oldDateObj.getMonth() + '-' + oldDateObj.getDate() + '-' + oldDateObj.getFullYear() + ' ' + teeTimeValue);
          newDateObj.setTime(oldDateObj.getTime() + (10 * 60 * 1000));
          teeTimeValue = newDateObj.getHours() + ":" + newDateObj.getMinutes();
        }
        item.controls.teeTime.setValue(teeTimeValue);


      });
    }


  }
  saveGroupDetails() {
    const data = this.groupFormGroup.getRawValue();
    data.tourId = this.data.details.tourID;
    const grpArr: any = [];
    if (data.groupDetailsArr.length > 0) {
      data.groupDetailsArr.forEach((item: any) => {
        grpArr.push(item.group);
      });

      const filtered = grpArr.filter((el: any, index: any) => grpArr.indexOf(el) !== index);
      if (filtered.length == 0) {

        this.service.postAPIMethod("/tournament/saveTournamentGroupDetails", data).subscribe((APIResponse: any) => {
      
          if (APIResponse.error != 'X') {
            this.sweetAlertMsg("success", APIResponse.response.result.msg);
            this.closeDialogClick();
          } else {
            this.sweetAlertMsg("error", APIResponse.response.msg);
          }

        })
      } else {
        this.sweetAlertMsg("error", 'Group count must be one');
      }
    }
  }
  // ###############################################################################################

  closeDialogClick(): void {
    this.dialogRef.close(false);

  }
  // ------------ save tournament details------------------ 

  // saveTournamentDetails() {
  //   const data = this.tournament.getRawValue();
  //   const url = "/dataApi/saveTournamentDetails";
  //   this.service.postAPIMethod(url, data).subscribe((response: any) => {
  //     ;
  //     if (response.error != 'X' && response.result.err != "X") {

  //       if (this.data.isTournamentAdd) {
  //         this.sweetAlertMsg('success', response.result.msg);
  //         this.tournament.controls.tourID.setValue(response.result.tour_Id);
  //         this.eventTabDisplay();
  //       }
  //     } else {
  //       this.sweetAlertMsg('error', response.result.msg);
  //     }
  //   });
  // }



  sweetAlertMsg(typeIcon: any, msg: any) {
    console.log(typeIcon, msg)
    Swal.fire({
      toast: true,
      position: 'top',
      showConfirmButton: false,
      icon: typeIcon,
      timer: 5000,
      title: msg,
    });
  }

  saveTournamentDetails() {

    const data = this.eventFormGroup.getRawValue();
    data.eventDetailsArr[0]?.roundsArray?.forEach((item: any, index: any) => {
      let eventDate: any;
      eventDate = this.datePipe.transform(item.eventDate, "yyyy-MM-dd HH:mm:ss");
      if (index == 0) {
        data.eventDetailsArr[0].startDate = eventDate;
      }
      if (data.eventDetailsArr[0]?.roundsArray?.length == (index + 1)) {
        data.eventDetailsArr[0].endDate = eventDate;
      }
      item['eventDate'] = this.datePipe.transform(item.eventDate, "yyyy-MM-dd HH:mm:ss");
    });
    const url = "/tournament/saveEventDetails";

    this.service.postAPIMethod(url, data).subscribe((response: any) => {
      if (response.error != 'X' && response.response.result.err != "X") {
        if (this.data.isTournamentAdd) {
          this.sweetAlertMsg('success', response.response.result.msg);

          this.tourID = response.response.result.tour_id;
          this.getPlayerList();
        }
      }
      else {
        this.sweetAlertMsg('error', response.response.msg ? response.response.msg : response.response.result.msg);
      }

    });

  }





  // --------------------Add Tournament flow--------------------------

  // eventTabDisplay() {
  //   this.service.getAPIMethod('/courseList').subscribe((courseResponse: any) => {
  //     if (courseResponse.error != 'X') {
  //       const tournamentDetails = {
  //         tourID: this.eventFormGroup.controls.tourID.value
  //       }
  //       const data = {
  //         title: 'Event Details',
  //         sectionName: 'tournament',
  //         details: '',
  //         eventType: ['Match Play', 'Stroke Play'],
  //         roundsList: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
  //         courseList: courseResponse.response.result,
  //         isTournamentAdd: true
  //       }
  //       this.data = data;
  //       this.eventFormGroupInit(tournamentDetails);
  //       //  this.selectedTabIndex = 0;
  //     } else {

  //     }
  //   });
  // }






  // groupTabDisplay() {
  //   const groupList = this.service.getAPIMethod('/dataApi/getGroupList');
  //   const approvedPlayerList = this.service.getAPIMethod('/tournament/getApprovedPlayerList?tourId='+48);
  //   forkJoin([groupList, approvedPlayerList]).subscribe((response: any) => {
  //     if (response[0].error != 'X' && response[1].error != 'X') {
  //       const data = {
  //         title: 'Group Details',
  //         sectionName: 'group',
  //         approvedPlayerList: response[1].result,
  //         groupList: response[0].result,
  //         teeList: ['Tee1', 'Tee2', 'Tee3', 'Tee4', 'Tee5'],
  //         isTournamentAdd: true
  //       }
  //       this.data = data;
  //       this.selectedTabIndex = 1;
  //       this.groupFormGroupInit('');
  //     } else {

  //     }

  //   });
  // }




  // groupTabDisplay() {

  //   const groupList = this.service.getAPIMethod('/dataApi/getGroupList');
  //   const approvedPlayerList = this.service.getAPIMethod('/tournament/getApprovedPlayerList?tourId=' + 48);
  //   forkJoin([groupList, approvedPlayerList]).subscribe((response: any) => {
  //     if (response[0].error != 'X' && response[1].error != 'X') {

  //       const data = {
  //         title: 'Group Details',
  //         sectionName: 'group',
  //         approvedPlayerList: response[1].response.result,
  //         groupList: response[0].result,
  //         teeList: ['Tee1', 'Tee2', 'Tee3', 'Tee4', 'Tee5', 'Tee6', 'Tee7', 'Tee8', 'Tee9', 'Tee10', 'Tee11', 'Tee12', 'Tee13', 'Tee14', 'Tee15', 'Tee16', 'Tee17', 'Tee18',],
  //         isTournamentAdd: true
  //       }
  //       this.data = data;
  //       //this.selectedTabIndex = 1;
  //       this.groupFormGroupInit('');
  //     } else {

  //     }

  //   });
  // }


  // couponTabDisplay() {
  //   this.service.getCourseApi().subscribe((courseResponse: any) => {
  //     if (courseResponse.error != 'X') {
  //       const data = {
  //         title: 'Coupon Details',
  //         details: '',
  //         sectionName: 'coupon',
  //         isTournamentAdd: true
  //       }
  //       this.data = data;
  //       this.couponFormGroupInit('');
  //       // this.selectedTabIndex = 0;
  //     } else {

  //     }
  //   });
  // }



  getPlayerList() {

    this.service.getAPIMethod('/players').subscribe((res: any) => {
      console.log(res.response.result);
      if (res.response.error == 'X') {

      }
      else {
        this.playerList = res.response.result;
        this.data.sectionName = 'sendInvite';
      //  this.data.sectionName = 'invite'

      }

    })
  }



  getInvitedPlayerList(event: any, value: any) {
    debugger;
    if (event.checked) {
      this.invitedplayersList.push(value);
    }
    else {
      const index = this.invitedplayersList.indexOf(value);
      this.invitedplayersList.splice(index, 1);
    }

  }


  sendInviteLink() {
    const data = { tournamentId: this.tourID, selectedPlayerList: this.invitedplayersList }
    this.service.postAPIMethod('/tournamentInvitation', data).subscribe((APIResponse) => {
      if (APIResponse.error == '') {
        this.sweetAlertMsg("success", APIResponse.response.result.msg);
        this.dialogRef.close(true);
      } else {
        this.sweetAlertMsg("error", APIResponse.response.msg);
      }

    });
  }

  getApprovedPlayerList() {
    const data = { tournamentId: this.tourID }
    this.service.postAPIMethod('/tournament/getApprovedPlayerList', data).subscribe((APIResponse) => {

      if (APIResponse.error != 'X') {
        this.approvedPlayerList = APIResponse.result;
        this.sweetAlertMsg("success", APIResponse.response.result.msg);
        this.closeDialogClick();
      } else {

        this.sweetAlertMsg("error", APIResponse.response.msg);
      }


    });

  }



  // code for approve players



  getInvitedPlayerStatus(event: any, value: any) {

    if (event.checked) {
      this.acceptRejectPlayerList.push(value);
    }
    else {
      const index = this.acceptRejectPlayerList.indexOf(value);
      this.acceptRejectPlayerList.splice(index, 1);
    }


  }




  getAcceptRejectPlayerList(value: any) {


    this.service.getAPIMethod('/tournament/getAcceptedDenyPlayerList?tourId=' + this.data.details.tourID + '&value=' + value).subscribe((res: any) => {

      if (res.err == 'X') {

      }
      else {
        this.acceptRejectPlayerList = [];
        this.data.playerList = res.response.result;


      }

    })
  }

  saveApprovedPlayerList() {
    const data = { tournamentId: this.data.details.tourID, selectedPlayerList: this.acceptRejectPlayerList }
    console.log("approved list", data);
    this.service.postAPIMethod('/tournament/approvedListBytourOrganizer', data).subscribe((APIResponse) => {


      if (APIResponse.error != 'X') {
        this.sweetAlertMsg("success", APIResponse.response.result.msg);
        this.closeDialogClick();
      } else {
        this.sweetAlertMsg("error", APIResponse.response.msg);
      }

    });
  }





  getInvitedPlayersStatus(event: any, value: any) {

    if (event.checked) {
      this.acceptRejectPlayerList.push(value);
    }
    else {
      const index = this.acceptRejectPlayerList.indexOf(value);
      this.acceptRejectPlayerList.splice(index, 1);
    }


  }

  // InvitedPlayerList() {
  //   this.service.getAPIMethod('/tournament/getInvitedPlayerList?tourId=' + this.data.details.tourID).subscribe((res: any) => {
  //     if (res.err == '') {
  //       this.data.invitedPlayerList = res.response.result;
  //     }
  //     else {
  //       this.sweetAlertMsg("error", res.response.msg);
  //     }
  //   });
  // }



}
