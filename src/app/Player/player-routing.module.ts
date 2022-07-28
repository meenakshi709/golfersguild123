import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';
import { PlayerListingComponent } from './player-listing/player-listing.component';
const routes: Routes = [
  {
    path: '', component: PlayerListingComponent,

  },
]
@NgModule({
  
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class PlayerRoutingModule { }
