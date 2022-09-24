import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { MatchPlayListingComponent } from './match-play/match-play-listing/match-play-listing.component';
import { StablefordListingComponent } from './stableford/stableford-listing/stableford-listing.component';
import { MatchFormatListingComponent } from './match-format/match-format-listing/match-format-listing.component';



const routes: Routes = [
  {
    path: 'matchformat', component: MatchFormatListingComponent,
    

  },
  {
    path: 'stableford', component: StablefordListingComponent,
    

  },
  {
    path: 'matchplay', component: MatchPlayListingComponent,
    

  },

]

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class SettingsRoutingModule { }
