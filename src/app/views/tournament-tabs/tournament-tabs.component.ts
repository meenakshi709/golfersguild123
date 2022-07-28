import { Component, OnInit } from '@angular/core';
import { MatStepperModule } from '@angular/material/stepper';
import { NgxUiLoaderService } from 'ngx-ui-loader';
import { CommonServiceService } from 'src/app/Service/common-service.service';

declare var $: any;
@Component({
  selector: 'app-tournament-tabs',
  templateUrl: './tournament-tabs.component.html',
  styleUrls: ['./tournament-tabs.component.css']
})
export class TournamentTabsComponent implements OnInit {



  yearData: any = [];
  respnseData: any = [];
  monthData: any = [];
  tourId: any;
  tourWebDetails: any = [];
  RoundData: any = [];
  selectedYear: any;
  selectedMonth: any;
  selectedTournament: any = 0;
  tabData = [
    {
      'id': 1, 'month': "February 2022", "tagline": "", "duration": "Feb 26  - Mar 03",
      'dates': [
        { 'isActive': false, 'idd': 31, "date": 26, "tee": "TEE-OFF FROM BLUE", "course": "Golden Green  ", "review": "Golfers' Guild is back with yet another tough and an exciting challenge, thanks to love and support of the golfing fraternity in Gurgaon & Delhi. Covid-19 returned as Omicron and once again, life was disrupted and the world still couldn't breathe freely... Golf further reinforced itself as an antidote to the crisis mounted by the disease and was rightly the vanguard among sports that kept the human as well as sportsman spirit alive and kicking.This edition of the tournament is really special as Golfers'Guild unveils it's digital platform that will be used to conduct this tournament, end to end. The tournament is to be held on 26th, 27th Feb and 3rd March at Golden Greens, Canyon - Ridge (Classic) & Ridge - Valley (Classic) respectively. Final day of this thrilling contest on 3rd March will be followed by gala lunch and award ceremony at Classic Golf and Country Club. The competition is tougher this time with low, single digit stalwarts like Ranndeep, Simran, Avneet, Aman, Mihirjit & Rohit S joining the Guild to mount challenge to defending champs Rajiv Ghuman and Aseem Vivek & Bobby Kochhar. Dont miss the thrill, log in to witness a fierce competition amongst these golf lovers.", "head": "Match Preview" },
        { 'isActive': false, 'idd': 32, "date": 27, "tee": "TEE-OFF FROM BLACK", "course": "ITC Classic  ", "review": "Golfers' Guild is back with yet another tough and an exciting challenge, thanks to love and support of the golfing fraternity in Gurgaon & Delhi. Covid-19 returned as Omicron and once again, life was disrupted and the world still couldn't breathe freely... Golf further reinforced itself as an antidote to the crisis mounted by the disease and was rightly the vanguard among sports that kept the human as well as sportsman spirit alive and kicking. This edition of the tournament is really special as Golfers'Guild unveils it's digital platform that will be used to conduct this tournament, end to end. The tournament is to be held on 26th, 27th Feb and 3rd March at Golden Greens, Canyon - Ridge (Classic) & Ridge - Valley (Classic) respectively. Final day of this thrilling contest on 3rd March will be followed by gala lunch and award ceremony at Classic Golf and Country Club. The competition is tougher this time with low, single digit stalwarts like Ranndeep, Simran, Avneet, Aman, Mihirjit & Rohit S joining the Guild to mount challenge to defending champs Rajiv Ghuman and Aseem Vivek & Bobby Kochhar. Dont miss the thrill, log in to witness a fierce competition amongst these golf lovers.", "head": "Match Preview" },
        { 'isActive': false, 'idd': 33, "date": 3, "tee": "TEE-OFF FROM BLACK", "course": "ITC Classic ", "review": "Golfers' Guild is back with yet another tough and an exciting challenge, thanks to love and support of the golfing fraternity in Gurgaon & Delhi. Covid-19 returned as Omicron and once again, life was disrupted and the world still couldn't breathe freely... Golf further reinforced itself as an antidote to the crisis mounted by the disease and was rightly the vanguard among sports that kept the human as well as sportsman spirit alive and kicking. This edition of the tournament is really special as Golfers'Guild unveils it's digital platform that will be used to conduct this tournament, end to end. The tournament is to be held on 26th, 27th Feb and 3rd March at Golden Greens, Canyon - Ridge (Classic) & Ridge - Valley (Classic) respectively. Final day of this thrilling contest on 3rd March will be followed by gala lunch and award ceremony at Classic Golf and Country Club. The competition is tougher this time with low, single digit stalwarts like Ranndeep, Simran, Avneet, Aman, Mihirjit & Rohit S joining the Guild to mount challenge to defending champs Rajiv Ghuman and Aseem Vivek & Bobby Kochhar. Dont miss the thrill, log in to witness a fierce competition amongst these golf lovers.", "head": "Match Preview" },

      ]
    },

    // {
    //   'id': 2, 'month': "March", "tagline": "Golfer's Guild Hexadic March", "duration": "4th - 16th",
    //   'dates': [
    //     { 'isActive': false, 'idd': 21, "date": 4, "tee": "TEE-OFF FROM GOLD", "course": "ITC Classic ", "review": "The March tournament was held at Classic Golf & Country Club with a unique format - Hexadic over 54 holes. Players competed for 4 prizes - Gross, Net, X-factor & Hexadic Champion. X-factor award is for the player who scores maximum birdies in the tournament. Hexadic champion is the player who scores the best in chosen 18 holes from 54 holes. Fierce competition coupled with some really fine golf was the highlight of the tournament. Dev, Pulak, Aseem & Rishi prevailed over the competition and walked away with the trophies. Award ceremony in the evening was organised during the Gala dinner with family. The On course competition n Off course camaraderie is the hallmark of Golfers' Guild!", "head": "Match Review" },
    //     { 'isActive': false, 'idd': 22, "date": 9, "tee": "TEE-OFF FROM GOLD", "course": "ITC Classic ", "review": "The March tournament was held at Classic Golf & Country Club with a unique format - Hexadic over 54 holes. Players competed for 4 prizes - Gross, Net, X-factor & Hexadic Champion. X-factor award is for the player who scores maximum birdies in the tournament. Hexadic champion is the player who scores the best in chosen 18 holes from 54 holes. Fierce competition coupled with some really fine golf was the highlight of the tournament. Dev, Pulak, Aseem & Rishi prevailed over the competition and walked away with the trophies. Award ceremony in the evening was organised during the Gala dinner with family. The On course competition n Off course camaraderie is the hallmark of Golfers' Guild!", "head": "Match Review" },
    //     { 'isActive': false, 'idd': 23, "date": 16, "tee": "TEE-OFF FROM GOLD", "course": "ITC Classic ", "review": "The March tournament was held at Classic Golf & Country Club with a unique format - Hexadic over 54 holes. Players competed for 4 prizes - Gross, Net, X-factor & Hexadic Champion. X-factor award is for the player who scores maximum birdies in the tournament. Hexadic champion is the player who scores the best in chosen 18 holes from 54 holes. Fierce competition coupled with some really fine golf was the highlight of the tournament. Dev, Pulak, Aseem & Rishi prevailed over the competition and walked away with the trophies. Award ceremony in the evening was organised during the Gala dinner with family. The On course competition n Off course camaraderie is the hallmark of Golfers' Guild!", "head": "Match Review" }

    //   ]
    // },
    // {
    //   'id': 3, 'month': "January", "tagline": "Golfer's Guild January Mania", "duration": "20th - 27th",
    //   'dates': [
    //     { 'isActive': false, 'idd': 11, "date": 20, "tee": "TEE-OFF FROM GOLD", "course": "ITC Classic", "review": "", "head": "" },
    //     { 'isActive': false, 'idd': 12, "date": 22, "tee": "TEE-OFF FROM GOLD", "course": "ITC Classic", "review": "", "head": "" },
    //     { 'isActive': false, 'idd': 13, "date": 27, "tee": "TEE-OFF FROM GOLD", "course": "ITC Classic", "review": "", "head": "Match Review" }

    //   ]
    // },


  ]





  constructor(private service: CommonServiceService, public loader: NgxUiLoaderService) { }

  ngOnInit(): void {

    this.onMonthChange(0);
    // this.onCallApi();
    this.getYearAccordingRoute(0);

  }

  // onCallApi() {

  //   this.service.getAPIMethod('/tournament/getTourDetails').subscribe((APIresponse: any) => {
  //   //  this.service.getAPIMethod('/tourDetails').subscribe((APIresponse: any) => {
  //     var tourId = APIresponse.response.result.tour_id;
  //     var roundID = APIresponse.response.result.round_Id;
  //   //  this.getRoundAccordingRoute(tourId)
  //   //  this.getTourDetail(tourId)


  // }, error => console.error(error));


  // }


  getYearAccordingRoute(dt: any): void {
    this.loader.start();
    this.service.getAPIMethod(`/tournament/getTourYearDetails`).subscribe((APIresponse: any) => {
      this.yearData = APIresponse?.response
      if (this.yearData && this.yearData?.result?.length > 0) {
        this.getMonthDetails(this.yearData?.result[0]?.year)
        this.selectedYear = this.yearData?.result[0]?.year;
      } else {

      }
    })
  }


  getMonthDetails(dt: any): void {
    this.loader.start();
    this.service.getAPIMethod(`/tournament/getTourMonthDetails?year=${dt}`).subscribe((APIresponse: any) => {
      this.loader.stop();
      this.monthData = APIresponse?.response;
      if (this.monthData && this.monthData?.result.length > 0) {

        debugger;
        const data = {
          month: "All",
          monthNum: '',
          year: this.monthData?.result[0].year
        }

        this.monthData.result.unshift(data);
        this.selectedMonth = data.month;
        this.selectedTournament = 0;
        this.getMonthWiseTour(this.monthData?.result[0]?.year, this.monthData?.result[0]?.monthNum)
      }
    })
  }

  getMonthWiseTour(year: any, month: any): void {
    this.service.getAPIMethod(`/tournament/getTourDetails?year=${year}&month=${month}`).subscribe((APTres: any) => {

      // this.service.getAPIMethod('/tournament/tournamentDetailedScoreById?tour_id='+tourID+'&player_id=0&round_Id='+roundID).subscribe((APTres: any) => {
      console.log("month wise data", APTres?.response)


      if (APTres.response && APTres.response.result.length > 0) {
        console.log("tour", APTres.response.result);
        const getResponse = APTres.response.result;
        this.respnseData = APTres.response.result;
        this.selectedTournament = 0;
        console.log("tourId response data", this.respnseData);



        this.tourId = APTres.response.result[0].tourID;
        // this.service.getAPIMethod(`/tournament/getWebTourDetails?tourID=${this.tourId}`).subscribe((APiresp: any) => {
        this.service.getAPIMethod(`/tournament/getWebTourDetails?tourID=${1}`).subscribe((APiresp: any) => {
          let tourData: any = [];
          this.tourWebDetails = APiresp.response.result;
          tourData.push(this.tourWebDetails);
          this.tourWebDetails = tourData;

          console.log("webtourId", this.tourWebDetails);
          this.getRoundDetailByID(this.tourId);
        });

      }
    })
  }


  getRoundDetailByID(tourID: string): void {
    console.log("round tour id is ", tourID)
    this.service.getAPIMethod(`/tournament/getTournamentRoundDetails?tourId=${tourID}`).subscribe((APTres: any) => {


      if (APTres.response && APTres.response.result.length > 0) {

        const getResponse = APTres.response.result;
        this.RoundData = APTres.response.result;
        console.log("test data", this.RoundData);
      }
    })
  }

  onMonthChange(index: any) {
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




}
function value(value: any) {
  throw new Error('Function not implemented.');
}

