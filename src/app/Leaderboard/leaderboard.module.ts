import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { LeaderboardListingComponent } from './leaderboard-listing/leaderboard-listing.component';
import { AddEditLeaderboardComponent } from './add-edit-leaderboard/add-edit-leaderboard.component';
import { LeaderboardRoutingModule } from './leaderboard-routing.module';
import { SharedModule } from '../Shared/shared.module';



@NgModule({
  declarations: [ 
    AddEditLeaderboardComponent,
    LeaderboardListingComponent

  ],
  imports: [
    CommonModule,
    LeaderboardRoutingModule,
    SharedModule
  ]
})
export class LeaderboardModule { }
