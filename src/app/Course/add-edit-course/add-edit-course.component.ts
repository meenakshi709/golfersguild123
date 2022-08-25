
import { Component, Inject, OnInit } from '@angular/core';
import { FormArray, FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { CommonServiceService } from 'src/app/Service/common-service.service';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import Swal from 'sweetalert2';
@Component({
  selector: 'app-add-edit-course',
  templateUrl: './add-edit-course.component.html',
  styleUrls: ['./add-edit-course.component.css']
})
export class AddEditCourseComponent implements OnInit {

  colorsList: any = [];
  courseForm: FormGroup = new FormGroup({
    cid: new FormControl('', []),
    c_code: new FormControl('', []),
    cname: new FormControl('', [Validators.required]),
    caddress: new FormControl('', [Validators.required]),
    par1: new FormControl('', [Validators.required]),
    par2: new FormControl('', [Validators.required]),
    par3: new FormControl('', [Validators.required]),
    par4: new FormControl('', [Validators.required]),
    par5: new FormControl('', [Validators.required]),
    par6: new FormControl('', [Validators.required]),
    par7: new FormControl('', [Validators.required]),
    par8: new FormControl('', [Validators.required]),
    par9: new FormControl('', [Validators.required]),
    par10: new FormControl('', [Validators.required]),
    par11: new FormControl('', [Validators.required]),
    par12: new FormControl('', [Validators.required]),
    par13: new FormControl('', [Validators.required]),
    par14: new FormControl('', [Validators.required]),
    par15: new FormControl('', [Validators.required]),
    par16: new FormControl('', [Validators.required]),
    par17: new FormControl('', [Validators.required]),
    par18: new FormControl('', [Validators.required]),
    pinn: new FormControl('', []),
    pout: new FormControl('', []),
    hdcp1: new FormControl('', [Validators.required]),
    hdcp2: new FormControl('', [Validators.required]),
    hdcp3: new FormControl('', [Validators.required]),
    hdcp4: new FormControl('', [Validators.required]),
    hdcp5: new FormControl('', [Validators.required]),
    hdcp6: new FormControl('', [Validators.required]),
    hdcp7: new FormControl('', [Validators.required]),
    hdcp8: new FormControl('', [Validators.required]),
    hdcp9: new FormControl('', [Validators.required]),
    hdcp10: new FormControl('', [Validators.required]),
    hdcp11: new FormControl('', [Validators.required]),
    hdcp12: new FormControl('', [Validators.required]),
    hdcp13: new FormControl('', [Validators.required]),
    hdcp14: new FormControl('', [Validators.required]),
    hdcp15: new FormControl('', [Validators.required]),
    hdcp16: new FormControl('', [Validators.required]),
    hdcp17: new FormControl('', [Validators.required]),
    hdcp18: new FormControl('', [Validators.required]),
    teeFormArray: new FormArray([]),
  })
  teeFormArray: FormArray = new FormArray([]);
  constructor(
    public dialogRef: MatDialogRef<AddEditCourseComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private formBuilder: FormBuilder,
    private service: CommonServiceService,
    public route: Router) { }

  //only number input
  keyPress(event: any) {
    const pattern = /^\d*\.?\d*$/;

    let inputChar = String.fromCharCode(event.charCode);
    if (event.keyCode != 8 && !pattern.test(inputChar)) {
      event.preventDefault();
    }
  }

  ngOnInit(): void {
    ;
    if (this.data) {
      this.courseForm.controls.cname.disable();
      this.setCourseDetails();
    }else
    {
      this.addTeeName('');
    }
    this.courseForm.controls.pinn.disable();
    this.courseForm.controls.pout.disable();


  }
  get getTeeFormArray() {

    return this.courseForm.get('teeFormArray') as FormArray
  }
  ngAfterViewInit(): void {

  }
  addTeeName(data: any) {
    const teeForm = new FormGroup({
      teeName: new FormControl(data ? data.teeName : '', [Validators.required, Validators.pattern(/^[a-zA-Z]*$/)]),
      courseRating: new FormControl(data ? data.courseRating : '', [Validators.required]),
      slopeRating: new FormControl(data ? data.slopeRating : '',[Validators.required]),
    });
    (this.courseForm.get('teeFormArray') as FormArray).push(teeForm);
  }
  deleteTeeName(i: any) {
    const formControl = (this.courseForm.get('teeFormArray') as FormArray);
    formControl.controls.splice(i, 1);
  }

  setCourseDetails() {
    const keys = Object.keys(this.data);
    const formGroup = this.courseForm.controls;
    console.log(keys);
    for (let i = 0; i < keys.length; i++) {
      const keyName = keys[i];
      if (keyName !== 'teeArray' && keyName !='is_deleted') {
        formGroup[keyName].setValue(this.data[keyName])
      }
    }
    if (this.data.teeArray.length > 0) {
      this.data.teeArray.forEach((record: any) => {
        this.addTeeName(record);
      });
    }
  }

  saveCourseDetails() {

    ;
    const data = this.courseForm.getRawValue();
    const teeNameArr: any = [];
    data.teeFormArray.forEach((itemDetails: any) => {
      const payload = itemDetails.teeName + '-' + itemDetails.courseRating + '-' + itemDetails.slopeRating;
      teeNameArr.push(payload);
    });
    data.teeNameArr = teeNameArr.join(',');
    this.service.postAPIMethod('/course/addCourse', data).subscribe(response => {
      // console.log("final",response);
      
      if (response.response.result.err != "X") {
        //  this.route.navigateByUrl("/course");
        this.dialogRef.close(true);
        this.sweetAlertMsg('success', response.response.result.msg);
      }
      else {
        this.sweetAlertMsg('error', response.response.result.msg);
      }
    });

  }

  calculateParIn() {

    const parInValue = Number(this.courseForm.value.par1) + Number(this.courseForm.value.par2) + Number(this.courseForm.value.par3) +
      Number(this.courseForm.value.par4) +
      Number(this.courseForm.value.par5) +
      Number(this.courseForm.value.par6) +
      Number(this.courseForm.value.par7) +
      Number(this.courseForm.value.par8) +
      Number(this.courseForm.value.par9);
    // const parOutValue=Number(this.courseForm.value.par1)+Number(this.courseForm.value.par2)+Number(this.courseForm.value.par3)+Number(this.courseForm.value.par4)+Number(this.courseForm.value.par5)+Number(this.courseForm.value.par6);Number(this.courseForm.value.par7)+Number(this.courseForm.value.par8)+Number(this.courseForm.value.par9);
    this.courseForm.controls.pinn.setValue(parInValue);
    //  this.courseForm.controls.pout.setValue(parOutValue);
    console.log("par", this.courseForm.value)


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

  calculateParOut() {

    const parOutValue = Number(this.courseForm.value.par10) + Number(this.courseForm.value.par11) + Number(this.courseForm.value.par12) +
      Number(this.courseForm.value.par13) +
      Number(this.courseForm.value.par14) +
      Number(this.courseForm.value.par15) +
      Number(this.courseForm.value.par16) +
      Number(this.courseForm.value.par17) +
      Number(this.courseForm.value.par18);

    // const parOutValue=Number(this.courseForm.value.par1)+Number(this.courseForm.value.par2)+Number(this.courseForm.value.par3)+Number(this.courseForm.value.par4)+Number(this.courseForm.value.par5)+Number(this.courseForm.value.par6);Number(this.courseForm.value.par7)+Number(this.courseForm.value.par8)+Number(this.courseForm.value.par9);
    this.courseForm.controls.pout.setValue(parOutValue);
    //  this.courseForm.controls.pout.setValue(parOutValue);
    console.log("par", this.courseForm.value)


  }

  // //get tee details 
  // getTeeColorsList() {

  //   this.service.getAPIMethod('/course/getTeeColors').subscribe(apliResponse => {
  //     ;
  //     // const apliResponse:any=response.response;
  //     console.log("country", apliResponse)
  //     if (apliResponse.error != 'X' && apliResponse.response.result.err != "X") {
  //       {
  //         this.colorsList = apliResponse.response.result;
  //       }

  //     }
  //   });
  // }


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
    this.dialogRef.close();
  }



}
