import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AddUpdateStablefordComponent } from './add-update-stableford.component';

describe('AddUpdateStablefordComponent', () => {
  let component: AddUpdateStablefordComponent;
  let fixture: ComponentFixture<AddUpdateStablefordComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AddUpdateStablefordComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AddUpdateStablefordComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
