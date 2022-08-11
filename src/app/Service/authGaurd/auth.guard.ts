
import { Injectable } from '@angular/core';
import { CanActivate, Router, CanDeactivate, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { Observable } from 'rxjs';
import Swal from 'sweetalert2';
import { CommonServiceService } from 'src/app/Service/common-service.service';
import { PaginationHelper } from 'src/app/Shared/common-Listing/paginationHelper.service';
@Injectable({
  providedIn: 'root',
})
export class AuthGuard implements CanActivate {
  isPermissionChanged: Boolean = false;
  isLogout: Boolean = false;
  constructor(
    private service: CommonServiceService,
    private router: Router,
    private paginationHelper: PaginationHelper) { }

  canActivate(): any {
    const accessToken = sessionStorage.getItem('access-token');
    const userDetails = localStorage.getItem('userDetails');
    if (accessToken && userDetails) {
      return true;

    } else {
      this.router.navigate(['/admin-login']);
      return false;
    }
  }
  canDeactivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot,
    nextState: RouterStateSnapshot) {
    this.paginationHelper.pageIndex = 0;
    this.paginationHelper.pageSize = 10;
    this.paginationHelper.length = 0;
    return true;
  }
}


