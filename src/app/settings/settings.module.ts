import { SharedModule } from './../Shared/shared.module';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SettingsRoutingModule } from './settings-routing.module';
import { AddEditMatchFormatComponent } from './match-format/add-edit-match-format/add-edit-match-format.component';
import { AddEditMatchPlayComponent } from './match-play/add-edit-match-play/add-edit-match-play.component';
import { AddUpdateStablefordComponent } from './stableford/add-update-stableford/add-update-stableford.component';
import { StablefordListingComponent } from './stableford/stableford-listing/stableford-listing.component';
import { MatchPlayListingComponent } from './match-play/match-play-listing/match-play-listing.component';
import { MatchFormatListingComponent } from './match-format/match-format-listing/match-format-listing.component';



@NgModule({
  declarations: [
    MatchPlayListingComponent,
    MatchFormatListingComponent,
    AddEditMatchFormatComponent,
    AddEditMatchPlayComponent,
    AddUpdateStablefordComponent,
    StablefordListingComponent
  ],
  imports: [
  CommonModule,
  SharedModule,
  SettingsRoutingModule
  ]
})
export class SettingsModule { }
