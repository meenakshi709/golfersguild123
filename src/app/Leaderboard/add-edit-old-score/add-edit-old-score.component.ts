import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { NgxUiLoaderService } from 'ngx-ui-loader';
import { CommonServiceService } from 'src/app/Service/common-service.service';
import Swal from 'sweetalert2';
import { AddEditLeaderboardComponent } from '../add-edit-leaderboard/add-edit-leaderboard.component';

@Component({
  selector: 'app-add-edit-old-score',
  templateUrl: './add-edit-old-score.component.html',
  styleUrls: ['./add-edit-old-score.component.css']
})
export class AddEditOldScoreComponent implements OnInit {

 
  playerList: any = [];
  submitted = false;
  playerData: any = [];
  roundList: any = [];
  groupList: any = [];
  selectedCourse: any;
  teeNameList: any = [];
  holeCount: any = 0;
  selectedTeeName: any;
  scoreDiff: any = 0;
  courseRate: any = 0;
  slopeRate: any = 0;
  constructor(
    public dialogRef: MatDialogRef<AddEditLeaderboardComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    public loader: NgxUiLoaderService,
    private formBuilder: FormBuilder,
    private service: CommonServiceService,
    public route: Router) { }

  ngOnInit(): void {

    console.log("data=", this.data);
    if (this.data) {
      //  this.scoreForm.controls.cname.disable();
      //  this.setScoreDetails();

    }
    // this.scoreForm.controls.round_Id.disable();teeDetails
    //  this.scoreForm.controls.cid.disable();
  }

  public scoreForm: FormGroup = new FormGroup({
    tour_id: new FormControl('', [Validators.required]),
    round_Id: new FormControl('', [Validators.required]),
    groupId: new FormControl('', [Validators.required]),
    cid: new FormControl('', [Validators.required]),
    p_id: new FormControl('', [Validators.required]),
    hdcp: new FormControl('', [Validators.required]),
    holeNum: new FormControl('18', [Validators.required]),
    teeName: new FormControl('', [Validators.required]),
    score1: new FormControl('', []),
    score2: new FormControl('', []),
    score3: new FormControl('', []),
    score4: new FormControl('', []),
    score5: new FormControl('', []),
    score6: new FormControl('', []),
    score7: new FormControl('', []),
    score8: new FormControl('', []),
    score9: new FormControl('', []),
    score10: new FormControl('', []),
    score11: new FormControl('', []),
    score12: new FormControl('', []),
    score13: new FormControl('', []),
    score14: new FormControl('', []),
    score15: new FormControl('', []),
    score16: new FormControl('', []),
    score17: new FormControl('', []),
    score18: new FormControl('', []),
  });

  summaryForm: FormGroup = new FormGroup({

    inTotal: new FormControl(0, []),
    outTotal: new FormControl(0, []),
    grossTotal: new FormControl(0, []),
    netTotal: new FormControl(0, []),
    birdieTotal: new FormControl(0, []),
    scoreDiff: new FormControl(0, []),
  });







  setScoreDetails() {
    const keys = Object.keys(this.data);
    const formGroup = this.scoreForm.controls;

    for (let i = 0; i < keys.length; i++) {
      const keyName = keys[i];
      formGroup[keyName].setValue(this.data[keyName])
    }
  }

  saveScoreDetails() {
    
    this.calculateScoreDifferential();
    
    const data = this.scoreForm.getRawValue();
    const data1 = this.summaryForm.getRawValue();
    data1.grossTotal = this.summaryForm.controls.inTotal.value + this.summaryForm.controls.outTotal.value;
    data1.netTotal = (this.summaryForm.controls.inTotal.value + this.summaryForm.controls.outTotal.value) - (this.scoreForm.controls.hdcp.value);

    let enteredHoleCount = 0;
    for (let i = 1; i < data.holeNum; i++) {
      const controlName = 'score' + i;

      if (data[controlName] > 0) {
        enteredHoleCount++;

      }
      data.enteredHoleCount = enteredHoleCount;
      console.log("hole count", data.enteredHoleCount)

    }
    
    console.log("finalData", data)
    let finalData = { ...data, ...data1 };
    this.service.postAPIMethod('/tournament/savetournamentScore', finalData).subscribe(APIresponse => {
      // console.log("final",response);
debugger
      if (APIresponse.error != 'X') {
        //  this.route.navigateByUrl("/course");
        this.closeDialogClick();
        this.sweetAlertMsg("success", APIresponse.response.result.msg)
      }
      else {
        this.sweetAlertMsg("error", APIresponse.response.msg);
      }
    });

  }



  calculateResult() {
    //this.leaderboardForm.controls.playername.value,
    //  const data: any = this.leaderboardForm.getRawValue();
    // console.log(this.scoreForm.controls.playername.value,);
    let class11: any;
    this.service.getCourseApi().subscribe({
      next: (response: any) => {

        let respns;
        if (response && response.response.length > 0) {


          var dataa = response.response;
          // console.log(dataa);
          var diff = 0;
          var cid = this.scoreForm.value;

          dataa.forEach((element: any) => {
            if (cid == element.cid) {
              var parkeyName;
              var scoreName;
              var parValue;
              var scoreValue;

              for (let indexNumber = 1; indexNumber < 19; indexNumber++) {
                parkeyName = 'par' + indexNumber;
                scoreName = 'score' + indexNumber;

                //var z=parkeyName.replace(/['"]+/g, '');


                // element.parkeyName=parkeyName;
                parValue = element[parkeyName];
                scoreValue = element[scoreName];
                
                if (scoreValue > 0) {
                  this.holeCount = this.holeCount + 1;
                }


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







            }
          });





        }


      },
      error: (error) => { },
      complete: () => {
      }
    });

    console.log("hole count=", this.holeCount)
  }


  onSubmit() {
    // TODO: Use EventEmitter with form value
    this.submitted = true;

  }

  validateAllFields(formGroup: FormGroup) {
    Object.keys(formGroup.controls).forEach((field) => {
      let fieldName = formGroup.get(field);
      if (fieldName instanceof FormControl && fieldName.validator) {
        if (isNaN(fieldName.value) && field != 'language') {
          fieldName.setValue(fieldName.value.replace(/ {2,}/g, ' ').trim());
        }
      }
    });
  }
  closeDialogClick(): void {
    this.dialogRef.close(false);
  }


  outHoleTotal = 0;
  // score in total
  calculateScoreOut(fieldName: any) {

    const scoreInValue = Number(this.scoreForm.value.score1) +
      Number(this.scoreForm.value.score2) +
      Number(this.scoreForm.value.score3) +
      Number(this.scoreForm.value.score4) +
      Number(this.scoreForm.value.score5) +
      Number(this.scoreForm.value.score6) +
      Number(this.scoreForm.value.score7) +
      Number(this.scoreForm.value.score8) +
      Number(this.scoreForm.value.score9);



    // const scoreOutValue=Number(this.scoreForm.value.score1)+Number(this.scoreForm.value.score2)+Number(this.scoreForm.value.score3)+Number(this.scoreForm.value.score4)+Number(this.scoreForm.value.score5)+Number(this.scoreForm.value.score6);Number(this.scoreForm.value.score7)+Number(this.scoreForm.value.score8)+Number(this.scoreForm.value.score9);
    this.summaryForm.controls.outTotal.setValue(scoreInValue);
    //  this.scoreForm.controls.pout.setValue(scoreOutValue);

    this.calculateBirdie(fieldName);
    this.calculateScoreDifferential();

  }
  onChangeHoles() {
    const value: any = this.scoreForm.value['holeNum'];

    for (let i = 1; i <= 18; i++) {
      if ((value == 9 && i < 9) || (value == 18)) {
        const keyName = 'score' + i;
        const controlName: any = this.scoreForm.controls[keyName];
        controlName.setValue('');
        controlName.enable();
      } else {
        const keyName = 'score' + i;
        const controlName: any = this.scoreForm.controls[keyName];
        controlName.setValue('');
        controlName.disable();
      }

    }
  }

  calculateBirdie(fieldName: any) {
    var class11 = 0;
    var countPar = 0;
    const keys = Object.keys(this.selectedCourse);
    if (keys.length > 0) {
      const keysArr = Object.keys(this.scoreForm.controls);
      let totalBirdie = 0;
      keysArr.forEach(keyName => {
        if (keyName.indexOf("score") >= 0) {
          console.log('keyName', keyName);
          const scoreValue = this.scoreForm.controls[keyName].value;
          if (scoreValue) {
            let field = keyName;
            field = field.replace('score', '');
            const parKey = "par" + field
            const parValue = this.selectedCourse[parKey];
            const actualParValue = scoreValue - parValue;


            // if (actualParValue<=0)
            // {
            //   totalBirdie = totalBirdie + actualParValue;
            // }

            switch (actualParValue) {
              case -1:

                class11 = class11 + 1;
                break;
              case -2:

                class11 = class11 + 2;
                break;
              case 0:
                class11 = class11 + 0;
                countPar = countPar + 1;

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
        }
      });

      this.summaryForm.controls.birdieTotal.setValue(class11);
      console.log("count of player", countPar)
    }
  }

  calculateScoreIn(fieldName: any) {

    const scoreOutValue = Number(this.scoreForm.value.score10) + Number(this.scoreForm.value.score11) + Number(this.scoreForm.value.score12) +
      Number(this.scoreForm.value.score13) +
      Number(this.scoreForm.value.score14) +
      Number(this.scoreForm.value.score15) +
      Number(this.scoreForm.value.score16) +
      Number(this.scoreForm.value.score17) +
      Number(this.scoreForm.value.score18);
    // const scoreOutValue=Number(this.scoreForm.value.score1)+Number(this.scoreForm.value.score2)+Number(this.scoreForm.value.score3)+Number(this.scoreForm.value.score4)+Number(this.scoreForm.value.score5)+Number(this.scoreForm.value.score6);Number(this.scoreForm.value.score7)+Number(this.scoreForm.value.score8)+Number(this.scoreForm.value.score9);
    this.summaryForm.controls.inTotal.setValue(scoreOutValue);
    //  this.scoreForm.controls.pout.setValue(scoreOutValue);

    this.calculateBirdie(fieldName);
    this.calculateScoreDifferential();

  }
  // Toaster msg function
  sweetAlertMsg(typeIcon: any, msg: any) {
    Swal.fire({
      toast: true,
      position: 'top',
      showConfirmButton: false,
      icon: typeIcon,
      timer: 5000,
      title: msg,
    });
  }



  // ------------------------------------


  getRoundDetails() {

    this.loader.start();
    this.service.getAPIMethod("/tournament/getTournamentRoundDetails?tourId=" + this.scoreForm.controls.tour_id.value).subscribe((APIResponse) => {
      this.loader.stop();
      if (APIResponse.error == '') {
        this.roundList = APIResponse.response.result;
        let currentIndex = 2;
        if (APIResponse.response.roundDetails) {
          this.roundList.forEach((round: any, index: any) => {

            // if (round.round_Id == APIResponse.response.roundDetails.round_Id) {

            //   if (this.roundList.length[index + 1]) {
            //     currentIndex = index + 1;
            //   }
            //   else{
            //     currentIndex=this.roundList.length-1;
            //   }
            // }
          });
        }
        
        //   this.scoreForm.controls.round_Id.setValue(this.roundList[currentIndex].round_Id);
        //    this.scoreForm.controls.cid.setValue(this.roundList[currentIndex].cid);

        // this.data.courseListing.forEach((course: any) => {

        //   if (course.cid == this.roundList[currentIndex].cid) {
        
        //   }
        // });


      }
    });
  }

  getGroupList() {
    this.roundList.forEach((round: any) => {
      if (round.round_Id == this.scoreForm.controls.round_Id.value) {
        this.scoreForm.controls.cid.setValue(round.cid);
        // this.onCourseChange(round.cid);
          
            this.data.courseListing.forEach((course: any) => {
debugger
                if (course.cid == round.cid) {
                  this.selectedCourse = course;
                }
              });



        this.service.getAPIMethod(`/course/getCourseTeeList?courseId=` + round.cid).subscribe((APIResponse: any) => {
          if (APIResponse.error == '') {
            this.teeNameList = APIResponse.response.result;
          }
        });
      }
    });


    this.service.getAPIMethod("/tournament/getTournamentGroups?tourId=" + this.scoreForm.controls.tour_id.value + "&roundId=" + this.scoreForm.controls.round_Id.value).subscribe((APIResponse) => {
      this.loader.stop();
      if (APIResponse.error == '') {
        this.groupList = APIResponse.response.result;
      }
    });
  }

  onChangeTeeName(event: any) {

    this.teeNameList.forEach((item: any) => {
      if (item.cRatingId == event.value) {
        this.slopeRate = item.slopeRating;
        this.courseRate = item.courseRating;
      }
    });
  }
  getPlayerList() {
    this.service.getAPIMethod("/tournament/getTournamentGroupPlayerList?tourId=" + this.scoreForm.controls.tour_id.value + "&roundId=" + this.scoreForm.controls.round_Id.value + "&groupId=" + this.scoreForm.controls.groupId.value).subscribe((APIResponse) => {
      if (APIResponse.error != 'X') {

        this.playerList = APIResponse.response.result;
      }

    })
  }

  onPlayerSelection() {
    this.playerList.forEach((player: any) => {
      if (player.playerId == this.scoreForm.controls.p_id.value) {
        this.scoreForm.controls.hdcp.setValue(player.hdcp);
      }
    });

  }

  onCourseChange(event: any) {


  }


  calculateScoreDifferential() {
    
    var ags = (this.summaryForm.controls.inTotal.value + this.summaryForm.controls.outTotal.value);
    var Diff1 = (ags - this.courseRate) * 113;
    var socreAvg = Diff1 / this.slopeRate;
    var rounded = Math.round(socreAvg * 10) / 10
    console.log("differnece", Diff1);
    console.log("after divide", socreAvg);

    this.summaryForm.controls.scoreDiff.setValue(rounded);

  }

}
