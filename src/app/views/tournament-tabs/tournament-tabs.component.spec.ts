import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TournamentTabsComponent } from './tournament-tabs.component';

describe('TournamentTabsComponent', () => {
  let component: TournamentTabsComponent;
  let fixture: ComponentFixture<TournamentTabsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ TournamentTabsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(TournamentTabsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
