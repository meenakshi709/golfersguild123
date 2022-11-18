import { response } from 'express';

import { Component, OnInit } from '@angular/core';
import { CommonListProperties } from '../../Shared/common-Listing/common-properties';
import { CommonListMenu } from '../../Shared/common-Listing/common-list-menu';
import { CommonListMenuItem } from '../../Shared/common-Listing/common-list-menu-item';
import { CommonServiceService } from 'src/app/Service/common.service';
import { MatTableDataSource } from '@angular/material/table';
import { MatDialog } from '@angular/material/dialog';
import { AddEditCourseComponent } from '../add-edit-course/add-edit-course.component';
import { NgxUiLoaderService } from 'ngx-ui-loader';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-course-listing',
  templateUrl: './course-listing.component.html',
  styleUrls: ['./course-listing.component.css']
})
export class CourseListingComponent implements OnInit {
  courseList: CommonListProperties = new CommonListProperties();
  isLoadingDone: boolean = false;
  constructor(private service: CommonServiceService, public dialog: MatDialog, public loader: NgxUiLoaderService) { }

  ngOnInit(): void {
    this.getCourseList();
  }

  getCourseList() {
    this.loader.start();
    this.service.getAPIMethod('/courseList').subscribe((response) => {
      this.loader.stop();
      const data: any = response;

      if (data.error == '') {
        this.isLoadingDone = true;
        //  this.roleList.url = '/getRolesList';

        this.courseList.miDataSource = new MatTableDataSource(data.response.result);
        this.courseList.columnLabels = ['Course Name', 'Address',  'Par 1', 'Par 2', 'Par 3', 'Par 4', 'Par 5', 'Par 6', 'Par 7', 'Par 8', 'Par 9', 'Sum Out', 'Par 10', 'Par 11', 'Par 12', 'Par 13', 'Par 14', 'Par 15', 'Par 16', 'Par 17', 'Par 18', 'Sum In', 'HDCP 1', 'HDCP 2', 'HDCP 3', 'HDCP 4', 'HDCP 5', 'HDCP 6', 'HDCP 7', 'HDCP 8', 'HDCP 9', 'HDCP 10', 'HDCP 11', 'HDCP 12', 'HDCP 13', 'HDCP 14', 'HDCP 15', 'HDCP 16', 'HDCP 17', 'HDCP 18', 'Action'];
        this.courseList.displayedColumns = ['cname', 'caddress', 'par1', 'par2', 'par3', 'par4', 'par5', 'par6', 'par7', 'par8', 'par9', 'pout', 'par10', 'par11', 'par12', 'par13', 'par14', 'par15', 'par16', 'par17', 'par18', 'pinn', 'hdcp1', 'hdcp2', 'hdcp3', 'hdcp4', 'hdcp5', 'hdcp6', 'hdcp7', 'hdcp8', 'hdcp9', 'hdcp10', 'hdcp11', 'hdcp12', 'hdcp13', 'hdcp14', 'hdcp15', 'hdcp16', 'hdcp17', 'hdcp18', 'Action'];

        this.courseList.miListMenu = new CommonListMenu();
        this.courseList.miListMenu.menuItems =
          [
            new CommonListMenuItem('Edit', 1, true, false, null, 'edit_icon'),
            new CommonListMenuItem('Delete', 2, true, true, null, 'delete_icon'),
          ];
      } else {
this.sweetAlertMsg('error',data.response.msg);

      }
    });
  }

  applyFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.courseList.miDataSource.filter = filterValue.trim().toLowerCase();


  }


  saveCourseDetails(clickedRecordDetails: any) {
if(clickedRecordDetails)
{


    this.service.getAPIMethod(`/course/getCourseTeeList?courseId=` + clickedRecordDetails.cid).subscribe((APIResponse: any) => {
      if (APIResponse.error == '') {
        clickedRecordDetails.teeArray = APIResponse.response.result;
        this.addEditCourseDialog(clickedRecordDetails);
      } else {
        this.sweetAlertMsg('error', APIResponse.msg);
      }
    });
  }
  else{
    this.addEditCourseDialog(clickedRecordDetails);
  }
  }



addEditCourseDialog(clickedRecordDetails:any){
  const dialogRef = this.dialog.open(AddEditCourseComponent, {
    data: clickedRecordDetails,
    width: '80%',
    height: '600px',

  });
  dialogRef.afterClosed().subscribe(result => {
    if (result) {
      this.getCourseList();
    }
  }); 
}
  onCourseActionClick(clickedRecord: any) {

    if (clickedRecord.name == 'Edit') {
      this.saveCourseDetails(clickedRecord.data)
    }
    else if (clickedRecord.name == 'Delete') {
      this.deleteCourse(clickedRecord.data)
    }
  }



  deleteCourse(clickedrecord: any) {

    Swal.fire({
      title: 'Delete Course',
      text: 'Are you sure you want to delete Course ?',
      icon: "warning",
      showCancelButton: true,
      confirmButtonText: 'Yes, Delete',
      confirmButtonColor: '#fe0000',
      showLoaderOnConfirm: true,
    }).then((result) => {
      if (result.isConfirmed) {
        this.loader.start();
        this.service.getAPIMethod('/course/deleteCourse?courseId=' + clickedrecord.cid).subscribe((success) => {
          this.loader.stop();
          
          if (success.response.result.err === 'X') {
            this.sweetAlertMsg('error', success.response.result.msg);
            console.log(success.response.result.msg)
          } else {

            this.sweetAlertMsg('success', success.response.result.msg);

            this.isLoadingDone = false;
            this.getCourseList();

          }
        })
      }
    });
  }


  sweetAlertMsg(typeIcon: any, msg: any) {
    console.log(typeIcon, msg)
    Swal.fire({
      toast: true,
      position: 'top',
      showConfirmButton: false,
      icon: typeIcon,
      timer: 5000,
      title: msg,
    });
  }




}



