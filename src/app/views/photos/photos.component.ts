import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-photos',
  templateUrl: './photos.component.html',
  styleUrls: ['./photos.component.css']
})
export class PhotosComponent implements OnInit {

  constructor() { }

  ngOnInit(): void {
  }

  imgCollection: Array<object> = [
    {
      image: '../../assets/images/golf-5.jpg',
      thumbImage: '../../assets/images/golf-5.jpg',
    
    }, {
      image: '../../assets/images/golf-6.jpg',
      thumbImage: '../../assets/images/golf-6.jpg',
    
    }, 
   {
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
    
    }, 
    {
      image: '../../assets/images/golf-11.jpg',
      thumbImage: '../../assets/images/golf-11.jpg',
     
    }, {
      image: '../../assets/images/golf-12.jpg',
      thumbImage: '../../assets/images/golf-12.jpg',
    
    },
    {
      image: '../../assets/images/golf-13.jpg',
      thumbImage: '../../assets/images/golf-13.jpg',
  
    },
   
    {
      image: '../../assets/images/golf-14.jpg',
      thumbImage: '../../assets/images/golf-14.jpg',
    
    },
    {
      image: '../../assets/images/golf-15.jpg',
      thumbImage: '../../assets/images/golf-15.jpg',
     
    }, {
      image: '../../assets/images/golf-16.jpg',
      thumbImage: '../../assets/images/golf-16.jpg',
     
    },
    {
      image: '../../assets/images/golf-17.jpg',
      thumbImage: '../../assets/images/golf-17.jpg',
    
    },
    {
      image: '../../assets/images/golf-18.jpg',
      thumbImage: '../../assets/images/golf-18.jpg',
   
    }
   
];

}
