import { Router } from '@angular/router';
import { Injectable } from '@angular/core';
import {HttpRequest,HttpHandler,HttpEvent,HttpInterceptor} from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
// import { UserHTTPService } from './userHttp.service';

@Injectable()
export class ErrorInterceptor implements HttpInterceptor {
  constructor(public router:Router) { }

  intercept(
    request: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {
    return next.handle(request).pipe(
      catchError((err) => {
        if (err.status === 401) {
        
          // auto logout if 401 response returned from api
        //   this.userService.logoutUser('/logout');
        }

        const error = err.error.message || err.statusText;
        return throwError(error);
      })
    );
  }

}
