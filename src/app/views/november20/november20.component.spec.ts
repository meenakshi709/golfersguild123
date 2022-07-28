import { ComponentFixture, TestBed } from '@angular/core/testing';

import { November20Component } from './november20.component';

describe('November20Component', () => {
  let component: November20Component;
  let fixture: ComponentFixture<November20Component>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ November20Component ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(November20Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
