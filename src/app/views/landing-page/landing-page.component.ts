import { Component, OnInit } from '@angular/core';
import {NgbCarouselConfig} from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'app-landing-page',
  templateUrl: './landing-page.component.html',
  styleUrls: ['./landing-page.component.css'],
  providers: [NgbCarouselConfig]
})
export class LandingPageComponent implements OnInit {
  clubs=[
    {'id':1,'name':'Tournament', 'image': "../../assets/images/tournament.svg"},
    {'id':2,'name':'Lessons', 'image': "../../assets/images/lessons.svg"},
    {'id':3,'name':'Pro Shop', 'image': "../../assets/images/pro-shop.svg"},
    {'id':4,'name':'Merchandise', 'image': "../../assets/images/merchandise.svg"}
   
  ]

  
  showNavigationArrows = false;
  showNavigationIndicators = true;
  images=["../../assets/images/golf-1.png","../../assets/images/golf-2.png","../../assets/images/golf-3.png","../../assets/images/golf-4.png"];


  constructor(config: NgbCarouselConfig) {
    // customize default values of carousels used by this component tree
    config.showNavigationArrows = true;
    config.showNavigationIndicators = true;
  }

  ngOnInit(): void {
  }
//slider code


 }
