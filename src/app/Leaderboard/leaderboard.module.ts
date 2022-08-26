import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { LeaderboardListingComponent } from './leaderboard-listing/leaderboard-listing.component';
import { AddEditLeaderboardComponent } from './add-edit-leaderboard/add-edit-leaderboard.component';
import { LeaderboardRoutingModule } from './leaderboard-routing.module';
import { SharedModule } from '../Shared/shared.module';
import { AddEditOldScoreComponent } from './add-edit-old-score/add-edit-old-score.component';



@NgModule({
  declarations: [ 
    AddEditLeaderboardComponent,
    LeaderboardListingComponent,
    AddEditOldScoreComponent

  ],
  imports: [
    CommonModule,
    LeaderboardRoutingModule,
    SharedModule
  ]
})
export class LeaderboardModule { }
