import { HttpClient } from '@angular/common/http';
import { analyzeAndValidateNgModules } from '@angular/compiler';
import { Component, Directive, EventEmitter, Input, Output, QueryList, ViewChildren } from '@angular/core';
import { CommonServiceService } from '../../Service/common-service.service';


interface Leader {

  name: string;
  par: number;
  r1: number;
  r2: number;
  r3: number;

  total: number;
  net:number;
  birdies:number;

}


/*
const leaderboardData: Leader[] = [
  
  {
    
    name: 'Aseem Vivek',
    par: 72,
    r1: 81,
    r2:84,
    r3:0,   
    total: 165,
    net:153,
    birdies:2
  }, 
  {
    
    name: 'Azaad Gill',
    par: 72,
    r1: 90,
    r2:95,
    r3:0,   
    total: 185,
    net:161,
    birdies:2
  }, 
  {
    
    name: 'Bobby Kochhar',
    par: 72,
    r1: 88,
    r2:85,
    r3:0,   
    total: 173,
    net:151,
    birdies:2
  }, 

  {
    
    name: 'Col. Azad S Ruhail',
    par: 72,
    r1: 89,
    r2:89,
    r3:0,   
    total: 178,
    net:160,
    birdies:1
  },

  {
    
    name: 'Col. Manish Dubey',
    par: 72,
    r1: 83,
    r2:96,
    r3:0,   
    total: 179,
    net:155,
    birdies:2
  }, 
  {
    
    name: 'Col. Rajesh Bains',
    par: 72,
    r1: 87,
    r2:94,
    r3:0,   
    total: 181,
    net:159,
    birdies:1
  }, 

  {   
    name: 'Col. Sanjay Verma',
    par: 72,
    r1: 91,
    r2:86,
    r3:0,   
    total: 177,
    net:154,
    birdies:1
  },

  {
    
    name: 'Col. Sunny Meitei',
    par: 72,
    r1: 90,
    r2:90,
    r3:0,   
    total: 180,
    net:167,
    birdies:0
  },  
  {
    
    name: 'Dev Amritesh',
    par: 72,
    r1: 81,
    r2:84,
    r3:0,   
    total: 165,
    net:147,
    birdies:0
  }, 
  {
    
    name: 'Gaurav Gandhi',
    par: 72,
    r1: 92,
    r2:91,
    r3:0,   
    total: 183 ,
    net:162,
    birdies:2
  },
  {
   
    name: 'Jaideep Brar',
    par: 72,
    r1: 86,
    r2:88,
    r3:0,   
    total: 174,
    net:150,
    birdies:1
  },

  {
   
    name: 'Manish Rathi',
    par: 72,
    r1: 92,
    r2:95,
    r3:0,   
    total: 187,
    net:164,
    birdies:0
  },
  {
    
    name: 'Manjit Bagri',
    par: 72,
    r1: 84,
    r2:89,
    r3:0,   
    total: 173,
    net:161,
    birdies:1
  },  
  {
    
    name: 'Naresh Kumar',
    par: 72,
    r1: 83,
    r2:88,
    r3:0,   
    total: 171,
    net:149,
    birdies:1
  }, 

  {
    
    name: 'Pankaj Tandon',
    par: 72,
    r1: 92,
    r2:90,
    r3:0,   
    total: 182,
    net:158,
    birdies:0
  },
  {
    
    name: 'Pulak Chakraborty',
    par: 72,
    r1: 83,
    r2:93,
    r3:0,   
    total: 176,
    net:165,
    birdies:3
  },  
 
  {
    
    name: 'Rajiv Ghumman',
    par: 72,
    r1: 76,
    r2:75,
    r3:0,   
    total: 151,
    net:141,
    birdies:7
  }, 
 
  {
    
    name: 'Rishi Poddar',
    par: 72,
    r1: 93,
    r2:88,
    r3:0,   
    total:181,
    net:160,
    birdies:0
  }, 
  
];

*/

@Component({
  selector: 'app-leaderboard-table',
  templateUrl: './leaderboard-table.component.html',
  styleUrls: ['./leaderboard-table.component.css']
})
export class LeaderboardTableComponent {

  
  respnseData: any = [];
  scoreSmallData:any=[];
  respnseSmallData: any = [];
  title = 'datatables';
  playerData  :any
  combinedplayerData:any
  dataOption: DataTables.Settings = {};

   
 //leadData = leaderboardData;
  
 constructor(private service:CommonServiceService ) {
  //get request from web api

}
  ngOnInit(): void {
    this.playerData = []
    this.combinedplayerData = []
    this.dataOption = {
      pagingType: 'full_numbers',
      pageLength: 5,
      processing: true,     
      "columnDefs": [{
        'targets': [1,2], /* column index */
        'orderable': false /* true or false */

      

      }]
    };
this.summryTable();
}




// summryTable(){
// //this.service.getScoreApi().subscribe({http://golfersguild.in/tournament/tournamentScoreById?tournamentId=16&playerId=0
//   this.service.getScoreApi().subscribe({
//   next:(response:any)=>{
 
// console.log(response.response.result)
// if(response.response.result && response.response.result.length > 0){
//   response.response.result.filter((item: any, index: any) => {
   
//     const tdate=new Date(item.tournament_date);

//     const getmonthNum = (new Date(item.tournament_date).getMonth()+1).toString() + '-' + new Date(item.tournament_date).getFullYear().toString();
//     //const currmonth = (new Date().getMonth() + 1).toString() + '-' + new Date().getFullYear().toString();
//   if(getmonthNum=='2-2022')
//   {
//     this.playerData.push(item)
    
//   }
//   })
// }
//   },
//   error:(error)=>{},
//   complete:()=>{
    
//     let sorted_arr = this.playerData.slice().sort();
//     console.log('plyer data',this.playerData, sorted_arr)
//   const  uni = sorted_arr.filter((v: any, i: any, a: any) => a.findIndex((t: any)=> {
//     if(t.p_id == v.p_id) {
     
//       const index = this.combinedplayerData.length > 0?this.combinedplayerData.findIndex((obj:any)=>obj.p_id==t.p_id):-1
//       if(index != -1){
//          this.combinedplayerData[index][t.round_Id] = t
//       }else{
//         let obj :any = {
//           name:v.playerName,
//           p_id:v.p_id
//         }
//          obj[t.round_Id] = t
//         this.combinedplayerData.push(obj)
//       }
      
//     }
//     console.log(this.combinedplayerData);
//   } ))
  
//   }

// })

// }







// }
summryTable()
{

  this.service.getAPIMethod('/tourDetails').subscribe((APIresponse: any) => {
    
  
    var tourId = APIresponse.response?.result?.tour_id;
   // var roundID = APIresponse.response.result.round_Id;

  this.service.getAPIMethod('/tournament/tournamentScoreById?tournamentId='+tourId+'&playerId=0').subscribe((APTres: any) => {
     

    this.combinedplayerData=APTres.response.result;
    console.log("tour",APTres.response);

   if(APTres.response && APTres.response.result){
   
    const getResponse = APTres.response.result;
    this.respnseData = APTres.response.result;
    const newArr: any = [];
    var uni: any = [];
   
    this.respnseData.filter((item: any, index: any) => {
  
   
     
      const isActive = false;
      let finalData: any = {

        'playerName': item.playerName,
        'gross': item.TotalGross,
        'net': item.TotalNet,
        'birdie': item.TotalBirdie,
        'round1':item.round[0].score,
        'round2':item.round[1].score,
        'round3':item.round[2].score
       
      }
    //  this.combinedplayerData.push(finalData);
     // console.log('final',finalData);
    });
   
 
  }
   }, error => console.error(error));

 }, error => console.error(error));


}
}