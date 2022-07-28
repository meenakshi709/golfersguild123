import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { WinnerRoutingModule } from './winner-routing.module';
import { AddUpdateWinnerComponent } from './add-update-winner/add-update-winner.component';
import { WinnerListingComponent } from './winner-listing/winner-listing.component';
import { SharedModule } from '../Shared/shared.module';


@NgModule({
  declarations: [
    AddUpdateWinnerComponent,
    WinnerListingComponent
  ],
  imports: [
    CommonModule,
    SharedModule,
    WinnerRoutingModule
  ]
})
export class WinnerModule { }
