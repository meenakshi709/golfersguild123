import { HttpClient } from '@angular/common/http';
import { analyzeAndValidateNgModules } from '@angular/compiler';
import { Component, Directive, EventEmitter, Input, Output, QueryList, ViewChildren } from '@angular/core';
import { CommonServiceService } from '../../Service/common.service';

@Component({
  selector: 'app-leaderboard-table',
  templateUrl: './leaderboard-table.component.html',
  styleUrls: ['./leaderboard-table.component.css']
})
export class LeaderboardTableComponent {


  respnseData: any = [];
  scoreSmallData: any = [];
  respnseSmallData: any = [];
  title = 'datatables';
  playerData: any
  combinedplayerData: any;
  roundsArr: any = [];
  dataOption: DataTables.Settings = {};


  

  constructor(private service: CommonServiceService) {
    //get request from web api

  }
  ngOnInit(): void {
    this.playerData = []
    this.combinedplayerData = []
    this.dataOption = {
      pagingType: 'full_numbers',
      pageLength: 5,
      processing: true,
      // dom: 'Bfrtip',
      // buttons: [
      //     'copy', 'csv', 'excel', 'print'
      // ],
      "columnDefs": [{
        'targets': [1,2], /* column index */
        'orderable': false /* true or false */



      }]
    };
    this.summryTable();
  }



  summryTable() {
    this.service.getAPIMethod('/tournament/tourDetails').subscribe((APIresponse: any) => {
      const tourId = APIresponse.response?.result?.tour_id;
      this.service.getAPIMethod('/tournament/tournamentScoreById?tournamentId=' + tourId + '&playerId=0').subscribe((APTres: any) => {
        this.combinedplayerData = [];
        if (APTres.response && APTres.response.result) {

          //const getResponse = APTres.response.result;
          this.respnseData = APTres.response.result;
         // const newArr: any = [];
          this.respnseData.filter((item: any, index: any) => {
            const recordDetails = item[0];
            let finalData: any = {

              'playerName': recordDetails?.playerName,
              'holes': recordDetails?.Totalholes,
              'TotalGross': recordDetails?.TotalGross,
              'TotalNet': recordDetails?.TotalNet,
              'TotalBirdie': recordDetails?.TotalBirdie,
              'round': recordDetails?.round,
            }    
            if (recordDetails.round.length > this.roundsArr.length) {
              recordDetails.round.forEach((round: any) => {
                this.roundsArr.push(round.round);
              });
            }
            this.combinedplayerData.push(finalData);
            // console.log('final',finalData);
          });
        }
      }, error => console.error(error));

    }, error => console.error(error));


  }
}