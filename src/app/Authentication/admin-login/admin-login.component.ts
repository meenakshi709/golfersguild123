/*
 ModifiedBy-Meenaxi Dhariwal
ModifiedOn-30-09-2022
Purpose:login Details 
*/
import { Router } from '@angular/router';
import { Component, OnInit } from '@angular/core';
import { AbstractControl, FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import Swal from 'sweetalert2';
import { CommonServiceService } from '../../Service/common.service';

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
  //This methos is used for login details verified
  onClickLogin() {

    if (this.loginForm.valid) {
      const data = this.loginForm.getRawValue();
      this.service.postAPIMethod('/userLogin', data).subscribe((res: any) => {
        debugger;
        const apiResponse = res.response;
        if (res.error == "") {
          const tokenKey = apiResponse.token;
          sessionStorage.setItem('access-token', tokenKey);
          localStorage.setItem('userDetails', JSON.stringify(apiResponse.result[0]));
           this.route.navigateByUrl("/tournament");
        }
        else {
          this.service.showToasterMsg("error", apiResponse.msg);
        }
      });
    }

  }
}
