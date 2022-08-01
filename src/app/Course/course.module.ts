import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import{CourseListingComponent} from '../Course/course-listing/course-listing.component';
import{AddEditCourseComponent} from '../Course/add-edit-course/add-edit-course.component';
import { CourseRoutingModule } from './course-routing.module';
import { SharedModule } from '../Shared/shared.module';
import { ReactiveFormsModule } from '@angular/forms';
import { CourseLocationComponent } from './course-location/course-location.component';

@NgModule({
  declarations: [CourseListingComponent,AddEditCourseComponent, CourseLocationComponent],
  imports: [
    CommonModule,
    CourseRoutingModule,
    SharedModule,
    // ReactiveFormsModule
  ]
})
export class CourseModule { }
