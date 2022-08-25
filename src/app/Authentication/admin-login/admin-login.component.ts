import { Router } from '@angular/router';
import { Component, OnInit } from '@angular/core';
import { AbstractControl, FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import Swal from 'sweetalert2';
import { CommonServiceService } from '../../Service/common-service.service';

@Component({
  selector: 'app-admin-login',
  templateUrl: './admin-login.component.html',
  styleUrls: ['./admin-login.component.css']
})
export class AdminLoginComponent implements OnInit {
  hide = true;


  loginForm: FormGroup = new FormGroup({
    email: new FormControl('', [Validators.required, Validators.pattern(/^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/)]),
    password: new FormControl('', [Validators.required])

  })

  constructor(private formBuilder: FormBuilder,
    private service: CommonServiceService,
    public route: Router) { }

  ngOnInit(): void {

  }
  userLoggedIn() {
    const data = this.loginForm.getRawValue();
    this.service.postAPIMethod('/userLogin', data).subscribe(APIresponse => { 
      if (APIresponse.response.result[0].err == "X" ) {
        this.sweetAlertMsg("error", APIresponse.error ? APIresponse.error : APIresponse.response.result[0].msg);
       
      }
      else {
        ;
        const tokenKey = APIresponse.response.token ;
        sessionStorage.setItem('access-token',tokenKey);
        localStorage.setItem('userDetails',JSON.stringify(APIresponse.response.result[0]));
        this.route.navigateByUrl("/dashboard");
      }
    });

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

  sweetAlertMsg(typeIcon: any, msg: any) {
    console.log(typeIcon, msg)
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
