import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MatchPlayListingComponent } from './match-play-listing.component';

describe('MatchPlayListingComponent', () => {
  let component: MatchPlayListingComponent;
  let fixture: ComponentFixture<MatchPlayListingComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ MatchPlayListingComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(MatchPlayListingComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
