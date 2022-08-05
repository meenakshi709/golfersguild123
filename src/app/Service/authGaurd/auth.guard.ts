
import { Injectable } from '@angular/core';
import { CanActivate, Router, CanDeactivate, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { Observable } from 'rxjs';


// import { GlobalService } from '../services/global.service';
import Swal from 'sweetalert2';
import { CommonServiceService } from 'src/app/Service/common-service.service';
import { PaginationHelper } from 'src/app/Shared/common-Listing/paginationHelper.service';
@Injectable({
  providedIn: 'root',
})
export class AuthGuard implements CanActivate {
  isPermissionChanged: Boolean = false;
  isLogout: Boolean = false;
  constructor(private service: CommonServiceService,
    //  private authService: AuthService,
    private router: Router,
    // private globalService: GlobalService,
    private paginationHelper: PaginationHelper) { }

  // Authgaurd for if user login
  canActivate(): any {
    debugger;
    const accessToken = sessionStorage.getItem('access-token');
    const userDetails = localStorage.getItem('userDetails');
    if (accessToken && userDetails) {
      return true;
    } else {
      this.router.navigate(['/admin-login']);
    }
    // this.service.getAPIMethod('/permission/getModuleListByRole?roleId=' + role_id).subscribe((result) => {
    //   if (result.error === 'X') {
    //   } else {

    //     // this.isPermissionChange(result.result);
    //     // this.getUserRole(role_id);
    //     // this.getServerConfig();
    //   }
    //});
    // if (this.authService.isLoggedIn()) {
    //   return true;
    // } else {
    //   this.router.navigateByUrl('');
    //   return false;
    // }
    return true;

  }
  canDeactivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot,
    nextState: RouterStateSnapshot) {
    // return component.canExit();
    //alert( this.paginationHelper.pageSize )
    this.paginationHelper.pageIndex = 0;
    this.paginationHelper.pageSize = 10;
    this.paginationHelper.length = 0;
    return true;
  }

  // autoLogOut() {
  //   const userid = localStorage.getItem("id");
  //   this.globalService.getAPIMethod('/logout?userid=' + userid).subscribe((success) => {
  //     this.sweetAlertMsg('success', 'Dear user, your account access permissions are updated, please re-login');
  //     sessionStorage.removeItem("access-token");
  //     localStorage.removeItem("id");
  //     localStorage.removeItem("role_id");
  //     localStorage.removeItem('validity');
  //     localStorage.removeItem('userPermissions');
  //     // localStorage.removeItem("role_name");
  //     this.router.navigateByUrl("/signin");
  //   });
  // }

  // isPermissionChange(permissions: any) {
  //   const isLogout = false;
  //   const localStoragePrmsn: any = JSON.parse(localStorage.getItem('userPermissions'));
  //   if (localStoragePrmsn && permissions && permissions.length > 0) {
  //     localStoragePrmsn.forEach((item, index) => {
  //       if (permissions[index].moduleId == localStoragePrmsn[index].moduleId) {
  //         if (permissions[index].custom != localStoragePrmsn[index].custom ||
  //           permissions[index].all != localStoragePrmsn[index].all ||
  //           permissions[index].none != localStoragePrmsn[index].none || permissions[index].dashboardId != localStoragePrmsn[index].dashboardId) {
  //           if (!isLogout) {
  //             this.isLogout = true;
  //             this.autoLogOut()
  //           }
  //         }
  //         else {
  //           item.children.forEach((element, elementIndex) => {
  //             if (permissions[index].children[elementIndex].subModuleId == localStoragePrmsn[index].children[elementIndex].subModuleId) {
  //               if (permissions[index].children[elementIndex].is_read != localStoragePrmsn[index].children[elementIndex].is_read ||
  //                 permissions[index].children[elementIndex].is_write != localStoragePrmsn[index].children[elementIndex].is_write ||
  //                 permissions[index].children[elementIndex].deny_all != localStoragePrmsn[index].children[elementIndex].deny_all) {
  //                 if (!isLogout) {
  //                   this.isLogout = true;
  //                   this.autoLogOut()
  //                 }
  //               }
  //             }
  //           });
  //         }
  //       }
  //     });
  //   } else {
  //     if (!permissions || (permissions && permissions.length == 0)) {
  //       this.autoLogOut();
  //     }
  //   }
  // }
  // sweetAlertMsg(typeIcon, msg) {
  //   Swal.fire({
  //     toast: true,
  //     position: 'top',
  //     showConfirmButton: false,
  //     icon: typeIcon,
  //     timer: 5000,
  //     title: msg,
  //   });
  // }

  // getUserRole(prevRoleId) {
  //   this.globalService.getAPIMethod('/getUserRole').subscribe(resp => {
  //     if (resp.error) {
  //       this.sweetAlertMsg('error', 'Something went wrong');
  //     } else {
  //       if (prevRoleId != resp.result.role_id) {
  //         this.autoLogOut();
  //       }
  //     }
  //   })
  // }
  // getServerConfig() {
  //   this.globalService.getAPIMethod('/display/getServerConfiguration').subscribe((response) => {
  //     if (response.error == '') {
  //       this.globalService.alarmStatus = response.result[1].value;
  //     }
  //   });

  // }
}


