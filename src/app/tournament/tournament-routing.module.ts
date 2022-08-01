import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';
import { TournamentListingComponent } from './tournament-listing/tournament-listing.component';
const routes: Routes = [
  {
    path: '', component: TournamentListingComponent,
  },
]


@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class TournamentRoutingModule { }
