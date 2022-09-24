import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { GalleryComponent } from './views/gallery/gallery.component';
import { ContactPageComponent } from './views/contact-page/contact-page.component';
import { EventComponent } from './views/event/event.component';
import { LandingPageComponent } from './views/landing-page/landing-page.component';
import { LeaderboardComponent } from './views/leaderboard/leaderboard.component';
import { PageNotFoundComponent } from './views/page-not-found/page-not-found.component';
import { September21Component } from './views/september21/september21.component';
import { November20Component } from './views/november20/november20.component';
import { January21Component } from './views/january21/january21.component';
import { March21Component } from './views/march21/march21.component';
import { SidebarComponent } from './Layout/sidebar/sidebar.component';
import { AdminLoginComponent } from './Authentication/admin-login/admin-login.component';
import { ThankyouComponent } from './views/thankyou/thankyou.component';
import { PrivacyPolicyComponent } from './privacy-policy/privacy-policy.component';
import { ClientComponent } from './client/Client/client.component';
import { AuthGuard } from './Service/authGaurd/auth.guard';







const routes: Routes = [
  {path:'', component:LandingPageComponent},
  {path:'leaderboard', component:LeaderboardComponent},
  {path :'event', component:EventComponent},
  {path:'contact', component:ContactPageComponent},
  {path:'gallery', component:GalleryComponent},
  {path:'september21', component:September21Component},
  {path:'november20', component:November20Component},
  {path:'january21', component:January21Component},
  {path:'march21', component:March21Component},
  {path:'admin-login', component:AdminLoginComponent},
  {path:'thankyou', component:ThankyouComponent},
  {path:'privacy', component:PrivacyPolicyComponent},
  {path:'client-signup', component:ClientComponent},


  {
    path: 'courses',
     canActivate: [AuthGuard],
    loadChildren: () => import('./Course/course.module').then(m => m.CourseModule),
   component:SidebarComponent
  },
  {
    path: 'dashboard',
    canActivate: [AuthGuard],
    loadChildren: () => import('./Dashboard/dashboard.module').then(m => m.DashboardModule),
   component:SidebarComponent
  },
  {
    path: 'player',
   canActivate: [AuthGuard],
    loadChildren: () => import('./Player/player.module').then(m => m.PlayerModule),
   component:SidebarComponent
  },
  {
    path: 'tournament',
     canActivate: [AuthGuard],
    loadChildren: () => import('./tournament/tournament.module').then(m => m.TournamentModule),
    component:SidebarComponent
  },
  {
    path: 'leaderboardList',
     canActivate: [AuthGuard],
    loadChildren: () => import('./Leaderboard/leaderboard.module').then(m => m.LeaderboardModule),
   component:SidebarComponent
  },

  {
    path: 'client-signup',
     canActivate: [AuthGuard],
    loadChildren: () => import('./client/client.module').then(m => m.ClientModule),
  // component:SidebarComponent
  },
  {
    path: 'winners',
    canActivate: [AuthGuard],
    loadChildren: () => import('./winner/winner.module').then(m => m.WinnerModule),
   component:SidebarComponent
  },
  {
    path: 'settings',
   // canActivate: [AuthGuard],
    loadChildren: () => import('./settings/settings.module').then(m => m.SettingsModule),
   component:SidebarComponent
  },
  
  
  {path:'**', component:PageNotFoundComponent}
  
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
