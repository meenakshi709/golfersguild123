import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SharedModule } from '../Shared/shared.module';
import { ClientComponent } from './Client/client.component';
import { ClientRoutingModule } from './client-routing.module';



@NgModule({
  declarations: [ClientComponent],
  imports: [
    CommonModule,
    ClientRoutingModule,
    SharedModule,
    // ReactiveFormsModule
  ]
})
export class ClientModule { }
