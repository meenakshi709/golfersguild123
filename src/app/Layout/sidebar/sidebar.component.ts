import { Router } from '@angular/router';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-sidebar',
  templateUrl: './sidebar.component.html',
  styleUrls: ['./sidebar.component.css']
})
export class SidebarComponent implements OnInit {
  userDetails: any;
  constructor(public route: Router) { }

  ngOnInit(): void {
    const data: any = localStorage.getItem('userDetails');
    this.userDetails = JSON.parse(data);
  }



  logout() {
    localStorage.clear();
    this.route.navigate(['/admin-login']);
  }

}
