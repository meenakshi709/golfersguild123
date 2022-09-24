import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { LandingPageComponent } from './views/landing-page/landing-page.component';
import { ContactPageComponent } from './views/contact-page/contact-page.component';
import { LeaderboardComponent } from './views/leaderboard/leaderboard.component';
import { EventComponent } from './views/event/event.component';
import { CarouselNavigationComponent } from './views/carousel-navigation/carousel-navigation.component';
import { NgbModule, NgbNavModule } from '@ng-bootstrap/ng-bootstrap';
import { TournamentTabsComponent } from './views/tournament-tabs/tournament-tabs.component';
import { LeaderboardTableComponent } from './views/leaderboard-table/leaderboard-table.component';
import { ContactComponent } from './views/contact/contact.component';
import { FormsModule,ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule, HTTP_INTERCEPTORS} from '@angular/common/http';
import {DataTablesModule} from 'angular-datatables';
import { PageNotFoundComponent } from './views/page-not-found/page-not-found.component';
import { SponsorsComponent } from './views/sponsors/sponsors.component';
import { NgImageSliderModule } from 'ng-image-slider';
import { GalleryComponent } from './views/gallery/gallery.component';
import { PhotosComponent } from './views/photos/photos.component';
import { September21Component } from './views/september21/september21.component';
import { November20Component } from './views/november20/november20.component';
import { TestimonialComponent } from './views/testimonial/testimonial.component';
import { CommonServiceService } from './Service/common-service.service';
import { NavigationComponent } from './views/navigation/navigation.component';
import { FooterComponent } from './views/footer/footer.component';
import {January21Component} from './views/january21/january21.component';
import  {March21Component} from './views/march21/march21.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { SidebarComponent } from './Layout/sidebar/sidebar.component';
import { AdminLoginComponent } from './Authentication/admin-login/admin-login.component';
import { SharedModule } from './Shared/shared.module';
import { NgxUiLoaderModule } from 'ngx-ui-loader';
import { ThankyouComponent } from './views/thankyou/thankyou.component';
import { PrivacyPolicyComponent } from './privacy-policy/privacy-policy.component';
import { RootInterceptor } from './Service/authGaurd/rootInterceptor';
import { ErrorInterceptor } from './Service/authGaurd/errorInterceptor';
import { AuthgaurdService } from './Service/authGaurd/authGuard.service';







@NgModule({
  declarations: [
    AppComponent,
    LandingPageComponent,
    ContactPageComponent,
    LeaderboardComponent,
    EventComponent,
    CarouselNavigationComponent,
    TournamentTabsComponent,
    LeaderboardTableComponent,
    ContactComponent,
    PageNotFoundComponent,
    SponsorsComponent,
    GalleryComponent,
    PhotosComponent,
    September21Component,
    November20Component,
    TestimonialComponent,   
    NavigationComponent,
    FooterComponent,
    January21Component,
    March21Component,
    SidebarComponent,
    AdminLoginComponent,
    ThankyouComponent,
    PrivacyPolicyComponent,
 



  ],
  imports: [
    NgxUiLoaderModule,
    BrowserModule,
    AppRoutingModule,
    NgbModule,
    FormsModule,
    HttpClientModule,
    DataTablesModule, 
    NgImageSliderModule,
    NgbNavModule,
    ReactiveFormsModule,
    BrowserAnimationsModule,
    SharedModule
    
    
  ],
    providers: [

    { provide: HTTP_INTERCEPTORS, useClass: RootInterceptor, multi: true },
    { provide: HTTP_INTERCEPTORS, useClass: ErrorInterceptor, multi: true },
    AuthgaurdService,
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
