import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AddEditTournamentComponent } from './add-edit-tournament/add-edit-tournament.component';
import { TournamentListingComponent } from './tournament-listing/tournament-listing.component';
import { SharedModule } from '../Shared/shared.module';
import { TournamentRoutingModule } from './tournament-routing.module';



@NgModule({
  declarations: [
    AddEditTournamentComponent,
    TournamentListingComponent
  
  ],
  imports: [
    CommonModule,
    SharedModule,
    TournamentRoutingModule
  
  ]
})
export class TournamentModule { }
