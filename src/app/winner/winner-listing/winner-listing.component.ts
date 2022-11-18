import { response } from 'express';
import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { NgxUiLoaderService } from 'ngx-ui-loader';
import { CommonServiceService } from 'src/app/Service/common.service';

import { CommonListProperties } from 'src/app/Shared/common-Listing/common-properties';
import Swal from 'sweetalert2';
import { AddUpdateWinnerComponent } from '../add-update-winner/add-update-winner.component';
import { FormControl, Validators } from '@angular/forms';

@Component({
  selector: 'app-winner-listing',
  templateUrl: './winner-listing.component.html',
  styleUrls: ['./winner-listing.component.css']
})
export class WinnerListingComponent implements OnInit {

  courseList: CommonListProperties = new CommonListProperties();
  tournament = new FormControl('', [Validators.required]);
  isLoadingDone: boolean = false;
  tournamentList: any = [];
  winnerObj: any;
  constructor(private service: CommonServiceService, public dialog: MatDialog, public loader: NgxUiLoaderService) { }

  ngOnInit(): void {
    this.getTournamentList();
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

  getTournamentList() {
    this.service.getAPIMethod("/getTournamentListing").subscribe(response => {
      if (response.error == "") {
        this.tournamentList = response.response.result;
      }
      else {
        this.sweetAlertMsg('error', response.msg);
      }

    });
  }
  onChangeTournament() {
    debugger;
    this.service.getAPIMethod("/tournament/getTournamentWinnersByTourId?tour_id=" + this.tournament.value+"&isLead=1").subscribe(response => {
      if (response.error == "") {
        this.winnerObj = response.response;
      }
      else {
        this.sweetAlertMsg('error', response.msg);
      }

    });
  }


}
