import { Component } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';

@Component({
  selector: 'app-start',
  templateUrl: './start.component.html',
  styleUrls: ['./start.component.css']
})
export class StartComponent {
  roFlag: boolean = true;
  enFlag: boolean = false;

  constructor(public translate: TranslateService) {
    translate.addLangs(['en', 'ro']);
    translate.setDefaultLang('en');
  }

  switchLanguage(lang: string) {
    this.translate.use(lang);
  }

  switchRo() {
    this.switchLanguage('ro');
    this.roFlag = false;
    this.enFlag = true;
  }

  switchEn() {
    this.switchLanguage('en');
    this.enFlag = false;
    this.roFlag = true;
  }
}
