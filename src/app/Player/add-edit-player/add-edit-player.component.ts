import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { CommonServiceService } from 'src/app/Service/common.service';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-add-edit-player',
  templateUrl: './add-edit-player.component.html',
  styleUrls: ['./add-edit-player.component.css']
})
export class AddEditPlayerComponent implements OnInit {

  stateList:any=[];
  hide = true;
  countryList:any=[];
  submitted = false;

  PlayerForm: FormGroup = new FormGroup({
    p_id: new FormControl('', []),
   // playerName:new FormControl('', []),
    userName: new FormControl('', [Validators.required]),
    firstName:new FormControl('', [Validators.required]),
    lastName:new FormControl('', [Validators.required]),
    email: new FormControl('', [Validators.required]),
    contactNumber: new FormControl('', [Validators.required, Validators.pattern("^[0-9]*$"),
    Validators.minLength(10), Validators.maxLength(10)]),  
    gender: new FormControl('', []),
    dob: new FormControl('', []),
    country_Id :new FormControl('', [Validators.required]),
    state_Id:new FormControl('', [Validators.required]),
    profileImg:new FormControl('', []),
    password:new FormControl('', [Validators.required]),
    isWebUser:new FormControl(1, []),
    isFirstLogin:new FormControl(0, [])
  })
  constructor(
    public dialogRef: MatDialogRef<AddEditPlayerComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private formBuilder: FormBuilder,
    private service: CommonServiceService,
    public route: Router) { }

    get f() { return this.PlayerForm.controls; }

    keyPress(event: any) {
      const pattern = /[0-9\+\-\ ]/;
   
      let inputChar = String.fromCharCode(event.charCode);
      if (event.keyCode != 8 && !pattern.test(inputChar)) {
        event.preventDefault();
      }
    }

  ngOnInit(): void {
    console.log("data=", this.data);
   this.PlayerForm.controls.state_Id.disable();
    this.getCountryList();
    if (this.data) {
      this.setPlayerDetails();
       }
  }



  setPlayerDetails() {
    
    const keys = Object.keys(this.data);
    const formGroup = this.PlayerForm.controls;
    console.log(keys);
    for (let i = 0; i < keys.length; i++) {
      const keyName = keys[i];
      formGroup[keyName].setValue(this.data[keyName])
    }
  }



  //save player details 
  savePlayerDetails() {
    const data = this.PlayerForm.getRawValue();
    this.service.postAPIMethod('/addUpdateUser', data).subscribe(response => {
      
      console.log("player data",response.response)
      if (response.response.err != "X") {
        //  this.route.navigateByUrl("/course");
        this.dialogRef.close(true);
        this.sweetAlertMsg('success',response.response.msg);
      }
      else {
        this.sweetAlertMsg('error',response.response.msg);
      }
    });

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

    //get state details 
  getStatesList() {

    this.service.getAPIMethod('/getStates?countryId='+this.PlayerForm.controls.country_Id.value).subscribe(response => {
      const apliResponse:any=response.response;

          if(apliResponse.error!='X')
          {
            this.PlayerForm.controls.state_Id.enable();
            this.stateList=apliResponse.result;
          }

    })
   }
   //get state details 
   getCountryList() {

    this.service.getAPIMethod('/getCountryList').subscribe(response => {
      const apliResponse:any=response.response;
      console.log("country",apliResponse)
          if(apliResponse.error!='X')
          {
            this.countryList=apliResponse.result;
          }

    })
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
    this.dialogRef.close();
  }

//country change function
  onCountryChange()
  {
    console.log("countjkjk",this.PlayerForm.controls.country_Id.value);
    this.getStatesList();
  }

// uplaod file
Uploadedfile:any;
imageUrl:any='';
uploadFile(event:any,fileInput:any) {
  let reader = new FileReader(); // HTML5 FileReader API
  let file = event.target.files[0];
  if (event.target.files && event.target.files[0]) {
    let fileType = file.name.substring(file.name.lastIndexOf('.') + 1).toLowerCase();
    if (fileType === "jpg" || fileType === "png" || fileType === "jpeg") {
      if (file.size < 28097 && file.size > 1097) {
        this.Uploadedfile=file;
        reader.readAsDataURL(file);
        // When file uploads set it to file formcontrol
        reader.onload = () => {
          this.imageUrl = reader.result;
         
          // this.companyForm.patchValue({
          //   file: reader.result
          // });
          fileInput.value = "";  
        }
      } else {
        fileInput.value = "";
        this.sweetAlertMsg('error', 'Please select image size greater than 1kb and less than 28kb');
      }
    } else {
      fileInput.value = "";
      this.sweetAlertMsg('error', 'Please choose this type of image format. jpg, png, jpeg');
    }
 
  }
}

}
