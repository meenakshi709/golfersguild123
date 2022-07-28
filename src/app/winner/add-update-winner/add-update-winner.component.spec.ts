import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AddUpdateWinnerComponent } from './add-update-winner.component';

describe('AddUpdateWinnerComponent', () => {
  let component: AddUpdateWinnerComponent;
  let fixture: ComponentFixture<AddUpdateWinnerComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AddUpdateWinnerComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AddUpdateWinnerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
