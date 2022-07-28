import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';
import { LeaderboardListingComponent } from './leaderboard-listing/leaderboard-listing.component';
const routes: Routes = [
  {
    path: '', component: LeaderboardListingComponent,

  },
]


@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class LeaderboardRoutingModule { }
