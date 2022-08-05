// import { AuthgaurdService } from './../gaurd/authgaurd.service';
import { Injectable } from "@angular/core";
import { HttpHeaders } from "@angular/common/http";
Injectable()
export class AuthgaurdService{
    httpOptions={
        Headers:new HttpHeaders({'Content-Type': 'application/json'}),
    };
    
    
    constructor(){}
    setToken(token:any){
        localStorage.setItem('authorization',token)
    }
    getToken(){
        return localStorage.getItem('authorization')
    }
    isAuthorized(){
        return Boolean(localStorage.getItem('authorization'))
    }
    isLoggedIn(url:any){
        // console.log(url)
      var lastUrl = url.substring(url.lastIndexOf("/"), url.length);
        if(localStorage.getItem('authorization')===undefined || localStorage.getItem('authorization')==='' ||
         localStorage.getItem('authorization')===null){
            return false;
        }else{
            let returnPermission:boolean=false;
            let getpermissions:any=localStorage.getItem('permissions')
            let localroutes= (JSON.parse(getpermissions));
            // console.log("===",lastUrl)
            const hasPermission = localroutes.filter((p:any) =>
                p.module_url===lastUrl
            );
            // console.log("=====",hasPermission)
            if(lastUrl=='/modules'||lastUrl=='/dashboard'||lastUrl=='/userProfile'||lastUrl=='/changepassword'
            || '/AddRules' || '/listProducts'){
                returnPermission=true;
            }
            else if (hasPermission.length>0) {
                returnPermission=true;
            }else if(hasPermission.length==0){
                returnPermission=false;
            } 
            return returnPermission; 
            
        }
    }
    userProfileDetails() {
        let token = this.getToken();
        let payload;
        if (token) {
          payload = atob(token.split('.')[1]);
          return JSON.parse(payload);
        } else {
          return null;
        }
      }

}