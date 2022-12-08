import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { NgxUiLoaderService } from 'ngx-ui-loader';
import { forkJoin } from 'rxjs';
import { CommonServiceService } from 'src/app/Service/common.service';
import Swal from 'sweetalert2';
@Component({
  selector: 'app-add-edit-leaderboard',
  templateUrl: './add-edit-leaderboard.component.html',
  styleUrls: ['./add-edit-leaderboard.component.css']
})
export class AddEditLeaderboardComponent implements OnInit {
  class11: any = 0;
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
  public scoreForm: FormGroup = new FormGroup({
    tour_score_Id: new FormControl('', []),
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
    ags1: new FormControl('', []),
    ags2: new FormControl('', []),
    ags3: new FormControl('', []),
    ags4: new FormControl('', []),
    ags5: new FormControl('', []),
    ags6: new FormControl('', []),
    ags7: new FormControl('', []),
    ags8: new FormControl('', []),
    ags9: new FormControl('', []),
    ags10: new FormControl('', []),
    ags11: new FormControl('', []),
    ags12: new FormControl('', []),
    ags13: new FormControl('', []),
    ags14: new FormControl('', []),
    ags15: new FormControl('', []),
    ags16: new FormControl('', []),
    ags17: new FormControl('', []),
    ags18: new FormControl('', []),
  });
  summaryForm: FormGroup = new FormGroup({
    agsTotal: new FormControl(0, []),
    inTotal: new FormControl(0, []),
    outTotal: new FormControl(0, []),
    grossTotal: new FormControl(0, []),
    netTotal: new FormControl(0, []),
    birdieTotal: new FormControl(0, []),
    scoreDiff: new FormControl(0, []),
  });
  constructor(
    public dialogRef: MatDialogRef<AddEditLeaderboardComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    public loader: NgxUiLoaderService,
    private formBuilder: FormBuilder,
    private service: CommonServiceService,
    public route: Router) { }
  ngOnInit(): void {
    for (let i = 1; i <= 18; i++) {
      const agsKeyName = "ags" + i;
      const scoreKeyName = "score" + i;
      this.scoreForm.controls[agsKeyName].disable();
      if (!this.data.selectedRecordDetails) {
        this.scoreForm.controls[scoreKeyName].disable();
      }
    }
    if (this.data.selectedRecordDetails) {
      this.scoreForm.controls['tour_score_Id'].setValue(this.data.selectedRecordDetails['tour_score_id']);
      this.scoreForm.controls['tour_id'].setValue(this.data.selectedRecordDetails['tour_id']);
      this.getRoundDetails();
    }
    this.scoreForm.controls['cid'].disable();
  }
  setScoreDetails() {
    const keys = Object.keys(this.data.selectedRecordDetails);
    for (let i = 0; i < keys.length; i++) {
      const keyName = keys[i];
      if (this.scoreForm.controls[keyName]) {
        this.scoreForm.controls[keyName].disable();
        if (keyName.indexOf('score') > -1) {
          this.scoreForm.controls[keyName].enable();
          this.scoreForm.controls[keyName].setValue(this.data.selectedRecordDetails[keyName]);
          const digit: any = (keyName.replace('score', ''));
          if (Number(digit) < 10) {
            this.calculateScoreOut(keyName)
          } else {
            this.calculateScoreIn(keyName)
          }
        }
      }
    }
    this.summaryForm.controls.scoreDiff.setValue(Number(this.data.selectedRecordDetails.scoreDifferential));
    this.scoreForm.controls['hdcp'].setValue(this.data.selectedRecordDetails['hdcp']);
  }
  saveScoreDetails() {
    this.calculateScoreDifferential();
    const data = this.scoreForm.getRawValue();
    const data1 = this.summaryForm.getRawValue();
    data1.grossTotal = this.summaryForm.controls.inTotal.value + this.summaryForm.controls.outTotal.value;
    data1.netTotal = (this.summaryForm.controls.inTotal.value + this.summaryForm.controls.outTotal.value) - (this.scoreForm.controls.hdcp.value);
    let enteredHoleCount = 0;
    for (let i = 1; i <= data.holeNum; i++) {
      const controlName = 'score' + i;
      if (data[controlName] > 0) {
        enteredHoleCount++;
      }
      data.enteredHoleCount = enteredHoleCount;
    }
    let finalData = { ...data, ...data1 };
    this.service.postAPIMethod('/tournament/savetournamentScore', finalData).subscribe(APIresponse => {
      if (APIresponse.error == '') {
        if (APIresponse.response.result.err == '') {
          this.sweetAlertMsg("success", APIresponse.response.result.msg);
          this.dialogRef.close(true);
        } else {
          this.sweetAlertMsg("error", APIresponse.response.result.msg);
        }
      }
      else {
        this.sweetAlertMsg("error", APIresponse.response.msg);
      }
    });
  }
  calculateResult() {
    let class11: any;
    this.service.getCourseApi().subscribe({
      next: (response: any) => {
        if (response && response.response.length > 0) {
          var dataa = response.response;
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
    // console.log("hole count=", this.holeCount)
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
    // var class11 = 0;
    var countPar = 0;
    const keys = Object.keys(this.selectedCourse);
    if (keys.length > 0) {
      const keysArr = Object.keys(this.scoreForm.controls);
      let totalBirdie = 0;
      keysArr.forEach(keyName => {
        if (keyName.indexOf("score") >= 0) {
          // console.log('keyName', keyName);
          const scoreValue = this.scoreForm.controls[keyName].value;
          if (scoreValue && keyName == fieldName) {
            let field = keyName;
            field = field.replace('score', '');
            const parKey = "par" + field
            const parValue = this.selectedCourse[parKey];
            const actualParValue = scoreValue - parValue;
            const hdcpKey = "hdcp" + field;
            const hdcpValue = this.selectedCourse[hdcpKey];
            this.calculateAgs(fieldName, parValue, hdcpValue, scoreValue);
            switch (actualParValue) {
              case -1:
                this.class11 = this.class11 + 1;
                break;
              case -2:
                this.class11 = this.class11 + 2;
                break;
              case 0:
                this.class11 = this.class11 + 0;
                countPar = countPar + 1;
                break;
              default:
                this.class11 = this.class11 + 0;
            }
          }
        }
      });
      this.summaryForm.controls.birdieTotal.setValue(this.class11);
      // console.log("count of player", countPar)
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
  // Toaster msg functio
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
        // let currentIndex = 2;
        if (APIResponse.response.roundDetails) {
          if (this.data.selectedRecordDetails) {
            this.scoreForm.controls['round_Id'].setValue(this.data.selectedRecordDetails['round_Id']);
            this.getGroupList();
          }
        }
      }
    });
  }
  getGroupList() {
    this.roundList.forEach((round: any) => {
      if (round.round_Id == this.scoreForm.controls.round_Id.value) {
        this.scoreForm.controls.cid.setValue(round.cid);
        this.data.courseListing.forEach((course: any) => {
          if (course.cid == round.cid) {
            this.selectedCourse = course;
          }
        });
        const teeList = this.service.getAPIMethod(`/course/getCourseTeeList?courseId=` + round.cid);
        const groupList = this.service.getAPIMethod("/tournament/getTournamentGroups?tourId=" + this.scoreForm.controls.tour_id.value + "&roundId=" + this.scoreForm.controls.round_Id.value)
        forkJoin([teeList, groupList]).subscribe((res: any) => {
          if (res[0].error == '' && res[1].error == '') {
            this.teeNameList = res[0].response.result;
            this.groupList = res[1].response.result;
            if (this.data.selectedRecordDetails) {
              debugger;
              this.scoreForm.controls['groupId'].setValue(Number(this.data.selectedRecordDetails['groupId']));
              this.scoreForm.controls['teeName'].setValue(Number(this.data.selectedRecordDetails['teeName']));
              this.teeNameList.forEach((item: any) => {

                if (item.cRatingId == this.data.selectedRecordDetails['teeName']) {
                  this.slopeRate = item.slopeRating;
                  this.courseRate = item.courseRating;
                }
              });
              this.getPlayerList();
            }
          } else {
            this.sweetAlertMsg('error', 'Please try again after sometime')
          }
        });
      }
    });
  }
  onChangeTeeName(event: any) {
    for (let i = 1; i <= 18; i++) {
      const scoreKeyName = "score" + i;
      this.scoreForm.controls[scoreKeyName].enable();
    }
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
        if (this.data.selectedRecordDetails) {
          this.scoreForm.controls['p_id'].setValue(this.data.selectedRecordDetails['p_id']);
          this.setScoreDetails();
        }
      }
    })
  }
  onPlayerSelection() {
    this.playerList.forEach((player: any) => {
      if (player.playerId == this.scoreForm.controls.p_id.value) {
        debugger;
        this.scoreForm.controls.hdcp.setValue(Math.round(player.hdcp));
      }
    });
  }
  onCourseChange(event: any) {
  }
  calculateScoreDifferential() {

    let ags = Number(this.scoreForm.controls.ags1.value) + Number(this.scoreForm.controls.ags2.value) +
      Number(this.scoreForm.controls.ags3.value) + Number(this.scoreForm.controls.ags4.value) +
      Number(this.scoreForm.controls.ags5.value) + Number(this.scoreForm.controls.ags6.value) +
      Number(this.scoreForm.controls.ags7.value) + Number(this.scoreForm.controls.ags8.value) +
      Number(this.scoreForm.controls.ags9.value) + Number(this.scoreForm.controls.ags10.value) +
      Number(this.scoreForm.controls.ags11.value) + Number(this.scoreForm.controls.ags12.value) +
      Number(this.scoreForm.controls.ags13.value) + Number(this.scoreForm.controls.ags14.value) +
      Number(this.scoreForm.controls.ags15.value) + Number(this.scoreForm.controls.ags16.value) +
      Number(this.scoreForm.controls.ags17.value) + Number(this.scoreForm.controls.ags18.value);
    var Diff1 = (ags - this.courseRate) * 113;
    var socreAvg = Diff1 / this.slopeRate;
    var rounded = Math.round(socreAvg * 10) / 10

    this.summaryForm.controls.scoreDiff.setValue(rounded);
  }
  calculateAgs(fieldName: any, parValue: any, hdcpValue: any, scoreValue: any) {
    let hdcp = 0;
    let ags = 0;
    this.playerList.forEach((element: any) => {
      if (element.playerId == this.scoreForm.controls.p_id.value) {
        hdcp = element.hdcp;
      }
    });
    const actualParValue = scoreValue - parValue;

    if (actualParValue > 2) {
      if (hdcpValue <= hdcp) {
        ags = parValue + 3;
      }
      else {
        ags = parValue + 2;
      }
    }
    else {
      ags = scoreValue;
    }
    const fieldNum = fieldName.replace("score", '');
    const newFieldName = "ags" + fieldNum;
    this.scoreForm.controls[newFieldName].setValue(ags);
  }
}
