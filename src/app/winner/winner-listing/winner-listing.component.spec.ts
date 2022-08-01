import { ComponentFixture, TestBed } from '@angular/core/testing';

import { WinnerListingComponent } from './winner-listing.component';

describe('WinnerListingComponent', () => {
  let component: WinnerListingComponent;
  let fixture: ComponentFixture<WinnerListingComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ WinnerListingComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(WinnerListingComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
