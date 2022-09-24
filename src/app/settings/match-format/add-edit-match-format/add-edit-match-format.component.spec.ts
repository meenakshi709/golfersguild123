import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AddEditMatchFormatComponent } from './add-edit-match-format.component';

describe('AddEditMatchFormatComponent', () => {
  let component: AddEditMatchFormatComponent;
  let fixture: ComponentFixture<AddEditMatchFormatComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AddEditMatchFormatComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AddEditMatchFormatComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
