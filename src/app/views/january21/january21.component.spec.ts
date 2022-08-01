import { ComponentFixture, TestBed } from '@angular/core/testing';

import { January21Component } from './january21.component';

describe('January21Component', () => {
  let component: January21Component;
  let fixture: ComponentFixture<January21Component>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ January21Component ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(January21Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
