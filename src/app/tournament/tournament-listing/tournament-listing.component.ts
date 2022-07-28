import { Component, OnInit } from '@angular/core';
import { CommonListProperties } from '../../Shared/common-Listing/common-properties';
import { CommonListMenu } from '../../Shared/common-Listing/common-list-menu';
import { CommonListMenuItem } from '../../Shared/common-Listing/common-list-menu-item';
import { CommonServiceService } from 'src/app/Service/common-service.service';
import { MatTableDataSource } from '@angular/material/table';
import { MatDialog } from '@angular/material/dialog';
import { NgxUiLoaderService } from 'ngx-ui-loader';
import Swal from 'sweetalert2';
import { AddEditTournamentComponent } from '../add-edit-tournament/add-edit-tournament.component';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { forkJoin } from 'rxjs';
import { response } from 'express';


@Component({
  selector: 'app-tournament-listing',
  templateUrl: './tournament-listing.component.html',
  styleUrls: ['./tournament-listing.component.css']
})
export class TournamentListingComponent implements OnInit {

  courseList: CommonListProperties = new CommonListProperties();
  isLoadingDone: boolean = false;
  constructor(private service: CommonServiceService, public dialog: MatDialog, public loader: NgxUiLoaderService) { }

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
        debugger
      //   var myDate = new Date(data.response.result.startDate);
      //  let startDate= myDate.getDate()+ '/' +(myDate.getMonth() + 1)  + '/' + myDate.getFullYear();

        this.courseList.miDataSource = new MatTableDataSource(data.response.result);
        this.courseList.columnLabels = ['Tournament Name', 'Event Type', 'Rounds', 'Date', 'Action'];
        this.courseList.displayedColumns = ['tournamentName', 'eventType', 'numRounds', 'startDate', 'Action'];

        this.courseList.miListMenu = new CommonListMenu();
        this.courseList.miListMenu.menuItems =
          [

            new CommonListMenuItem('Edit', 1, true, false, null,'edit'),
            new CommonListMenuItem('Group', 1, true, false, null, 'group'),
            new CommonListMenuItem('Approval', 1, true, false, null, 'approval'),
            new CommonListMenuItem('Coupon', 1, true, false, null, 'card_giftcard'),
            new CommonListMenuItem('Delete', 2, true, true, null, 'delete'),
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

  //   addEditEventDetails(clickedRecordDetails: any) {

  //     this.service.getCourseApi().subscribe((APIresponse) => {

  //        ;

  //       // this.service.getAPIMethod(`/tournament/getTournamentListById?tourId=${clickedRecordDetails.tourID}`).subscribe((APIresponse: any) => {

  //       const apiResponse: any = APIresponse;
  // //console.log("tour data",apiResponse.response.result);

  //       if (APIresponse.error != 'X' && APIresponse.response.result.error != "X") {
  //         const dialogRef = this.dialog.open(AddEditTournamentComponent, {
  //           data: {
  //             title: 'Tournament Details',
  //             details: clickedRecordDetails,
  //             sectionName: 'tournament',
  //             eventType: ['Match Play', 'Stroke Play'],
  //             roundsList: ['1', '2', '3', '4', '5','6','7'],
  //             tourList: apiResponse.response.result,
  //             isTournamentAdd: true
  //           },
  //           width: '950px',
  //           height: '400px'
  //         });
  //         dialogRef.afterClosed().subscribe(result => {
  //           if (result) {
  //             this.getTournamentList();
  //           }
  //         });
  //       }
  //     });
  //   }


  addEditEventDetails(clickedRecordDetails: any, roundDetails: any) {
    this.loader.start();
    
    // const apiResponse: any = APIresponse;
    const arrayToSend = [];
    const courseList = this.service.getAPIMethod('/courseList');
    arrayToSend.push(courseList);
    if (clickedRecordDetails) {
      const roundDetailList = this.service.getAPIMethod('/tournament/getTournamentRoundDetails?tourId=' + clickedRecordDetails.tourID);
      arrayToSend.push(roundDetailList);
    }

    forkJoin(arrayToSend).subscribe((apiResponse: any) => {
      this.loader.stop();
      

      if (apiResponse[0]?.['error'] != 'X' && apiResponse[1]?.['error'] != 'X') {



        const dialogRef = this.dialog.open(AddEditTournamentComponent, {
          data: {
            title: 'Tournament Details',
            details: clickedRecordDetails,
            selectedRound: apiResponse[1]?.response?.result?.length > 0 ? apiResponse[1].response.result : [],
            sectionName: 'tournament',
            eventType: ['Match Play', 'Stroke Play'],
            roundsList: ['1', '2', '3', '4', '5', '6', '7'],
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

    const teeList = this.service.getAPIMethod('/tournament/getCourseTeeList');
    const playerList = this.service.getAPIMethod('/tournament/getApprovedPlayerList?tourId=' + clickedRecordDetails.tourID);
    const roundList = this.service.getAPIMethod('/tournament/getTournamentRoundDetails?tourId=' + clickedRecordDetails.tourID);

    forkJoin([teeList, playerList, roundList]).subscribe(response => {
      this.loader.stop();
      if (response[0]['error'] != 'X' && response[1]['error'] != 'X' || response[2]['error'] != 'X') {
        if (response[1].response.result.length > 0) {
          const dialogRef = this.dialog.open(AddEditTournamentComponent, {
            data: {
              title: 'Group Details',
              details: clickedRecordDetails,
              sectionName: 'group',
              playerList: response[1].response.result,
              teeList: response[0].response.result,
              roundList: response[2].response.result,
              previousRoundDetails: response[2].response.roundDetails,
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
    this.service.getAPIMethod('/tournament/getTournamentRoundDetails?tourId=' + clickedRecordDetails.tourID).subscribe((APIresponse: any) => {
      console.log(APIresponse);
      if (APIresponse.error != "X") {
        const dialogRef = this.dialog.open(AddEditTournamentComponent, {
          data: {
            title: 'Coupon Details',
            details: clickedRecordDetails,
            sectionName: 'coupon',
            roundList: APIresponse.response.result
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
        this.sweetAlertMsg("error", APIresponse.error);
      }
    })
  }




  deleteTournament(clickedrecord: any) {

    Swal.fire({
      title: 'Delete Tournament',
      text: 'Are you sure you want to delete Tournament ?',
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



}



function roundDetails(data: any, roundDetails: any) {
  throw new Error('Function not implemented.');
}

