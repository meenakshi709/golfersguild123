import { Component, OnInit, ViewChild, Input, Output, EventEmitter } from '@angular/core';
import { MatPaginator } from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { TooltipPosition } from '@angular/material/tooltip';
import { FormControl } from '@angular/forms';
import { Observable } from 'rxjs';
import { CommonListProperties } from './common-properties';
import { Router } from '@angular/router';
import Swal from 'sweetalert2';
import { PaginationHelper } from './paginationHelper.service'

@Component({
  selector: 'app-common-list',
  templateUrl: './common-list.component.html',
  styleUrls: ['./common-list.component.css']
})
export class CommonListComponent implements OnInit {
  @Input()
  CommonListProperties!: CommonListProperties;
  @Input()
  moduleName!: string;
  @Input() permissions: any;

  @Output() onMenuItemClick = new EventEmitter<object>();
  @Output() onchangeClick = new EventEmitter<object>();
  @ViewChild(MatSort, { static: true })
  sort!: MatSort;
  @ViewChild(MatPaginator, { static: true })
  paginator!: MatPaginator;
  pageSizeOptions: any = [10, 20, 50, 100];
  dataObservable!: Observable<any>;
  positionOptions: TooltipPosition[] = ['above'];
  position = new FormControl(this.positionOptions[0]);
  isExpand: boolean = true;
  length: number;
  pageSize: number = 10;
  pageIndex: number = 0;

  constructor(public router: Router, private paginationHelper: PaginationHelper) {
    let pageObj = this.paginationHelper.getPageOptions();
    this.length = pageObj.length;
    this.pageSize = pageObj.pageSize;
    this.pageIndex = pageObj.pageIndex;
    this.paginationHelper.setPageOptions(this.pageSize, this.pageIndex, this.length)
  }
  ngOnInit() {
    this.CommonListProperties.miDataSource.paginator = this.paginator;
    this.CommonListProperties.miDataSource.sort = this.sort;
    this.CommonListProperties.miDataSource.sortingDataAccessor = (data, sortHeaderId) => data[sortHeaderId];
    this.length = this.CommonListProperties.miDataSource.data.length;
    this.pageSize = this.pageSize;
    this.pageIndex = this.pageIndex;
    this.paginationHelper.setPageOptions(this.pageSize, this.pageIndex, this.length)
  }

  menuItemClicked(nameOfItemClicked:any, obj:any, event:any, events?: any) {
    this.onMenuItemClick.emit({ name: nameOfItemClicked, data: obj, event: event, events: events });
  }
  isExpandToggle() {
    this.isExpand = !this.isExpand;
  }
  OnToggleChange(nameOfItemClicked:any, obj:any, event:any, events?: any) {
    
    if(this.moduleName=='Hardware'){this.moduleName='Device'}
    if(this.moduleName==' Hardware-Type'){
      this.moduleName='Device-Type';
    }
    if(this.moduleName==' Group'){ this.moduleName='Device Type Group'};
    if(this.moduleName==' Flight'){obj.field_name=obj.flight_code};
    events.target.checked = !events.target.checked;
    const isActive = obj.is_active == 1 ? 0 : 1;
    const text = isActive ? "activate " : "deactivate ";
    Swal.fire({
      title: isActive ? "Activate " + this.moduleName : "Deactivate " + this.moduleName,
      text: "Are you sure you want to " + text + " '" + obj.field_name + "'?",
      icon: "warning",
      showCancelButton: true,
      confirmButtonText: isActive ? " Yes, Activate" : " Yes, Deactivate",
      confirmButtonColor: '#89C045',
      showLoaderOnConfirm: true,
      customClass: {
        icon: isActive ? 'icon-success-class' : 'icon-warning-class',
        confirmButton: !isActive ? 'confirm-warning-class' : 'confirm-success-class',
      },

      allowOutsideClick: false
    }).then((result) => {
      if (result.isConfirmed) {
        this.onMenuItemClick.emit({ name: nameOfItemClicked, data: obj, event: event, events: events });
      }
    });
  }

  onRadioChange(nameOfItemClicked:any, obj:any, event:any, events?: any) {

    events.target.checked = !events.target.checked;
    Swal.fire({
      title: "Change Default " + this.moduleName,
      text: "Are you sure you want to change default " + " '" + obj.field_name + "'?",
      icon: "warning",
      showCancelButton: true,
      confirmButtonText: "Yes,Change",
      confirmButtonColor: '#89C045',
      showLoaderOnConfirm: true,
      allowOutsideClick: false
    }).then((result) => {
      if (result.isConfirmed) {
        this.onMenuItemClick.emit({ name: nameOfItemClicked, data: obj, event: event, events: events });
      }
    });
  }

  onPaginateChange(event:any) {
    document.body.scrollTop = document.documentElement.scrollTop = 0;
    this.pageIndex = event.pageIndex;
    this.pageSize = event.pageSize;
    this.paginationHelper.setPageOptions(this.pageSize, this.pageIndex, this.length);
  }


  /*****************Image display code  */
  imagesource(value:any){
    let a;
    a='/assets/uploadedmedia/'+value;
    return a;
  } 
    
      /************End code of image display ************/

}
