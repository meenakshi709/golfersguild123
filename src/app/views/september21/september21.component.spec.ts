import { ComponentFixture, TestBed } from '@angular/core/testing';

import { September21Component } from './september21.component';

describe('September21Component', () => {
  let component: September21Component;
  let fixture: ComponentFixture<September21Component>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ September21Component ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(September21Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
