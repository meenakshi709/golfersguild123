import { Component, OnInit, Directive, EventEmitter, Input, Output, QueryList, ViewChildren } from '@angular/core';


import { CommonServiceService } from '../../Service/common-service.service';

@Component({
  selector: 'app-event',
  templateUrl: './event.component.html',
  styleUrls: ['./event.component.css']
})
export class EventComponent implements OnInit {

  activeId:any = 0;
  tabData = [
    {
      'id': 1, 'month': "January",'monthNum': "1", "tagline": "Golfer's Guild January Mania", "duration": "20th - 27th",
      'dates': [
        { 'isActive': false, 'idd': 11, "date": 20, "tee": "TEE-OFF FROM GOLD", "course": "ITC Classic", "review": "", "head": "" },
        { 'isActive': false, 'idd': 12, "date": 22, "tee": "TEE-OFF FROM GOLD", "course": "ITC Classic", "review": "", "head": "" },
        { 'isActive': false, 'idd': 13, "date": 27, "tee": "TEE-OFF FROM GOLD", "course": "ITC Classic", "review": "", "head": "Match Review" }
       
      ]
    },

    {
      'id': 2, 'month': "March",'monthNum': "3", "tagline": "Golfer's Guild Hexadic March", "duration": "4th - 16th",
      'dates': [
        { 'isActive': false, 'idd': 21, "date": 4, "tee": "TEE-OFF FROM GOLD", "course": "ITC Classic ", "review": "The March tournament was held at Classic Golf & Country Club with a unique format - Hexadic over 54 holes. Players competed for 4 prizes - Gross, Net, X-factor & Hexadic Champion. X-factor award is for the player who scores maximum birdies in the tournament. Hexadic champion is the player who scores the best in chosen 18 holes from 54 holes. Fierce competition coupled with some really fine golf was the highlight of the tournament. Dev, Pulak, Aseem & Rishi prevailed over the competition and walked away with the trophies. Award ceremony in the evening was organised during the Gala dinner with family. The On course competition n Off course camaraderie is the hallmark of Golfers' Guild!", "head": "Match Review" },
        { 'isActive': false, 'idd': 22, "date": 9, "tee": "TEE-OFF FROM GOLD", "course": "ITC Classic ", "review": "The March tournament was held at Classic Golf & Country Club with a unique format - Hexadic over 54 holes. Players competed for 4 prizes - Gross, Net, X-factor & Hexadic Champion. X-factor award is for the player who scores maximum birdies in the tournament. Hexadic champion is the player who scores the best in chosen 18 holes from 54 holes. Fierce competition coupled with some really fine golf was the highlight of the tournament. Dev, Pulak, Aseem & Rishi prevailed over the competition and walked away with the trophies. Award ceremony in the evening was organised during the Gala dinner with family. The On course competition n Off course camaraderie is the hallmark of Golfers' Guild!", "head": "Match Review" },
        { 'isActive': false, 'idd': 23, "date": 16, "tee": "TEE-OFF FROM GOLD", "course": "ITC Classic ", "review": "The March tournament was held at Classic Golf & Country Club with a unique format - Hexadic over 54 holes. Players competed for 4 prizes - Gross, Net, X-factor & Hexadic Champion. X-factor award is for the player who scores maximum birdies in the tournament. Hexadic champion is the player who scores the best in chosen 18 holes from 54 holes. Fierce competition coupled with some really fine golf was the highlight of the tournament. Dev, Pulak, Aseem & Rishi prevailed over the competition and walked away with the trophies. Award ceremony in the evening was organised during the Gala dinner with family. The On course competition n Off course camaraderie is the hallmark of Golfers' Guild!", "head": "Match Review" }
       
      ]
    },
    {
      'id': 3, 'month': "September",'monthNum': "9", "tagline": "Invitational Tournament", "duration": "3rd - 12th",
      'dates': [
        { 'isActive': false, 'idd': 31, "date": 3, "tee": "TEE-OFF FROM GOLD", "course": "ITC Classic ", "review": "Golfers' Guild resumes, after Covid, this September. With more players joining this edition, the competition is set to be intense as the average handicap has further dropped. A 54 hole tournament will be played at the two prestigious golf courses - Classic Golf & Country Club and Golden Greens Golf Club. Live leader board will track the story unfolding on the course in every game and players and followers will know, where they stand in competition anytime during or after the rounds. The battle will throw up winners in 3 categories - Gross, Net & X-factor. Get ready for some amazing action on the course... Dev, Pulak, Aseem & Rishi are all in fray to defend their titles but there is a strong field trying to get their hands on these exquisite trophies. All the best !", "head": "Match Preview" },
        { 'isActive': false, 'idd': 32, "date": 4, "tee": "TEE-OFF FROM BLUE", "course": "Golden Green  ", "review": "Golfers' Guild resumes, after Covid, this September. With more players joining this edition, the competition is set to be intense as the average handicap has further dropped. A 54 hole tournament will be played at the two prestigious golf courses - Classic Golf & Country Club and Golden Greens Golf Club. Live leader board will track the story unfolding on the course in every game and players and followers will know, where they stand in competition anytime during or after the rounds. The battle will throw up winners in 3 categories - Gross, Net & X-factor. Get ready for some amazing action on the course... Dev, Pulak, Aseem & Rishi are all in fray to defend their titles but there is a strong field trying to get their hands on these exquisite trophies. All the best !", "head": "Match Preview" },
        { 'isActive': false, 'idd': 33, "date": 12, "tee": "TEE-OFF FROM BLUE", "course": "Golden Green ", "review": "Golfers' Guild resumes, after Covid, this September. With more players joining this edition, the competition is set to be intense as the average handicap has further dropped. A 54 hole tournament will be played at the two prestigious golf courses - Classic Golf & Country Club and Golden Greens Golf Club. Live leader board will track the story unfolding on the course in every game and players and followers will know, where they stand in competition anytime during or after the rounds. The battle will throw up winners in 3 categories - Gross, Net & X-factor. Get ready for some amazing action on the course... Dev, Pulak, Aseem & Rishi are all in fray to defend their titles but there is a strong field trying to get their hands on these exquisite trophies. All the best !", "head": "Match Preview" },
       
      ]
    }
  ]



  constructor(private service:CommonServiceService) {
   }

  ngOnInit(): void {
    this.onMonthChange(0);
       
   this.onRoundChange(0);

   this.dtOptions2 = {
     pagingType: 'numbers',
     pageLength: 10,
     "info": false,
     processing: false,
     "paging": false,
     "order":[[3,"asc"]],
     "columnDefs": [{
       'targets': [2,3,5], /* column index */
       'orderable': false, /* true or false */
     
       orderData: [ 0 ]

     }]
   };
  // this.onCallApi2();
  }
  onMonthChange(index: any) {
    this.scoreData=[];
    this.dnotfound=false;
    this.tabData.filter(item => {
      item.dates.map((element, index) => {
        element.isActive = false
        if (index == 0) {
          element.isActive = true;
        }

      });
    })
  }
  isReviewShown(rowDetails: any, index: any) {
    
    this.tabData.filter(item => {
      item.dates.map(element => {
        element.isActive = false
      });
    });
    rowDetails.isActive = true;
  }





  scoreData: any = [];
  respnseData: any = [];
  courseData: any = [];
  courseRespnseData: any = [];
  selectroundIndex:any=0;

  data: any;
  roundData: any = [];


  dtOptions2: DataTables.Settings = {};


  item: any;
  
  isShown: boolean = false ; // hidden by default

  dnotfound:boolean=false;
  toggleShow(month:any) {
  
  this.isShown = true;  
  this.scoreData=[];
  this.service.getAPIMethod('/score').subscribe((response: any) => {


      this.dnotfound=true;
      const getResponse = response;
      this.respnseData = response;
      
 
      const newArr: any = [];
      var uni:any=[];
      this.respnseData.response.filter((item: any, index: any) => {
        
        const tdate=new Date(item.tournament_date);
        const getmonthNum=tdate.getMonth()+1;

      console.log("month is"+getmonthNum);
      if(getmonthNum==month)
      {

            const round = item.round;
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
    
              this.scoreData = uni
            } else {
              console.log("month1 is0",newArr);
              let numberOfRounds = newArr.map((items: any) => items.round);
              newArr.map((elem: any, index: any) => {
    console.log(numberOfRounds[index] , round)
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
          
          }
          else{
            // this.scoreData=[];
    
          }
      
          });
    
         
          
          
       
    
         
          
        }, error => console.error(error));
    
    
      }
      getGross(data: any) {

        // if (data && data.length > 0){
          if(data && data.length > 0){
            let z = Math.min(...data.map((o: any) => o['board']['gross']));
    
            return z;
          }else return 0;
    
       
        // }
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
      const diff = (Number(data.scoreArr[index])-Number(data.parValue[index]));
     
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
      
    
  this.scoreData.map((element: any,index:any) => {
        
        element.isActive = false
        if (index == 0) {
          element.isActive = true;
        }
  
      })
 
  
    }
  
   
  

    }

