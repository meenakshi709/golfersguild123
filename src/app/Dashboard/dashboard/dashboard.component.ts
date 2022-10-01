import { Component, OnInit } from '@angular/core';

import { CommonServiceService } from '../../Service/common.service';
import { AbstractControl, FormBuilder, FormGroup, Validators,FormControl } from '@angular/forms';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css']
})
export class DashboardComponent implements OnInit {


  submitted = false;
  playerData: any = [];
  constructor(private service: CommonServiceService, private formBuilder: FormBuilder) {}

  ngOnInit(): void {
    this.playerList();
    this.courseList();
  }

  public leaderboardForm:FormGroup = new FormGroup({
    playername: new FormControl(''),
    score1: new FormControl(''),
    score2: new FormControl(''),
    score3: new FormControl(''),
    score4: new FormControl(''),
    score5: new FormControl(''),
    score6: new FormControl(''),
    score7: new FormControl(''),
    score8: new FormControl(''),
    score9: new FormControl(''),
    score10: new FormControl(''),
    score11: new FormControl(''),
    score12: new FormControl(''),
    score13: new FormControl(''),
    score14: new FormControl(''),
    score15: new FormControl(''),
    score16: new FormControl(''),
    score17: new FormControl(''),
    score18: new FormControl(''),
    tdate: new FormControl(''),
    coursename: new FormControl(''),
    round: new FormControl(''),
    hdcp: new FormControl(''),

  });

  playerList() {

    this.service.getAPIMethod('/dataApi/players').subscribe({
      next: (response: any) => {
        console.log(response)
        let respns;
        if (response && response.response.length > 0) {
          respns = response.response;



          $.each(respns, function (i, data) {
            $('#playername').append($('<option/>').attr("value", data.pid).text(data.playerName));

          });
        }
      },
      error: (error) => { },
      complete: () => {
      }
    });
  }

  courseList() {

    this.service.getCourseApi().subscribe({
      next: (response: any) => {
        console.log(response)
        let respns;
        if (response && response.response.length > 0) {
          respns = response.response;



          $.each(respns, function (i, data) {
            $('#coursename').append($('<option/>').attr("value", data.cid).text(data.cname));

          });
        }
      },
      error: (error) => { },
      complete: () => {
      }
    });
  }



  calculateResult() {
    //this.leaderboardForm.controls.playername.value,
  //  const data: any = this.leaderboardForm.getRawValue();
    console.log(this.leaderboardForm.controls.playername.value,);
    let class11:any;
    this.service.getCourseApi().subscribe({
      next: (response: any) => {
        console.log(response)
        let respns;
        if (response && response.response.length > 0) {


          var dataa = response.response;
          // console.log(dataa);
          var diff = 0;
          var cid = this.leaderboardForm.value;
          console.log(cid);
          dataa.forEach((element: any) => {
            if (cid == element.cid) {
              var parkeyName;
              var scoreName;
              var parValue;
              var scoreValue;

              for (let indexNumber = 1; indexNumber < 19; indexNumber++) {
                parkeyName = 'par' + indexNumber;
                scoreName = 'score' + indexNumber;
                console.log(parkeyName);
                //var z=parkeyName.replace(/['"]+/g, '');

                
                // element.parkeyName=parkeyName;
                parValue = element[parkeyName];
                scoreValue = element[scoreName];

                console.log("score vlue", scoreValue);

                diff = parseInt(scoreValue) - parseInt(parValue);

                switch (diff) {
                  case -1:

                    class11 = class11 + 1;
                    break;
                  case -2:

                    class11 = class11 + 2;
                    break;
                  case 0:
                    class11 = class11 + 0;

                    break;
                  case 1:
                    class11 = class11 + 0;

                    break;
                  case 2:
                    class11 = class11 + 0;

                    break;
                  case 3:
                    class11 = class11 + 0;
                    break;

                  default:

                    class11 = class11 + 0;


                }



              }




              console.log(class11);


            }
          });





        }


      },
      error: (error) => { },
      complete: () => {
      }
    });


  }


  onSubmit() {
    // TODO: Use EventEmitter with form value
    this.submitted = true;
    console.warn(this.leaderboardForm.value);
  }




}



