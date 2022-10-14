import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { MatTableDataSource } from '@angular/material/table';
import { NgxUiLoaderService } from 'ngx-ui-loader';
import { CommonServiceService } from 'src/app/Service/common.service';
import { CommonListMenu } from 'src/app/Shared/common-Listing/common-list-menu';
import { CommonListMenuItem } from 'src/app/Shared/common-Listing/common-list-menu-item';
import { CommonListProperties } from 'src/app/Shared/common-Listing/common-properties';
import Swal from 'sweetalert2';
import { AddEditPlayerComponent } from '../add-edit-player/add-edit-player.component';

@Component({
  selector: 'app-player-listing',
  templateUrl: './player-listing.component.html',
  styleUrls: ['./player-listing.component.css']
})
export class PlayerListingComponent implements OnInit {

  playerList: CommonListProperties = new CommonListProperties();
  isLoadingDone:boolean=false;
  constructor(private service: CommonServiceService, public dialog: MatDialog,public loader:NgxUiLoaderService) { }

  ngOnInit(): void {
    this.getPlayerList();
  }
  getPlayerList() {
    this.loader.start();
    this.service.getAPIMethod('/players').subscribe((response) => {
      this.loader.stop();
      
 const data:any=response;

      if (response.error === 'X') {
       console.log('error');
      } else {
        this.isLoadingDone = true;
      //  this.roleList.url = '/getRolesList';
        this.playerList.miDataSource = new MatTableDataSource(data.response.result);
        this.playerList.columnLabels = [ 'Player Name','Handicap','Handicap Certificate','Platform Link','Home Course','Email Id','Phone','Gender','DOB','State','Country', 'Action'];
        this.playerList.displayedColumns = [  'playerName','hdcp', 'homeCourse','hdcpCertificate', 'platformLink','email','contact_Number','gender','dateofbirth','state_name','country_name','Action'];
    
        this.playerList.miListMenu = new CommonListMenu();
        this.playerList.miListMenu.menuItems =
          [
            new CommonListMenuItem('Edit', 1, true, false, null, 'edit_icon'),
            new CommonListMenuItem('Delete', 2, true, true, null, 'delete_icon'),
          ];
      
      }
    });
  }


  applyFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.playerList.miDataSource.filter = filterValue.trim().toLowerCase();

  
  }


  savePlayerDetails(clickedRecordDetails:any) {
    const dialogRef = this.dialog.open(AddEditPlayerComponent, {
      data: clickedRecordDetails,
      width: '900px',
      height: '400px'
    });
    dialogRef.afterClosed().subscribe(result => {
      if(result){
        this.getPlayerList();
      }
     });
  }


    
    



  onPlayerActionClick(clickedRecord: any) {
   
    if (clickedRecord.name == 'Edit') {
this.savePlayerDetails(clickedRecord.data)
    }
    else if (clickedRecord.name=='Delete')
    {
this.deletePlayer(clickedRecord.data);
    }
  }


  deletePlayer(clickedrecord:any)
  {

    Swal.fire({
      title: 'Delete Player',
      text: 'Are you sure you want to delete Player ?',
      icon: "warning",
      showCancelButton: true,
      confirmButtonText: 'Yes, Delete',
      confirmButtonColor: '#fe0000',
      showLoaderOnConfirm: true,
    }).then((result) => {
      if (result.isConfirmed) {
        this.loader.start();
        this.service.getAPIMethod('/deletePlayer?playerId=' + clickedrecord.p_id).subscribe((success) => {
          
          this.loader.stop();
          if (success.response.err === 'X') {
            this.sweetAlertMsg('error', success.response.msg);
          } else {
            this.isLoadingDone = false;
            this.getPlayerList();
            this.sweetAlertMsg('success', success.response.msg);
          }
        })
      }
    });
  }
 

  sweetAlertMsg(typeIcon:any, msg:any) {
    console.log(typeIcon,msg)
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
