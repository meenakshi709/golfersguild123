import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AddEditLeaderboardComponent } from './add-edit-leaderboard.component';

describe('AddEditLeaderboardComponent', () => {
  let component: AddEditLeaderboardComponent;
  let fixture: ComponentFixture<AddEditLeaderboardComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AddEditLeaderboardComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AddEditLeaderboardComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
