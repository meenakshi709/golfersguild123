import { HttpBackend, HttpClient,HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, of, from, Subscriber } from 'rxjs';
import { catchError, map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import Swal from 'sweetalert2';

@Injectable({
  providedIn: 'root'
})
export class CommonServiceService {
  httpOptions = {
    headers: new HttpHeaders({ 'Content-Type': 'application/json' }),
  };


  updated!: Subscriber<boolean>;
 // baseURL:any = environment['serverUrl'];
  constructor(private http:HttpClient, private httpbackend: HttpBackend) { }
getScoreApi()
{
  return this.http.get('/score');
}

getCourseApi()
{
  return this.http.get('/courseList');
}

deleteCourseApi(details:any)
{
 
  return this.http.delete('/dataApi/deleteCourse?id=',details);


}
getPlayerListApi()
{
  return this.http.get('/dataApi/players');
}


postContactApi(details:any){
  return this.http.post('/dataApi/contactdetails',details);
}


/**
   * Post API method
   * @param url
   * @param data 
   * @Developer Ankit
   */ 
 public postAPIMethod(url: any, postData: any): Observable<any> {
 // url= this.baseURL +url;
   console.log(postData);
  return this.http.post<any>(url, postData, this.httpOptions).pipe(
    map((res: any) => { return res; }), catchError(<T>(error: any, result?: T) => { return of(result as T); }));

}
/**
 * Get API Method 
 * @param url 
 * @Developer Ankit
 */ 
public getAPIMethod(url: any): Observable<any> {
 // url= this.baseURL +url;
  return this.http.get<any>(url).pipe(
    map((res: any) => { return res; }), catchError(<T>(error: any, result?: T) => { return of(result as T); }));
}




showToasterMsg(typeIcon: any, msg: any) {
  console.log(typeIcon, msg)
  Swal.fire({
    toast: true,
    position: 'top',
    showConfirmButton: false,
    icon: typeIcon,
    timer: 2000,
    title: msg,
  });
}



httpOptionsauth() {
  return {
    headers: new HttpHeaders({
      Authorization: 'Bearer ' + sessionStorage.getItem('access-token'),
   //   role_id:this.role?this.role:'',
      "Access-Control-Allow-Methods": "GET, POST,PUT,DELETE",
      // 'Content-Type': 'application/json'
    })
  };
}


public uploadImg(url: any, imgObj:any): Observable<any> {
  let http = new HttpClient(this.httpbackend);
  return http.post<any>(url, imgObj, this.httpOptionsauth()).pipe(
    map((res: any) => {
      this.updated.next(true);
      return res;
    }),
    catchError(<T>(error: any, result?: T) => {
      return of(result as T);
    })
  );
}



}
