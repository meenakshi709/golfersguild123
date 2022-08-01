import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';
import { CourseListingComponent } from './course-listing/course-listing.component';


const routes: Routes = [
  {
    path: '', component: CourseListingComponent,
    

  },
  {
    path: 'listing', component: CourseListingComponent,
  }
  
 

]
@NgModule({
  
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class CourseRoutingModule { }


