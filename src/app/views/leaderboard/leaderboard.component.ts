 
import { Component, OnInit, Directive, EventEmitter, Input, Output, QueryList, ViewChildren } from '@angular/core';
import { CommonServiceService } from '../../Service/common-service.service';

@Component({
  selector: 'app-leaderboard',
  templateUrl: './leaderboard.component.html',
  styleUrls: ['./leaderboard.component.css']
})
export class LeaderboardComponent implements OnInit {
id:any;
  scoreData: any = [];
  respnseData: any = [];
  courseData: any = [];
  courseRespnseData: any = [];
  selectroundIndex: any = 0;

  data: any;
  roundData: any = [];
  activeId:any = 0;
  dnotfound:boolean=false;
  tourDetail:any 
  filteredGross:any = []
  filteredNet:any = []
  filteredBirdie:any = []
  constructor(private service:CommonServiceService) {
    //get request from web api

  }

  dtOptions: DataTables.Settings = {};
  ngOnInit(): void {
    this.dtOptions = {
      pagingType: 'numbers',
      pageLength: 10,
      "info": false,
      processing: false,
      "paging": false,
      "order": [[3, "asc"]],
      "columnDefs": [{
        'targets': [2, 3, 5], /* column index */
        'orderable': false, /* true or false */

        orderData: [0]

      }]
    };
  this.onCallApi();
  /*  this.id = setInterval(() => {
      this.onCallApi(); 
    }, 5000);
    */
  
    //   this.courseApi();
  }
 
  item: any;
  onCallApi() {
    
    this.service.getAPIMethod('/tourDetails').subscribe((APIresponse: any) => {
      var tourId = APIresponse.response.result.tour_id;
      var roundID = APIresponse.response.result.round_Id;
      this.getRoundAccordingRoute(tourId)
      this.getTourDetail(tourId)

 
  }, error => console.error(error));

  
  }

  getRoundAccordingRoute(tour_id:string):void{
 this.service.getAPIMethod(`/tournament/getTournamentRoundDetails?tourId=${tour_id}`).subscribe((APIresponse: any) => {
 this.roundData = APIresponse?.response
 if(this.roundData && this.roundData?.result.length > 0) this.getRoundDetailByID(this.roundData?.result[0]?.tourID,this.roundData?.result[0]?.round_Id)
 })
  }
  getRoundDetailByID(tourID:string,roundID:string):void{
    
    this.service.getAPIMethod('/tournament/tournamentDetailedScoreById?tour_id='+tourID+'&player_id=0&round_Id='+roundID).subscribe((APTres: any) => {
       
    

      if(APTres.response && APTres.response.result.length > 0){
       console.log("tour",APTres.response.result);
       const getResponse = APTres.response.result;
       this.respnseData = APTres.response.result;
       const newArr: any = [];
       var uni: any = [];
      
       this.respnseData.filter((item: any, index: any) => {
         console.log("code",item.round_Id);
        // const tdate=new Date(item.tournament_date);
 
       //  const getmonthNum = (new Date(item.tournament_date).getMonth()+1).toString() + '-' + new Date(item.tournament_date).getFullYear().toString();
       //  const currmonth = (new Date().getMonth() + 1).toString() + '-' + new Date().getFullYear().toString();
 
 
      // if(item.round_Id==78)
      // {
         this.dnotfound=false;
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
         // const i: any = 18;
         const finalScoreArr: any = [];
         let parValue: any = [];
         let scoreArr: any = [];
         let hdcpArr: any = [];
         let count: number = 1;
         let sum = "";
         for (let indexNumber = 1; indexNumber < 19; indexNumber++) {
          
           const parkeyName = 'par' + indexNumber;
           const scoreName = 'score' + indexNumber;
           const hdcpName = 'hdcp' + indexNumber;
           let value = item[parkeyName];
           let scoreValue: any = item[scoreName];
           let hdcpValue: any = item[hdcpName];
           parValue.push(value);
           scoreArr.push(scoreValue);
           hdcpArr.push(hdcpValue);
 
 
           if (indexNumber == 9 || indexNumber == 18) {
             const data: any = {
               'parValue': parValue,
               'scoreArr': scoreArr,
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
 
             parValue = [];
             scoreArr = [];
             hdcpArr = [];
             count = count + 1;
             finalScoreArr.push(data);
            
             par.push(pardata)
             hdcpp.push(hdcpData)
 
 
           }
         }
 
         finalData.score = finalScoreArr;
         mainData.par = par;
         mainData.hdcap = hdcpp;
         mainData['board'] = finalData;
 
         if (newArr.length == 0) {
           let data156: any = [];
           data156.push(mainData)
           newArr.push({ round: round, isActive: "false", data: data156 });
           console.log("month1 is0",newArr);
           uni = newArr.filter((v: any, i: any, a: any) => a.findIndex((t: any) => (t.round === v.round)) === i)
 
           this.scoreData = uni;
         } else {
           console.log("month1 is0",newArr);
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
                 console.log('newArray',newArr)
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
 
       console.log('unit',this.scoreData);
       
       
    
 
      }
      this.dnotfound=true;
     }, error => console.error(error));
  }

  getTourDetail(tourId:string):void{
    this.service.getAPIMethod(`/tournament/tournamentScoreById?tournamentId=${tourId}&playerId=0`).subscribe((APTres: any) => {
     debugger
     this.tourDetail = APTres?.response?.result[0];
      if(this.tourDetail){
    console.log(this.tourDetail)
    this.getGross(this.tourDetail)

      }
   
    })
     
  }

  getGross(data: any) {
 const length  =  2
 const filterData:any = data
 if(filterData && filterData.length > 0 ){
  let getGrossData = filterData
  let getNetData = filterData
  for (let index = 0; index < length; index++) {
    if(getGrossData?.length > 0 ){
      let topGross = Math.min(...getGrossData.map((o: any) => o['TotalGross']));
      const grossObj  = getGrossData.filter((obj:any)=>obj.TotalGross == topGross)
      this.filteredGross.push({name:grossObj[0]?.playerName,gross:grossObj[0]?.TotalGross})
      getGrossData = getGrossData.filter((obj:any)=>obj.TotalGross !== topGross)
    }
  if(getNetData?.length > 0){
    let topTotalNet = Math.min(...getNetData.map((o: any) => o['TotalNet']));
    const TotalNetObj  = getNetData.filter((obj:any)=>obj.TotalNet == topTotalNet)
    this.filteredNet.push({name:TotalNetObj[0]?.playerName,net:TotalNetObj[0]?.TotalNet})
    getNetData = getNetData.filter((obj:any)=>obj.TotalNet !== topTotalNet)
  }

    }
    let totalBirdie = Math.max(...filterData.map((o: any) => o['TotalBirdie']));
    const TotalBirdieObj  = filterData.filter((obj:any)=>obj.TotalBirdie == totalBirdie)
    this.filteredBirdie.push({name:TotalBirdieObj[0]?.playerName,birdie:TotalBirdieObj[0]?.TotalBirdie})
    console.log(this.filteredBirdie)
 
}
  }

  getGross1(data: any) {
   if (data && data.length > 0){
    let z = Math.min(...data.map((o: any) => o['board']['gross']));
    let index = data.findIndex((x: any) => x['board']['gross'] == z);
   
      let name = index >= 0 ? data[index]['board']['playerName'] : '';
      return name;
    
   
    }
   
  }


  getnet1(data: any) {
    if(data && data.length > 0){
    let z = Math.min(...data.map((o: any) => o['board']['net']));
    let index = data.findIndex((x: any) => x['board']['net'] == z);
    let name = index >= 0? data[index]['board']['playerName'] : '';
 
    return name;
   
    }
  }

  getnet(data: any) {
    if(data && data.length > 0){
    let z = Math.min(...data.map((o: any) => o['board']['net']));

    return z;
    } else return 0

  }

  getbird1(data: any) {
    if(data && data.length > 0){
      console.log(data)
      let z = Math.max(...data.map((o: any) => o['board']['birdie']));
      let index = data.findIndex((x: any) => x['board']['birdie'] == z);
      let name = index >= 0 ? data[index]['board']['playerName'] : '';
      return name; 
    
 
  
    }
  }

  getbird(data: any) {
    if(data && data.length > 0){
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

}
