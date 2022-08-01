import { Component,ViewChild,AfterViewInit}  from '@angular/core';
import { ModalDismissReasons, NgbModal, NgbModalOptions } from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent  {
  title = 'golfersguild';
  modalOptions:NgbModalOptions;
  closeResult: string = '';
  @ViewChild('content') content: any;

  constructor(private modalService: NgbModal) {
    this.modalOptions = {
      backdrop:'static',
      backdropClass:'customBackdrop'
   }
  }



   

  ngAfterViewInit() {
  //  this.openModal();
  }
  openModal(){
    this.modalService.open(this.content, { centered: true });
  }
  




 



}

