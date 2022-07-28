import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AddEditTournamentComponent } from './add-edit-tournament.component';

describe('AddEditTournamentComponent', () => {
  let component: AddEditTournamentComponent;
  let fixture: ComponentFixture<AddEditTournamentComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AddEditTournamentComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AddEditTournamentComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
