import { ComponentFixture, TestBed } from '@angular/core/testing';

import { March21Component } from './march21.component';

describe('March21Component', () => {
  let component: March21Component;
  let fixture: ComponentFixture<March21Component>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ March21Component ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(March21Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
