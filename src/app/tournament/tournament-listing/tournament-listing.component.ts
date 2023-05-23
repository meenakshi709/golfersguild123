import { Component, OnInit } from '@angular/core';
import { CommonListProperties } from '../../Shared/common-Listing/common-properties';
import { CommonListMenu } from '../../Shared/common-Listing/common-list-menu';
import { CommonListMenuItem } from '../../Shared/common-Listing/common-list-menu-item';
import { CommonServiceService } from 'src/app/Service/common.service';
import { MatTableDataSource } from '@angular/material/table';
import { MatDialog } from '@angular/material/dialog';
import { NgxUiLoaderService } from 'ngx-ui-loader';
import Swal from 'sweetalert2';
import { AddEditTournamentComponent } from '../add-edit-tournament/add-edit-tournament.component';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { forkJoin } from 'rxjs';
import { response } from 'express';
import { ExcelService } from 'src/app/Service/excel.service';



@Component({
  selector: 'app-tournament-listing',
  templateUrl: './tournament-listing.component.html',
  styleUrls: ['./tournament-listing.component.css']
})
export class TournamentListingComponent implements OnInit {

  courseList: CommonListProperties = new CommonListProperties();
  downloadList: any = [];
  isLoadingDone: boolean = false;
  constructor(private service: CommonServiceService, public dialog: MatDialog, public loader: NgxUiLoaderService, public exportService: ExcelService) { }

  ngOnInit(): void {
    this.getTournamentList();
  }

  getTournamentList() {
    this.loader.start();
    this.service.getAPIMethod("/getTournamentListing").subscribe((response) => {
      this.loader.stop();
      const data: any = response;

      if (data.error == '') {
        this.isLoadingDone = true;
        //  this.roleList.url = '/getRolesList';

        //   var myDate = new Date(data.response.result.startDate);
        //  let startDate= myDate.getDate()+ '/' +(myDate.getMonth() + 1)  + '/' + myDate.getFullYear();

        this.courseList.miDataSource = new MatTableDataSource(data.response.result);
        // this.downloadList=data.response.result;

        this.courseList.columnLabels = ['Name', 'Event Type', 'Num of Rounds', ' Tournament Date', 'Holes', 'Action'];
        this.courseList.displayedColumns = ['tournamentName', 'formatName', 'numRounds', 'tournamentDate', 'holes', 'Action'];
        data.response.result.forEach((item: any) => {
          const data: any = {};
          this.courseList.columnLabels.forEach((name: any, index: any) => {
            if (name != 'Action') {
              data[name] = item[this.courseList.displayedColumns[index]]
            }
          })
        
          this.downloadList.push(data);
        })
        this.courseList.miListMenu = new CommonListMenu();
        this.courseList.miListMenu.menuItems =
          [

            new CommonListMenuItem('Edit', 1, true, false, null, 'edit_icon'),
            new CommonListMenuItem('InvitedList', 2, true, false, null, 'insert_invitation'),
            new CommonListMenuItem('Group', 3, true, false, null, 'group'),
            new CommonListMenuItem('Approval', 4, true, false, null, 'approval'),
            new CommonListMenuItem('Coupon', 5, true, false, null, 'card_giftcard'),
            new CommonListMenuItem('Delete', 6, true, true, null, 'delete_icon'),
          ];
      }
    });
  }

  applyFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.courseList.miDataSource.filter = filterValue.trim().toLowerCase();


  }

  onCourseActionClick(clickedRecord: any) {

    if (clickedRecord.name == 'Edit') {

      this.addEditEventDetails(clickedRecord.data, '')
    }
    else if (clickedRecord.name == 'InvitedList') {
      this.addEditInvitedList(clickedRecord.data)
    }
    else if (clickedRecord.name == 'Group') {
      this.addEditGroupDetails(clickedRecord.data)
    }
    else if (clickedRecord.name == 'Approval') {
      this.addEditApprovedList(clickedRecord.data)
    }
    else if (clickedRecord.name == 'Coupon') {
      this.addEditCouponDetails(clickedRecord.data)
    }
    else if (clickedRecord.name == 'Delete') {
      this.deleteTournament(clickedRecord.data)
    }
  }
  addEditEventDetails(clickedRecordDetails: any, roundDetails: any) {
    this.loader.start();

    // const apiResponse: any = APIresponse;
    const arrayToSend = [];
    const courseList = this.service.getAPIMethod('/courseList');
    const formatList = this.service.getAPIMethod('/tournament/getTournamentFormat');
    arrayToSend.push(courseList);
    arrayToSend.push(formatList);
    if (clickedRecordDetails) {
      const roundDetailList = this.service.getAPIMethod('/tournament/getTournamentRoundDetails?tourId=' + clickedRecordDetails.tourID);
      arrayToSend.push(roundDetailList);
    }
    forkJoin(arrayToSend).subscribe((apiResponse: any) => {
      this.loader.stop();
      if (apiResponse[0]?.['error'] != 'X' && apiResponse[1]?.['error'] != 'X' && apiResponse[2]?.['error'] != 'X') {
        const dialogRef = this.dialog.open(AddEditTournamentComponent, {
          data: {
            title: 'Tournament Details',
            details: clickedRecordDetails,
            selectedRound: apiResponse[2]?.response?.result?.length > 0 ? apiResponse[2].response.result : [],
            sectionName: 'tournament',
            eventType: apiResponse[1]?.response?.result?.length > 0 ? apiResponse[1].response.result : [],
            roundsList: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
            courseList: apiResponse[0].response.result,
            isTournamentAdd: true
          },
          width: '840px',
          height: '400px'
        });
        dialogRef.afterClosed().subscribe(result => {
          if (result) {
            this.getTournamentList();
          }
        });
      }
      else {
        this.sweetAlertMsg("error", "No player register for the tournament");
      }

    });
  }

  addEditGroupDetails(clickedRecordDetails: any) {
    this.loader.start();


    const playerList = this.service.getAPIMethod('/tournament/getApprovedPlayerList?tourId=' + clickedRecordDetails.tourID);
    const roundList = this.service.getAPIMethod('/tournament/getTournamentRoundDetails?tourId=' + clickedRecordDetails.tourID);


    forkJoin([playerList, roundList]).subscribe(response => {
      this.loader.stop();
      if (response[0]['error'] != 'X' && response[1]['error'] != 'X') {
        if (response[1].response.result.length > 0) {
          const dialogRef = this.dialog.open(AddEditTournamentComponent, {
            data: {
              title: 'Create Group ',
              details: clickedRecordDetails,
              sectionName: 'group',
              playerList: response[0].response.result,
              teeList: '',
              roundList: response[1].response.result,
              previousRoundDetails: response[1].response.roundDetails,
              groupList: []
            },
            width: '1000px',
            height: '400px'
          });
          dialogRef.afterClosed().subscribe(result => {
            if (result) {
              this.getTournamentList();
            }
          });
        } else {
          this.sweetAlertMsg("error", "No player register for the tournament")
        }
      }
    });



  }


  addEditCouponDetails(clickedRecordDetails: any) {
    this.loader.start();
    const roundList = this.service.getAPIMethod('/tournament/getTournamentRoundDetails?tourId=' + clickedRecordDetails.tourID);
    const playerList = this.service.getAPIMethod('/tournament/getTournamentCouponList?tourId=' + clickedRecordDetails.tourID + '&roundId=' + '');

    forkJoin([roundList, playerList]).subscribe(res => {

      this.loader.stop();
      if (res[0].error == "" && res[1].error == "") {
        const dialogRef = this.dialog.open(AddEditTournamentComponent, {
          data: {
            title: 'Coupon Details',
            details: clickedRecordDetails,
            sectionName: 'coupon',
            roundList: res[0].response.result,
            couponList: res[1].response.result
          },
          width: '740px',
          height: '300px'
        });
        dialogRef.afterClosed().subscribe(result => {

          if (result) {
            this.getTournamentList();
          }
        });
      } else {
        this.sweetAlertMsg("error", 'Error occur while fetching details');
      }
    })
  }




  deleteTournament(clickedrecord: any) {

    Swal.fire({
      title: 'Delete tournament',
      text: `Are you sure you want to delete '${clickedrecord.tournamentName}' ?`,
      icon: "warning",
      showCancelButton: true,
      confirmButtonText: 'Yes, Delete',
      confirmButtonColor: '#fe0000',
      showLoaderOnConfirm: true,
    }).then((result) => {
      if (result.isConfirmed) {
        this.loader.start();
        this.service.getAPIMethod('/tournament/deleteTournament?tourId=' + clickedrecord.tourID).subscribe((success) => {
          this.loader.stop();
          if (success.error === 'X') {
            this.sweetAlertMsg('error', success.response.result.msg);

          } else {

            this.sweetAlertMsg('success', success.response.result.msg);

            this.isLoadingDone = false;
            this.getTournamentList();

          }
        })
      }
    });
  }


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



  // approved list status

  addEditApprovedList(clickedRecordDetails: any) {


    this.loader.start();

    this.service.getAPIMethod('/tournament/getAcceptedDenyPlayerList?tourId=' + clickedRecordDetails.tourID + '&value=' + 1).subscribe((response: any) => {


      this.loader.stop();
      if (response['error'] != 'X') {

        const dialogRef = this.dialog.open(AddEditTournamentComponent, {
          data: {
            title: 'Players List for Approval',
            details: clickedRecordDetails,
            sectionName: 'approval',
            playerList: response.response.result,

          },
          width: '950px',
          height: '400px'
        });
        dialogRef.afterClosed().subscribe(result => {

          if (result) {
            this.getTournamentList();
          }
        });
      }
    });

  }






  // approved list status

  addEditInvitedList(clickedRecordDetails: any) {


    this.loader.start();

    const invitedPlayerList = this.service.getAPIMethod('/tournament/getInvitedPlayerList?tourID=' + clickedRecordDetails.tourID);
    const sendInvitePlayerList = this.service.getAPIMethod(' /tournament/getSendInvitePlayerList?tourID=' + clickedRecordDetails.tourID);
    forkJoin([invitedPlayerList, sendInvitePlayerList]).subscribe((response: any) => {
      this.loader.stop();
      debugger;
      if (response[0]['error'] == '' && response[1]['error'] == '') {
        const dialogRef = this.dialog.open(AddEditTournamentComponent, {
          data: {
            title: 'Invited Player List',
            details: clickedRecordDetails,
            sectionName: 'invite',
            invitedPlayerList: response[0].response.result,
            sendInvitePlayerList: response[1].response.result,

          },
          width: '950px',
          height: '400px'
        });
        dialogRef.afterClosed().subscribe(result => {

          if (result) {
            this.getTournamentList();
          }
        });
      } else {
        this.sweetAlertMsg('error', 'Error occur please try again');
      }
    });

  }

  downloadExcel() {
    this.exportService.exportAsExcelFile(
      this.downloadList, 'Tournament List'
    );
  }
}



