
import { ElementRef, Injectable, ViewChild } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor,
  HttpResponse
} from '@angular/common/http';
import { Observable } from 'rxjs';
import { Router } from '@angular/router';
import { map, catchError } from 'rxjs/operators';
import { NgxUiLoaderService } from 'ngx-ui-loader';
import { MAT_DIALOG_DATA, MatDialogRef, MatDialog } from '@angular/material/dialog';
import Swal from 'sweetalert2';
import { CommonServiceService } from '../common-service.service';


@Injectable()
export class RootInterceptor implements HttpInterceptor {
  infoObject: any;
  user_id: any;
 
  constructor(private router: Router, private GlobalService: CommonServiceService, 
    private ngxLoader: NgxUiLoaderService, private _dialog: MatDialog) { }

  intercept(
    request: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {
    // add auth header with jwt if user is logged in and request is to the api url
    const userDetails:any = localStorage.getItem('userDetails')
    let token = localStorage.getItem('authorization');
    debugger;
    if (userDetails && token) {
     

      request = request.clone({
        setHeaders: {
          Authorization: 'Bearer ' + token,
          role_id: userDetails['roleId'] ? userDetails.roleId : '',
          "Access-Control-Allow-Methods": "GET, POST,PUT,DELETE",
          'Content-Type': 'application/json'
        },
      });
    } else {
      this.router.navigateByUrl('admin-login');
    }
    return next.handle(request).pipe(
      map((event: HttpEvent<any>) => {
        if (event instanceof HttpResponse) {
          // console.log("hgfghfhgf", event.body.data)
          let code = event.body.data.statusCode ? event.body.data.statusCode : 0;
          // debugger;
          if (code == 401 && event.body.data.error == 'X') {
            // this.sessionExpired();
            this.logout();
          }
         
        }
        return event;
      }),
    )
  }
  
  logout() {
    localStorage.clear();
    sessionStorage.clear();
    this.router.navigateByUrl('login');
  }
  public onClose(): void {
    this._dialog.closeAll();
  }

}
