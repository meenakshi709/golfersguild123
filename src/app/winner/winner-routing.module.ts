import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { WinnerListingComponent } from './winner-listing/winner-listing.component';

const routes: Routes = [  
  {
  path: '', component: WinnerListingComponent,
},
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class WinnerRoutingModule { }
