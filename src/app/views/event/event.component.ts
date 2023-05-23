import { Component, OnInit, Directive, EventEmitter, Input, Output, QueryList, ViewChildren } from '@angular/core';

import { ViewChild, AfterViewInit } from '@angular/core';
import { ModalDismissReasons, NgbModal, NgbModalOptions } from '@ng-bootstrap/ng-bootstrap';
import { FormControl, FormGroup } from '@angular/forms';
import { NgxUiLoaderService } from 'ngx-ui-loader';
import { CommonServiceService } from 'src/app/Service/common.service';

@Component({
  selector: 'app-event',
  templateUrl: './event.component.html',
  styleUrls: ['./event.component.css']
})
export class EventComponent implements OnInit {

  yearData: any = [];
  //selectedYear: any;
  selectedMonth: any;
  selectedTournament: any = 0;
  respnseData: any = [];
  monthData: any = [];
  tourId: any;
  tourWebDetails: any = [];
  RoundData: any = [];
  activeId: any = 0;
  stableFordList: any = [];
  tournamentDetails: any;
  isSfpShown: boolean = false;
  combinedplayerData: any;
  roundsArr: any = [];
  playerData: any;
  title = 'golfersguild';
  modalOptions: NgbModalOptions;
  dataOption: DataTables.Settings = {};
  closeResult: string = '';
  @ViewChild('content') content: any;
  filterGroup = new FormGroup({
    year: new FormControl('', []),
    month: new FormControl('', []),
    tour: new FormControl('', []),
  })


  constructor(private service: CommonServiceService, private modalService: NgbModal, public loader: NgxUiLoaderService) {
    //get request from web api
    this.modalOptions = {
      backdrop: 'static',
      backdropClass: 'customBackdrop'
    }
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
        'targets': [1, 2], /* column index */
        'orderable': false /* true or false */



      }]
    };
    this.summryTable();
    // this.onMonthChange(0);
    this.getYearAccordingRoute();


    this.dtOptions2 = {
      pagingType: 'numbers',
      pageLength: 10,
      "info": false,
      processing: false,
      "paging": false,
      "order": [[3, "asc"]],
      "columnDefs": [{
        'targets': [2, 3, 5, 8], /* column index */
        'orderable': false, /* true or false */

        orderData: [0]

      }]
    };

    // this.onCallApi2();

  }

  openModal() {
    this.modalService.open(this.content, { centered: true });
  }



  scoreData: any = [];

  courseData: any = [];
  courseRespnseData: any = [];
  selectroundIndex: any = 0;
  filteredGross: any = []
  filteredNet: any = []
  filteredBirdie: any = [];


  data: any;
  roundData: any = [];


  dtOptions2: DataTables.Settings = {};


  item: any;



  dnotfound: boolean = false;

  getRoundDetailByID(tourID: string, roundID: string): void {

    this.service.getAPIMethod('/tournament/tournamentDetailedScoreById?tour_id=' + tourID + '&player_id=0&round_Id=' + roundID).subscribe((APTres: any) => {



      if (APTres.response && APTres.response.result.length > 0) {
        console.log("tour", APTres.response.result);
        const getResponse = APTres.response.result;
        this.respnseData = APTres.response.result;
        const newArr: any = [];
        var uni: any = [];

        this.respnseData.filter((item: any, index: any) => {
          console.log("code", item.round_Id);
          // const tdate=new Date(item.tournament_date);

          //  const getmonthNum = (new Date(item.tournament_date).getMonth()+1).toString() + '-' + new Date(item.tournament_date).getFullYear().toString();
          //  const currmonth = (new Date().getMonth() + 1).toString() + '-' + new Date().getFullYear().toString();


          // if(item.round_Id==78)
          // {
          this.dnotfound = false;
          const round = item.round_Id;
          const isActive = false;
          let mainData: any = {

            'cid': item.cid,
            "course": item.cname,
            'par': [],
            'hdcap': [],
            'board': []
          }



          const par: any = [];
          let finalData: any = {

            'playerName': item.playerName,
            'gross': item.gross,
            'hdcp': item.hdcp,
            'net': item.net,
            'birdie': item.birdie,
            'score': []
          }

          const hdcpp: any = [];
          const score: any = [];
          const stf: any = [];
          // const i: any = 18;
          const finalScoreArr: any = [];
          let parValue: any = [];
          let scoreArr: any = [];
          let hdcpArr: any = [];
          let stfArr: any = [];
          let count: number = 1;
          let sum = "";
          for (let indexNumber = 1; indexNumber < 19; indexNumber++) {

            const parkeyName = 'par' + indexNumber;
            const scoreName = 'score' + indexNumber;
            const hdcpName = 'hdcp' + indexNumber;
            let value = item[parkeyName];
            let scoreValue: any = item[scoreName];
            let hdcpValue: any = item[hdcpName];
            let diff = (scoreValue - value);
            if (this.tourWebDetails.eventType == 1) {
              for (let i = 0; i < this.stableFordList.length; i++) {

                if (diff == this.stableFordList[i].netScorePoints) {

                  if (hdcpValue <= item.hdcp) {

                    let total = (this.stableFordList[i].points + 1);
                    stfArr.push(total);
                    break;
                  }
                  else {

                    stfArr.push(this.stableFordList[i].points);
                    break;
                  }

                }
                else {
                  if (diff > 2) {
                    stfArr.push(0);
                    break;
                  }
                }
              }
            }
            parValue.push(value);
            scoreArr.push(scoreValue);
            hdcpArr.push(hdcpValue);

            if (indexNumber == 9 || indexNumber == 18) {
              let stfSum = 0;
              if (stfArr.length > 0) {

                for (let i = 0; i < stfArr.length; i++) {
                  stfSum += parseInt(stfArr[i]);
                }
              }
              const data: any = {
                'parValue': parValue,
                'scoreArr': scoreArr,
                'stfArr': stfArr,
                'stfSum': stfSum,
                'parsum': count == 1 ? item.pinn : item.pout,
                'scoresum': count == 1 ? item.outt : item.inn
              }

              const pardata: any = {
                'parValue': parValue,
                'parsum': count == 1 ? item.pout : item.pinn,

              }
              const hdcpData: any = {
                'hcdpValue': hdcpArr

              }

              const stfData: any = {
                'stfValue': stfArr,
                'stfSum': stfSum
              }

              parValue = [];
              scoreArr = [];
              hdcpArr = [];
              stfArr = [];
              count = count + 1;
              finalScoreArr.push(data);

              par.push(pardata)
              hdcpp.push(hdcpData)
              stf.push(stfData);
            }
          }

          finalData.score = finalScoreArr;
          mainData.par = par;
          mainData.hdcap = hdcpp;
          mainData['board'] = finalData;
          mainData.stf = stf;
          if (newArr.length == 0) {
            let data156: any = [];
            data156.push(mainData)
            newArr.push({ round: round, isActive: "false", data: data156 });
            console.log("month1 is0", newArr);
            uni = newArr.filter((v: any, i: any, a: any) => a.findIndex((t: any) => (t.round === v.round)) === i)

            this.scoreData = uni;
          } else {
            console.log("month1 is0", newArr);
            let numberOfRounds = newArr.map((items: any) => items.round);
            newArr.map((elem: any, index: any) => {
              if (numberOfRounds[index] == round) {
                if (elem.round == round) {
                  let data156: any = [];
                  if (Object.getPrototypeOf(elem.data) != Object.prototype) {
                    data156.push(...elem.data);
                    elem.data = data156;

                  } else {

                    data156.push(elem.data);
                    elem.data = data156;

                  }

                  data156.push(mainData);
                  elem.data = data156;
                }

              } else {

                if (!numberOfRounds.includes(round)) {

                  let data156: any = [];
                  data156.push(mainData)
                  newArr.push({ round: round, isActive: "false", data: data156 });
                  console.log('newArray', newArr)
                  uni = newArr.filter((v: any, i: any, a: any) => a.findIndex((t: any) => (t.round === v.round)) === i)
                }
              }
            });

            this.scoreData = uni;
          }

          // }
          // else{
          // this.scoreData=[];

          // }

        });

        console.log('unit', this.scoreData);




      }
      this.dnotfound = true;
    }, error => console.error(error));
  }

  getGross(data: any) {

    // if (data && data.length > 0){
    if (data && data.length > 0) {
      let z = Math.min(...data.map((o: any) => o['board']['gross']));

      return z;
    } else return 0;


    // }
  }

  getGross1(data: any) {
    if (data && data.length > 0) {
      let z = Math.min(...data.map((o: any) => o['board']['gross']));
      let index = data.findIndex((x: any) => x['board']['gross'] == z);

      let name = index >= 0 ? data[index]['board']['playerName'] : '';
      return name;


    }

  }


  getnet1(data: any) {
    if (data && data.length > 0) {
      let z = Math.min(...data.map((o: any) => o['board']['net']));
      let index = data.findIndex((x: any) => x['board']['net'] == z);
      let name = index >= 0 ? data[index]['board']['playerName'] : '';

      return name;

    }
  }

  getnet(data: any) {
    if (data && data.length > 0) {
      let z = Math.min(...data.map((o: any) => o['board']['net']));

      return z;
    } else return 0

  }

  getbird1(data: any) {
    if (data && data.length > 0) {
      console.log(data)
      let z = Math.max(...data.map((o: any) => o['board']['birdie']));
      let index = data.findIndex((x: any) => x['board']['birdie'] == z);
      let name = index >= 0 ? data[index]['board']['playerName'] : '';
      return name;



    }
  }

  getbird(data: any) {
    if (data && data.length > 0) {
      let z = Math.max(...data.map((o: any) => o['board']['birdie']));

      return z;
    } else return 0

  }





  getactiveClass(data: any, index: any) {


    let class11 = "";
    const diff = (Number(data.scoreArr[index]) - Number(data.parValue[index]));

    switch (diff) {
      case -1:
        class11 = "circle";

        break;
      case -2:
        class11 = "dblcircle";

        break;
      case 0:
        class11 = "equal";

        break;
      case 1:
        class11 = "rect1";

        break;
      case 2:
        class11 = "rect2";

        break;
      case 3:
        class11 = "rect3";

        break;
      case 4:
        class11 = "rect3";

        break;
      case 5:
        class11 = "rect3";
        break;
      case 6:
        class11 = "rect3";
        break;



      default:
        class11 = "equal";


    }
    //const class1 = data.parValue[index] > data.value[index] ? "circle" : data.parValue[index] < data.value[index] ? "rect1" : "equal";
    return class11;

  }






  onRoundChange(index: any) {


    this.scoreData.map((element: any, index: any) => {

      element.isActive = false
      if (index == 0) {
        element.isActive = true;
      }

    })


  }


  getYearAccordingRoute(): void {
 
    this.loader.start();
    this.service.getAPIMethod(`/tournament/getTourYearDetails`).subscribe((APIresponse: any) => {
      this.yearData = APIresponse?.response
      if (this.yearData && this.yearData?.result?.length > 0) {
        if (this.filterGroup.controls.year.value) {
          this.filterGroup.controls.year.setValue(this.filterGroup.controls.year.value)
        } else {
          this.filterGroup.controls.year.setValue(this.yearData?.result[0]?.year)
        }
        this.getMonthDetails()

      }
    })
  }


  getMonthDetails(): void {
    this.loader.start();
    this.service.getAPIMethod(`/tournament/getTourMonthDetails?year=${this.filterGroup.controls.year.value}`).subscribe((APIresponse: any) => {
      this.loader.stop();
      this.monthData = APIresponse?.response;
      if (this.monthData && this.monthData?.result.length > 0) {
        if (this.filterGroup.controls.month.value) {
          this.filterGroup.controls.month.setValue(this.filterGroup.controls.month.value)
        } else {
          this.filterGroup.controls.month.setValue(this.monthData?.result[0]?.monthNum)
        }


        this.getMonthWiseTour()
      }
    })
  }

  getMonthWiseTour(): void {
    const controls: any = this.filterGroup.controls;
    this.service.getAPIMethod(`/tournament/getTourDetails?year=${controls.year.value}&month=${controls.month.value}`).subscribe((APTres: any) => {
      debugger
      if (APTres.response && APTres.response.result.length > 0) {

        this.respnseData = APTres.response.result;
        this.tournamentDetails = APTres.response.result;
        if (this.filterGroup.controls.tour.value) {
          this.filterGroup.controls.tour.setValue(this.filterGroup.controls.tour.value)
        } else {
          this.filterGroup.controls.tour.setValue( APTres.response.result[0].tourID)
        }
        
        this.getRoundAccordingRoute(this.tourId);
      }
    });
  }
  getRoundAccordingRoute(tour_id: string): void {
    debugger;
    const controls: any = this.filterGroup.controls;
    this.service.getAPIMethod(`/tournament/getTournamentRoundDetails?tourId=${controls.tour.value}`).subscribe((APIresponse: any) => {

      this.roundData = APIresponse?.response;
      if (this.tournamentDetails.eventType == 1) {
        this.service.getAPIMethod('/tournament/getStablefordPoints').subscribe((res: any) => {
          if (res.response.result) {
            this.stableFordList = res.response.result;
            if (this.roundData && this.roundData?.result.length > 0)
             this.getRoundDetailByID(this.roundData?.result[0]?.tourID, this.roundData?.result[0]?.round_Id)
          }
        })
      } else {
        if (this.roundData && this.roundData?.result.length > 0)
         this.getRoundDetailByID(this.roundData?.result[0]?.tourID, this.roundData?.result[0]?.round_Id)
      }

    })
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

