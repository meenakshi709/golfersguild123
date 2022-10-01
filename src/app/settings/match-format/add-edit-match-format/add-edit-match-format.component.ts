import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { NgxUiLoaderService } from 'ngx-ui-loader';
import { CommonServiceService } from 'src/app/Service/common.service';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-add-edit-match-format',
  templateUrl: './add-edit-match-format.component.html',
  styleUrls: ['./add-edit-match-format.component.css']
})
export class AddEditMatchFormatComponent implements OnInit {
  submitted = false;

  constructor(
    public dialogRef: MatDialogRef<AddEditMatchFormatComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    public loader: NgxUiLoaderService,
    private formBuilder: FormBuilder,
    private service: CommonServiceService,
    public route: Router) { }

  ngOnInit(): void {
    console.log("data=", this.data);
    if (this.data) {
      //  this.scoreForm.controls.cname.disable();
        this.setFormatDetails();

    }
  }


  public formatForm: FormGroup = new FormGroup({
    formatId: new FormControl(''),
    formatName: new FormControl('', [Validators.required]),

  });

  setFormatDetails() {
    const keys = Object.keys(this.data);
    const formGroup = this.formatForm.controls;

    for (let i = 0; i < keys.length; i++) {
      const keyName = keys[i];
      formGroup[keyName].setValue(this.data[keyName])
    }
  }


  saveFormatDetails() {  
    
    const data = this.formatForm.getRawValue();
   
    
    
  
 debugger
    this.service.postAPIMethod('/tournament/addEditTournamentFormat', data).subscribe(APIresponse => {
      // console.log("final",response);
debugger
      if (APIresponse.error != 'X') {

        this.closeDialogClick();
        this.sweetAlertMsg("success", APIresponse.response.result.msg)
      }
      else {
        this.sweetAlertMsg("error", APIresponse.response.msg);
      }
    });

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


}
