import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PlayerListingComponent } from './player-listing/player-listing.component';
import { AddEditPlayerComponent } from './add-edit-player/add-edit-player.component';
import { PlayerRoutingModule } from './player-routing.module';
import { SharedModule } from '../Shared/shared.module';



@NgModule({
  declarations: [
    PlayerListingComponent,
    AddEditPlayerComponent
  ],
  imports: [
    CommonModule,
    PlayerRoutingModule,
    SharedModule
  ]
})
export class PlayerModule { }
