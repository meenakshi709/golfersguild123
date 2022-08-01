import { Router } from '@angular/router';
import { Component, OnInit } from '@angular/core';
import { AbstractControl, FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import Swal from 'sweetalert2';
import { CommonServiceService } from 'src/app/Service/common-service.service';


@Component({
  selector: 'app-client',
  templateUrl: './client.component.html',
  styleUrls: ['./client.component.css']
})
export class ClientComponent implements OnInit {

  hide = true;


  clientSignup: FormGroup = new FormGroup({
    email: new FormControl('', [Validators.required, Validators.pattern(/^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/)]),
    password: new FormControl('', [Validators.required])

  })

  constructor(private formBuilder: FormBuilder,
    private service: CommonServiceService,
    public route: Router) { }

  ngOnInit(): void {

  }
  userLoggedIn() {
    const data = this.clientSignup.getRawValue();
    this.service.postAPIMethod('/userLogin', data).subscribe(APIresponse => {
      if (APIresponse.response.result.err == "") {
        const tokenKey = APIresponse.response.result.token;
        this.route.navigateByUrl("/dashboard");
      }
      else {
        this.sweetAlertMsg("error", APIresponse.error ? APIresponse.error : APIresponse.response.result.msg);
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
