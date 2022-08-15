import { Directive, ElementRef, HostListener, Input } from '@angular/core';
import { NgControl } from '@angular/forms';

@Directive({
    selector: 'input[numbersWithDecimal]'
})
export class NumberWithDecimalDirective {

 // Allow decimal numbers and negative values
 private regex: RegExp = new RegExp(/^\d*\.?\d*$/);
 // Allow key codes for special events. Reflect :
 // Backspace, tab, end, home
 private specialKeys: Array<string> = [ 'Backspace', 'Tab', 'End', 'Home', '-' ];
constructor(private el: ElementRef) {
 }
 @HostListener('keydown', [ '$event' ])
 onKeyDown(event: KeyboardEvent) {
 // Allow Backspace, tab, end, and home keys
 if (this.specialKeys.indexOf(event.key) !== -1) {
 return;
 }
 const current: string = this.el.nativeElement.value;
 const next: string = current.concat(event.key);
 if (next && !String(next).match(this.regex)) {
 event.preventDefault();
 }
 }

}
