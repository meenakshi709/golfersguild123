import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PlayerListingComponent } from './player-listing.component';

describe('PlayerListingComponent', () => {
  let component: PlayerListingComponent;
  let fixture: ComponentFixture<PlayerListingComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ PlayerListingComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(PlayerListingComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
