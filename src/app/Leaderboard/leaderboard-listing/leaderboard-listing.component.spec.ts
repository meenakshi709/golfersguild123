import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LeaderboardListingComponent } from './leaderboard-listing.component';

describe('LeaderboardListingComponent', () => {
  let component: LeaderboardListingComponent;
  let fixture: ComponentFixture<LeaderboardListingComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ LeaderboardListingComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(LeaderboardListingComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
