
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
    let token = sessionStorage.getItem('access-token');
    const isLoggedIn=true;
    if (isLoggedIn) {
      request = request.clone({
        setHeaders: {
          Authorization: 'Bearer ' + token,
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
          let code = event.status ? event.status : 0;
          if (code == 401 && event.body.error == 'X') {      
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
