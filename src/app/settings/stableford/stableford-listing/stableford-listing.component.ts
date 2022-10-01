import { Component, OnInit } from '@angular/core';
import { CommonServiceService } from 'src/app/Service/common.service';
import { MatTableDataSource } from '@angular/material/table';
import { MatDialog } from '@angular/material/dialog';
import { NgxUiLoaderService } from 'ngx-ui-loader';
import Swal from 'sweetalert2';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { forkJoin } from 'rxjs';


import { CommonListMenu } from 'src/app/Shared/common-Listing/common-list-menu';
import { CommonListMenuItem } from 'src/app/Shared/common-Listing/common-list-menu-item';
import { CommonListProperties } from 'src/app/Shared/common-Listing/common-properties';
import { AddUpdateStablefordComponent } from '../add-update-stableford/add-update-stableford.component';

@Component({
  selector: 'app-stableford-listing',
  templateUrl: './stableford-listing.component.html',
  styleUrls: ['./stableford-listing.component.css']
})

export class StablefordListingComponent implements OnInit {

  matchPlayList: CommonListProperties = new CommonListProperties();
  isLoadingDone: boolean = false;
  constructor(private service: CommonServiceService, public dialog: MatDialog, public loader: NgxUiLoaderService) { }

  ngOnInit(): void {
    this.getStablefordList();
  }



  getStablefordList() {
    this.loader.start();
    this.service.getAPIMethod("/tournament/getStablefordPoints").subscribe((response) => {
      this.loader.stop();
      const data: any = response;

      if (data.error == '') {
        this.isLoadingDone = true;
    

        this.matchPlayList.miDataSource = new MatTableDataSource(data.response.result);
        this.matchPlayList.columnLabels = ['Format Id', 'Score Name','Score Point',  'Action'];
        this.matchPlayList.displayedColumns = ['sno', 'netScoreName','netScorePoints',  'Action'];

        this.matchPlayList.miListMenu = new CommonListMenu();
        this.matchPlayList.miListMenu.menuItems =
          [
            new CommonListMenuItem('Edit', 1, true, false, null,'edit'),
            new CommonListMenuItem('Delete', 2, true, true, null, 'delete'),
          ];
      }
    });
  }

  applyFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.matchPlayList.miDataSource.filter = filterValue.trim().toLowerCase();


  }

  onScoreActionClick(clickedRecord: any) {

    if (clickedRecord.name == 'Edit') {

      this.addEditStablefordPonits(clickedRecord.data)
    }
    else if (clickedRecord.name == 'Delete') {
      this.deletePoints(clickedRecord.data)
    }
  }






  deletePoints(clickedrecord: any) {
debugger
    Swal.fire({
      title: 'Delete Tournament Format',
      text: 'Are you sure you want to delete Tournament Format?',
      icon: "warning",
      showCancelButton: true,
      confirmButtonText: 'Yes, Delete',
      confirmButtonColor: '#fe0000',
      showLoaderOnConfirm: true,
    }).then((result) => {
      if (result.isConfirmed) {
        this.loader.start();
        this.service.getAPIMethod('/tournament/deleteStablefordPoint?ponitId=' + clickedrecord.sno).subscribe((success) => {
          this.loader.stop();
          if (success.error === 'X') {
            this.sweetAlertMsg('error', success.response.result.msg);

          } else {

            this.sweetAlertMsg('success', success.response.result.msg);

            this.isLoadingDone = false;
            this.getStablefordList();

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



  // approved list status

  addEditStablefordPonits(clickedRecordDetails: any) {
debugger

        const dialogRef = this.dialog.open(AddUpdateStablefordComponent, {
         
      data: clickedRecordDetails,
      width: '900px',
      height: '400px'
    });
       
        dialogRef.afterClosed().subscribe(result => {
          if (result) {
            this.getStablefordList();
          }
        });
      }









    }