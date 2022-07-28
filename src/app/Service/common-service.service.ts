import { HttpClient,HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, of, from } from 'rxjs';
import { catchError, map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';

@Injectable({
  providedIn: 'root'
})
export class CommonServiceService {
  httpOptions = {
    headers: new HttpHeaders({ 'Content-Type': 'application/json' }),
  };
 // baseURL:any = environment['serverUrl'];
  constructor(private http:HttpClient) { }
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

}
