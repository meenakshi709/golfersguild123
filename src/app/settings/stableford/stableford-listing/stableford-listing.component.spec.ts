import { ComponentFixture, TestBed } from '@angular/core/testing';

import { StablefordListingComponent } from './stableford-listing.component';

describe('StablefordListingComponent', () => {
  let component: StablefordListingComponent;
  let fixture: ComponentFixture<StablefordListingComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ StablefordListingComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(StablefordListingComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
