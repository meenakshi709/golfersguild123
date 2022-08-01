import { AfterViewInit, Component, OnInit, ViewChild } from '@angular/core';
import { FormControl, FormGroup, Validators} from '@angular/forms';
import { Router } from '@angular/router';
import { CommonServiceService } from '../../Service/common-service.service';

@Component({
  selector: 'app-contact-page',
  templateUrl: './contact-page.component.html',
  styleUrls: ['./contact-page.component.css']
})
export class ContactPageComponent implements OnInit {


  constructor(private service:CommonServiceService,public route: Router) { }

  userGroupForm = new FormGroup({
    name: new FormControl('', [Validators.required, Validators.minLength(3)]),
    email: new FormControl('', [Validators.required, Validators.email]),
    phn: new FormControl('', [Validators.required, Validators.minLength(10),Validators.maxLength(10)]),
    subject: new FormControl('', Validators.required),
    msg: new FormControl('', Validators.required)
  });
  
  get f(){
    return this.userGroupForm.controls;
  }
  
  submit(){
   
    if (this.userGroupForm.invalid) {
      return;
    }
    let roleObj = {
      gname: this.userGroupForm.value.name.replace(/ {2,}/g, ' ').trim(),
      gemail: (this.userGroupForm.value.email === undefined || this.userGroupForm.value.email === null) ? '' : this.userGroupForm.value.email.replace(/ {2,}/g, ' ').trim(),
      phone: (this.userGroupForm.value.phn === undefined || this.userGroupForm.value.phn === null) ? '' : this.userGroupForm.value.phn.replace(/ {2,}/g, ' ').trim(),
      subject: (this.userGroupForm.value.subject === undefined || this.userGroupForm.value.subject === null) ? '' : this.userGroupForm.value.subject.replace(/ {2,}/g, ' ').trim(),
      msg: (this.userGroupForm.value.msg === undefined || this.userGroupForm.value.msg === null) ? '' : this.userGroupForm.value.msg
    }

    const data = this.userGroupForm.getRawValue();
    this.service.postAPIMethod('/contactdetails', data).subscribe(APIresponse => {
  
      if (APIresponse.response.result.err == "") {
 //       const tokenKey = APIresponse.response.result.token;
        this.route.navigateByUrl("/thankyou");
      }
      else {
     //   this.sweetAlertMsg("error", APIresponse.error ? APIresponse.error : APIresponse.response.result.msg);
      }
  
    //  console.log("result is",APIresponse);

 
     });

   
  }



  


  ngOnInit(): void {

  }
  


}
