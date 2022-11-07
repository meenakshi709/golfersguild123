import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { MatTableDataSource } from '@angular/material/table';
import { NgxUiLoaderService } from 'ngx-ui-loader';
import { forkJoin } from 'rxjs';
import { CommonServiceService } from 'src/app/Service/common.service';
import { CommonListMenu } from 'src/app/Shared/common-Listing/common-list-menu';
import { CommonListMenuItem } from 'src/app/Shared/common-Listing/common-list-menu-item';
import { CommonListProperties } from 'src/app/Shared/common-Listing/common-properties';
import Swal from 'sweetalert2';
import { AddEditLeaderboardComponent } from '../add-edit-leaderboard/add-edit-leaderboard.component';
import { AddEditOldScoreComponent } from '../add-edit-old-score/add-edit-old-score.component';

@Component({
  selector: 'app-leaderboard-listing',
  templateUrl: './leaderboard-listing.component.html',
  styleUrls: ['./leaderboard-listing.component.css']
})
export class LeaderboardListingComponent implements OnInit {

  scoreList: CommonListProperties = new CommonListProperties();
  isLoadingDone: boolean = false;
  constructor(private service: CommonServiceService, public dialog: MatDialog, public loader: NgxUiLoaderService) { }

  ngOnInit(): void {
    this.getScoreList();
  }
  getScoreList() {
    this.loader.start();
    this.service.getAPIMethod('/score').subscribe((Apiresponse) => {
      this.loader.stop();
      const data: any = Apiresponse;
      console.log(data.response);
      if (data.error == '') {
        this.isLoadingDone = true;

        //  this.roleList.url = '/getRolesList';
        //  const getmonthNum = (new Date(data.tournament_date).getMonth() + 1).toString() + '-' + new Date(data.tournament_date).getFullYear().toString();

        this.scoreList.miDataSource = new MatTableDataSource(data.response.result);
        this.scoreList.columnLabels = ['Tournament Date','Tournament Name', 'Player Name', 'Round',  'Group', 'Gross', 'HDCP', 'Net Score', 'Birdie', 'AGS', 'Action'];
        this.scoreList.displayedColumns = ['createdDate','tournamentName', 'playerName', 'round_name', 'groupName', 'gross', 'hdcp', 'net', 'birdie', 'scoreDifferential', 'Action'];

        this.scoreList.miListMenu = new CommonListMenu();
        this.scoreList.miListMenu.menuItems =
          [
            new CommonListMenuItem('Edit', 1, true, false, null, 'edit_icon'),
            new CommonListMenuItem('Delete', 2, true, true, null, 'delete_icon'),
          ];

      }
    });
  }

  applyFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.scoreList.miDataSource.filter = filterValue.trim().toLowerCase();


  }



  saveScoreDetails(clickedRecordDetails: any) {

    const getTournamentListing = this.service.getAPIMethod("/getTournamentListing");
    const courseListing = this.service.getAPIMethod("/courseList");
    forkJoin([getTournamentListing, courseListing]).subscribe((APIResponse) => {
      this.loader.stop();
      if (APIResponse[0]['error'] != 'X' && APIResponse[1]['error'] != 'X') {
        const dialogRef = this.dialog.open(AddEditLeaderboardComponent, {

          data: {
            title: 'Score Details',
            sectionName: 'Score',
            selectedRecordDetails: clickedRecordDetails,
            tournamentList: APIResponse[0].response.result,
            courseListing: APIResponse[1].response.result,

          },
          disableClose: true,
          width: '80%',
          height: '600px'
        });
        dialogRef.afterClosed().subscribe(result => {
          if (result) {
            this.getScoreList();
          }
        });
      }
    });
  }




  onScoreActionClick(clickedRecord: any) {

    if (clickedRecord.name == 'Edit') {
      if (clickedRecord.data.tournamentName) {
        this.saveScoreDetails(clickedRecord.data)
      }
      else {
        this.sweetAlertMsg('error', 'Tournament details does not exist')
      }

    }
    else if (clickedRecord.name == 'Delete') {
      this.deleteScore(clickedRecord.data)
    }

  }


  // for history scores

  savePastScoreDetails(clickedRecordDetails: any) {

    const getPlayerListing = this.service.getAPIMethod("/players");
    const courseListing = this.service.getAPIMethod("/courseList");
    forkJoin([getPlayerListing, courseListing]).subscribe((APIResponse) => {
      this.loader.stop();
      if (APIResponse[0]['error'] != 'X' && APIResponse[1]['error'] != 'X') {
        const dialogRef = this.dialog.open(AddEditOldScoreComponent, {

          data: {
            title: 'Score Details',
            sectionName: 'Score',
            selectedRecordDetails: clickedRecordDetails,
            playerListing: APIResponse[0].response.result,
            courseListing: APIResponse[1].response.result,
          },
          width: '80%',
          height: '600px'
        });
        dialogRef.afterClosed().subscribe(result => {
          if (result) {
            this.getScoreList();
          }
        });
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




  deleteScore(clickedrecord: any) {

    Swal.fire({
      title: 'Delete Score',
      text: 'Are you sure you want to delete Score ?',
      icon: "warning",
      showCancelButton: true,
      confirmButtonText: 'Yes, Delete',
      confirmButtonColor: '#fe0000',
      showLoaderOnConfirm: true,
    }).then((result) => {
      if (result.isConfirmed) {
        this.loader.start();
        this.service.getAPIMethod('/score/deleteScore?scoreId=' + clickedrecord.tour_score_id).subscribe((success) => {
          this.loader.stop();
          if (success.error === 'X') {
            this.sweetAlertMsg('error', success.response.result.msg);

          } else {

            this.sweetAlertMsg('success', success.response.result.msg);

            this.isLoadingDone = false;
            this.getScoreList();

          }
        })
      }
    });
  }




  addEditEventDetails(clickedRecordDetails: any) {

    this.service.getCourseApi().subscribe((APIresponse) => {
      const apiResponse: any = APIresponse;

      if (apiResponse['error'] != 'X') {
        const dialogRef = this.dialog.open(AddEditLeaderboardComponent, {
          data: {
            title: 'Tournament Details',
            details: clickedRecordDetails,
            sectionName: 'tournament',
            eventType: ['Match Play', 'Stroke Play'],
            roundsList: ['1', '2', '3', '4', '5'],
            courseList: apiResponse.response.result,
            isTournamentAdd: true
          },
          width: '950px',
          height: '400px'
        });
        dialogRef.afterClosed().subscribe(result => {
          if (result) {
            this.getScoreList();
          }
        });
      }
    });
  }


}
