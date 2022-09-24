import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AddEditMatchPlayComponent } from './add-edit-match-play.component';

describe('AddEditMatchPlayComponent', () => {
  let component: AddEditMatchPlayComponent;
  let fixture: ComponentFixture<AddEditMatchPlayComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AddEditMatchPlayComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AddEditMatchPlayComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
