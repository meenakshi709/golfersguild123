import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AddEditOldScoreComponent } from './add-edit-old-score.component';

describe('AddEditOldScoreComponent', () => {
  let component: AddEditOldScoreComponent;
  let fixture: ComponentFixture<AddEditOldScoreComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AddEditOldScoreComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AddEditOldScoreComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
