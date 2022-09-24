import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MatchFormatListingComponent } from './match-format-listing.component';

describe('MatchFormatListingComponent', () => {
  let component: MatchFormatListingComponent;
  let fixture: ComponentFixture<MatchFormatListingComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ MatchFormatListingComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(MatchFormatListingComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
