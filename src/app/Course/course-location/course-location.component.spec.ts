import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CourseLocationComponent } from './course-location.component';

describe('CourseLocationComponent', () => {
  let component: CourseLocationComponent;
  let fixture: ComponentFixture<CourseLocationComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CourseLocationComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CourseLocationComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
