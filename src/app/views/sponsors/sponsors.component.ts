import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-sponsors',
  templateUrl: './sponsors.component.html',
  styleUrls: ['./sponsors.component.css']
})
export class SponsorsComponent implements OnInit {

  constructor() { }

  ngOnInit(): void {
  }

  imgCollection: Array<object> = [
    {
      image: '../../assets/images/parkLogo.png',
      thumbImage: '../../assets/images/parkLogo.png',
 
    }, {
      image: '../../assets/images/crucibleLogo.png',
      thumbImage: '../../assets/images/crucibleLogo.png',
   
    }, {
      image: '../../assets/images/echelonLogo.png',
      thumbImage: '../../assets/images/echelonLogo.png',
    
    }, {
      image: '../../assets/images/blueairLogo.png',
      thumbImage: '../../assets/images/blueairLogo.png',
   
    },
    /* {
      image: '../../assets/images/golf-5.jpg',
      thumbImage: '../../assets/images/golf-5.jpg',
    
    }, 
    {
      image: '../../assets/images/golf-6.jpg',
      thumbImage: '../../assets/images/golf-6.jpg',
     
    }, {
      image: '../../assets/images/golf-7.jpg',
      thumbImage: '../../assets/images/golf-7.jpg',
    
    },
    {
      image: '../../assets/images/golf-8.jpg',
      thumbImage: '../../assets/images/golf-8.jpg',
  
    }, {
      image: '../../assets/images/golf-9.jpg',
      thumbImage: '../../assets/images/golf-9.jpg',
    
    },
    {
      image: '../../assets/images/golf-10.jpg',
      thumbImage: '../../assets/images/golf-10.jpg',
     
    }, {
      image: '../../assets/images/golf-11.jpg',
      thumbImage: '../../assets/images/golf-11.jpg',
     
    },
    {
      image: '../../assets/images/golf-12.jpg',
      thumbImage: '../../assets/images/golf-12.jpg',
    
    },
    {
      image: '../../assets/images/golf-13.jpg',
      thumbImage: '../../assets/images/golf-13.jpg',
   
    }
    */
];

}
